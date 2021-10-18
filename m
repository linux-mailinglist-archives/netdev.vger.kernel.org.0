Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED74743243C
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhJRQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbhJRQzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 12:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B872B61002;
        Mon, 18 Oct 2021 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634575971;
        bh=2RnLVqd6pLkU1SLhNQPNfmrkvEPcx9yjWWBquEj6IPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eO7cuTwltqOxrCsPmDuKjTgRls5MGgxOTFZ1HDRMpNUIo8f4FXSBMQ3rGatQ6jRqf
         mSbBvVVTl2GKUsn4RhXHX2u8EiGUV1QChkp+dQ0asNI/55i09TMJpiM48gQpUNcLDt
         u42MgvFZeH6lM2cc17nWar6k4AT5rcFg2/7pCS+cNnLKAnOnypoL2BfBgArBqqDRs2
         QLsXotOaDvdX/vsHnupMNksmWXmo4uv/J/k24yMoMGjw/aN8MdycYM/MZ5/G7t8yVd
         mkn7n8cu09OXv+9Ha3D7WH78ABh5VmRsOQgHdGXBK5I4W2RtU4SfRuIs4lequZRZNc
         /l8FsZqcNMMNA==
Date:   Mon, 18 Oct 2021 09:52:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        christophe.leroy@csgroup.eu, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
Message-ID: <20211018095249.1219ddaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018094256.70096-1-francesco.dolcini@toradex.com>
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 11:42:58 +0200 Francesco Dolcini wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
> the power down mode bit (0.11). If the PHY is taken out of power down
> mode in a certain temperature range, the PHY enters a weird state which
> leads to continously reporting RX errors. In that state, the MAC is not
> able to receive or send any Ethernet frames and the activity LED is
> constantly blinking. Since Linux is using the suspend callback when the
> interface is taken down, ending up in that state can easily happen
> during a normal startup.
> 
> Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
> clock recovery when using power down mode. Even the latest revision (A4,
> Revision ID 0x1513) seems to suffer that problem, and according to the
> errata is not going to be fixed.
> 
> Remove the suspend/resume callback to avoid using the power down mode
> completely.
> 
> [*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Is this the correct fixes tag?

Fixes: 1a5465f5d6a2 ("phy/micrel: Add suspend/resume support to Micrel PHYs")

Should we leave a comment in place of the callbacks referring 
to the errata?
