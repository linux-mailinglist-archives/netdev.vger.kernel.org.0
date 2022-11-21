Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70B3632352
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiKUNV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKUNVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:21:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD31274CEF
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69E39B81015
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B1EC433C1;
        Mon, 21 Nov 2022 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669036910;
        bh=3q5MAXyml2TGXEOQfIBwydZ0aJBAfHx7YKo33iI5Xy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NJOSnKXCy6FRPEyD4qf3y4B06YuRnXXRDSvIblj2pCTNQDklZVnLuUDbJtMGw3RRB
         3t6zjfFGG8kKKhIzJ1prHkJ8xymg6zIQZ5yGtVd09zXWYL/Ae6phrrM6o/JFpNE68v
         mjVLkN7ElCWjwYUjT53pYLN7Zipz2cpUlC+yaALq8oSy9cRx+XZjleXp/Vz7hXxt8g
         n8cDcWVhSlqgW/Sz0PCjp3OvvdWsXnqLWoZC0yJRCB4KVZKGa7ZfpVaVM7Vv8TcbLC
         E88kVPtsYdFX6akeX1ui4s5esKgqIi8jAF+GL3kvctnKb3VTrLR/rKPVmKp4cUFGZb
         eZV9soHZXLVWw==
Date:   Mon, 21 Nov 2022 15:21:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3t7aSUBPXPoR8VD@unreal>
References: <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121121040.GY704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 01:10:40PM +0100, Steffen Klassert wrote:
> On Mon, Nov 21, 2022 at 01:34:30PM +0200, Leon Romanovsky wrote:
> > 
> > Sorry, my bad. But why can't we drop all packets that don't have HW
> > state? Why do we need to add larval?
> 
> The first packet of a flow tiggers an acquire and inserts a larval
> state. On a traffic triggered connection, we need this to get
> a state with keys installed.
> 
> We need this larval state then, because that tells us we sent already an
> acquire to userspace. All subsequent packets of that flow will be
> dropped without sending another acquire. Otherwise each subsequent
> packet will generate another acquire until the keys are negotiated.
> If a flow starts sending on a high rate, this would be not so nice
> for userspace :)

The thing is that this SW acquire flow is a fraction case, as it applies
to locally generated traffic.

In my mind, there are other cases, like eswitch mode and tunnel mode. In
these cases, the packets are arrived to HW without even passing SW stack.

What we want to do is to catch in HW all TX packets, which don't have SAs
(applicable for all types of traffic), mark them and route back to the
driver. The driver will be responsible to talk with XFRM core to
generate acquire.

The same logic of rerouting packets is required for audit and will be done
later. Right now, we rely on *swan implementations which configure everything
in advance.

Also larval is default to 1 (drop) in all distros.

I hope that this larval/acquire is not must for this series to be merged.
And it is going to be implemented later as I'm assigned to work on this
offload feature till feature complete :).

Thanks
