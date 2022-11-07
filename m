Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9FD61EC8F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiKGIHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKGIHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:07:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160C012AB3;
        Mon,  7 Nov 2022 00:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9E78B80E15;
        Mon,  7 Nov 2022 08:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D1C433C1;
        Mon,  7 Nov 2022 08:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667808413;
        bh=VMhzbizg8eVkxMezhIH4pAP81sAj1v2PIczFUrJQNBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l7dAMeIFM07kbd04EWFxjHqh5+VIPkLEjnO85T2jF+8G4MkOTBAJDH6BGbaxsHCY4
         kAoLNnR6xeS+GiDVZkvDH2DVYv8LPAmjMf57aQdqKpW45qXtw4y4XuonW9QvNsZpJE
         TyVScLedExIpxKhx/GV8klikbJ41PJ0w1920b/UaHRYKIYBgghGe5Km76bvPo18Ofb
         CqHZ9/fXf03qZesFeYbQDYrwThYRXjjbBcqgNxTbNYUiAFjisr+JWsxyUJ6acB11k4
         SPYvcfQAjzBhcttBBNMOC84xcjYoX2jPdxpM7ZyJ6+HAlvnxpuzUQ9O5pIXO5cJ5SF
         7McepBrgvzO3Q==
Date:   Mon, 7 Nov 2022 10:06:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net] xfrm: Fix ignored return value in xfrm6_init()
Message-ID: <Y2i8mC0fNrs4MJsq@unreal>
References: <20221103090713.188740-1-chenzhongjin@huawei.com>
 <Y2gGIuwY368X8Won@unreal>
 <917fab11-ae57-07b9-ae67-7c290c7c6723@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <917fab11-ae57-07b9-ae67-7c290c7c6723@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 11:22:40AM +0800, Chen Zhongjin wrote:
> Hi,
> 
> On 2022/11/7 3:08, Leon Romanovsky wrote:
> > On Thu, Nov 03, 2022 at 05:07:13PM +0800, Chen Zhongjin wrote:
> > > When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
> > > is possible to fail but its return value is ignored.
> > > 
> > > If IPv6 initialization fails later and xfrm6_fini() is called,
> > > removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:
> > > 
> > > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > > CPU: 1 PID: 330 Comm: insmod
> > > RIP: 0010:unregister_pernet_operations+0xc9/0x450
> > > Call Trace:
> > >   <TASK>
> > >   unregister_pernet_subsys+0x31/0x3e
> > >   xfrm6_fini+0x16/0x30 [ipv6]
> > >   ip6_route_init+0xcd/0x128 [ipv6]
> > >   inet6_init+0x29c/0x602 [ipv6]
> > >   ...
> > > 
> > > Fix it by catching the error return value of register_pernet_subsys().
> > > 
> > > Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
> > > Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> > > ---
> > >   net/ipv6/xfrm6_policy.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > I see same error in net/ipv4/xfrm4_policy.c which introduced by same
> > commit mentioned in Fixes line.
> 
> It's true that in xfrm4_init() the ops->init is possible to fail as well.
> 
> However there is no error handling or exit path for ipv4, so IIUC the ops
> won't be unregistered anyway.
> 
> Considering that ipv4 don't handle most of error in initialization, maybe
> it's better to keep it as it is?

Yeah, makes sense.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
