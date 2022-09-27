Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92755EBA05
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiI0Fst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 01:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiI0Fso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 01:48:44 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E3C915D3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 22:48:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 86289204B4;
        Tue, 27 Sep 2022 07:48:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j4sUjSRwtEYT; Tue, 27 Sep 2022 07:48:38 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E02992008D;
        Tue, 27 Sep 2022 07:48:38 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D067580004A;
        Tue, 27 Sep 2022 07:48:38 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:48:38 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 07:48:38 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 252EF31829E5; Tue, 27 Sep 2022 07:48:38 +0200 (CEST)
Date:   Tue, 27 Sep 2022 07:48:38 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 6/8] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <20220927054838.GL2950045@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <1b9d865971972a63eaa2c076afd71743952bd3c8.1662295929.git.leonro@nvidia.com>
 <20220925093454.GU2602992@gauss3.secunet.de>
 <YzFI0kxN3k2EZw0v@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzFI0kxN3k2EZw0v@unreal>
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

On Mon, Sep 26, 2022 at 09:38:10AM +0300, Leon Romanovsky wrote:
> On Sun, Sep 25, 2022 at 11:34:54AM +0200, Steffen Klassert wrote:
> > On Sun, Sep 04, 2022 at 04:15:40PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Devices that implement IPsec full offload mode offload policies too.
> > > In RX path, it causes to the situation that HW can't effectively handle
> > > mixed SW and HW priorities unless users make sure that HW offloaded
> > > policies have higher priorities.
> > > 
> > > In order to make sure that users have coherent picture, let's require
> > > that HW offloaded policies have always (both RX and TX) higher priorities
> > > than SW ones.
> > > 
> > > To do not over engineer the code, HW policies are treated as SW ones and
> > > don't take into account netdev to allow reuse of same priorities for
> > > different devices.
> > 
> > I think we should split HW and SW SPD (and maybe even SAD) and priorize
> > over the SPDs instead of doing that in one single SPD. Each NIC should
> > maintain its own databases and we should do the lookups from SW with
> > a callback. 
> 
> I don't understand how will it work and scale.

That is rather easy. HW offload devices register their databases
at the xfrm layer with a certain priority higher than the one
of the SW databases. The lookup will happen consecutively based
on the database priorities. If there are no HW databases are
registered everything is like it was before. It gives us a clear
separation between HW and SW.

This has the advantage that you don't need to mess with policy
priorites. User can keep the priorites as they were before. This
is in particular important because usually the IKE daemon chosses
the priorities based on some heuristics.

The HW offload has also the advantage that we don't need to
search through all SW policies and states in that case.

> Every packet needs to be classified if it is in offloaded path or not.
> To ensure that, we will need to have two identifiers: targeted device
> (part of skb, so ok) and relevant SP/SA.
> 
> The latter is needed to make sure that we perform lookup only on
> offloaded SP/SA. It means that we will do lookup twice now. First
> to see if SP/SA is offloaded and second to see if it in HW.

I think you did not get my point, see above.

> HW lookup is also misleading name, as the lookup will be in driver code
> in very similar way to how SADB managed for crypto mode.

No, HW lookup means we do the lookup in the hardware and return
the result to software. The whole point of a 'full offload' is
to get rid of the costly SW database lookups.

> It makes no
> sense to convert data from XFRM representation to HW format, execute in
> HW and convert returned result back. It will be also slow because lookup
> of SP/SA based on XFRM properties is not datapath.

In case the HW can't do the lookup itself or is considered to be slower
than in software, a separated database for HW offload devices can be
maintained.

> In any case, you will have double lookup. You will need to query XFRM
> core DBs and later call to driver DB or vice versa.
> 
> Unless you want to perform HW lookup always without relation to SP/SA
> state and hurt performance for non-offloaded path.
> 
> > With the current approach, we still do the costly full
> > policy and state lookup on the TX side in software. On a 'full offload'
> > that should happen in HW too.
> 
> In proposed approach, you have only one lookup which is better than two.

In your approach, you still do the lookups in SW. This is not a problem
if you have just a handfull policies and SAs, but is problematic when
you have 100K policies and SAs. Even if the current HW can not support
this, we need to make sure our design allows for it.

> I'm not even talking about "quality" of driver lookups implementations.

You don't need to to reimplement the lookups, you just have to create an
additional database.

> 
> > Also, that will make things easier with tunnel mode whre we can have overlapping
> > traffic selectors.
> 
> Can we please put tunnel mode aside? It is a long journey.

No, we can't. A good design should include transport and tunnel mode.
I don't want to change everyting later just because we notice then that
it does not work at all for tunnel mode.

