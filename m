Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE1D51EE8F
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiEHPbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbiEHPb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:29 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222326349
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/b+rNFNWA8HQZIzDpd16BUaGCUgURB4X6G9QfCjhUFB4n40Vv50jH48aJt5eVE1F3JDZ5nWM8GZ+GAn3q95Azgouso3BQ7gUfSXzcPT/FW1UxuWulZEWMfLtDHsaEHrCcFWwDGGei3T7I27DsbjYUyzcBvt87n42QE2gvtYAutwoM/uXBvnl6iBHtAY5z5lT/TA7vchfhf5LmA4SxgT1KS3U406i79ljGrOyDUP2pXmkKAlaY63GPXvKDYikP8eGL/Hx3W1O6kGcRAo1pTxikm2VPqwf3FTEb2xag/Yx8SBN3SYELG4Tvq4+QJIKec7xaM5zi4IItmu5dpjhaSjKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+FfDEyEJjn24buEctc6/yQPjhEDWtGx8ksusmubYJs=;
 b=XUW/SvHcVya3mJc/j9/Hgr0qgsEiXksEtLzUYGD6OfC8GlAUqmuUyRgVsGRZyjrarlJFvEdNT2TAWPSJGk65qUr+swd4lO5tHgjNE297B6XnOc5u+yJHSUQ9rLuHIf00sBWgob27OhlFULmV830/9nb29OkmVMOCn+63MtEVLvEC8XRAUM/Zq1pxLsKmKKKGDOQuiSgXaQkR03IZvwEFUxyrzj5lyn0372ABLLpbt3CshRXXvAquuTjcaJrtcLN1VC4Kr9UU9eCsM0OgkY+kkO9r5OOLtXxVclKnS4W4/osR7aQ6G95JP06Wy0H22XWw3Ff8ZiMPiu3AbY5aeQhNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+FfDEyEJjn24buEctc6/yQPjhEDWtGx8ksusmubYJs=;
 b=eBPJBAH8Ativ/9a3wFGTPu/WZM/dYINmIZN73g+cP8qEltx6V39FLnX9DfUQHJ6MKUaNbjDlsXr70QccSBNcXtVLtQJjpNptE4wOnK+t1DWFQIEbedn2cAMKge0PatVPNsxp2Dv9ty0FzD4OL2+gOfjS2LWssfsjuCm3ziOG5J4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:35 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 5/8] net: dsa: felix: manage host flooding using a specific driver callback
Date:   Sun,  8 May 2022 18:27:10 +0300
Message-Id: <20220508152713.2704662-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf0036d-a40b-4804-5748-08da310746bf
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB28062A7ED6BA6D033CF7D8F9E0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEO5kMg6iXfYHv5nj6qvnmk41DMCLQ5RlfN6TaXn9ex1ELR0DGjrfSMrLuLYV83KBaHVdv7sbYYYxqoJyRx+6c1ySXXkgzwyXLO8+mSPswLgRyogzbx6UyMFA73dG8lZEy5//EMQIX+cmeoRMW8iC/ckfQhs2K0PSwNVrVelhaL1aaSups7zCAWdzH/SLv3Ypkp8LKBfeZHE3pGI8Dk8lBtn3gmq2jBiuHt/7qHP/waE4Kg+cyMIIGxyDb6No4BtGBK+XZHgrRThqpZTuyoe18NC7vaLHztfUhDtaY2KRAF5EFkFZlLbxQyIBO+Iu0slzJtKlu/USnjRlYHASe15HqqlWEdrraYq6R3EHzqJP/3FKsmRlMGX/x3ZnHIAXpwwGmygTeIGcuwpH2vlCRHkOdqVyyrwi4dy2qElD88ObDXxH5uWnMK0+MgbDNle9J2r0LOCPNtB1klScMNZQslhdnHznmOVmJYkVy4dQecccATUyH26j9G4//poVyjEJu/+A3gI8bECFduC5/MyXbEYdBU4Wlituy5hM8nxWhMVC5ci62Xt/K5O1OD4O/Ni9BegUFIjXEd8PmgPkq3WpH/ixS1moNFawi2KxJcyBXKEN8KJp0NBY/eiCwoMm/+eFcQpBzp78f9uljKgM9ibIXxyQWoS7vTX5zAh0Zeki6AOOjIGzsF0BaNxD0N7AcPbo+iuG5qEZavr2LVugW1Yp7NfMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CXRnILRXgrTfd859r7FGeNgrZlW2bcOi3a3vhvbYfRR1SyFvMIJFYMI1o5BU?=
 =?us-ascii?Q?7YfE8LXHoj3FQ6Zdp8J8SMtrHRidCCO/rOWxJ/igLGx7z44QDeIETHGLpX/W?=
 =?us-ascii?Q?eLw8j6GWGpc+Sn4INIssEUOFXVQ5EGKF+afB+n53vDevYunyF11LwSoWlgu4?=
 =?us-ascii?Q?mRc5Lqf/wjL9QWesf8UT+7VeXX0EtCnwh73vF5F5b639H0Y630kh/hv1c5Nn?=
 =?us-ascii?Q?L7nN6kxyAhiuF6Ygds2QfAaezdrXSxLRnj+UlYP1kdHvV8xHs/nvhM+ZhN1Z?=
 =?us-ascii?Q?G1pYttQZuI0ra32qiZjMiugTAhJIGF/WFRAcQnuCJwUTfDykqTkZqqwWRLGz?=
 =?us-ascii?Q?b30LvXXRKkaGG6RdY1wetMMCCWuRukWOuqeGlhKmXkcLy67CLbX2BP4yHXgp?=
 =?us-ascii?Q?7WvKDuMGAZ6qn3Iz/sUcXUPOnwM/sYJsMrtKNEkv2zKV+XwNeI2/dlmdITkK?=
 =?us-ascii?Q?Mafco88HufVETQMqB8iZED/y0OGLGBMhtpoiKztumQEtTJN0rB3+rr1OQY/k?=
 =?us-ascii?Q?PY1ra8KD4nY1A8aNKtpnBbKaNK31y11e8TujKTD7pu1STvprv1FN0AzMSrMJ?=
 =?us-ascii?Q?Oz4WMl+80EtOdiB24yZ+v5ZOdJnwaHIIRKnPAw7QGZTZ/AYlASSJ55QAxjZ8?=
 =?us-ascii?Q?hVsNehwtwf/ajf+BZqhWHxBLIbzPC/hOcVgkABt/WNNCh8hURG1Ntc9VupXJ?=
 =?us-ascii?Q?u8ZEwFYQGr7Znekas6j/r+j2sdbCbNf4uuplgAizWSPjBNY1oUXcJzW+MZ55?=
 =?us-ascii?Q?su/PqcEK9X2DEApVINqMJonBCRiN4WtRtsdaxI+fvScpGAIMgh+OU8buUvxW?=
 =?us-ascii?Q?XDJMI1FRsFhfCHRchxdwd6RX7z4pUvo0jS7eFeyS5ZQVggM1XYmF1b0KRLMv?=
 =?us-ascii?Q?elZurPCsQ3mSa3BvLBMM1N4bJpJBX9hIrqrMGs2N0iIVbBmTjalVplhrv+x3?=
 =?us-ascii?Q?wAPY1CrlPWGBENpzFyGf5bbkZZE8eXVSKQotcEERIzJzsFmZhYo28i69Zhps?=
 =?us-ascii?Q?TtZYTm9Q+jO46pKZeLIZPYt9aTA3d9yPwvolH/FjqBuR9vdQzcPEB+33KUEs?=
 =?us-ascii?Q?rCBFfLCkPLt0g3HoGoiYlXMH0q7xOGeYWg8TPllvH071MpX+PUlaE2I/3yM6?=
 =?us-ascii?Q?J2phUCpAf1vTyieZyPyA4w3Vj5LmF/3ijoVOkK0L59WqOMsSM7ZXMwOV88Hv?=
 =?us-ascii?Q?RenL8CyFlrTlHPiIbF8KWPZDHVOaPQhN89oI7Vgmra2T/gUFETV/1xpqu/bv?=
 =?us-ascii?Q?YlTKP6F6kaYCpIdg5PNbEQlKiBc5Ie5O9NkJX6O9+jj+5KkQPc6S/y04grn7?=
 =?us-ascii?Q?X/ULGVgQEeUDAHCI/le08DhzFZTVVg5pPYA9XPFugiXvPOXcJyQv/oGpXqxN?=
 =?us-ascii?Q?bmuKFBnc01zVP8l8HeatCc1bx/qklXQvCEhQeP93C5X/ThRjwpe/hch12IES?=
 =?us-ascii?Q?hdsmzF06+iDHvgXxayAARYcY2czv24s9ug5n4v+d3Lrl1SJYQWajwgNBihl5?=
 =?us-ascii?Q?/agF4OOjM+wqsbhAEILUQ/gGTPz3IP+9CbIcgohPuMIb6I24bS2EWGcEFeka?=
 =?us-ascii?Q?JV7aPJKNFl9/bP4nOgW+SN+PFnpLzFZynyqf/9nsNw9XEPZy15iJGpcBaLol?=
 =?us-ascii?Q?Q8tSfgapVLyUh4L+6XlkF4NuKfRu2mq+9/dS4UuekKny7sGLsMmfcibids13?=
 =?us-ascii?Q?dwSOMH8r3ME1OqKyGrZY39gqeeDtTzU5VaPOX7oYh7d2dPeiMljVkvEOGXOa?=
 =?us-ascii?Q?F9cZqt8kJ9kDjqQEGj/AjeNHcvaDhcU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf0036d-a40b-4804-5748-08da310746bf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:34.9385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w621sDC2gT8oYRsHpZpuK7q+92xIWQ+JC/yaHT3vL1fNSwMQQE6SM/FF8OMgOE5EGoTLRxeYwoiLakroZFkmrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the time - commit 7569459a52c9 ("net: dsa: manage flooding on the CPU
ports") - not introducing a dedicated switch callback for host flooding
made sense, because for the only user, the felix driver, there was
nothing different to do for the CPU port than set the flood flags on the
CPU port just like on any other bridge port.

There are 2 reasons why this approach is not good enough, however.

(1) Other drivers, like sja1105, support configuring flooding as a
    function of {ingress port, egress port}, whereas the DSA
    ->port_bridge_flags() function only operates on an egress port.
    So with that driver we'd have useless host flooding from user ports
    which don't need it.

(2) Even with the felix driver, support for multiple CPU ports makes it
    difficult to piggyback on ->port_bridge_flags(). The way in which
    the felix driver is going to support host-filtered addresses with
    multiple CPU ports is that it will direct these addresses towards
    both CPU ports (in a sort of multicast fashion), then restrict the
    forwarding to only one of the two using the forwarding masks.
    Consequently, flooding will also be enabled towards both CPU ports.
    However, ->port_bridge_flags() gets passed the index of a single CPU
    port, and that leaves the flood settings out of sync between the 2
    CPU ports.

This is to say, it's better to have a specific driver method for host
flooding, which takes the user port as argument. This solves problem (1)
by allowing the driver to do different things for different user ports,
and problem (2) by abstracting the operation and letting the driver do
whatever, rather than explicitly making the DSA core point to the CPU
port it thinks needs to be touched.

This new method also creates a problem, which is that cross-chip setups
are not handled. However I don't have hardware right now where I can
test what is the proper thing to do, and there isn't hardware compatible
with multi-switch trees that supports host flooding. So it remains a
problem to be tackled in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 32 ++++++++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix.h |  2 ++
 include/net/dsa.h              |  2 ++
 net/dsa/dsa_priv.h             |  1 +
 net/dsa/port.c                 |  8 ++++++++
 net/dsa/slave.c                | 36 ++++++----------------------------
 6 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e9d8aa9cc294..4ab4f3d16c20 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -634,6 +634,37 @@ static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 	return felix->tag_proto;
 }
 
+static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
+				      bool uc, bool mc)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long mask, val;
+
+	if (uc)
+		felix->host_flood_uc_mask |= BIT(port);
+	else
+		felix->host_flood_uc_mask &= ~BIT(port);
+
+	if (mc)
+		felix->host_flood_mc_mask |= BIT(port);
+	else
+		felix->host_flood_mc_mask &= ~BIT(port);
+
+	if (felix->tag_proto == DSA_TAG_PROTO_OCELOT_8021Q)
+		mask = dsa_cpu_ports(ds);
+	else
+		mask = BIT(ocelot->num_phys_ports);
+
+	val = (felix->host_flood_uc_mask) ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_UC);
+
+	val = (felix->host_flood_mc_mask) ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV6);
+}
+
 static int felix_set_ageing_time(struct dsa_switch *ds,
 				 unsigned int ageing_time)
 {
@@ -1875,6 +1906,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_get_dscp_prio		= felix_port_get_dscp_prio,
 	.port_add_dscp_prio		= felix_port_add_dscp_prio,
 	.port_del_dscp_prio		= felix_port_del_dscp_prio,
+	.port_set_host_flood		= felix_port_set_host_flood,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 39faf1027965..2b3df06e2a14 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -71,6 +71,8 @@ struct felix {
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
 	struct kthread_worker		*xmit_worker;
+	unsigned long			host_flood_uc_mask;
+	unsigned long			host_flood_mc_mask;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 76257a9f0e1b..cfb287b0d311 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -978,6 +978,8 @@ struct dsa_switch_ops {
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
 				     struct switchdev_brport_flags flags,
 				     struct netlink_ext_ack *extack);
+	void	(*port_set_host_flood)(struct dsa_switch *ds, int port,
+				       bool uc, bool mc);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c9abd5a0ab9..d9722e49864b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -291,6 +291,7 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
+void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 075a8db536c6..e1bc41654e35 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -920,6 +920,14 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 	return 0;
 }
 
+void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->port_set_host_flood)
+		ds->ops->port_set_host_flood(ds, dp->index, uc, mc);
+}
+
 int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5ee0aced9410..801a5d445833 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -262,37 +262,13 @@ static int dsa_slave_close(struct net_device *dev)
 	return 0;
 }
 
-/* Keep flooding enabled towards this port's CPU port as long as it serves at
- * least one port in the tree that requires it.
- */
-static void dsa_port_manage_cpu_flood(struct dsa_port *dp)
+static void dsa_slave_manage_host_flood(struct net_device *dev)
 {
-	struct switchdev_brport_flags flags = {
-		.mask = BR_FLOOD | BR_MCAST_FLOOD,
-	};
-	struct dsa_switch_tree *dst = dp->ds->dst;
-	struct dsa_port *cpu_dp = dp->cpu_dp;
-	struct dsa_port *other_dp;
-	int err;
-
-	list_for_each_entry(other_dp, &dst->ports, list) {
-		if (!dsa_port_is_user(other_dp))
-			continue;
-
-		if (other_dp->cpu_dp != cpu_dp)
-			continue;
-
-		if (other_dp->slave->flags & IFF_ALLMULTI)
-			flags.val |= BR_MCAST_FLOOD;
-		if (other_dp->slave->flags & IFF_PROMISC)
-			flags.val |= BR_FLOOD | BR_MCAST_FLOOD;
-	}
-
-	err = dsa_port_pre_bridge_flags(dp, flags, NULL);
-	if (err)
-		return;
+	bool mc = dev->flags & (IFF_PROMISC | IFF_ALLMULTI);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	bool uc = dev->flags & IFF_PROMISC;
 
-	dsa_port_bridge_flags(cpu_dp, flags, NULL);
+	dsa_port_set_host_flood(dp, uc, mc);
 }
 
 static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
@@ -310,7 +286,7 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 
 	if (dsa_switch_supports_uc_filtering(ds) &&
 	    dsa_switch_supports_mc_filtering(ds))
-		dsa_port_manage_cpu_flood(dp);
+		dsa_slave_manage_host_flood(dev);
 }
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
-- 
2.25.1

