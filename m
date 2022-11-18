Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E516962FD7A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbiKRS7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbiKRS54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:57:56 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D15BBE2B;
        Fri, 18 Nov 2022 10:57:37 -0800 (PST)
Message-ID: <e126b2cd-b8c7-5b04-324e-1bae06d7c22e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668797855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNh0y1dEP2ClIUC9F0BcoG+zdwd/Pp1A2lLbHHBONYs=;
        b=nJH/ClVRyVOKtHU0UzqcCeq0mjmesLoZ1bcu462aRcCrZ7KYinnLcmqjWTVa4d4JoGXbg9
        m/jxO7x+2O6l43TUjqHMp8fjiW+zSpSxFaIlyC5CvKqR0xIdnWsJ8OnFSBnTJex2d1NEwO
        A9sBcWSlY2hK568cKHN+Sd4xfvysNT0=
Date:   Fri, 18 Nov 2022 10:57:31 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] selftests/net: fix opening object file failed
Content-Language: en-US
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, andrii@kernel.org,
        mykolal@fb.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
 <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 2:23 AM, Wang Yufen wrote:
> The program file used in the udpgro_frglist testcase is "../bpf/nat6to4.o",
> but the actual nat6to4.o file is in "bpf/" not "../bpf".
> The following error occurs:
>    Error opening object ../bpf/nat6to4.o: No such file or directory
>    Cannot initialize ELF context!
>    Unable to load program
> 
> In addition, all the kernel bpf source files are centred under the
> subdir "progs" after commit bd4aed0ee73c ("selftests: bpf: centre
> kernel bpf objects under new subdir "progs""). So mv nat6to4.c to
> "../bpf/progs" and use "../bpf/nat6to4.bpf.o". And also move the
> test program to selftests/bpf.
> 
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>   tools/testing/selftests/bpf/Makefile               |   7 +-
>   tools/testing/selftests/bpf/in_netns.sh            |  23 +
>   .../testing/selftests/bpf/progs/nat6to4_egress4.c  | 184 ++++++
>   .../testing/selftests/bpf/progs/nat6to4_ingress6.c | 149 +++++
>   tools/testing/selftests/bpf/test_udpgro_frglist.sh | 110 ++++

Love to have more tests in the BPF CI which is run continuously: eg: 
https://github.com/kernel-patches/bpf/actions/runs/3491826279/jobs/5845219757

However, script like this does not get run in CI. test_progs has a more 
consistent error output and ensures some environment cleanup before running the 
next test.  Please take some effort to adapt this test to the bpf/test_progs.c 
framework which had already been suggested in the previous revision.

Try to run ./test_progs under the bpf selftests directory.  There are existing 
examples to setup/switch net ns and test_progs has logic in place to ensure the 
netns is restored before running the next selftest.  eg. take a look at 
bpf/prog_tests/{test_tunnel,tc_redirect}.c.


>   tools/testing/selftests/bpf/udpgso_bench_rx.c      | 409 ++++++++++++
>   tools/testing/selftests/bpf/udpgso_bench_tx.c      | 712 +++++++++++++++++++++

hmmm, it is a copy? Does it need all the bench marking feature (e.g. all the cmd 
args)?  If not, please simply because I expect the test_udpgro_frglist.sh, 
udpgso_bench_rx.c, and udpgso_bench_tx.c will become one file 
'selftests/bpf/prog_tests/udpgrp_frglish.c' which loads the bpf prog and 
generates traffic to exercise the bpf prog.

Please tag it with bpf-next in the next spin which Saeed has also mentioned in 
another thread.

>   tools/testing/selftests/net/Makefile               |   2 -
>   tools/testing/selftests/net/bpf/Makefile           |  14 -
>   tools/testing/selftests/net/bpf/nat6to4.c          | 285 ---------
>   tools/testing/selftests/net/udpgro_frglist.sh      | 103 ---
>   11 files changed, 1592 insertions(+), 406 deletions(-)
>   create mode 100755 tools/testing/selftests/bpf/in_netns.sh
>   create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_egress4.c
>   create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
>   create mode 100755 tools/testing/selftests/bpf/test_udpgro_frglist.sh
>   create mode 100644 tools/testing/selftests/bpf/udpgso_bench_rx.c
>   create mode 100644 tools/testing/selftests/bpf/udpgso_bench_tx.c
>   delete mode 100644 tools/testing/selftests/net/bpf/Makefile
>   delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
>   delete mode 100755 tools/testing/selftests/net/udpgro_frglist.sh

