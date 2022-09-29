Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8045EECD5
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 06:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiI2Ejz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 00:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiI2Ejy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 00:39:54 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467B5602B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 21:39:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0D4C8201AE;
        Thu, 29 Sep 2022 06:39:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oTayD9mzSJ-N; Thu, 29 Sep 2022 06:39:48 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8927D20082;
        Thu, 29 Sep 2022 06:39:48 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7880780004A;
        Thu, 29 Sep 2022 06:39:48 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 06:39:48 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 06:39:48 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6C2803182AD8; Thu, 29 Sep 2022 06:39:47 +0200 (CEST)
Date:   Thu, 29 Sep 2022 06:39:47 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Liu Jian <liujian56@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] xfrm: Reinject transport-mode packets through
 workqueue
Message-ID: <20220929043947.GX2950045@gauss3.secunet.de>
References: <20220924080157.247678-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220924080157.247678-1-liujian56@huawei.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 04:01:57PM +0800, Liu Jian wrote:
> The following warning is displayed when the tcp6-multi-diffip11 stress
> test case of the LTP test suite is tested:
> 
> watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [ns-tcpserver:48198]
> CPU: 0 PID: 48198 Comm: ns-tcpserver Kdump: loaded Not tainted 6.0.0-rc6+ #39
> Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : des3_ede_encrypt+0x27c/0x460 [libdes]
> lr : 0x3f
> sp : ffff80000ceaa1b0
> x29: ffff80000ceaa1b0 x28: ffff0000df056100 x27: ffff0000e51e5280
> x26: ffff80004df75030 x25: ffff0000e51e4600 x24: 000000000000003b
> x23: 0000000000802080 x22: 000000000000003d x21: 0000000000000038
> x20: 0000000080000020 x19: 000000000000000a x18: 0000000000000033
> x17: ffff0000e51e4780 x16: ffff80004e2d1448 x15: ffff80004e2d1248
> x14: ffff0000e51e4680 x13: ffff80004e2d1348 x12: ffff80004e2d1548
> x11: ffff80004e2d1848 x10: ffff80004e2d1648 x9 : ffff80004e2d1748
> x8 : ffff80004e2d1948 x7 : 000000000bcaf83d x6 : 000000000000001b
> x5 : ffff80004e2d1048 x4 : 00000000761bf3bf x3 : 000000007f1dd0a3
> x2 : ffff0000e51e4780 x1 : ffff0000e3b9a2f8 x0 : 00000000db44e872
> Call trace:

...

> The tasklet software interrupt takes too much time. Therefore, the
> xfrm_trans_reinject executor is changed from tasklet to workqueue. Add add
> spin lock to protect the queue. This reduces the processing flow of the
> tcp_sendmsg function in this scenario.
> 
> Fixes: acf568ee859f0 ("xfrm: Reinject transport-mode packets through tasklet")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Applied, thanks!
