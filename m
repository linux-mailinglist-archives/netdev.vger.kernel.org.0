Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA627C00C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgI2IvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:51:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:55300 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2IvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:51:19 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNBLf-00061o-Oa; Tue, 29 Sep 2020 10:50:59 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNBLf-0004qV-AC; Tue, 29 Sep 2020 10:50:59 +0200
Subject: Re: [PATCH v7 bpf-next 4/8] selftests/bpf: add bpf_snprintf_btf
 helper tests
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
 <1601292670-1616-5-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <30b2a441-9772-1662-ca03-13bfa0b37d46@iogearbox.net>
Date:   Tue, 29 Sep 2020 10:50:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1601292670-1616-5-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 1:31 PM, Alan Maguire wrote:
> Tests verifying snprintf()ing of various data structures,
> flags combinations using a tp_btf program. Tests are skipped
> if __builtin_btf_type_id is not available to retrieve BTF
> type ids.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
[...]
> +void test_snprintf_btf(void)
> +{
> +	struct netif_receive_skb *skel;
> +	struct netif_receive_skb__bss *bss;
> +	int err, duration = 0;
> +
> +	skel = netif_receive_skb__open();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +
> +	err = netif_receive_skb__load(skel);
> +	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
> +		goto cleanup;
> +
> +	bss = skel->bss;
> +
> +	err = netif_receive_skb__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	/* generate receive event */
> +	system("ping -c 1 127.0.0.1 > /dev/null");

This generates the following new warning when compiling BPF selftests:

   [...]
   EXT-OBJ  [test_progs] cgroup_helpers.o
   EXT-OBJ  [test_progs] trace_helpers.o
   EXT-OBJ  [test_progs] network_helpers.o
   EXT-OBJ  [test_progs] testing_helpers.o
   TEST-OBJ [test_progs] snprintf_btf.test.o
/root/bpf-next/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c: In function ‘test_snprintf_btf’:
/root/bpf-next/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c:30:2: warning: ignoring return value of ‘system’, declared with attribute warn_unused_result [-Wunused-result]
   system("ping -c 1 127.0.0.1 > /dev/null");
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   [...]

Please fix, thx!
