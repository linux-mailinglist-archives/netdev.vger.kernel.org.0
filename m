Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C8162D385
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKQGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQGd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:33:26 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD762E0;
        Wed, 16 Nov 2022 22:33:24 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4B7412052E;
        Thu, 17 Nov 2022 07:33:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DIxknmb5yAGe; Thu, 17 Nov 2022 07:33:22 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BCF4320501;
        Thu, 17 Nov 2022 07:33:22 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id ADF4E80004A;
        Thu, 17 Nov 2022 07:33:22 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 07:33:22 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 07:33:22 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E44F5318194B; Thu, 17 Nov 2022 07:33:21 +0100 (CET)
Date:   Thu, 17 Nov 2022 07:33:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Chen Zhongjin <chenzhongjin@huawei.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mkubecek@suse.cz>
Subject: Re: [PATCH net] xfrm: Fix ignored return value in xfrm6_init()
Message-ID: <20221117063321.GD704954@gauss3.secunet.de>
References: <20221103090713.188740-1-chenzhongjin@huawei.com>
 <Y2gGIuwY368X8Won@unreal>
 <917fab11-ae57-07b9-ae67-7c290c7c6723@huawei.com>
 <Y2i8mC0fNrs4MJsq@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2i8mC0fNrs4MJsq@unreal>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 10:06:48AM +0200, Leon Romanovsky wrote:
> On Mon, Nov 07, 2022 at 11:22:40AM +0800, Chen Zhongjin wrote:
> > Hi,
> > 
> > On 2022/11/7 3:08, Leon Romanovsky wrote:
> > > On Thu, Nov 03, 2022 at 05:07:13PM +0800, Chen Zhongjin wrote:
> > > > When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
> > > > is possible to fail but its return value is ignored.
> > > > 
> > > > If IPv6 initialization fails later and xfrm6_fini() is called,
> > > > removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:
> > > > 
> > > > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > > > CPU: 1 PID: 330 Comm: insmod
> > > > RIP: 0010:unregister_pernet_operations+0xc9/0x450
> > > > Call Trace:
> > > >   <TASK>
> > > >   unregister_pernet_subsys+0x31/0x3e
> > > >   xfrm6_fini+0x16/0x30 [ipv6]
> > > >   ip6_route_init+0xcd/0x128 [ipv6]
> > > >   inet6_init+0x29c/0x602 [ipv6]
> > > >   ...
> > > > 
> > > > Fix it by catching the error return value of register_pernet_subsys().
> > > > 
> > > > Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
> > > > Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> > > > ---
> > > >   net/ipv6/xfrm6_policy.c | 6 +++++-
> > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > I see same error in net/ipv4/xfrm4_policy.c which introduced by same
> > > commit mentioned in Fixes line.
> > 
> > It's true that in xfrm4_init() the ops->init is possible to fail as well.
> > 
> > However there is no error handling or exit path for ipv4, so IIUC the ops
> > won't be unregistered anyway.
> > 
> > Considering that ipv4 don't handle most of error in initialization, maybe
> > it's better to keep it as it is?
> 
> Yeah, makes sense.
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied, thanks a lot!
