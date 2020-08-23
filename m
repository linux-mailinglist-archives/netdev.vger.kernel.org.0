Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821BA24EDF0
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 17:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgHWPmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 11:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHWPmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 11:42:49 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:171:314c::100:a1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEC8C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 08:42:48 -0700 (PDT)
Date:   Sun, 23 Aug 2020 17:42:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1598197362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WEBQve+/dxCnRS08yIZckUq5RKG1E82t8UUYVFRllgc=;
        b=ILCJaqwrUUwtXcXASdqvU6bwRTjjI3O76EQTyA2Ut7wHL7rzBNanxBPD43cmr6N+FMMl/M
        LLmpcEVcp7ajZG5uAxQrDVbwYmN6eNklcWR8N+BvtWN3xv0fYtYTuc+dzZBQm1XNZ2YEDt
        rNhPI9XIvcUmME120hMHI2jRxrdQ+xG/kx4C6fmBnrT1WxcLrq0QWDts5XFenJ63TitN+f
        v7Hg8issHGdvvrhScqo44ZgXqPvN3Lfz7XmLLYEIxWdJQ63yeejqI+buVjSXJ4wHW6qDo3
        88+eeB6t5dSz+6fPPqvG8rOKJiiMCy7Hy9fXcuwR20bwLPmNsmTQ/rJ9UAJ9RQ==
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [Bridge] [RFC PATCH net-next] bridge: Implement MLD Querier
 wake-up calls / Android bug workaround
Message-ID: <20200823154239.GA2302@otheros>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
 <20200816150813.0b998607@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200816150813.0b998607@hermes.lan>
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 03:08:13PM -0700, Stephen Hemminger wrote:
> Rather than adding yet another feature to the bridge, could this hack be done by
> having a BPF hook? or netfilter module?

Hi Stephen,

Thanks for the constructive feedback and suggestions!

The netfilter approach sounds tempting. However as far as I know
OpenWrt's firewall has no easy layer 2 netfilter integration yet.
So it has default layer 3 netfilter rules, but not for layer 2.

Ideally I'd want to work towards a solution where things "just
work as expected" when a user enables "IGMP Snooping" in the UI.
I could hack the netfilter rules into netifd, the OpenWrt network
manager, when it configures the bridge. But not sure if the
OpenWrt maintainers would like that...

Any preferences from the OpenWrt maintainers side?

Regards, Linus


PS: With BPF I don't have that much experience yet. I would need
to write a daemon which would parse the MLD packets and would
fetch the FDB via netlink, right? If so, sounds like that would
need way more than 300 lines of code. And that would need to be
maintained within OpenWrt, right?
