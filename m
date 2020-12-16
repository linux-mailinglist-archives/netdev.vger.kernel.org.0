Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB632DC3C8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLPQNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPQNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 11:13:42 -0500
Date:   Wed, 16 Dec 2020 08:13:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608135182;
        bh=81uhZT7DVpYjdCreLCbeivUB0qv7WJTZEUE+d3HMhPQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CS9n6LgOFxRxJJKD8UykFv4WPBIK6VPZ1ifpmCAHqYrBHUDjJFoTZpA21uyfogBUC
         iccS+Z4Mun1ToW6FjrqWQo28EmNs9gtRgsniTkyXQWE8DoEDkoda4EaaC63Wbth+w9
         Ilkmgj7SRaZVWLzGaBYRFx5Y3xnp2w6Fn/au9GRbOphPj5X5sQNGQP8D9GZQ+KHgyl
         Diu4iNG1UgY9F6GGZoI8162MAB5Zh8ODuEt9S260UqtFW/NT4fGrimre0+ogxEXlgI
         1mMzL4XchcxpZvF453pHAjYH4AVzAP1Crs9GgIjzqSVnw1usbTNP7pn59dkLCnArE9
         1SjlLygImfT+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201216081300.3477c3fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftjczza7xgf.fsf%l.stelmach@samsung.com>
References: <20201215174615.17c08e88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201216122211eucas1p22314f0e8a28774545d168290ed57b355@eucas1p2.samsung.com>
        <dleftjczza7xgf.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 13:21:52 +0100 Lukasz Stelmach wrote:
> So, the only thing that's left is pskb_expand_head(). I need to wrap my
> head around it. Can you tell me how a cloned skb is different and why
> there may be separate branch for it?

I think this driver needs to prepend and append some info to the packet
data, right? Cloned skb is sharing the data with another skb, the
metadata is separate but the packet data is shared, so you can't modify
the data, you need to do a copy of the data. pskb_expand_head() should
take care of cloned skbs so you can just call it upfront and it will
make sure the skb is the right geometry for you.

BTW you should set netdev->needed_headroom and netdev->needed_tailroom
to the correct values so the stack pre-allocates the needed spaces,
when it can.
