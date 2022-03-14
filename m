Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00814D8F87
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245569AbiCNW1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiCNW13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:27:29 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B173D481;
        Mon, 14 Mar 2022 15:26:19 -0700 (PDT)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nTt8i-0009AB-7u; Mon, 14 Mar 2022 23:26:08 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nTt8h-000Jc1-Te; Mon, 14 Mar 2022 23:26:07 +0100
Subject: Re: [PATCH v4 bpf-next 5/5] selftests/bpf: add tests for uprobe
 auto-attach via skeleton
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
 <1647000658-16149-6-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <829ace90-17fa-5076-b213-30357b1c4776@iogearbox.net>
Date:   Mon, 14 Mar 2022 23:26:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1647000658-16149-6-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26481/Mon Mar 14 09:39:13 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/22 1:10 PM, Alan Maguire wrote:
> tests that verify auto-attach works for function entry/return for
> local functions in program, library functions in program and library
> functions in library.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>   .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 48 +++++++++++++++
>   .../selftests/bpf/progs/test_uprobe_autoattach.c   | 69 ++++++++++++++++++++++
>   2 files changed, 117 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> new file mode 100644
> index 0000000..57ed636
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022, Oracle and/or its affiliates. */
> +
> +#include <test_progs.h>
> +#include "test_uprobe_autoattach.skel.h"
> +
> +/* uprobe attach point */
> +static void autoattach_trigger_func(void)
> +{
> +	asm volatile ("");
> +}
> +
> +void test_uprobe_autoattach(void)
> +{
> +	struct test_uprobe_autoattach *skel;
> +	char *mem;
> +
> +	skel = test_uprobe_autoattach__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel_open"))
> +		return;
> +	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
> +		goto cleanup;
> +
> +	if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
> +		goto cleanup;
> +
> +	/* trigger & validate uprobe & uretprobe */
> +	autoattach_trigger_func();
> +
> +	/* trigger & validate shared library u[ret]probes attached by name */
> +	mem = malloc(1);
> +	free(mem);
> +
> +	if (!ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res"))
> +		goto cleanup;
> +	if (!ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res"))
> +		goto cleanup;
> +	if (!ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res"))
> +		goto cleanup;
> +	if (!ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res"))
> +		goto cleanup;
> +	if (!ASSERT_EQ(skel->bss->uprobe_byname3_res, 5, "check_uprobe_byname3_res"))
> +		goto cleanup;
> +	if (!ASSERT_EQ(skel->bss->uretprobe_byname3_res, 6, "check_uretprobe_byname3_res"))
> +		goto cleanup;
> +cleanup:
> +	test_uprobe_autoattach__destroy(skel);
> +}

Hmm, looks like this fails CI, ptal:

https://github.com/kernel-patches/bpf/runs/5517172330?check_suite_focus=true

[...]
   test_attach_probe:PASS:uprobe_offset 0 nsec
   test_attach_probe:PASS:ref_ctr_offset 0 nsec
   test_attach_probe:PASS:skel_open 0 nsec
   test_attach_probe:PASS:check_bss 0 nsec
   test_attach_probe:PASS:attach_kprobe 0 nsec
   test_attach_probe:PASS:attach_kretprobe 0 nsec
   test_attach_probe:PASS:uprobe_ref_ctr_before 0 nsec
   test_attach_probe:PASS:attach_uprobe 0 nsec
   test_attach_probe:PASS:uprobe_ref_ctr_after 0 nsec
   test_attach_probe:PASS:attach_uretprobe 0 nsec
   test_attach_probe:PASS:auto-attach should fail for old-style name 0 nsec
   test_attach_probe:PASS:attach_uprobe_byname 0 nsec
   test_attach_probe:PASS:attach_uretprobe_byname 0 nsec
   test_attach_probe:PASS:attach_uprobe_byname2 0 nsec
   test_attach_probe:PASS:attach_uretprobe_byname2 0 nsec
   test_attach_probe:PASS:check_kprobe_res 0 nsec
   test_attach_probe:PASS:check_kretprobe_res 0 nsec
   test_attach_probe:PASS:check_uprobe_res 0 nsec
   test_attach_probe:PASS:check_uretprobe_res 0 nsec
   test_attach_probe:PASS:check_uprobe_byname_res 0 nsec
   test_attach_probe:PASS:check_uretprobe_byname_res 0 nsec
   test_attach_probe:PASS:check_uprobe_byname2_res 0 nsec
   test_attach_probe:FAIL:check_uretprobe_byname2_res unexpected check_uretprobe_byname2_res: actual 0 != expected 8
   test_attach_probe:PASS:uprobe_ref_ctr_cleanup 0 nsec
   #4 attach_probe:FAIL
[...]
