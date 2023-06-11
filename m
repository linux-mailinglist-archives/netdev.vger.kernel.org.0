Return-Path: <netdev+bounces-9914-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7166672B284
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 015AA2811BC
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3411DC144;
	Sun, 11 Jun 2023 15:42:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2784133F1
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 15:42:36 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91CF10A;
	Sun, 11 Jun 2023 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MsB21n8Mn2hWywWEOAsC4fvmYh83aFSCx+cjt+pk5to=; b=O0j4c38OUMwcoYGWvSXGUYsSjX
	OAK7uHyyKqvkog9J5n5whAc68HNR44/P06TGFzghYpP9m+v9OMCCW367qOBXV7ngMDSPdRCDlu9z7
	MH+Q09oWfIkj3tfSVT8H4AB1ziC/Y8wbXJ4ozhMWCbLp8KB31Q2kUiqvNWedok5aOKmOekU7HLsEl
	iEmtgXaOo3d7nH6DGQk3DJUqE8HJqY6o9Y5YLRQ4M8Ld1//T9ORUH0jkwSNN5WnvuTsO5WH2YVBWZ
	uk6klCYpFCpHvojPMS3bkt3J92dfSfxhRHLzKbPXyB0aFcLwLS1l3reCQAq9uH5l+b43SRqJe6S4B
	NLCTLb9g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42454)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8ND4-0004Xd-Ck; Sun, 11 Jun 2023 16:42:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8ND0-00043f-AR; Sun, 11 Jun 2023 16:42:26 +0100
Date: Sun, 11 Jun 2023 16:42:26 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Simon Horman <simon.horman@corigine.com>,
	alexis.lothore@bootlin.com
Subject: Re: [PATCH net-next] net: altera_tse: fix init sequence to avoid
 races with register_netdev
Message-ID: <ZIXrYupBmpviSEW3@shell.armlinux.org.uk>
References: <20230611104019.33793-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611104019.33793-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 12:40:19PM +0200, Maxime Chevallier wrote:
> As reported here[1], the init sequence in altera_tse can be racy should
> any operation on the registered netdev happen after netdev registration
> but before phylink initialization.
> 
> Fix the registering order to avoid such races by making register_netdev
> the last step of the probing sequence.
> 
> [1]: https://lore.kernel.org/netdev/ZH9XK5yEGyoDMIs%2F@shell.armlinux.org.uk/
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> This patch targets net-next as it fixes a commit that is in net-next
> too.

While it fixes the order in which stuff is registered, it introduces
a new bug - register_netdev() is what atomically allocated a netdev
name, and you use the netdev name when creating the PCS MII bus:

	snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);

This needs to change, because this will end up being "eth%d-pcs-mii".

I am at a loss why you didn't realise this (or in fact recognise that
there are other issues) given that I sent you three patches fixing
this mess.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

