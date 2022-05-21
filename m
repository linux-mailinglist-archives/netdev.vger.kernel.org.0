Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7FA52FD3B
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbiEUOXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 10:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiEUOXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 10:23:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64910366BF
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=P8rlnbb8X+PAXL81rTHsiUp9qVszFgcKeogrle8KJAo=; b=j6lbx2En9XMph45qLzClYP3udf
        l9dUO9nLyBjoF4Qa4VtUsk7QqtCtc7YU/a9rCxXqczuYE3Z1reRMR/V2ZGg8mBvp7GzjYSubXHtdw
        3x9UbSCxYQqXH2CacA7ZkL7t7hPJF2qugMGkynccXZlKK77pou7OuZHSXfN05bRvHJlc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nsQ0i-003mFb-Uq; Sat, 21 May 2022 16:23:16 +0200
Date:   Sat, 21 May 2022 16:23:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <Yoj11Kv55HX3k/Ou@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
 <YoeIj2Ew5MPvPcvA@lunn.ch>
 <20220520111407.2bce7cb3@kernel.org>
 <YofidJtb+kVtFr6L@lunn.ch>
 <20220520150256.5d9aed65@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520150256.5d9aed65@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For a system which wants to monitor link quality on the local end =>
> i.e. whether physical hardware has to be replaced - differentiating
> between (1) and (2) doesn't really matter, they are both non-events.

Maybe data centres should learn something from the automotive world.
It seems like most T1 PHYs have a signal quality value, which is
exposed via netlink in the link info message. And it is none invasive.

Many PHYs also have counters of receive errors, framing errors
etc. These can be reported via ethtool --phy-stats.

SFPs expose SNR ratios in their module data, transmit and receive
powers etc, via ethtool -m and hwmon.

There is also ethtool --cable-test. It is invasive, in that it
requires the link to go down, but it should tell you about broken
pairs. However, you probably know that already, a monitoring system
which has not noticed the link dropping to 100Mbps so it only uses two
pairs is not worth the money you paired for it.

Now, it seems like very few, if any, firmware driven Ethernet card
actually make use of these features. You need cards which Linux is
actually driving the hardware. But these APIs are available for
anybody to use. Don't data centre users have enough purchasing power
they can influence firmware/driver writers to actually use these APIs?
And i think the results would be better than trying to count link
up/down.

     Andrew
