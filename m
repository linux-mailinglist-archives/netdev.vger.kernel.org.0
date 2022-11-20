Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08ED6315D4
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 20:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiKTTRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 14:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTTRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 14:17:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285DE2936F
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 11:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B77FB60CE8
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 19:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48621C433C1;
        Sun, 20 Nov 2022 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668971832;
        bh=arFcT+OFkB6aBvyQGTIbDpWjCrkvSV1A7o98ibXekdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fU28F/CYVDysSpbmD+d5CpBfTn5TTjYTcAN7INYr/v94Y7sxW52IE4wWcaUwfoLSD
         KaR9XRpl3yQOhfbNvwopzESW4bua9YiIgPkpqhsti6IchtnU5/WN9aFrKz0AL1g7TB
         rCZvvDXvwhjATPJ1OjbaxpZRim67PprJyKsxepgQ6Ma1FvvOnDuoJGIi3DAKZnUc2y
         K7dBCLry9eAfXUsQc75hg0hwRlMhqVx0hboW51bGEb7HCkFdM9Xytlx0XKP1brfY/6
         X0BVnEb775NAUOp/O6Lj2IqUaXTQd0vN+9fyRiFlUTKDVLSPEWonykOodxWMrLdzgC
         soPfy9cikJnGA==
Date:   Sun, 20 Nov 2022 21:17:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3p9LvAEQMAGeaCR@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118104907.GR704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > This does not work. A larval state will never have a x->xso.type set.
> > 
> > x->xso.type always exists. Default is 0, which is XFRM_DEV_OFFLOAD_UNSPECIFIED.
> > It means this XFRM_STATE_INSERT() will behave exactly as hlist_add_head_rcu() before.
> 
> Sure it exists, and is always 0 here.
> 
> > 
> > > So this raises the question how to handle acquires with this packet
> > > offload. 
> > 
> > We handle acquires as SW policies and don't offload them.
> 
> We trigger acquires with states, not policies. The thing is,
> we might match a HW policy but create a SW acquire state.
> This will not match anymore as soon as the lookup is
> implemented correctly.

For now, all such packets will be dropped as we have offlaoded
policy but not SA.

Like we said in one of our IPsec coffee hours, this flow will be
supported later. Right now, it is not important.

> 
> > > You could place the type and offload device to the template,
> > > but we also have to make sure not to mess too much with the non
> > > offloaded codepath.
> > > 
> > > This is yet another corner case where the concept of doing policy and
> > > state lookup in software for a HW offload does not work so well. I
> > > fear this is not the last corner case that comes up once you put this
> > > into a real network.
> > > 
> > 
> > It is not different from any other kernel code, bugs will be fixed.
> 
> The thing that is different here is, that the concept is already
> broken. We can't split the datapath to be partially handled in
> SW and HW in any sane way, this becomes clearer and clearer.
> 
> The full protocol offload simply does not fit well into HW,
> but we try to make it fit with a hammer. This is the problem
> why I do not really like this, and is also the reason why this
> is still not merged. We might be much better of by doing a
> HW frindly redesign of the protocol and offload this then.
> But, yes that takes time and will have issues too.

When you say "protocol", what do you mean? Many users, who have
deployed IPsec solutions, just want to have same look and feel
but much faster.

I truly believe that this packet offload fits SW model and the
(small) amount of changes supports it. There are almost no changes
to the stack to natively support this offload.

As long as HW involved, you will never have solution without issues,
and like you said even redesign "will have issues".

Plus, we called it packet offload, better and redesigned version will
be called something else. My patches which enhance XFRM to support more
than type of offload are exactly for that.

Thanks 
