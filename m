Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39882595BE7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiHPMk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiHPMk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:40:57 -0400
Received: from out199-8.us.a.mail.aliyun.com (out199-8.us.a.mail.aliyun.com [47.90.199.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6079D677;
        Tue, 16 Aug 2022 05:40:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VMQMqX4_1660653650;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VMQMqX4_1660653650)
          by smtp.aliyun-inc.com;
          Tue, 16 Aug 2022 20:40:51 +0800
Date:   Tue, 16 Aug 2022 20:40:50 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jan Karcher <jaka@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] net/smc: optimize the parallelism of
 SMC-R connections
Message-ID: <YvuQUu/hbIZgJdTG@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
 <2182efbc-99f8-17ba-d344-95a467536b05@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2182efbc-99f8-17ba-d344-95a467536b05@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:35:15AM +0200, Jan Karcher wrote:
> 
> 
> On 10.08.2022 19:47, D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > This patch set attempts to optimize the parallelism of SMC-R connections,
> > mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> > occur after thoses optimization.
> > 
> 
> Thank you again for your submission!
> Let me give you a quick update from our side:
> We tested your patches on top of the net-next kernel on our s390 systems.
> They did crash our systems. After verifying our environment we pulled
> console logs and now we can tell that there is indeed a problem with your
> patches regarding SMC-D. So please do not integrate this change as of right
> now. I'm going to do more in depth reviews of your patches but i need some
> time for them so here is a quick a description of the problem:
> 
> It is a SMC-D problem, that occurs while building up the connection. In
> smc_conn_create you set struct smc_lnk_cluster *lnkc = NULL. For the SMC-R
> path you do grab the pointer, for SMC-D that never happens. Still you are
> using this refernce for SMC-D => Crash. This problem can be reproduced using
> the SMC-D path. Here is an example console output:

Got it.

> 
> [  779.516382] Unable to handle kernel pointer dereference in virtual kernel
> address space
> [  779.516389] Failing address: 0000000000000000 TEID: 0000000000000483
> [  779.516391] Fault in home space mode while using kernel ASCE.
> [  779.516395] AS:0000000069628007 R3:00000000ffbf0007 S:00000000ffbef800
> P:000000000000003d
> [  779.516431] Oops: 0004 ilc:2 [#1] SMP
> [  779.516436] Modules linked in: tcp_diag inet_diag ism mlx5_ib ib_uverbs
> mlx5_core smc_diag smc ib_core nft_fib_inet nft_fib_ipv4
> nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
> nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv
> 6 nf_defrag_ipv4 ip_set nf_tables n
> [  779.516470] CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted
> 5.19.0-13940-g22a46254655a #3
> [  779.516476] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
> 
> [  779.522738] Workqueue: smc_hs_wq smc_listen_work [smc]
> [  779.522755] Krnl PSW : 0704c00180000000 000003ff803da89c
> (smc_conn_create+0x174/0x968 [smc])
> [  779.522766]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0
> RI:0 EA:3
> [  779.522770] Krnl GPRS: 0000000000000002 0000000000000000 0000000000000001
> 0000000000000000
> [  779.522773]            000000008a4128a0 000003ff803f21aa 000000008e30d640
> 0000000086d72000
> [  779.522776]            0000000086d72000 000000008a412803 000000008a412800
> 000000008e30d650
> [  779.522779]            0000000080934200 0000000000000000 000003ff803cb954
> 00000380002dfa88
> [  779.522789] Krnl Code: 000003ff803da88e: e310f0e80024        stg
> %r1,232(%r15)
> [  779.522789]            000003ff803da894: a7180000            lhi %r1,0
> [  779.522789]           #000003ff803da898: 582003ac            l %r2,940
> [  779.522789]           >000003ff803da89c: ba123020            cs
> %r1,%r2,32(%r3)
> [  779.522789]            000003ff803da8a0: ec1603be007e        cij
> %r1,0,6,000003ff803db01c
> 
> [  779.522789]            000003ff803da8a6: 4110b002            la
> %r1,2(%r11)
> [  779.522789]            000003ff803da8aa: e310f0f00024        stg
> %r1,240(%r15)
> [  779.522789]            000003ff803da8b0: e310f0c00004        lg
> %r1,192(%r15)
> [  779.522870] Call Trace:
> [  779.522873]  [<000003ff803da89c>] smc_conn_create+0x174/0x968 [smc]
> [  779.522884]  [<000003ff803cb954>] smc_find_ism_v2_device_serv+0x1b4/0x300
> [smc]
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop
> from CPU 01.
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop
> from CPU 00.
> [  779.522894]  [<000003ff803cbace>] smc_listen_find_device+0x2e/0x370 [smc]
> 
> 
> I'm going to send the review for the first patch right away (which is the
> one causing the crash), so far I'm done with it. The others are going to
> follow. Maybe you can look over the problem and come up with a solution,
> otherwise we are going to decide if we want to look into it as soon as I'm
> done with the reviews. Thank you for your patience.

Thanks for pointing this issue. We will fix this soon in v2.

Tony Lu
