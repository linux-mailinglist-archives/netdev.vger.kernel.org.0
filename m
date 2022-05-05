Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43D51BEFC
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359627AbiEEMRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359587AbiEEMRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:17:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5BF764A;
        Thu,  5 May 2022 05:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5OMJPmSj8QEl41Jiad4H1IyUmlhkdOz6SJlbgXUJFAk=; b=1T0+KjiCeALoGnscXI6EGpnlug
        aQmOGto+uEFjiGv+VM2MZN9ZZr8Oj/GZwv4qCwgMzisGgBQcK4BkWNHQ3KcMGEFGgee5XfJA3+1Ge
        ogwnf+r95sO1XI8X8jz5ac3oISTEe43wFbmUp7OqF7nFOK0SQtGadgsoXRB9A8GQVBfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmaM0-001LkD-Ch; Thu, 05 May 2022 14:13:08 +0200
Date:   Thu, 5 May 2022 14:13:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Remove unnecessary comparison in
 lan8814_handle_interrupt
Message-ID: <YnO/VGKVHfFJG7/7@lunn.ch>
References: <20220505030217.1651422-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505030217.1651422-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 11:02:17AM +0800, Wan Jiabing wrote:
> Fix following coccicheck warning:
> ./drivers/net/phy/micrel.c:2679:6-20: WARNING: Unsigned expression compared with zero: tsu_irq_status > 0

There are at least two different possibilities here:

As you say, the comparison is pointless, in which case, it can be
removed.

The code author really did have something in mind here, the comparison
is correct, but there is another bug.

I would generally assume the second, and try to first find the other
bug. If that bug really exists, removing the comparisons just adds one
bug on top of another.

So, check the return type of lanphy_read_page_reg(). It is int. If you
dig down, you get to __phy_read(), which calls __mdiobus_read(), all
of which return int. All these functions return a negative error code,
or a positive register value.

So the real problem here is, tsu_irq_status is defined as u16, when in
fact it should be an int.

As a result, a negative error code is going to get cast positive, and
then used as the value of the interrupt register. The code author
wanted to avoid this, so added a comparison. In an interrupt handler
you cannot actually return an error code, so the safe thing to do is
ignore it.

Please consider coccicheck just a hint, there is something wrong
somewhere around here. You then need to really investigate and figure
out what the real issue is, which might be exactly what coccicheck
says, but more likely it is something else.

NACK

   Andrew
