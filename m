Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384DE5BB763
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiIQJCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 05:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiIQJCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 05:02:09 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53A53ED7F;
        Sat, 17 Sep 2022 02:02:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 069F0E000C;
        Sat, 17 Sep 2022 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663405326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3n+5d6gN7wXx4G9cQ9iXiYL0yv1UNBqbWeZnd/o/68=;
        b=RXzA6qIFzDsgsg5h2XBhvb1k+H7xEflBwJVZ45xk8mKLVkl4d0MnquXtROW6Ek34DjR87e
        UovNg3uk1IHuVysoPnNV+mpIYm0oMskblt34T8WvqEVpa3mGd4gHAPP7zBvPdKn3AqSN/v
        mlg5WbKcJVyv7JNz5GT3UnKElGa0lNHFKN6h19KOXLvhXVN/I+vUy5q5EcTfUjoKlZVg2c
        Lr8fn6u2WKWcOr+SOF2ao+kD59noR7JjXmboeZ53626tXvXJBxLo41pLM6M5aew6B/bkEG
        nLj44Kdx/HUESXy3u0NpFV3Ufuvt9wlWqIDwXskVnxww0e3zUcQiYdWLnBtWqA==
Date:   Sat, 17 Sep 2022 11:02:02 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 0/5] net: ipqess: introduce Qualcomm IPQESS
 driver
Message-ID: <20220917110202.1b8562bf@fedora>
In-Reply-To: <20220917002031.f7jddzi7ppciusie@skbuf>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
        <20220917002031.f7jddzi7ppciusie@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Sep 2022 00:20:31 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Sep 09, 2022 at 05:24:49PM +0200, Maxime Chevallier wrote:
> > The DSA out-of-band tagging is still using the skb->headroom part,
> > but there doesn't seem to be any better way for now without adding
> > fields to struct sk_buff.  
> 
> Are we on the same page about what is meant by "skb extensions"? See
> what is provided by CONFIG_SKB_EXTENSIONS, I did not mean it as in
> "extend struct sk_buff with new fields".

Yep, that was one of the other approaches I had in mind, and I've
submitted a series adding fields to sk_buff in the past which was
rejected (for good reasons). But indeed that comment on the cover-letter
was misleading...

Thanks,

Maxime
