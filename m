Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE071FF15C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgFRMLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:11:51 -0400
Received: from gloria.sntech.de ([185.11.138.130]:53398 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgFRMLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:11:49 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.lan)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jltOP-0007op-Hd; Thu, 18 Jun 2020 14:11:41 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com
Subject: [PATCH v5 0/3] add clkout support to mscc phys
Date:   Thu, 18 Jun 2020 14:11:36 +0200
Message-Id: <20200618121139.1703762-1-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main part of this series is adding handling of the clkout
controls some of the mscc phys have and while at it Andrew
asked for some of the duplicated probe functionality to be
factored out into a common function.

A working config on rockchip/rk3368-lion for example now looks like:

&gmac {
	status = "okay";

	mdio {
		compatible = "snps,dwmac-mdio";
		#address-cells = <1>;
		#size-cells = <0>;

		phy0: phy@0 {
			compatible = "ethernet-phy-id0007.0570";
			reg = <0>;
			assigned-clocks = <&phy0>, <&cru SCLK_MAC>;
			assigned-clock-rates = <125000000>, <125000000>;
			assigned-clock-parents = <0>, <&phy0>;
			clock-output-names = "ext_gmac";
			#clock-cells = <0>;
			vsc8531,edge-slowdown = <7>;
			vsc8531,led-0-mode = <1>;
			vsc8531,led-1-mode = <2>;
		};
	};
};


changes in v5:
- added Andrew's Rb for patch 1
- modified clkout handling to be a clock-provider
  to fit into the existing clock structures
changes in v4:
- fix missing variable initialization in one probe function
changes in v3:
- adapt to 5.8 merge-window results
- introduce a more generic enet-phy-property instead of
  using a vsc8531,* one - suggested by Andrew
changes in v2:
- new probe factoring patch as suggested by Andrew


Heiko Stuebner (3):
  net: phy: mscc: move shared probe code into a helper
  dt-bindings: net: mscc-vsc8531: add optional clock properties
  net: phy: mscc: handle the clkout control on some phy variants

 .../bindings/net/mscc-phy-vsc8531.txt         |   2 +
 drivers/net/phy/mscc/mscc.h                   |  13 +
 drivers/net/phy/mscc/mscc_main.c              | 306 ++++++++++++++----
 3 files changed, 250 insertions(+), 71 deletions(-)

-- 
2.26.2

