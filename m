Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF2677D26
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjAWN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjAWN4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:56:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8113612867;
        Mon, 23 Jan 2023 05:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kJ3kL95O8Ni1CAI079jZv8+o4kwjue5dTbLO4wMZu7c=; b=eJxgwBi/io6zymxaTcG9vh87vL
        4CZBbYblgun/xRyeAOfIh/hat8pu4UsS2J5USHmN4AyTeTYxRAjMAMzd3IUczF8Jiih/XXJwNPU5W
        gPD2AuHqa7E6Llr6vJOcyhgjApP9NECRRwxPxbbI01GLp0qWOa7PtIcDEkHTE7FPYEaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJxJQ-002uTj-0Z; Mon, 23 Jan 2023 14:56:40 +0100
Date:   Mon, 23 Jan 2023 14:56:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Breno Leitao <leitao@debian.org>, netdev@vger.kernel.org,
        leit@fb.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sa+renesas@sang-engineering.com,
        linux-kernel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: Re: [RFC PATCH v2] netpoll: Remove 4s sleep during carrier detection
Message-ID: <Y86SGI5QMBS5kAI4@lunn.ch>
References: <20230119164448.1348272-1-leitao@debian.org>
 <20230119180008.2156048-1-leitao@debian.org>
 <20230119110421.3efc0f6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119110421.3efc0f6b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:04:21AM -0800, Jakub Kicinski wrote:
> On Thu, 19 Jan 2023 10:00:08 -0800 Breno Leitao wrote:
> > This patch proposes to remove the msleep(4s) during netpoll_setup() if
> > the carrier appears instantly.
> > 
> > Modern NICs do not seem to have this bouncing problem anymore, and this
> > sleep slows down the machine boot unnecessarily

I'm not sure 'bouncing' is the correct word here. That would imply up,
down, up, down and then stable up. What i guess the real issue here
was the MAC driver said the link was up while autoneg was still
happening, which takes around 1.5 seconds.

> We should mention in the message that the wait is counter-productive on
> servers which have BMC communicating over NC-SI via the same NIC as gets
> used for netconsole. BMC will keep the PHY up, hence the carrier
> appearing instantly.
> 
> We could add a smaller delay, but really having instant carrier and
> then loosing it seems like a driver bug, so let's try to rip the band
> aid off and ask for forgiveness instead.

It would be good to put some of this into the commit message. Explain
the case you see it go wrong.

The other scenarios i can think of are:

The bootloader configured the interface up, and used the interface,
e.g. to tftp boot. The PHY was left up when transitioning into
Linux. Hence there is no need to wait around 1.5 seconds for autoneg
to complete.

The link is fibre, SERDES getting sync could happen within 0.1Hz, and
so it appears to be instantaneously.

This work around does seem very old, pre-git times, so i also doubt
there are many systems which are truly broken like this.

      Andrew
