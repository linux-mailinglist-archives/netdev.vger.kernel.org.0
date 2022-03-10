Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C151D4D4C4C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiCJOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345277AbiCJOlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:41:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1218E40E;
        Thu, 10 Mar 2022 06:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X8rk1wKGgoot4D0abN1n7B47xEHjhOnmzv7J1avYjn0=; b=tcgNy46d72iV0QSf94ZwkSbPZc
        fiCNYP4pWJM8c/hJV6i7JGSHbwAcifxMJ5QS248qdiiElDvdtzg0y/Q1EP3mDErc9XjqNUBk7Jcy3
        R594egyRYg1kQrikaVNnld5cbVTlffScORNO6vcm5TKrGaHoFYXiuCjNuGfKq5G9Wk5I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nSJtv-00A9C3-9m; Thu, 10 Mar 2022 15:36:23 +0100
Date:   Thu, 10 Mar 2022 15:36:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        david.laight@aculab.com
Subject: Re: [PATCH net-next v2] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <YioM5zVqFtFxYhc+@lunn.ch>
References: <20220310084005.262551-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310084005.262551-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 09:40:05AM +0100, Horatiu Vultur wrote:
> When doing manual injection of the frame, it is required to check if the
> TX FIFO is ready to accept the next word of the frame. For this we are
> using 'readx_poll_timeout_atomic', the only problem is that before it
> actually checks the status, is determining the time when to finish polling
> the status. Which seems to be an expensive operation.
> Therefore check the status of the TX FIFO before calling
> 'readx_poll_timeout_atomic'.
> Doing this will improve the TX bitrate by ~70%. Because 99% the FIFO is
> ready by that time. The measurements were done using iperf3.
> 
> Before:
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.03  sec  55.2 MBytes  46.2 Mbits/sec    0 sender
> [  5]   0.00-10.04  sec  53.8 MBytes  45.0 Mbits/sec      receiver
> 
> After:
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.10  sec  95.0 MBytes  78.9 Mbits/sec    0 sender
> [  5]   0.00-10.11  sec  95.0 MBytes  78.8 Mbits/sec      receiver
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
