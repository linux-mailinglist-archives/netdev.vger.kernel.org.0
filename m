Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D47062F270
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbiKRKXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241520AbiKRKXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:23:15 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0450090385
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:23:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2D0BB20547;
        Fri, 18 Nov 2022 11:23:12 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qpuyu44NrSM3; Fri, 18 Nov 2022 11:23:11 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 03F4120563;
        Fri, 18 Nov 2022 11:23:11 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id F21F580004A;
        Fri, 18 Nov 2022 11:23:10 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 11:23:10 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 18 Nov
 2022 11:23:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4CE7A3180EFA; Fri, 18 Nov 2022 11:23:10 +0100 (CET)
Date:   Fri, 18 Nov 2022 11:23:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 4/8] xfrm: add TX datapath support for IPsec
 packet offload mode
Message-ID: <20221118102310.GQ704954@gauss3.secunet.de>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f0148001c77867d288251a96f6d838a16a6dbdc4.1667997522.git.leonro@nvidia.com>
 <20221117115939.GI704954@gauss3.secunet.de>
 <Y3YpyplG969qtYO3@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3YpyplG969qtYO3@unreal>
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

On Thu, Nov 17, 2022 at 02:32:10PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 17, 2022 at 12:59:39PM +0100, Steffen Klassert wrote:
> > On Wed, Nov 09, 2022 at 02:54:32PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > > @@ -2708,6 +2710,23 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
> > >  	if (!dev)
> > >  		goto free_dst;
> > >  
> > > +	dst1 = &xdst0->u.dst;
> > > +	/* Packet offload: both policy and SA should be offloaded */
> > > +	if ((policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > +	     dst1->xfrm->xso.type != XFRM_DEV_OFFLOAD_PACKET) ||
> > > +	    (policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET &&
> > > +	     dst1->xfrm->xso.type == XFRM_DEV_OFFLOAD_PACKET)) {
> > > +		err = -EINVAL;
> > > +		goto free_dst;
> > > +	}
> > > +
> > > +	/* Packet offload: both policy and SA should have same device */
> > > +	if (policy->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > +	    policy->xdo.dev != dst1->xfrm->xso.dev) {
> > > +		err = -EINVAL;
> > > +		goto free_dst;
> > > +	}
> > > +
> > 
> > This is the wrong place for these checks. Things went already wrong
> > in the lookup if policy and state do not match here.
> 
> Where do you think we should put such checks?

You need to create a new lookup key for this and match the policies
template against the TS of the state. This happens in xfrm_state_find.
Unfortunately this affects also the SW datapath even without HW
policies/states. So please try to make it a NOP if there are no HW
policies/states.

