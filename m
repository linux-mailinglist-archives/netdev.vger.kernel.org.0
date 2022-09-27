Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392A15EB96C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 07:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiI0FEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 01:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI0FEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 01:04:43 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE47270
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 22:04:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 94891204D9;
        Tue, 27 Sep 2022 07:04:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RSDg6bAXhnMJ; Tue, 27 Sep 2022 07:04:37 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1939A20189;
        Tue, 27 Sep 2022 07:04:37 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0278280004A;
        Tue, 27 Sep 2022 07:04:37 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:04:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 07:04:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0131C31829E5; Tue, 27 Sep 2022 07:04:35 +0200 (CEST)
Date:   Tue, 27 Sep 2022 07:04:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 4/8] xfrm: add TX datapath support for
 IPsec full offload mode
Message-ID: <20220927050435.GK2950045@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <0a44d3b02479e5b19831038f9dc3a99259fa50f3.1662295929.git.leonro@nvidia.com>
 <20220925091603.GS2602992@gauss3.secunet.de>
 <YzFBeC4ltNmQf9DU@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzFBeC4ltNmQf9DU@unreal>
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

On Mon, Sep 26, 2022 at 09:06:48AM +0300, Leon Romanovsky wrote:
> On Sun, Sep 25, 2022 at 11:16:03AM +0200, Steffen Klassert wrote:
> > On Sun, Sep 04, 2022 at 04:15:38PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > > index 9a5e79a38c67..dde009be8463 100644
> > > --- a/net/xfrm/xfrm_output.c
> > > +++ b/net/xfrm/xfrm_output.c
> > > @@ -494,7 +494,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
> > >  	struct xfrm_state *x = dst->xfrm;
> > >  	struct net *net = xs_net(x);
> > >  
> > > -	if (err <= 0)
> > > +	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > >  		goto resume;
> > 
> > You check here that the state is marked as 'full offload' before
> > you skip the SW xfrm handling, but I don't see where you check
> > that the policy that led to this state is offloaded too. Also,
> > we have to make sure that both, policy and state is offloaded to
> > the same device. Looks like this part is missing.
> 
> In SW flow, users are not required to configure policy. If they don't
> have policy, the packet will be encrypted and sent anyway.

No, it is not! You can't lookup a TX SA without a policy. The lookup
happens in two stages. The packet header is matched against the TS of
the policy. Then the template found at the policy is used to lookup
the SA.

> The full offload follows same semantic. The missing offloaded policy is
> equal to no policy at all.

No policy at all means that the packets are sent out unencrypted in
plaintext, and this is certainly not what you want.

> I don't think that extra checks are needed.

We need this checks. This is one of the reasons why I want to separate
the SW and HW databases.
