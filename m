Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788CF32DCF2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhCDWZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:25:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhCDWZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:25:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHwP8-009LWk-UM; Thu, 04 Mar 2021 23:25:10 +0100
Date:   Thu, 4 Mar 2021 23:25:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: stmmac driver timeout issue
Message-ID: <YEFeRrKKK7gnmqcc@lunn.ch>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 01:14:31PM +0000, Joakim Zhang wrote:
> 
> Hello Andrew, Hello Jakub,
> 
> You may can give some suggestions based on your great networking knowledge, thanks in advance!
> 
> I found that add vlan id hw filter (stmmac_vlan_rx_add_vid) have possibility timeout when accessing VLAN Filter registers during ifup/ifdown stress test, and restore vlan id hw filter (stmmac_restore_hw_vlan_rx_fltr) always timeout when access VLAN Filter registers. 
> 
> My hardware is i.MX8MP (drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c, RGMII interface, RTL8211FDI-CG PHY), it needs fix mac speed(imx_dwmac_fix_speed), it indirectly involved in phylink_link_up. After debugging, if phylink_link_up is called later than adding vlan id hw filter, it will report timeout, so I guess we need fix mac speed before accessing VLAN Filter registers. Error like below:
> 	[  106.389879] 8021q: adding VLAN 0 to HW filter on device eth1
> 	[  106.395644] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLAN_Tag_Filter
> 	[  108.160734] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full - flow control rx/tx   ->->-> which means accessing VLAN Filter registers before phylink_link_up is called.
> 
> Same case when system resume back, 
> 	[ 1763.842294] imx-dwmac 30bf0000.ethernet eth1: configuring for phy/rgmii-id link mode
> 	[ 1763.853084] imx-dwmac 30bf0000.ethernet eth1: No Safety Features support found
> 	[ 1763.853186] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLAN_Tag_Filter
> 	[ 1763.873465] usb usb1: root hub lost power or was reset
> 	[ 1763.873469] usb usb2: root hub lost power or was reset
> 	[ 1764.090321] PM: resume devices took 0.248 seconds
> 	[ 1764.257381] OOM killer enabled.
> 	[ 1764.260518] Restarting tasks ... done.
> 	[ 1764.265229] PM: suspend exit
> 	===============================
> 	suspend 12 times
> 	===============================
> 	[ 1765.887915] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full - flow control rx/tx  ->->-> which means accessing VLAN Filter registers before phylink_link_up is called.
> 
> My question is that some MAC controllers need RXC clock from RGMII interface to reset DAM or access to some registers.

There are some controllers which need the PHY clock. And some PHYs can
give you some control over the clock. e.g. there are DT properties
like "ti,clk-output-sel", "qca,clk-out-frequency". You probably want
to look at the PHY datasheet and see what you can control. It might be
possible to make it tick all the time. It has also been suggested that
the PHY could implement a clk provider, which a MAC driver to
clk_prepare_enable() when it needs it.

     Andrew
