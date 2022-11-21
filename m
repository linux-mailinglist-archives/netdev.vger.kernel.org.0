Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A763204C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiKULVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiKULUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:20:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E48C5637
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F01AE61009
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86411C433D6;
        Mon, 21 Nov 2022 11:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669029341;
        bh=SR2CBLWGnJycuKVplG/voy7722IHfuUgP+kIvtzChlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDtxBvq2Jwh3KVZ+JT5JSC1lrKLa5hSdu42cXdgAHmGYg6Zkz2X9e4XoRsi372oi9
         LRy94VYFrSzragETs1A0UnpwO6DscTQKrEMW09dbc8S23isGUx+ET84qSWvE6u4iRW
         mjVyQqc6RYBJtCRZcFhChbx6NYW7CvolEK4H6EBUnMYcm5WacWqW1jUutfzjxZQJld
         9HOrt1+4gDqdu7jM5E+AtXYQtwmvwCI8tsuvqFZqSJmLC3Lgm8LAJyPfyVH+8LjZJa
         DPbQkIqNGojiatKiMSvwSAJwTDpEmxGtfd/P/pYw4Uf0mvneOhj0xlLjEjgP3+Waqn
         aRfYhFf/r19zQ==
Date:   Mon, 21 Nov 2022 13:15:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3td2OjeIL0GN7uO@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121110926.GV704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:09:26PM +0100, Steffen Klassert wrote:
> On Mon, Nov 21, 2022 at 12:27:01PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 21, 2022 at 10:44:04AM +0100, Steffen Klassert wrote:
> > > On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> > > > On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > > > > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > > > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > 
> > > > > > > So this raises the question how to handle acquires with this packet
> > > > > > > offload. 
> > > > > > 
> > > > > > We handle acquires as SW policies and don't offload them.
> > > > > 
> > > > > We trigger acquires with states, not policies. The thing is,
> > > > > we might match a HW policy but create a SW acquire state.
> > > > > This will not match anymore as soon as the lookup is
> > > > > implemented correctly.
> > > > 
> > > > For now, all such packets will be dropped as we have offlaoded
> > > > policy but not SA.
> > > 
> > > I think you missed my point. If the HW policy does not match
> > > the SW acquire state, then each packet will geneate a new
> > > acquire. So you need to make sure that policy and acquire
> > > state will match to send the acquire just once to userspace.
> > 
> > I think that I'm still missing the point.
> > 
> > We require both policy and SA to be offloaded. It means that once
> > we hit HW policy, we must hit SA too (at least this is how mlx5 part
> > is implemented).
> 
> Let's assume a packet hits a HW policy. Then this HW policy must match
> a HW state. In case there is no matching HW state, we generate an acquire
> and insert a larval state. Currently, larval states are never marked as HW.

And this is there our views are different. If HW (in RX) sees policy but
doesn't have state, this packet will be dropped in HW. It won't get to
stack and no acquire request will be issues.

> 
> Now, the next packet from the same flow maches again this HW policy,
> but it does not find the larval state because it is not marked as
> a HW state. So we generate another acquire and insert another
> larval state. Same happens for packets 3,4,5...
> 
> Expected behaviour for subsequent packets is that the lookup will
> find a matching HW larval state and the packet is dropped without
> creating another acquire + larval state for the same flow.
> 

This is why we don't support acquire for now as it will require mixing
HW and SW paths which we don't want for now.

Thanks
