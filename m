Return-Path: <netdev+bounces-4677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9E670DD51
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677001C20D24
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C541D2D4;
	Tue, 23 May 2023 13:17:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974371C750
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:17:01 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC255118;
	Tue, 23 May 2023 06:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=QaJjwNP0byDh2vTB+BfRP2skNBByswtyi4rwwgzOO84=; b=ccExP0nk6kRSUyvuKNMxUTrYp9
	qZeebMgn0R0JRYDIvCz0au56fuuXA+49zhy5VzSJMeWwKse+BnKbFNywhzvCGoRLfdyIvbTV8b5TJ
	MWZoxRTa6km5+qDaRcImYnqD/z0HjL0xZwSm2e3JjM1xiKET/dZx3wc4jASsCZdV9SUU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1Rsh-00Dglg-2T; Tue, 23 May 2023 15:16:51 +0200
Date: Tue, 23 May 2023 15:16:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: mscc: support VSC8501
Message-ID: <c613298d-53bc-46ef-9cb2-4b385e21ba7b@lunn.ch>
References: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> - I left the mutex_lock(&phydev->lock) in the
>   vsc85xx_update_rgmii_cntl() function, as I'm not sure whether it
>   is required to repeatedly access phydev->interface and
>   phy_interface_is_rgmii(phydev) in a consistent way.

Just adding to Russell comment.

As a general rule of thumb, if your driver is doing something which no
other driver is doing, you have to consider if it is correct. A PHY
driver taking phydev->lock is very unusual. So at minimum you should
be able to explain why it is needed. And when it comes to locking,
locking is hard, so you really should understand it.

Now the mscc is an odd device, because it has multiple PHYs in the
package, and a number of registers are shared between these PHYs. So
it does have different locking requirements to most PHYs. However, i
don't think that is involved here. Those oddities are hidden behind
phy_base_write() and phy_base_read().

	Andrew

