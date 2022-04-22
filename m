Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B153D50C43F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbiDVXJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiDVXJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:09:30 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCB64EA01;
        Fri, 22 Apr 2022 15:43:18 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ni1zg-0008tO-Ai; Sat, 23 Apr 2022 00:43:16 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ni1zg-000DEn-1z; Sat, 23 Apr 2022 00:43:16 +0200
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: handle batch operations
 for map-in-map bpf-maps
To:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, kernel-team@fb.com,
        ndixit@fb.com, kafai@fb.com, andriin@fb.com
References: <20220422005044.4099919-1-ctakshak@fb.com>
 <20220422005044.4099919-2-ctakshak@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <015a8abe-9f6e-d3e8-e1c6-e618f8535109@iogearbox.net>
Date:   Sat, 23 Apr 2022 00:43:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220422005044.4099919-2-ctakshak@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26520/Fri Apr 22 10:30:17 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 2:50 AM, Takshak Chahande wrote:
[...]
> +static void fetch_and_validate(int outer_map_fd,
> +			       __u32 *inner_map_fds,
> +			       struct bpf_map_batch_opts *opts,
> +			       __u32 batch_size, bool delete_entries)
> +{
> +	__u32 *fetched_keys, *fetched_values, fetched_entries = 0;
> +	__u32 next_batch_key = 0, step_size = 5;
> +	int err, retries = 0, max_retries = 3;
> +	__u32 value_size = sizeof(__u32);
> +
> +	fetched_keys = calloc(batch_size, value_size);
> +	fetched_values = calloc(batch_size, value_size);
> +
> +	while (fetched_entries < batch_size) {
> +		err = delete_entries
> +		      ? bpf_map_lookup_and_delete_batch(outer_map_fd,
> +				      fetched_entries ? &next_batch_key : NULL,
> +				      &next_batch_key,
> +				      fetched_keys + fetched_entries,
> +				      fetched_values + fetched_entries,
> +				      &step_size, opts)
> +		      : bpf_map_lookup_batch(outer_map_fd,
> +				      fetched_entries ? &next_batch_key : NULL,
> +				      &next_batch_key,
> +				      fetched_keys + fetched_entries,
> +				      fetched_values + fetched_entries,
> +				      &step_size, opts);
> +		CHECK((err < 0 && (errno != ENOENT && errno != ENOSPC)),
> +		      "lookup with steps failed",
> +		      "error: %s\n", strerror(errno));
> +
> +		fetched_entries += step_size;
> +		/* retry for max_retries if ENOSPC */
> +		if (errno == ENOSPC)
> +			++retries;
> +
> +		if (retries >= max_retries)
> +			break;
> +	}
> +
> +	CHECK((fetched_entries != batch_size && err != ENOSPC),
> +	      "Unable to fetch expected entries !",
> +	      "fetched_entries(%d) and batch_size(%d) error: (%d):%s\n",
> +	      fetched_entries, batch_size, errno, strerror(errno));
> +
Looks like BPF CI in test_maps trips right here:

   [...]
   test_lpm_trie_map_batch_ops:PASS
   batch_op is successful for batch_size(5)
   batch_op is successful for batch_size(10)
   test_map_in_map_batch_ops_array:PASS with inner ARRAY map
   batch_op is successful for batch_size(5)
   batch_op is successful for batch_size(10)
   test_map_in_map_batch_ops_array:PASS with inner HASH map
   fetch_and_validate(158):FAIL:Unable to fetch expected entries ! fetched_entries(8) and batch_size(5) error: (2):No such file or directory
test_verifier - Testing test_verifier
collect_status - Collect status
shutdown - Shutdown
Test Results:
              bpftool: PASS
           test_progs: PASS
  test_progs-no_alu32: PASS
            test_maps: FAIL (returned 255)
        test_verifier: PASS
             shutdown: CLEAN
Error: Process completed with exit code 1.
