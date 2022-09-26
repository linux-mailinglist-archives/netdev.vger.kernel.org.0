Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CED5E99A8
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiIZGiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiIZGiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:38:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC75F42
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 403DFB818D6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21358C433D6;
        Mon, 26 Sep 2022 06:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664174294;
        bh=FTyjIIrlwr5V4b25coUjFY2bjKDMAvepiDkqaaNXx70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPIUw4aqWi/54ZRJqCmZo6Dcjv/w+42/lhPTmu+JumsOKBvXfPTd13uJHNJ+Nx5cS
         BtWnNzv5JWVB8uJ3/a+LWmNJ3QWvroOj0/AkBiGy2/V7aPsnGOtR+qFe5wO6rB39ZK
         J2J/2tH+VjW1rrlD75lqBO5uBH1FVNN1GgJ9fI8NWeuxxxe/QMITWy4n+YBMr26MPn
         QJ0yGJ6Ul5jqO0iZRcfqdjdlUtsJIiPUteTEuy3CcQdHQVUpYea4scI9F+iPAXifyn
         UU1lVCKhmzbdmPMrmjak0BlApJKTRvBnY4utHBd46i+pQdAXzL3YgF2zDM/9N8GWG8
         L0dLZJTpdVqWQ==
Date:   Mon, 26 Sep 2022 09:38:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 6/8] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <YzFI0kxN3k2EZw0v@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <1b9d865971972a63eaa2c076afd71743952bd3c8.1662295929.git.leonro@nvidia.com>
 <20220925093454.GU2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925093454.GU2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:34:54AM +0200, Steffen Klassert wrote:
> On Sun, Sep 04, 2022 at 04:15:40PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Devices that implement IPsec full offload mode offload policies too.
> > In RX path, it causes to the situation that HW can't effectively handle
> > mixed SW and HW priorities unless users make sure that HW offloaded
> > policies have higher priorities.
> > 
> > In order to make sure that users have coherent picture, let's require
> > that HW offloaded policies have always (both RX and TX) higher priorities
> > than SW ones.
> > 
> > To do not over engineer the code, HW policies are treated as SW ones and
> > don't take into account netdev to allow reuse of same priorities for
> > different devices.
> 
> I think we should split HW and SW SPD (and maybe even SAD) and priorize
> over the SPDs instead of doing that in one single SPD. Each NIC should
> maintain its own databases and we should do the lookups from SW with
> a callback. 

I don't understand how will it work and scale.

Every packet needs to be classified if it is in offloaded path or not.
To ensure that, we will need to have two identifiers: targeted device
(part of skb, so ok) and relevant SP/SA.

The latter is needed to make sure that we perform lookup only on
offloaded SP/SA. It means that we will do lookup twice now. First
to see if SP/SA is offloaded and second to see if it in HW.

HW lookup is also misleading name, as the lookup will be in driver code
in very similar way to how SADB managed for crypto mode. It makes no
sense to convert data from XFRM representation to HW format, execute in
HW and convert returned result back. It will be also slow because lookup
of SP/SA based on XFRM properties is not datapath.

In any case, you will have double lookup. You will need to query XFRM
core DBs and later call to driver DB or vice versa.

Unless you want to perform HW lookup always without relation to SP/SA
state and hurt performance for non-offloaded path.

> With the current approach, we still do the costly full
> policy and state lookup on the TX side in software. On a 'full offload'
> that should happen in HW too.

In proposed approach, you have only one lookup which is better than two.
I'm not even talking about "quality" of driver lookups implementations.

> Also, that will make things easier with tunnel mode whre we can have overlapping
> traffic selectors.

Can we please put tunnel mode aside? It is a long journey.

> 
> We can keep a HW SPD in software as a fallback for devices that don't
> support the offloaded lookup, but on the long run lookups for the  RX
> anf TX path should happen in HW.

I doubt about it.

> 
