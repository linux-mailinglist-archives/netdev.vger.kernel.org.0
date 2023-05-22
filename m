Return-Path: <netdev+bounces-4332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF4470C1A5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76371C20AD5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64A81428D;
	Mon, 22 May 2023 14:59:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65DE13AF8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:59:07 +0000 (UTC)
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75220FD;
	Mon, 22 May 2023 07:58:57 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 15EA921332;
	Mon, 22 May 2023 16:58:51 +0200 (CEST)
Date: Mon, 22 May 2023 16:58:46 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Andrew Lunn <andrew@lunn.ch>, Praneeth Bajjuri <praneeth@ti.com>,
	Geet Modi <geet.modi@ti.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: DP83867 ethernet PHY regression
Message-ID: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello all,
commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
established link") introduces a regression on my TI AM62 based board.

I have a working DTS with Linux TI 5.10 downstream kernel branch, while
testing the DTS with v6.4-rc in preparation of sending it to the mailing
list I noticed that ethernet is working only on a cold poweron.

With da9ef50f545f reverted it always works.

Here the DTS snippet for reference:

&cpsw_port1 {
	phy-handle = <&cpsw3g_phy0>;
	phy-mode = "rgmii-rxid";
};

&cpsw3g_mdio {
	assigned-clocks = <&k3_clks 157 20>;
	assigned-clock-parents = <&k3_clks 157 22>;
	assigned-clock-rates = <25000000>;

	cpsw3g_phy0: ethernet-phy@0 {
		compatible = "ethernet-phy-id2000.a231";
		reg = <0>;
		interrupt-parent = <&main_gpio0>;
		interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
		reset-gpios = <&main_gpio0 17 GPIO_ACTIVE_LOW>;
		reset-assert-us = <10>;
		reset-deassert-us = <1000>;
		ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
		ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
	};
};

Any suggestion?
Francesco


