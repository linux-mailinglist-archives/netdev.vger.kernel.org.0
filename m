Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62562CD61
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiKPWJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbiKPWJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:09:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FAC6A6B8;
        Wed, 16 Nov 2022 14:09:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3D0EB81EE1;
        Wed, 16 Nov 2022 22:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752BCC433D6;
        Wed, 16 Nov 2022 22:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668636538;
        bh=BAv4r6eNcyU1DYIdfn/4sCGtHRvGswgoegbRQ/qzZyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=geVbJAxAyvNHXdIKe73hgeTJRiacFy2PDX9ULvuhTArhtelVuz21DIPxK9TMLUcGN
         zwqCwR4h0e3fFge4ql4mZ3gzdrN4TKxs1AY8ktnUVgv2+5FMoQSZDwnjFIXSrhHbkZ
         90/ZpFNcaF+wQuOywzhCqM9ATJv0pnE/v5mVHUBAzLk24W63KDID8hMJzU1pS4JplF
         266BdiNy1AKxRLt6Hd+HNuM1D1+dHx+OZEbK3IfMhm//lvQ5uxooK4ZrJym9Fyz+3j
         V3oPaX+la83hJ7SrnfspvMDI4VhP2KH8kysim+HMCNFW9m4qT4s7sA07VcfiM4OSYv
         S3D5svNVrLgww==
Date:   Wed, 16 Nov 2022 14:08:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev
Subject: Re: [PATCH v2 2/2] selftests/net: fix opening object file failed
Message-ID: <Y3VfeXK092oeV+yh@x130.lan>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
 <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 18:23, Wang Yufen wrote:
>The program file used in the udpgro_frglist testcase is "../bpf/nat6to4.o",
>but the actual nat6to4.o file is in "bpf/" not "../bpf".
>The following error occurs:
>  Error opening object ../bpf/nat6to4.o: No such file or directory
>  Cannot initialize ELF context!
>  Unable to load program
>
>In addition, all the kernel bpf source files are centred under the
>subdir "progs" after commit bd4aed0ee73c ("selftests: bpf: centre
>kernel bpf objects under new subdir "progs""). So mv nat6to4.c to
                                                   ^^ move :) 
>"../bpf/progs" and use "../bpf/nat6to4.bpf.o". And also move the
>test program to selftests/bpf.
>

Can you separate the fix from the mv ?

>Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
>Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>---
> tools/testing/selftests/bpf/Makefile               |   7 +-
> tools/testing/selftests/bpf/in_netns.sh            |  23 +
> .../testing/selftests/bpf/progs/nat6to4_egress4.c  | 184 ++++++
> .../testing/selftests/bpf/progs/nat6to4_ingress6.c | 149 +++++
> tools/testing/selftests/bpf/test_udpgro_frglist.sh | 110 ++++
> tools/testing/selftests/bpf/udpgso_bench_rx.c      | 409 ++++++++++++
> tools/testing/selftests/bpf/udpgso_bench_tx.c      | 712 +++++++++++++++++++++
> tools/testing/selftests/net/Makefile               |   2 -
> tools/testing/selftests/net/bpf/Makefile           |  14 -
> tools/testing/selftests/net/bpf/nat6to4.c          | 285 ---------
> tools/testing/selftests/net/udpgro_frglist.sh      | 103 ---
> 11 files changed, 1592 insertions(+), 406 deletions(-)
> create mode 100755 tools/testing/selftests/bpf/in_netns.sh
> create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_egress4.c
> create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
> create mode 100755 tools/testing/selftests/bpf/test_udpgro_frglist.sh
> create mode 100644 tools/testing/selftests/bpf/udpgso_bench_rx.c
> create mode 100644 tools/testing/selftests/bpf/udpgso_bench_tx.c
> delete mode 100644 tools/testing/selftests/net/bpf/Makefile
> delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
> delete mode 100755 tools/testing/selftests/net/udpgro_frglist.sh
>

created more files than deleted? also moving files should appear as
rename. Did you do the mv with git mv ? I am surprised how git didn't pick this up
as "rename".

For next version please use tag [PATCH bpf-next]
