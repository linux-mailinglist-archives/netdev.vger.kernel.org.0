Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08FB4A8CFA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245658AbiBCUKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiBCUKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7D5C061714;
        Thu,  3 Feb 2022 12:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 817F1619E6;
        Thu,  3 Feb 2022 20:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F71C340E8;
        Thu,  3 Feb 2022 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643919028;
        bh=tdemnrdxS55d4CRNdh8HseqTkfZMq5xOxf+vvygaoTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mG9OBgnDnMTatUgZ92dcn7rkUf1wn39vweLw3nEOcVbz2mgOw1oeaYHVvbYpdmZlt
         G4fPP/OfiTDlNgKnjV6u0qzU3gacNknksYYymRgTx4kUIbbSTyDDjhdi8YSMQcNLAE
         zrhGTtc3wauOgM7RJIL3/sPxyJENbFBGcTl2D9hgTEt/gBD8wp63vMFu3v9FxzFJ2T
         hGHIMZsAkKhPMnGt1kGQBH0i8x8bQ654KgfhwJDjocwsf1p5yGFvvanjP/rZqocLWB
         uaxxNpKjlMubZsFxh9CRRsLDZ12KH3HfVt0gZGZqBy+VgVsns5o9Ym2cym49bZnq+J
         NuYYjO6awc6sg==
Date:   Thu, 3 Feb 2022 12:10:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 00/16] Add support for qca8k mdio rw in Ethernet
 packet
Message-ID: <20220203121027.7a6ea0f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203182128.z6xflse7fezccvhx@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
        <YfaZrsewBMhqr0Db@Ansuel-xps.localdomain>
        <a8244311-175d-79d3-d61b-c7bb99ffdfb7@gmail.com>
        <YfwX8YDDygBEsyo3@Ansuel-xps.localdomain>
        <20220203182128.z6xflse7fezccvhx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 20:21:28 +0200 Vladimir Oltean wrote:
> To my knowledge, when you call dev_queue_xmit(), the skb is no longer
> yours, end of story, it doesn't matter whether you increase the refcount
> on it or not. The DSA master may choose to do whatever it wishes with
> that buffer after its TX completion interrupt fires: it may not call
> napi_consume_skb() but directly recycle that buffer in its pool of RX
> buffers, as part of some weird buffer recycling scheme. So you'll think
> that the buffer is yours, but it isn't, because the driver hasn't
> returned it to the allocator, and your writes for the next packet may be
> concurrent with some RX DMA transactions. I don't have a mainline
> example to give you, but I've seen the pattern, and I don't think it's
> illegal (although of course, I stand to be corrected if necessary).

Are we talking about holding onto the Tx skb here or also recycling 
the Rx one? Sorry for another out of context comment in advance..

AFAIK in theory shared skbs are supposed to be untouched or unshared
explicitly by the driver on Tx. pktgen takes advantage of it.
We have IFF_TX_SKB_SHARING. 

In practice everyone gets opted into SKB_SHARING because ether_setup()
sets the flag. A lot of drivers are not aware of the requirement and
will assume full ownership (and for example use skb->cb[]) :/

I don't think there is any Tx completion -> Rx pool recycling scheme
inside the drivers (if that's what you described).
