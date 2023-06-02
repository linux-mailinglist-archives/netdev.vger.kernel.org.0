Return-Path: <netdev+bounces-7410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 226B07201E1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44810281899
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A82818C2A;
	Fri,  2 Jun 2023 12:19:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BECB18C14
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:18:59 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A64E7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o+PeReJGmunXxK+4er24zbzYmt36Z4P6PszmlWotXiw=; b=B8xr0OMiwwYivIlRPBWdPpNmSY
	ePxIplck5c/lkHvHbOwrmMUp4HhoqeF2BluvJ1uw2PYCrT2tcela4zocwIxldS9ba/sqosy3w151G
	OZZRzn7OUMB4yeKkwAD/6CGFSdvPulddJrNhf7JnbrSH9fc6wkyEZxUrne3UJjYyiZJR9rEQqD4Wb
	1X78Nm/uraHWwYEPFOZRy7otPQ2h5FEN2+4ILdQ0ywr6BWeicq1cr9rpuUlAlJv2fgBRDC0Izo2ze
	HQVhd/+orubT3RrKSC2SiYQKAT9XDM9jvS3KHBNEes1i8enVjUfsoA5c9f5Q+rvBT3eavuA1czGxn
	LOBKHSpg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33040)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q53jI-0007y3-35; Fri, 02 Jun 2023 13:18:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q53jH-0002wb-9T; Fri, 02 Jun 2023 13:18:03 +0100
Date: Fri, 2 Jun 2023 13:18:03 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: QUSGMII control word
Message-ID: <ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maxime,

Looking at your commit which introduced QUSGMII -
5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode"), are you sure
your decoding of the control word is correct?

I've found some information online which suggests that QUSGMII uses a
slightly different format to the control word from SGMII. Most of the
bits are the same, but the speed bits occupy the three bits from 11:9,
and 10M, 100M and 1G are encoded using bits 10:9, whereas in SGMII
they are bits 11:10. In other words, in QUSGMII they are shifted one
bit down. In your commit, you used the SGMII decoder for QUSGMII,
which would mean we'd be picking out the wrong bits for decoding the
speed.

QUSGMII also introduces EEE information into bits 8 and 7 whereas
these are reserved in SGMII.

Please could you take a look, because I think we need a different
decoder for the QUSGMII speed bits.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

