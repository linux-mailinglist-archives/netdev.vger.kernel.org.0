Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD47946079C
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 17:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358566AbhK1Qio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 11:38:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244871AbhK1Qgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 11:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JL1D5jpsdNCz3lOSZV2Opy0UGJH6As2zHwmP3iiE+Ew=; b=n+Up8E7EAIwCHXU478yckdMUf7
        oBuN+eIS/FZNll8KAdlMzhDMMWSwgty4N7SptBC/td7xPk86u4swpVWoNxStyC59drT74SouaXdF/
        JuQ/f3EFdVp++VIAnaT3eKJRAooe5UksuMt/QIGOfS8SlJQkbxNyhblnKXb0Ug/tnn/A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrN74-00EqcM-ME; Sun, 28 Nov 2021 17:33:14 +0100
Date:   Sun, 28 Nov 2021 17:33:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tianhao Chai <cth451@gmail.com>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <YaOvShya4kP4SRk7@lunn.ch>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 08:37:33PM -0600, Tianhao Chai wrote:
> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.

This is a change in behaviour, and could cause regressions. It would
be better to keep with the current flow. Call
aq_fw_ops->get_mac_permanent() first. If that does not give a valid
MAC address, then try DT, and lastly use a random MAC address.

    Andrew
