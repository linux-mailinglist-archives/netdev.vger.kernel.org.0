Return-Path: <netdev+bounces-5293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B64710A36
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D99DC281561
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC51AD2E8;
	Thu, 25 May 2023 10:38:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E71A94D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:38:33 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D89E6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mzKKNukQGSYGof86mbQ7ggvf5Xu06/kUUjfK6e4C+wQ=; b=XK8QVyz1T5QBwlRMKt5CbI0nt3
	+v8hLIXWysErijKVFs+5WxnZgqfzkhkAeR1OPI+u97bBpztcsJiXpjFIbl95IeN0vx8jLSOi01JNT
	vQCGPmFrOz7PtpAyBFJKRRDr1/Rvp4TK6tDX64wib/f0DsxNNb+zGHeJZJgQQL/m0m1M/D+wnz33t
	PssATuPfbSkJaqxd5+bm1FT5110jwIcwl5nGqC+Sl44y8bIW4w8N+uOUnl5J6OXgBcW67CEPhyYKk
	fTXBSbEz4oiS78QRyGBOMngvS449PhfrlJUQLa7Q4G0H35a+bnYUnu0P0mxSWSmYAVWFATZnq88I2
	UUv4ea8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56252)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q28MV-0003vw-E5; Thu, 25 May 2023 11:38:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q28MT-0002as-9N; Thu, 25 May 2023 11:38:25 +0100
Date: Thu, 25 May 2023 11:38:25 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] net: dsa: mv88e6xxx: prepare for phylink_pcs
 conversion
Message-ID: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
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

Hi,

These two patches provide some preparation for converting the mv88e6xxx
DSA driver to use phylink_pcs rather than bolting the serdes bits into
the MAC calls.

In order to correctly drive mv88e6xxx hardware when the PCS code is
split, we need to force the link down while changing the configuration
of a port. This is provided for via the mac_prepare() and mac_finish()
methods, but DSA does not forward these on to DSA drivers.

Patch 1 adds support to the DSA core to forward these two methods to
DSA drivers, and patch 2 moves the code from mv88e6xxx_mac_config()
into the respective methods.

 drivers/net/dsa/mv88e6xxx/chip.c | 65 +++++++++++++++++++++++++++-------------
 include/net/dsa.h                |  6 ++++
 net/dsa/port.c                   | 32 ++++++++++++++++++++
 3 files changed, 83 insertions(+), 20 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

