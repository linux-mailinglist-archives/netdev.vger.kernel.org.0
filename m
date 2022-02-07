Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D494AC974
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbiBGTZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiBGTWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:22:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C733C0401DA;
        Mon,  7 Feb 2022 11:22:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A3661478;
        Mon,  7 Feb 2022 19:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF20BC004E1;
        Mon,  7 Feb 2022 19:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644261761;
        bh=KUPX8Z2M1G/xjhIEvGyoRfsAVLpDqr7LkCtKEwt2NPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LymtuW9hHYGoHjJkXXpg7ic8WkI7mrBseAGjZGezJ9PuxGDdojcvlYcpqU8FnXzRn
         Fju29kxy62v1gn2rTvNG5W1wrexA+u7zis9UvgEqcdc5whRAxwNAWxhhCnxpppiIHd
         C5ddDxaUbfHxtNcOimzAGFj/YcBo8nEl2U0cm/3UGXJM8U5e/5lAmmfYt5vOPqlHv1
         Db65DhTur4nUIkgljUh/QMPlszCgadiH4eEKkCp86XQjqm3toZaHdQaZu9/0SBIlis
         qP2Y/GR5VuiI6qyI1x5jF08loCc/ewlksi+Hsz7yT1cbVS1tWQmtWbgDcl9stMeDPL
         y5fArvr7/uBbw==
Date:   Mon, 7 Feb 2022 11:22:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays
 setting in 88e1121-compatible PHYs
Message-ID: <20220207112239.20ae3bfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207183319.ls2rz4k6m7tgbqlg@mobilestation>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
        <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
        <20220207094039.6a2b34df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220207183319.ls2rz4k6m7tgbqlg@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Feb 2022 21:33:19 +0300 Serge Semin wrote:
> > I see it's marked as Superseded in patchwork, but can't track down a v3.  
> 
> We had accidentally sent out a temporal v2 version before submitting this
> one. The failed patch is here
> Link: https://lore.kernel.org/stable/20220205190814.20282-1-Pavel.Parkhomenko@baikalelectronics.ru/
> But the message was sent to Russel and to the stable mailing list only
> with no netdev list being in Cc. I thought if the right v2 was sent
> out after the failed one, then even if patchwork somehow gets to catch
> both of the messages, the former patch would have at least superseded
> the later one. It appears I was wrong. Sorry about that. Do you want
> us to resend this patch as v3 to have a proper patchwork status?

No need, I set it back to New, thanks!
