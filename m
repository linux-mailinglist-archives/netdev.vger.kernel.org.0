Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31506BD4D6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCPQNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCPQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:13:35 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C829193E9;
        Thu, 16 Mar 2023 09:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqM1tGdNICHJcAKGRNDPTWc0xvKYVSeqmGehrR1j+J1Oo5Ie01+52lWe91E5M6LsN0vJNPfLKHBYGwxebxz0aHY5Or0JUDjUcSCKItCwntzFnSjZVj7HnVYTstkZYqBJtFn4IRArkaPh/czb0IX2C6noGs1h0OZCdxw3dcIwD+EekT6H2vWR6044EPq3jh1YpEaLbZ9SI5vcFiBwHZYVpHyOE5UShe2CAVia+wOBBTbWiPYYSPPnNUpVeNrEMbrTTHfArsZnUaaJiwjchpKhfptU1bZCu1thWSVpw8t+zg8f2q7q2STXx7Vb9oqmmS7MOKZrzUNWsCs6XfJ4ibuSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7ea6CfsGQ/OH7qvt1ki+x2Pw6IMRsM8YUgJV8WsPcs=;
 b=ahg5WaFiqPMYaYiXR+LmW4HwqqfHij2bDECq+mqwZhGE6xmo8jumiiUOgGUhmxIZs8BRXD/8rMs6JERfYuBzfgkJLJ7Fpk0Nu4QzrY4rSX+uRmIBFk/TYfazN0ohpMzjJ7j1S8NMqC+65F9VtSEtyRznEutfy5LvAVgjkCknpPTr+I0/H1STjH02CqWNSsdlDRj8UC1qXzvEVIKoJh0ELU73qSrZ6tA40VKQG2zvUUmUyeE+0nLPHWh2BqHhABYQKswGxcfY7/W0n3lUOqxE4UquojRZw0E231GOiO8gUyWYimcC4uXhKl0oob5RJUCCZv6Dzs/Kg6Zxa+lmrYTdUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7ea6CfsGQ/OH7qvt1ki+x2Pw6IMRsM8YUgJV8WsPcs=;
 b=Y6EwGFy1v3zHta4Wrs+PiwyRRkE/YSgxU4RWLJDxtXpcrwM8F/zu41WMAShMCCgaEWbiPoKdHkleqFmG8nV0D9CJyWtdbnfeulvpcgZdS998nMrgG26DMhOoZ+20Zi0ujlWUzJ0A/57xIQCXHNRaHjQejzMiQC7cGhneecQJ3xA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 16:13:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:13:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH net-next 3/4] net: dsa: microchip: allow setting xMII port speed/duplex on KSZ8765/KSZ8794/KSZ8795
Date:   Thu, 16 Mar 2023 18:12:49 +0200
Message-Id: <20230316161250.3286055-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: ca862501-7e73-4fbf-4e30-08db26395718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12vWWdCxqDuQMGID0tXEUuP2eOzk01Ty6zGRCdId68LFIRVfk3TIdYGtzckPKQsAu8foNIVJ2saMYc+sHDeE/w+kREL2edKUDYLxQZhy7W+hPhtMQXtCkuMj1aYa6rW8UC8NIL/V0BJe+a3YGMR2phzoOxC6/xsnXgRTZcgrlHLCq6kGARouz8yQRAM9VRU6gPANLtkhmGzOiaE9rJKKMmP/nzBwFL5ueBwugW7aA+uFMN8l9C8P5GFewLUHZdCVA6j7jCSRec4cQtBz4tUP/p8O5kJDkTkMi3bF/0Ai1q5kJhICNEXRzdHqHgV0u2xatnb8c+ne4Be9SA/OCfx04ZIGcoSr7yAzNi8+t5GLwqs7U5XI+rJuWEfgaVZ3dsGHYUtF0s0uvn/0CWaPUmfwLuab/Nq3U+1+rJUYYTM2oTmbQllIrqKmzLa9G0t5QBzSh/3Ydj+EEKJjDmW11xRxEahkxlDvPrH8/DDflST4JOyapihCLTpj3tQT3pfDwoegrt//PPw0IsEfV9owCv+W6Ze0v3mUikyssVanMJ+I1CW9FvCDv0BXwb91/GdRW1gM8HzIGbdnz4JzziYz8lpcOgLCW9cQOqy4WUJeZSM8C9nhiijPh9pO2NGJRZo37usoq3D4D6JbrdFxyGy71V7XV8J+HuVXQExA1BiWcNWXa5G3pJtmeQBkkQCYUcsAjukqZAhITVLtobpLonsAZsKgdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(36756003)(86362001)(38350700002)(38100700002)(2906002)(5660300002)(41300700001)(8936002)(44832011)(7416002)(4326008)(6512007)(66476007)(1076003)(6506007)(26005)(186003)(2616005)(6666004)(83380400001)(316002)(54906003)(6916009)(8676002)(66946007)(6486002)(966005)(52116002)(478600001)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WRuuwQnUHoAAydh8zfJE81rEA5Z0mutCr+wn0gCr0AePKmPESCJQ8ThWgv+z?=
 =?us-ascii?Q?eOeuUGmvmOFmEk5eKyOwXtcRifABx0eFWAr9ADSkLhDl5SzyEgxLjEOEXIgo?=
 =?us-ascii?Q?GuXJuySGCYBI13v6CKaIXQRDCBPVNDbbjrb1U9RPRjovYckIvW8E8gJyLziY?=
 =?us-ascii?Q?offrSpl1urj6HWMmgxEYL/4FGRMXU5f9mQajp8+r5ZZfbUr7gnNB+FVqX/Re?=
 =?us-ascii?Q?mqvxKz8iKain9VkhqJF9w5R8VTNXgfErSlQibAjRPfHk9Ayfj1oZNC1qracd?=
 =?us-ascii?Q?KLUQ9w3Hrv4KgQWiQBF8y0WWH1vUkt45zZKjfmnkYscL4IFvSFrdSP6R5FqS?=
 =?us-ascii?Q?rY5Gt5yN3M/hmvfv0JsDMNT1dmx+GnGZ4HUVO1tcE3+C6SuAMYYW0Ug0fN3i?=
 =?us-ascii?Q?eCVEooxkkW1mxZrrbxc3lqLeZWQMzge5+H6RTl4KOT3b4t7aKcm5DuTTzPjc?=
 =?us-ascii?Q?ttPkj1dDXYBgZc6I+o7NaQZ9ISx1fFiSkxM8KXgc9zhir35qeSHIzncXNVZ6?=
 =?us-ascii?Q?oCpUK978suI3R2ijCOIXXEpRJeXWM1LDIQOOzlQo1+TWC+J67Y7Wm8q2MStq?=
 =?us-ascii?Q?LOT8tEIsM3kjnWijko8NaEJlFjPGjjel/XxJyAj6T9jXmKMhQf6mSJ1B4gwa?=
 =?us-ascii?Q?39K2sHG6oSMzKYXJW7DMfyZpKA2sUnNUsw+ZnyF37/Rx7eRHZkXKkY4eGRpj?=
 =?us-ascii?Q?hxS0W2t3vcb2eZzJXqR6QmCxwCJpUMDvNX/k6F0EWvW/DX+lGqurxK0E4Ir4?=
 =?us-ascii?Q?49OLuWx2UZ+kyanX7dHjPQdKTk5y3hysK+vkA8QT6rugnSz4BO7/yCVjwqW1?=
 =?us-ascii?Q?XzZ7c/Z1hoUu0vWwnFfmgAkur1mwcGV0YwCRKAKk9AQo35II8cauM65q/D7w?=
 =?us-ascii?Q?Vg8TkTiu6CmLb7yXHWpT6fYBUr/+33Q5s25pSk7S/UClOU4SdHohk4aPLfN0?=
 =?us-ascii?Q?R/XDlbrqSx2di+dYsffyMO+v/T5c+7OBZTu0OHzcboPK13nweuu7in/q5g2t?=
 =?us-ascii?Q?aNMYHSO0R8EY2v5ZxTSR6/T4UQOHS5B3Aa9EMVb0DYk9aIbhzRMrIYDzAPiG?=
 =?us-ascii?Q?sHw/gDk4XyQOHWA2zex+0u3ukOWGwagW7MTgovv/dtz5ogeEb9qn+qqWRsIT?=
 =?us-ascii?Q?snPDdDVwG13dg8jSNZaX+48zM6sRK9+Lx+QkaQYKmOyX4l+hSDRYfa+SZmex?=
 =?us-ascii?Q?PLtc0+OI9cVd7p2wycipEAPulo0t9+szSoUcE1SFuohB7zZgKFyC/es/giOf?=
 =?us-ascii?Q?LFBnm4JxaGgpCK4RBmKoT24JFRjAPgu7bqfYDRx+O4pXmL/uRRv581aT6/gq?=
 =?us-ascii?Q?5BVtapqnHMVV/h8Pa/Q4h+XKh3e70aloMQQRn36utRKxzyGt6K+hvzn6EVJW?=
 =?us-ascii?Q?7FTRz9mPFEQ9WmEmvNw9GR3RkAutGopZyWkExhWs2I5jc0W0hyLDk94218F6?=
 =?us-ascii?Q?vZ6SXiiMgoksQt/DyR3t/Jj9qBNGxVYLah45cwAAHcJR2kLBNxPhBTdK6BxD?=
 =?us-ascii?Q?Jold3NSvgqd/FuIvxRImO/SkfVPLF4I/Y60/hhpLqtVC3JNIbjrveR7Q9Pj5?=
 =?us-ascii?Q?WaLAso1ouXjuDDs8YZCuaKqIn/9bWOHsh4N77DLHafJ+ix/NqlksuEh7nDCy?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca862501-7e73-4fbf-4e30-08db26395718
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:13:12.0977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVFZmwciQ4o2JXmrtDcdS5Oy7eKxprNKb13c5fMmO6Frm2ItxaGIjVtd20xANVswRyk8Y4MzBNJDjmUmO/4BLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to commit c476bede4b0f ("net: dsa: microchip: ksz8795: use common
xmii function"), the logic from ksz8795_cpu_interface_select() used to
modify the following fields in REG_PORT_5_CTRL_6, based on the phy-mode
of the CPU port:
- PORT_INTERFACE_TYPE (now P_MII_SEL_M)
- PORT_GMII_1GPS_MODE (now P_GMII_1GBIT_M)
- PORT_RGMII_ID_IN_ENABLE (now P_RGMII_ID_IG_ENABLE)
- PORT_RGMII_ID_OUT_ENABLE (now P_RGMII_ID_EG_ENABLE)

That logic was replaced to a call with ksz_set_xmii(), which only
touches 3 of those 4 fields. It does not touch PORT_GMII_1GPS_MODE
(now P_GMII_1GBIT_M, or RF_GMII_1GBIT, in its reg_fields form).
That is handled by ksz_set_gbit(), which should have been called as
well, for code-wise identical behavior.

The driver has always written to PORT_GMII_1GPS_MODE to enable RGMII
ports at their maximum speed, since the initial commit e66f840c08a2
("net: dsa: ksz: Add Microchip KSZ8795 DSA driver"). Searching in the
KSZ8975 documentation, I see that the Is_1Gbps field (what the driver
calls P_GMII_1GBIT_M) is set to 1 by default, unless pin strapping via
LED1_0 sets it to zero, case in which the RGMII speed is either 10 or
100 Mbps - controlled via P_MII_100MBIT.

I can only imagine this being a problem if there are boards where the
pin strapping is wrong (asking for 100Mbps when the link was capable of
gigabit), and the initial version of the driver was overwriting that.
That may or may not be plausible. For example, this commit does indicate
a (different, but still) incorrect pin strapping setting which does need
to be fixed up by the Linux driver:
https://patchwork.kernel.org/project/netdevbpf/patch/20230315231916.2998480-1-vladimir.oltean@nxp.com/

In any case, it makes sense for Linux to configure the switch to match
the device tree description, and that means calling the missing
ksz_port_set_xmii_speed().

The current position of the ksz_port_set_xmii_speed() call is from the
ksz9477_phylink_mac_link_up() handler, but this is called for all
dev_ops except for ksz8_dev_ops.

Studyint ksz9477_phylink_mac_link_up() a bit, its contents seems to be
more than useful, since it also calls ksz_duplex_flowctrl() and that is
also something that KSZ8765 supports but doesn't call. It seems to be
desirable to move the entirety of ksz9477_phylink_mac_link_up() into the
common ksz_phylink_mac_link_up(), and remove the family-specific
handling.

The KSZ8830 switch is a bit special. It uses ksz8_dev_ops() (so it has
skipped phylink_mac_link_up() so far), but it uses the ksz8863_regs[],
which don't have P_GMII_1GBIT_M defined. This makes sense, since the
KSZ8830 switch comes either in RMII or MII variants, both of which are
fixed speeds (100Mbps). So we still need to skip phylink_mac_link_up()
completely for these, and the test for ksz_is_ksz88x3(), which is also
present in ksz_phylink_mac_config(), achieves that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 38 ++++++--------------------
 drivers/net/dsa/microchip/ksz_common.h |  5 ----
 2 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5bcbea8d9151..9bc26c5da254 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -216,13 +216,6 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.change_mtu = ksz8_change_mtu,
 };
 
-static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
-					unsigned int mode,
-					phy_interface_t interface,
-					struct phy_device *phydev, int speed,
-					int duplex, bool tx_pause,
-					bool rx_pause);
-
 static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.setup = ksz9477_setup,
 	.get_port_addr = ksz9477_get_port_addr,
@@ -249,7 +242,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = ksz9477_change_mtu,
-	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = ksz9477_config_cpu_port,
 	.tc_cbs_set_cinc = ksz9477_tc_cbs_set_cinc,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
@@ -286,7 +278,6 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mdb_add = ksz9477_mdb_add,
 	.mdb_del = ksz9477_mdb_del,
 	.change_mtu = lan937x_change_mtu,
-	.phylink_mac_link_up = ksz9477_phylink_mac_link_up,
 	.config_cpu_port = lan937x_config_cpu_port,
 	.tc_cbs_set_cinc = lan937x_tc_cbs_set_cinc,
 	.enable_stp_addr = ksz9477_enable_stp_addr,
@@ -2983,15 +2974,18 @@ static void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
 		ksz_regfields_write(dev, port, RF_MII_RX_FLOW_CTRL, !!rx_pause);
 }
 
-static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
-					unsigned int mode,
-					phy_interface_t interface,
-					struct phy_device *phydev, int speed,
-					int duplex, bool tx_pause,
-					bool rx_pause)
+static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				    unsigned int mode,
+				    phy_interface_t interface,
+				    struct phy_device *phydev, int speed,
+				    int duplex, bool tx_pause, bool rx_pause)
 {
+	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
 
+	if (ksz_is_ksz88x3(dev))
+		return;
+
 	p = &dev->ports[port];
 
 	/* Internal PHYs */
@@ -3005,20 +2999,6 @@ static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
 	ksz_duplex_flowctrl(dev, port, duplex, tx_pause, rx_pause);
 }
 
-static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
-				    unsigned int mode,
-				    phy_interface_t interface,
-				    struct phy_device *phydev, int speed,
-				    int duplex, bool tx_pause, bool rx_pause)
-{
-	struct ksz_device *dev = ds->priv;
-
-	if (dev->dev_ops->phylink_mac_link_up)
-		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
-						  phydev, speed, duplex,
-						  tx_pause, rx_pause);
-}
-
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2, id4;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a92ebf5417b4..760e5f21faa1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -381,11 +381,6 @@ struct ksz_dev_ops {
 	void (*phylink_mac_config)(struct ksz_device *dev, int port,
 				   unsigned int mode,
 				   const struct phylink_link_state *state);
-	void (*phylink_mac_link_up)(struct ksz_device *dev, int port,
-				    unsigned int mode,
-				    phy_interface_t interface,
-				    struct phy_device *phydev, int speed,
-				    int duplex, bool tx_pause, bool rx_pause);
 	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
 	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
 	void (*config_cpu_port)(struct dsa_switch *ds);
-- 
2.34.1

