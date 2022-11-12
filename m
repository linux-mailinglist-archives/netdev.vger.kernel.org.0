Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42B0626A71
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 17:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiKLQIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 11:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLQIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 11:08:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEF610FE0
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 08:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iXBxKE5sxzRd0/uQ3rSAW1I8WLjRXhf2wm8sUQ71qeI=; b=0fCoOWepMG2euYkKOJ7wnM8TOf
        qU3pZa2L8i/Lzipt7SrhQIYsDu+WcHhLLj8RGsKQlnrOf+Zsus6T898VaEutCAw7n8/0bzOS0P3A5
        uMaLKpzIlSm6yRJbfBi17kXkmeP+1nWyVLHh8XsJbG6pwE1Jb1qo1PGESdoK8O91BXoE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ott32-002C6j-8Y; Sat, 12 Nov 2022 17:08:00 +0100
Date:   Sat, 12 Nov 2022 17:08:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: status of rate adaptation
Message-ID: <Y2/E4FQzlw+T+6c/@lunn.ch>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
 <20221112004827.oy62fd7aah6alay2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112004827.oy62fd7aah6alay2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As to LEVEL_LOW vs EDGE_FALLING, I suppose the only real difference is
> if the interrupt line is shared with other peripherals?

It pretty much always is, on the PHY side. The PHY is an interrupt
controller, with lots of different interrupt sources within the PHY
coming together to trigger one external interrupt. It is unlikely to
produce another edge if the hardware has another interrupt source
trigger an interrupt while the interrupt handler is running. With a
level interrupt, the interrupt handler will exit, the interrupt will
get enabled in the parent interrupt controller, and immediately fire
again.

I have seen some boards using edge, but that is only because the
interrupt controller does not support level. They mostly get away with
it because generally PHYs are slow things, interrupts tend to be few
and infrequency and the race window is small.

	Andrew
