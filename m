Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297B96320CE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiKULhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiKULhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:37:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F2CF005
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5E860FF4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51768C433B5;
        Mon, 21 Nov 2022 11:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669030474;
        bh=BgMlPK3jVxY7kl0IQ45+ysDYm8FXcLNHEMzqRJluLLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLfxP33d2XuQY9CN1gKc4sdyoREOMtvVtok3i9Q6oFLzfP4qPhFQkvFqfVvmj7s+R
         Sgl0A+ZHg3uP5TTO4+X4WpOSW4J90CqWDjMIkeYc1o5LxC5Rjh1lLOyHDlS+caXfgr
         2i1/W4vmJ9fpwuDhUfLCeg7EYLtWGYysV/kb32vfj5LKBs7ZS+jyYebcvB8T71hvoK
         0cfumZ3mi2kv67659ZpgkS9ANYpxytYPfLP6zpVnwtj4SBc2noccvlvA9+gWj6oWj6
         LDcv2M0Q0DBqDLe/ivbAM4CRoZJr5jKUaYPi8rKqRqEd/tqhsveG+RepdSGjGB3rqM
         oYQvbnQVPkTaQ==
Date:   Mon, 21 Nov 2022 13:34:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3tiRnbfBcaH7bP0@unreal>
References: <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121112521.GX704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:25:21PM +0100, Steffen Klassert wrote:
> On Mon, Nov 21, 2022 at 01:15:36PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 21, 2022 at 12:09:26PM +0100, Steffen Klassert wrote:
> > > On Mon, Nov 21, 2022 at 12:27:01PM +0200, Leon Romanovsky wrote:
> > > > On Mon, Nov 21, 2022 at 10:44:04AM +0100, Steffen Klassert wrote:
> > > > > On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> > > > > > On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > > > > > > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > > > > > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > > > > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > 
> > > > > > > > > So this raises the question how to handle acquires with this packet
> > > > > > > > > offload. 
> > > > > > > > 
> > > > > > > > We handle acquires as SW policies and don't offload them.
> > > > > > > 
> > > > > > > We trigger acquires with states, not policies. The thing is,
> > > > > > > we might match a HW policy but create a SW acquire state.
> > > > > > > This will not match anymore as soon as the lookup is
> > > > > > > implemented correctly.
> > > > > > 
> > > > > > For now, all such packets will be dropped as we have offlaoded
> > > > > > policy but not SA.
> > > > > 
> > > > > I think you missed my point. If the HW policy does not match
> > > > > the SW acquire state, then each packet will geneate a new
> > > > > acquire. So you need to make sure that policy and acquire
> > > > > state will match to send the acquire just once to userspace.
> > > > 
> > > > I think that I'm still missing the point.
> > > > 
> > > > We require both policy and SA to be offloaded. It means that once
> > > > we hit HW policy, we must hit SA too (at least this is how mlx5 part
> > > > is implemented).
> > > 
> > > Let's assume a packet hits a HW policy. Then this HW policy must match
> > > a HW state. In case there is no matching HW state, we generate an acquire
> > > and insert a larval state. Currently, larval states are never marked as HW.
> > 
> > And this is there our views are different. If HW (in RX) sees policy but
> > doesn't have state, this packet will be dropped in HW. It won't get to
> > stack and no acquire request will be issues.
> 
> This makes no sense. Acquires are always generated at TX, never at RX.

Sorry, my bad. But why can't we drop all packets that don't have HW
state? Why do we need to add larval?

> 
> On RX, the state lookup happens first, the policy must match to the
> decapsulated packet.
> 
