Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00F752FD49
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 16:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbiEUO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 10:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235561AbiEUO3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 10:29:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13FE3AA5E;
        Sat, 21 May 2022 07:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r96J06AA/hx9f6lJVo/su3KBEml3SMC6atekdO73IQM=; b=DA7AJxCsP7mGwECk9LimTyPCeq
        mGKgm41gxsuHHV7QhgBYxPT8DUmPSCyenxJ71/uLaEg5vufk0igLqeQ+OZFcnaYb6Aq2PRGmnwkq5
        NN1bQ+lQmxVO8nAmtFk7J0Y/KM7jdI/Q7Nw67nC4GQgYTJUkYAdwWLLSO0ym/EyuljdE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nsPZq-003lku-2S; Sat, 21 May 2022 15:55:30 +0200
Date:   Sat, 21 May 2022 15:55:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, clement.leger@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ocelot: fix wrong time_after usage
Message-ID: <YojvUsJ090H/wfEk@lunn.ch>
References: <YoeMW+/KGk8VpbED@lunn.ch>
 <20220520213115.7832-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520213115.7832-1-paskripkin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 12:31:15AM +0300, Pavel Skripkin wrote:
> Accidentally noticed, that this driver is the only user of
> while (time_after(jiffies...)).
> 
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
> 
> There is one possible problem with this poll loop: the scheduler could put
> the thread to sleep, and it does not get woken up for
> OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
> its thing, but you exit the while loop and return -ETIMEDOUT.
> 
> Fix it by using sane poll API that avoids all problems described above
> 
> Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> I can't say if 0 is a good choise for 5th readx_poll_timeout() argument,
> so this patch is build-tested only.

> Testing and suggestions are welcomed!

If you had the hardware, i would suggest you profile how often it does
complete on the first iteration. And when it does not complete on the
first iteration, how many more iterations it needs.

Tobias made an interesting observation with the mv88e6xxx switch. He
found that two tight polls was enough 99% of the time. Putting a sleep
in there doubles the time it took to setup the switch. So he ended up
with a hybrid of open coded polling twice, followed by iopoll with a
timer value set.

That was with a heavily used poll function. How often is this function
used? No point in overly optimising this if it is not used much.

      Andrew
 
