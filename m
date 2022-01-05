Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177984856ED
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbiAEQ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:57:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37182 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAEQ5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:57:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A6261756
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C083C36AE0;
        Wed,  5 Jan 2022 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641401865;
        bh=YleeRLWTrVVS7iE7hwl0ukNlSEjkHSP03ZQlvTUUPrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o9DzYqaxObNcMbmZ+6sDzniQTnrxTLyKSagiH15AF9zz5HxxJL46JY9kzmLC0iAFG
         ENU5GU9nQpyX495jVGHhk1UoSPPB+rfb7ymv+wKX+4EHcZgHPmtuSURV1oP4ic0xuG
         aBJQD42SWIsULyIvLRYie4/cTxpfKAp1+kMZs4yvTrMyZOdvG56FkySQ/NVFNXc6QA
         I5H8ilyzD1tkjF7vcg0IIdSvuHLk6qW9iLRUi0M+uXlqDQAtSYXM6Wxw3AeQXoe8Hw
         +L9L2jTLQCD7wamsq2Du6JDw29DJd3Jr/ggrGk6UROJJ+YuBJqtd3EGuIl3Iiz5oQZ
         /LyYUIZDGLZHg==
Date:   Wed, 5 Jan 2022 08:57:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
Message-ID: <20220105085744.52015420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e2f0315e65052b7ff798e61100a02f624a609afb.camel@sipsolutions.net>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
        <20211207013039.1868645-12-eric.dumazet@gmail.com>
        <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
        <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com>
        <c14b5872799b071145c79a78aab238884510f2a9.camel@sipsolutions.net>
        <CANn89iLYo8XQbKGxT=pKQepe8FeELx0pnpMWjKS8n93uHwNJ5Q@mail.gmail.com>
        <e2f0315e65052b7ff798e61100a02f624a609afb.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jan 2022 17:23:51 +0100 Johannes Berg wrote:
> > diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> > index ea23659fab28..5fe8f4ae2ceb 100644
> > --- a/net/ethtool/netlink.c
> > +++ b/net/ethtool/netlink.c
> > @@ -627,7 +627,6 @@ static void ethnl_default_notify(struct net_device
> > *dev, unsigned int cmd,
> >         }
> > 
> >         req_info->dev = dev;
> > -       netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);  
> 
> So I had already tested both this and explicitly doing
> netdev_tracker_free() when req_info is freed, both work fine.
> 
> Tested-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Just wasn't sure it was correct or I was missing something. :)

Hi Eric, I didn't see this one submitted, is it coming?
No rush, just checking if it fell thru the cracks.
