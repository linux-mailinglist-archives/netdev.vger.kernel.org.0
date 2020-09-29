Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8786427D09E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgI2OIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:08:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:43052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2OIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:08:09 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGIZ-0007VA-6o; Tue, 29 Sep 2020 16:08:07 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGIY-000VLQ-Vm; Tue, 29 Sep 2020 16:08:07 +0200
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add tests for BPF_F_SHARE_PE
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-3-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <462d5ed2-727b-d932-a5f3-333c4b2c4806@iogearbox.net>
Date:   Tue, 29 Sep 2020 16:08:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200929084750.419168-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 10:47 AM, Song Liu wrote:
> Add tests for perf event array with and without BPF_F_SHARE_PE.
> 
> Add a perf event to array via fd mfd. Without BPF_F_SHARE_PE, the perf
> event is removed when mfd is closed. With BPF_F_SHARE_PE, the perf event
> is removed when the map is freed.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
[...]
> +static void test_one_map(struct bpf_map *map, struct bpf_program *prog,
> +			 bool has_share_pe)
> +{
> +	int err, key = 0, pfd = -1, mfd = bpf_map__fd(map);
> +	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts);
> +	struct perf_event_attr attr = {
> +		.size = sizeof(struct perf_event_attr),
> +		.type = PERF_TYPE_SOFTWARE,
> +		.config = PERF_COUNT_SW_CPU_CLOCK,
> +	};
> +
> +	pfd = syscall(__NR_perf_event_open, &attr, 0 /* pid */,
> +		      -1 /* cpu 0 */, -1 /* group id */, 0 /* flags */);
> +	if (CHECK(pfd < 0, "perf_event_open", "failed\n"))
> +		return;
> +
> +	err = bpf_map_update_elem(mfd, &key, &pfd, BPF_ANY);
> +	if (CHECK(err < 0, "bpf_map_update_elem", "failed\n"))
> +		goto cleanup;
> +
> +	err = bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
> +	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
> +		goto cleanup;
> +	if (CHECK(opts.retval != 0, "bpf_perf_event_read_value",
> +		  "failed with %d\n", opts.retval))
> +		goto cleanup;
> +
> +	/* closing mfd, prog still holds a reference on map */
> +	close(mfd);
> +
> +	err = bpf_prog_test_run_opts(bpf_program__fd(prog), &opts);
> +	if (CHECK(err < 0, "bpf_prog_test_run_opts", "failed\n"))
> +		goto cleanup;
> +
> +	if (has_share_pe) {
> +		CHECK(opts.retval != 0, "bpf_perf_event_read_value",
> +		      "failed with %d\n", opts.retval);
> +	} else {
> +		CHECK(opts.retval != -ENOENT, "bpf_perf_event_read_value",
> +		      "should have failed with %d, but got %d\n", -ENOENT,
> +		      opts.retval);
> +	}
> +
> +cleanup:
> +	close(pfd);

Why holding pfd until the end? The map should already hold a ref after update.
So you should be able to just do ...

err = bpf_map_update_elem(mfd, &key, &pfd, BPF_ANY);
close(pfd);

... and simplify cleanup.

> +}
> +
> +void test_perf_event_share(void)
> +{
> +	struct test_perf_event_share *skel;
> +
> +	skel = test_perf_event_share__open_and_load();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +
> +	test_one_map(skel->maps.array_1, skel->progs.read_array_1, false);
> +	test_one_map(skel->maps.array_2, skel->progs.read_array_2, true);
> +
> +	test_perf_event_share__destroy(skel);
> +}
