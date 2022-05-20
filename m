Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7880452EC5F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349355AbiETMld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiETMlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:41:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363AE12D09;
        Fri, 20 May 2022 05:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y5yue5StjMLDz9Stw8tyOk8WJH/+6r8jlx/4Qmd/Q5c=; b=40SWpeZS1e9hHYXISSNDgAETMz
        fg0iOwPHdtVGaZDTPcOxP774uLKK3RHuX5jcE4qrYsikW4cnM776o07+TQqgZwxtsW+m6DT0zRKt3
        1rFIDgLmHCxmY7Ydx0WhKf5o7ze+Udsh5JY7kAzAE1F8e79/jwIS+BL3YzMg56Q/cf3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns1wB-003co2-Au; Fri, 20 May 2022 14:40:59 +0200
Date:   Fri, 20 May 2022 14:40:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ocelot: fix wront time_after usage
Message-ID: <YoeMW+/KGk8VpbED@lunn.ch>
References: <20220519204017.15586-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519204017.15586-1-paskripkin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 11:40:17PM +0300, Pavel Skripkin wrote:
> Accidentally noticed, that this driver is the only user of
> while (timer_after(jiffies...)).
> 
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
> 
> Fix it by negating time_after return value inside while loops statement

A better fix would be to use one of the helpers in linux/iopoll.h.

There is a second bug in the current code:

static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
{
	unsigned long timeout;
	u32 safe;

	timeout = jiffies + usecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
	do {
		safe = ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
		if (safe & BIT(chan))
			return 0;
	} while (time_after(jiffies, timeout));

	return -ETIMEDOUT;
}

The scheduler could put the thread to sleep, and it does not get woken
up for OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware
has done its thing, but you exit the while loop and return -ETIMEDOUT.

linux/iopoll.h handles this correctly by testing the state one more
time after the timeout has expired.

  Andrew
