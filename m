Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7817B4D6AC9
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiCKWvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiCKWvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:51:25 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA082C14BE
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:25:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko9wiZHAXOKGHIYKbkCxCm3bBAUY/20/eztN/gdIwYTLSA/2ccY5FEdW7Ai55SPlF0PpArX+V8WNfOpvREPRqP+bmZHh7FAiel3OA1PfXMjdjq8kMGUV4nFyUUMkVmM5uLtG05lhrRnDhof3t04Ktixr2s2/eq6cu050Iit6U+NCFG3GtNQ60cj0B4cAt0P0pOSek8FTsXec94zlNqiHJgt6VwgldPZ6NCYr8T+Az9m0+XrGghbZB9rA6kvekVPH2NC7bA0Ml4IXHRrzK3cfl5pJnh0TsNncx6Wp6e7rI4ec1wL9Sze0SiBBV6UAQ3quP0bGPiKxBoFF4LFPoZR8CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5jXbu9hoHifto8sFEiSK27vHwvo/QzmmF01KpLD/Z4=;
 b=Fsy6mCTiNTZXxMwqzUlUz+1IDNLx03rHdVj7rfwbUq0LddVVPaI91IlAXl8TwI4Ehpcw+IzLHpN1KgxQkhk0pX78BKGxDC29dK5xWHPIeAI8bodIBfPpPf1+tqAwFjGvZnQqR3f7XWJuBMhYRZY1jkGRmSTPI99wpAFj1NpM+WAmILBaN0IK7PeyG4tc6lrxJLZOIB87bJX2Gw5+BOfzJSsrqf3gd1ohuXFOnKluxMegCEBszqRpF7i86XV5ZjC+JNt5rL+5rwZ6X79J7Kl4M6IsjNfIbo+Zw5Avts00Mu3Y+WhoNFt45ANxXoO6FIo8UjxxxJpGKZRULGrPrdAgnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5jXbu9hoHifto8sFEiSK27vHwvo/QzmmF01KpLD/Z4=;
 b=QtR2CKGheyd+njMOrUQrlGVfeiWrqdxr301mKb0LEYEmk3YFGoMRNG3jOKM1j+N1EqaJ+E/ZwOzlktm6YEaOvWksSuIiieoTjf9dalKa7KhkpYQ92+em3LJXoT9G8PgcQsLPwmbt/v8P3UhFFBFlB86AIfn8LeTDMqJI+GbFhOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8934.eurprd04.prod.outlook.com (2603:10a6:10:2e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 21:15:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 21:15:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 1/3] net: dsa: report and change port default priority using dcbnl
Date:   Fri, 11 Mar 2022 23:15:18 +0200
Message-Id: <20220311211520.2543260-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
References: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37208d90-4252-4849-64ee-08da03a4461b
X-MS-TrafficTypeDiagnostic: DU2PR04MB8934:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8934398B69890037455C28CCE00C9@DU2PR04MB8934.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpvhwpHqlcPOgqwyjjd26uiZWIOBehCky68ZPlwAzGDmsobiPTNWoaFQMGiFOIT4YZc6A6Ui9o3vSpdGlYkvKXlpi3p7vkiVI9zorHYRj2GE3ewfoClq01P60GrB2J3mm1p7oSftAEAK7kjnmCz9IUaoEbTbD53/nqRu55aC7sg9XIgUAwoos+1W+oAsYg/XQLG7WHJOk0dtcPWmvkCV9ZVrbDNXbxUn7MJB0PUAzHcNJGKYKYSP07HMvsrLtcP6aLPV01t78AHz0zjz0nNvVznO+ugeFRsTOz+EagLfuQZ4+tXTGyAHZY4AVUNkZox4oND42q+dl8qxGOFipmYFOzXZrXup7diBrTvad262OERQQQQa0+YuUW6egOxWu8F4zA6IvF6crnYN98BYtLlDNm+nsTwzNAlNySHAKiqHdpRBIwCDsA4tPQPFi/RNbSVkiqhR94DqqsQufVYzLgqMKj+42Hpd586viu4rP1hy2bNxDNbgSWkw64mKkijeopXPtHU3M89yusGQYdiXh9oriWclieCex/PImA9Pn2aXvAxNxh/iHwDgzffSP9pSUTRLqyEOMB/3cvd3AD4deLlqf1xv3Oe4TI1PcapQVSLZmSKLiPq3g12jJjojQkWPm+VCMm8AbHeYVON3x8S8kp6ZmQ1vPtxLspcyjd1A0+CqJom7+G0qwZpdMxYppkjw3OuNrt4GPT8XvDIx+FZ7MjFl4Nuar79LqpeJgmRyUSKvCpDtHer0DDDZ9ZHbEHaNslK1l03RYJlb3DXp33YVMf6CdgwTnQQDRbrfxO6kEe0SireSjUPxMyoMq9IpsOUCR8Lu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(38350700002)(1076003)(54906003)(38100700002)(316002)(66476007)(6512007)(83380400001)(86362001)(508600001)(2616005)(2906002)(8936002)(66556008)(7416002)(6666004)(26005)(6506007)(6486002)(4326008)(8676002)(66946007)(5660300002)(966005)(44832011)(186003)(52116002)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FCzV39fT2iq8X+MVrJ67O6p1WwdgOT2I4Bv9IR/FJQlrvXubvSEyn3NmmCEq?=
 =?us-ascii?Q?C07mOpLTPLQCFymvzu6dLlwMpjhm/SGPCC54hOVD4X3oKx2eWxng/VI5ggMO?=
 =?us-ascii?Q?uSccXLVbJ/LVHoeT3OkR/dmel9PcyvxIXDU3eXaRHa8/RqxQZGnDK6X8CyPD?=
 =?us-ascii?Q?5kjfRz/eajzO9ZkayfjaIn/X6kq8XrL4IZOL418dbC+LT57iVP/0nNgdwHVn?=
 =?us-ascii?Q?61DPu3xxVQN16GyZnGO+xcm1jLDnpaRN/4BUmkHnwt8OBc1LodJHTWUt5Ppy?=
 =?us-ascii?Q?dt9F7i/v15DhwKwCAB+Jgl9FQiA1c6fBevdpIlSkCZxhVFdcDdb+JPHzMrn1?=
 =?us-ascii?Q?82XFy8N7cDJtOJ7tcH2XPbLVwSGWI/uJAsQcOwr7pib+3QuprFkgwQb0M3Yw?=
 =?us-ascii?Q?uPPakLDmf+8ZpEqH0yRysvnzMp4EjT4WVudCQdT2I6QQpMrYLCDjJLOkze7Y?=
 =?us-ascii?Q?aSCBlsLOvD7Q9bchEDMqP3RgSi7Xq7t704KKV8ZPTj8yp9M3jo9oPw6RbsGV?=
 =?us-ascii?Q?54POr17+af+PSPk+QsXgm82WzYs+je02rBeodCUEZ6Eb/84ZtlQUnw+OXOp1?=
 =?us-ascii?Q?PZY9bkPzU/dvw31Nt6pArjbNa1zmzXy7rIoqLxfQJKod4YHBBM7vBxGf6rql?=
 =?us-ascii?Q?1tMVBCY0abA6zoB3WxKLAa+RPYXBicuuu42PonqkUSEb0RYcnlAFVG1Ul8zf?=
 =?us-ascii?Q?/8LmbK1bN4cokhmMvqq9Zz70aMFTK0RMhGDeB+JbCSpT2FQ3xJunL9gPDjxv?=
 =?us-ascii?Q?13dbj/wRAn4E7TJskpwZ9N9ZIYQScsvKZb69asKBUOaLhD+SHDZAoK+RaG0M?=
 =?us-ascii?Q?N2EyQK2GbVVBJRHLihCZIw062qemKJqfASlKUAC1nuwQ+MkZWDbhx31fAzFV?=
 =?us-ascii?Q?U61+IEqlbscP4l9lUo8II0HW0tBZeZNySNZyGWcHMXVYSul2Bsv98av7dgb9?=
 =?us-ascii?Q?6L3zsuZSCx0HSWC+WX6Obav8WetAYNLUOKeuJiu5acLD8WYe3V4BvnzjubOz?=
 =?us-ascii?Q?hZzmuf8jYXEdjN5OF7Rab738861HQvQCmxtDo7rvfqOtTuEKdYhEtuic/UXK?=
 =?us-ascii?Q?xmrd9KhhlmnJ5ymQaSVXHWItfWj4447oJw8Gia4kltW41ax58Ps3zjvDzABd?=
 =?us-ascii?Q?To8gtWxuX/WbeT2RIwaYBdL5EeW+LaYiqv0a281cO/959REVeDzlIqtAmYk9?=
 =?us-ascii?Q?HPc2k1EgPeImO6P3XJCzSvHr5HVltHzHlrRCZAt4x8Qe/TMEhjWcbbZcjNBw?=
 =?us-ascii?Q?iWYD58ZDiTXC5+hK/qUY3WknLeVUz1l5GOo19M1OGpbItF9bso+niPClqZiY?=
 =?us-ascii?Q?lTZwRB5a6PFMSiMghWfZei3um8YK52AIbE70/vuDXqjibDxR3TVPp7VlK6ac?=
 =?us-ascii?Q?kNvpNygpfEh2sm20Gpx1pAFvoYEwRM7G19MlTTcn5MrGb1N+/PoEavruKzIN?=
 =?us-ascii?Q?eAUj2l6OSmFPwyybTslH03aTQ7FifJPGE6x6kP8xdDk+ZIOwwLZU3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37208d90-4252-4849-64ee-08da03a4461b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:15:31.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVvzdpltwmn47g/4zwFEtvF55IjlDFzcx4TeKeGDyymlWD6jVzNSmfJNjpAsZoFkI4ZP1QElHhcgVFuNfdLjCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8934
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port-based default QoS class is assigned to packets that lack a
VLAN PCP (or the port is configured to not trust the VLAN PCP),
an IP DSCP (or the port is configured to not trust IP DSCP), and packets
on which no tc-skbedit action has matched.

Similar to other drivers, this can be exposed to user space using the
DCB Application Priority Table. IEEE 802.1Q-2018 specifies in Table
D-8 - Sel field values that when the Selector is 1, the Protocol ID
value of 0 denotes the "Default application priority. For use when
application priority is not otherwise specified."

The way in which the dcbnl integration in DSA has been designed has to
do with its requirements. Andrew Lunn explains that SOHO switches are
expected to come with some sort of pre-configured QoS profile, and that
it is desirable for this to come pre-loaded into the DSA slave interfaces'
DCB application priority table.

In the dcbnl design, this is possible because calls to dcb_ieee_setapp()
can be initiated by anyone including being self-initiated by this device
driver.

However, what makes this challenging to implement in DSA is that the DSA
core manages the net_devices (effectively hiding them from drivers),
while drivers manage the hardware. The DSA core has no knowledge of what
individual drivers' QoS policies are. DSA could export to drivers a
wrapper over dcb_ieee_setapp() and these could call that function to
pre-populate the app priority table, however drivers don't have a good
moment in time to do this. The dsa_switch_ops :: setup() method gets
called before the net_devices are created (dsa_slave_create), and so is
dsa_switch_ops :: port_setup(). What remains is dsa_switch_ops ::
port_enable(), but this gets called upon each ndo_open. If we add app
table entries on every open, we'd need to remove them on close, to avoid
duplicate entry errors. But if we delete app priority entries on close,
what we delete may not be the initial, driver pre-populated entries, but
rather user-added entries.

So it is clear that letting drivers choose the timing of the
dcb_ieee_setapp() call is inappropriate. The alternative which was
chosen is to introduce hardware-specific ops in dsa_switch_ops, and
effectively hide dcbnl details from drivers as well. For pre-populating
the application table, dsa_slave_dcbnl_init() will call
ds->ops->port_get_default_prio() which is supposed to read from
hardware. If the operation succeeds, DSA creates a default-prio app
table entry. The method is called as soon as the slave_dev is
registered, but before we release the rtnl_mutex. This is done such that
user space sees the app table entries as soon as it sees the interface
being registered.

The fact that we populate slave_dev->dcbnl_ops with a non-NULL pointer
changes behavior in dcb_doit() from net/dcb/dcbnl.c, which used to
return -EOPNOTSUPP for any dcbnl operation where netdev->dcbnl_ops is
NULL. Because there are still dcbnl-unaware DSA drivers even if they
have dcbnl_ops populated, the way to restore the behavior is to make all
dcbnl_ops return -EOPNOTSUPP on absence of the hardware-specific
dsa_switch_ops method.

The dcbnl framework absurdly allows there to be more than one app table
entry for the same selector and protocol (in other words, more than one
port-based default priority). In the iproute2 dcb program, there is a
"replace" syntactical sugar command which performs an "add" and a "del"
to hide this away. But we choose the largest configured priority when we
call ds->ops->port_set_default_prio(), using __fls(). When there is no
default-prio app table entry left, the port-default priority is restored
to 0.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210113154139.1803705-2-olteanv@gmail.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I dislike having "#if IS_ENABLED(CONFIG_DCB)" in C code, so I minimized
this pattern as much as possible, replacing it with __maybe_unused.
Let's see how this goes with build testing...

 include/net/dsa.h |   7 +++
 net/dsa/slave.c   | 137 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9d16505fc0e2..1220af73151b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -892,6 +892,13 @@ struct dsa_switch_ops {
 	int	(*get_ts_info)(struct dsa_switch *ds, int port,
 			       struct ethtool_ts_info *ts);
 
+	/*
+	 * DCB ops
+	 */
+	int	(*port_get_default_prio)(struct dsa_switch *ds, int port);
+	int	(*port_set_default_prio)(struct dsa_switch *ds, int port,
+					 u8 prio);
+
 	/*
 	 * Suspend and resume
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a61a7c54af20..97f5da81fe68 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -19,6 +19,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <linux/if_bridge.h>
 #include <linux/if_hsr.h>
+#include <net/dcbnl.h>
 #include <linux/netpoll.h>
 
 #include "dsa_priv.h"
@@ -1852,6 +1853,123 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	return err;
 }
 
+static int __maybe_unused
+dsa_slave_dcbnl_set_default_prio(struct net_device *dev, struct dcb_app *app)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	unsigned long mask, new_prio;
+	int err, port = dp->index;
+
+	if (!ds->ops->port_set_default_prio)
+		return -EOPNOTSUPP;
+
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		return err;
+
+	mask = dcb_ieee_getapp_mask(dev, app);
+	new_prio = __fls(mask);
+
+	err = ds->ops->port_set_default_prio(ds, port, new_prio);
+	if (err) {
+		dcb_ieee_delapp(dev, app);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __maybe_unused dsa_slave_dcbnl_ieee_setapp(struct net_device *dev,
+						      struct dcb_app *app)
+{
+	switch (app->selector) {
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+		switch (app->protocol) {
+		case 0:
+			return dsa_slave_dcbnl_set_default_prio(dev, app);
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int __maybe_unused
+dsa_slave_dcbnl_del_default_prio(struct net_device *dev, struct dcb_app *app)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	unsigned long mask, new_prio;
+	int err, port = dp->index;
+
+	if (!ds->ops->port_set_default_prio)
+		return -EOPNOTSUPP;
+
+	err = dcb_ieee_delapp(dev, app);
+	if (err)
+		return err;
+
+	mask = dcb_ieee_getapp_mask(dev, app);
+	new_prio = mask ? __fls(mask) : 0;
+
+	err = ds->ops->port_set_default_prio(ds, port, new_prio);
+	if (err) {
+		dcb_ieee_setapp(dev, app);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __maybe_unused dsa_slave_dcbnl_ieee_delapp(struct net_device *dev,
+						      struct dcb_app *app)
+{
+	switch (app->selector) {
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+		switch (app->protocol) {
+		case 0:
+			return dsa_slave_dcbnl_del_default_prio(dev, app);
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/* Pre-populate the DCB application priority table with the priorities
+ * configured during switch setup, which we read from hardware here.
+ */
+static int dsa_slave_dcbnl_init(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	int err;
+
+	if (ds->ops->port_get_default_prio) {
+		int prio = ds->ops->port_get_default_prio(ds, port);
+		struct dcb_app app = {
+			.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE,
+			.protocol = 0,
+			.priority = prio,
+		};
+
+		if (prio < 0)
+			return prio;
+
+		err = dcb_ieee_setapp(dev, &app);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_drvinfo		= dsa_slave_get_drvinfo,
 	.get_regs_len		= dsa_slave_get_regs_len,
@@ -1881,6 +1999,11 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.self_test		= dsa_slave_net_selftest,
 };
 
+static const struct dcbnl_rtnl_ops __maybe_unused dsa_slave_dcbnl_ops = {
+	.ieee_setapp		= dsa_slave_dcbnl_ieee_setapp,
+	.ieee_delapp		= dsa_slave_dcbnl_ieee_delapp,
+};
+
 static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -2105,6 +2228,9 @@ int dsa_slave_create(struct dsa_port *port)
 		return -ENOMEM;
 
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
+#if IS_ENABLED(CONFIG_DCB)
+	slave_dev->dcbnl_ops = &dsa_slave_dcbnl_ops;
+#endif
 	if (!is_zero_ether_addr(port->mac))
 		eth_hw_addr_set(slave_dev, port->mac);
 	else
@@ -2162,6 +2288,17 @@ int dsa_slave_create(struct dsa_port *port)
 		goto out_phy;
 	}
 
+	if (IS_ENABLED(CONFIG_DCB)) {
+		ret = dsa_slave_dcbnl_init(slave_dev);
+		if (ret) {
+			netdev_err(slave_dev,
+				   "failed to initialize DCB: %pe\n",
+				   ERR_PTR(ret));
+			rtnl_unlock();
+			goto out_unregister;
+		}
+	}
+
 	ret = netdev_upper_dev_link(master, slave_dev, NULL);
 
 	rtnl_unlock();
-- 
2.25.1

