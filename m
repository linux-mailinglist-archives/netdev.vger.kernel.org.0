Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019C445E34E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346741AbhKYX27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:28:59 -0500
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:55694
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230448AbhKYX06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:26:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fds+bk+ief2a7ciiOF1dzIr0C6AskNuEdTEbQWHnSxRBl3Ohlvs6wgbLWaiyg6NDQ0e73g3R4xzBKdAmb9Fe0jbJOLFPJcnSSNmkVbgh5Y5LErTgqDhXEhqF8ElR3lCfhK8CJT/TCEhchVJUnFQnkUKFFM6wJK75rUf9ql7BHkVsryhW0NP2S52OcLHanHOwnJLpHaasmAFWOoQOxcubbvw15tyIBsACf4O+ivZuRPZOk/l2dYNelI4EwPtabGDlicokJVF4TLgQhGl+xx3+zwu9PnN72awixHRWAJLr2I+hLmo071n7US7+5BZHiVSxzMKNyEpoOiiUUrH19yIs9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwRYsMtkMgDyIUzyUUYs57zNVnlS0V0e5mkC8MsBQ5s=;
 b=RH4zKcrcKzPZBAJ7FRP0QrPJKjAcZ5NWe8jn4r6L3UiXl3UHrUeSSGe5kxfsOSvmkHsfwCb7YJhXoQHzpgnT5HBK/iVzBwb7tMkXqfLeXbbhfi8cxdcDTL/38wX9ShFZMbJOZxX4X0ckIAc4t9b3xxYBc+wOfryRlphhFxhqnSuZsTJj7D/KAGZp3bCqQoAkX5+dMw9Q9Av45ZoY263u37Vr7gtnBLZhGe/QSVcfpR1dXNwuUElSZtYTsdaVPDkDYgZzCrWKgk5iiSBa0gEUFqqY4Jw9kl3GGESSVJrgL5xX4J5o5te4Ch13IODeXHadgOEOub51paXrVojVAuhU6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwRYsMtkMgDyIUzyUUYs57zNVnlS0V0e5mkC8MsBQ5s=;
 b=loZ0MJWFO95mZ0T6y5pP6Y11seJCEJerF6ZH8G2kboqW4S+nU0OhnIDPy1l84vnIvohQxp/9EMyr0XeGOCNrC/GDwJi+7rZmDKH8zExHEDeU/5jYGojJYurimhWsbc6Q24TFiZrNIM+X5cLCcJROcXRDZj6hyeSfqDpe1ZsnBd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 23:21:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:21:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP packets
Date:   Fri, 26 Nov 2021 01:21:18 +0200
Message-Id: <20211125232118.2644060-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS8PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:20b:311::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:21:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4569418a-17b5-4b47-8c18-08d9b06a5acb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862884FD8341C5A9548FD27E0629@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhwuieVHVM2OG4AEkTxTe4dpkPTsKf5kprOo8IZgRY56iadCX0gySnzYLwLTslJWvJhsuFVh7J6oMdkckJ2x5lrCOSwnmxgg+75W6a4BaRPt/v3HxQxa6RCIjulBmgnV3Z+JWxxmQIrD2igy2vtDwIwZDi5hNNY5D3zZeag5BY6a4x+3oHlnV/veEAX1oyFT/gHHOe5Nu+koRvJjksMl7wB6hY0nSrJSLmz8xRBCj+fXMtvrzG5NC7Y1lqRvToFTg17tIMehpYGJw3FOOfga7oPW27M9OKxMrXkNoVEyyQ4gxwv0E4pI54S3WND5bS/VqOYY7qBtlwB4JM+Hc0dYIXo3r2xoijfSb/gbihVgiL9YObk8U5mHInaXNyoou3fKS8Yz89dSkS2dzVdPeXJrHMc1MTRhudcZUBhPc02vRKg3yVmboneeCwH6/zyNBV0nX4cTaLwETKln5nZ7Wx3UPNidYlRdg1yxlIlxwcR8ldm9Yt9qblZnjKK2/Q8CIqdCvyOKYJ1hlT7tOx8jKXo3WJ1vamyjeof5+FrLpQg2Y0d8E8nMe20xv/XNckSWt/rxaspbud24XDdyxalsUgfNURy9EKBkj7gMxEt454SXThY6IyEIdvVINNtU8qlq3x4SJ3hO8e45RaRpDw1x3cESiVYgJDjx1nnT1MwnWDkOJwofEMTkVY6guSD/i9V0+KebspfMmGvbfIfIbmbTEjCDINQcg5udR3IVdcqdzSd0lSF3uAfiYCgEm42x2TOmuIMw2MhgOVs1Ng+r8GVKP+P3vcYdc0RvGpve9b+qRDq6PXqw+kP5/ufl5PVMs4VMbuD7BEI5lIRe3gw47ZsCzlsTnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(1076003)(8676002)(30864003)(5660300002)(52116002)(2616005)(8936002)(6506007)(44832011)(83380400001)(6636002)(6666004)(186003)(956004)(966005)(6512007)(6486002)(508600001)(66476007)(66946007)(66556008)(6862004)(37006003)(38350700002)(316002)(86362001)(38100700002)(36756003)(54906003)(2906002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fPtG9W32zpwXcuL/4iue54fQcs4p6hgjwEsPdUAIDTDgWlcBmvWFzSKzGVAD?=
 =?us-ascii?Q?6vUbXp+szV7zYBJq8U+s3Nm/RLNjypNYH5B1yig6Q5oKjAb6v1PtqkLtNXHb?=
 =?us-ascii?Q?NMthVmeE1o0HrVD61xp56bBXimmpzbbrYg9unTG7wd8fhEtyk5G/3TsdtSiC?=
 =?us-ascii?Q?4/IVsKeKmvKQscjcWIqOqYEn7+J2GgmDqcA1lcPCCT7WDG6r4b+1WQsB20Cx?=
 =?us-ascii?Q?PrIaZrXDBN0YLgbD40hfmYqUMurxB0dpB01yMpRlJLuTw7O9YrfrrkYVTlPL?=
 =?us-ascii?Q?m2KZiZu7JuKHD/Da0x+Xm+t+ttCkKbkS1OFWZr6SZzBl+JrFGFX8PqcHmnAk?=
 =?us-ascii?Q?94la2cim1cc0ZNijIECB3ahlSRWLKR1AKqK7EsPsKPVdocKpHnCXeULvWbQl?=
 =?us-ascii?Q?4mn0aEqHMGYuPEs0W//PdVdnI/NeDWKKyfSkFbnJt7KYMjxm/fDHruqk+kt6?=
 =?us-ascii?Q?RNpk+sjM0p/K7Uc9TUD+BYALRoPfhG3fEaShgAxGhJ9Nw7w8EtCpzOq5SwBE?=
 =?us-ascii?Q?EXDWDM83Y/L2+UgBMLHP8tBCq3nKxgmsVuHiUPkG7RUQSoc/KRFIhvLcscdX?=
 =?us-ascii?Q?/tiqdZdcjg5vI3S2HpgJrUaAQWzKx9P7NlES3SJEB99Pr0W0dIAuP3pEbudA?=
 =?us-ascii?Q?D40AQlGL6r+SBp7p6e1GWSsYj/8obr57zN+K2qlLZC4s71eLqmhf+LzUxR1Y?=
 =?us-ascii?Q?rBtHyotaIQa13M8bZaezxUGX+b4OZeBJrR6sv6fQ9KqtY5S+cG6TVr1Anq6f?=
 =?us-ascii?Q?thBzEukleExdJqOqNUGQGrchVHkjikdD7iiRyzfsZX6BGm/bg6dC1sbnQ+iZ?=
 =?us-ascii?Q?q4J487QGwvhfgZMZWQ0IqVJcUCqtzf8JYXqCVWxHZ/PkLN3tgJt4TYAwax4b?=
 =?us-ascii?Q?UW+Co5pCcDz+3TNgXx+CRz3JInvWNnHSYZe3TdmXEm4/k3QMrp5Kh0YAGvL8?=
 =?us-ascii?Q?qUYmC/Ngmm35XzV/TgmNq0mofApC929WTsgDMhG4fdlQEimY/GZ6r5YEPPNG?=
 =?us-ascii?Q?B4yUW3lSDCx2LT2SR5R2OaqqetL49H2eNfDsUXi4zPGvqoXocTCwB0BvDX13?=
 =?us-ascii?Q?eJVReZzhOCCX901jlnOjBYzMnNiNikv2WNrmVA7SMH3Rk8gbLQTybj0flv2y?=
 =?us-ascii?Q?ze3I4A73pKE4ScXH7bK/IvwVBB24mnSL8q4FqVLQa9BjJISzy+inGUO7snTD?=
 =?us-ascii?Q?L25oB++R6hFU2AZO9FcmzTsor+9PHOeMf/iqu+YVB0Omjz+ywXwIXkQ72xLR?=
 =?us-ascii?Q?EdKqNx7bAZrig/7q8KlC5y51zjFKqrnoaMDPYqrY3wi1G0aQm7/Behu+vQL/?=
 =?us-ascii?Q?lG0LgKGCYRP5oRS3/0nd1B723aJbdG1hJNYVWBbyHbSnl5dmIWtBIpLGFuZg?=
 =?us-ascii?Q?00PU4OxJlfSGw29JYCxwRNtT2FPusa20nHgHD73LI5HFQa8pEWqVlvi6VoVh?=
 =?us-ascii?Q?nFGlBlqexqJytOdhVzBgh8Y1IcPDk8ROthBGMIyA3mB9Ali5x0f2SwMqTjU+?=
 =?us-ascii?Q?46gvPQ3e8zd1nc3wN3FlQRWeMu0Kj9PgLgeIVgbsap+hW/dxfhZeMd1bbcg1?=
 =?us-ascii?Q?/zdwkmvKHrP7FyiPyOeUBuUut+/L984xlWP967V5WoDBxrxzksyxdtkTxQbQ?=
 =?us-ascii?Q?TrNL3pTwGahP8ByLIWQzakw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4569418a-17b5-4b47-8c18-08d9b06a5acb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:21:48.7705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kek5DkykTY5bpDheJ4CrBu1knaDpKiM08UUKYr8n7FkB2HFd+aQCxXjqVvLChkTqx4TpSsJuBRHVYQ0h5NiJVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 1588 support was declared too soon for the Ocelot switch. Out of
reset, this switch does not apply any special treatment for PTP packets,
i.e. when an event message is received, the natural tendency is to
forward it by MAC DA/VLAN ID. This poses a problem when the ingress port
is under a bridge, since user space application stacks (written
primarily for endpoint ports, not switches) like ptp4l expect that PTP
messages are always received on AF_PACKET / AF_INET sockets (depending
on the PTP transport being used), and never being autonomously
forwarded. Any forwarding, if necessary (for example in Transparent
Clock mode) is handled in software by ptp4l. Having the hardware forward
these packets too will cause duplicates which will confuse endpoints
connected to these switches.

So PTP over L2 barely works, in the sense that PTP packets reach the CPU
port, but they reach it via flooding, and therefore reach lots of other
unwanted destinations too. But PTP over IPv4/IPv6 does not work at all.
This is because the Ocelot switch have a separate destination port mask
for unknown IP multicast (which PTP over IP is) flooding compared to
unknown non-IP multicast (which PTP over L2 is) flooding. Specifically,
the driver allows the CPU port to be in the PGID_MC port group, but not
in PGID_MCIPV4 and PGID_MCIPV6. There are several presentations from
Allan Nielsen which explain that the embedded MIPS CPU on Ocelot
switches is not very powerful at all, so every penny they could save by
not allowing flooding to the CPU port module matters. Unknown IP
multicast did not make it.

The de facto consensus is that when a switch is PTP-aware and an
application stack for PTP is running, switches should have some sort of
trapping mechanism for PTP packets, to extract them from the hardware
data path. This avoids both problems:
(a) PTP packets are no longer flooded to unwanted destinations
(b) PTP over IP packets are no longer denied from reaching the CPU since
    they arrive there via a trap and not via flooding

It is not the first time when this change is attempted. Last time, the
feedback from Allan Nielsen and Andrew Lunn was that the traps should
not be installed by default, and that PTP-unaware switching may be
desired for some use cases:
https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/

To address that feedback, the present patch adds the necessary packet
traps according to the RX filter configuration transmitted by user space
through the SIOCSHWTSTAMP ioctl. Trapping is done via VCAP IS2, where we
keep 5 filters, which are amended each time RX timestamping is enabled
or disabled on a port:
- 1 for PTP over L2
- 2 for PTP over IPv4 (UDP ports 319 and 320)
- 2 for PTP over IPv6 (UDP ports 319 and 320)

The cookie by which these filters (invisible to tc) are identified is
strategically chosen such that it does not collide with the filters used
for the ocelot-8021q tagging protocol by the Felix driver, or with the
MRP traps set up by the Ocelot library.

Other alternatives were considered, like patching user space to do
something, but there are so many ways in which PTP packets could be made
to reach the CPU, generically speaking, that "do what?" is a very valid
question. The ptp4l program from the linuxptp stack already attempts to
do something: it calls setsockopt(IP_ADD_MEMBERSHIP) (and
PACKET_ADD_MEMBERSHIP, respectively) which translates in both cases into
a dev_mc_add() on the interface, in the kernel:
https://github.com/richardcochran/linuxptp/blob/v3.1.1/udp.c#L73
https://github.com/richardcochran/linuxptp/blob/v3.1.1/raw.c

Reality shows that this is not sufficient in case the interface belongs
to a switchdev driver, as dev_mc_add() does not show the intention to
trap a packet to the CPU, but rather the intention to not drop it (it is
strictly for RX filtering, same as promiscuous does not mean to send all
traffic to the CPU, but to not drop traffic with unknown MAC DA). This
topic is a can of worms in itself, and it would be great if user space
could just stay out of it.

On the other hand, setting up PTP traps privately within the driver is
not new by any stretch of the imagination:
https://elixir.bootlin.com/linux/v5.16-rc2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c#L833
https://elixir.bootlin.com/linux/v5.16-rc2/source/drivers/net/dsa/hirschmann/hellcreek.c#L1050
https://elixir.bootlin.com/linux/v5.16-rc2/source/include/linux/dsa/sja1105.h#L21

So this is the approach taken here as well. The difference here being
that we prepare and destroy the traps per port, dynamically at runtime,
as opposed to driver init time, because apparently, PTP-unaware
forwarding is a use case.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Reported-by: Po Liu <po.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 241 ++++++++++++++++++++++++++++-
 1 file changed, 240 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f5490533c884..456aeba2b245 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1347,6 +1347,225 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
+static void ocelot_populate_l2_ptp_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_ETYPE;
+	*(__be16 *)trap->key.etype.etype.value = htons(ETH_P_1588);
+	*(__be16 *)trap->key.etype.etype.mask = htons(0xffff);
+}
+
+static void
+ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.dport.value = PTP_EV_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv6.dport.value = PTP_EV_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.dport.value = PTP_GEN_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv6.dport.value = PTP_GEN_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static int ocelot_trap_add(struct ocelot *ocelot, int port,
+			   unsigned long cookie,
+			   void (*populate)(struct ocelot_vcap_filter *f))
+{
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot_vcap_filter *trap;
+	bool new = false;
+	int err;
+
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	trap = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, cookie,
+						   false);
+	if (!trap) {
+		trap = kzalloc(sizeof(*trap), GFP_KERNEL);
+		if (!trap)
+			return -ENOMEM;
+
+		populate(trap);
+		trap->prio = 1;
+		trap->id.cookie = cookie;
+		trap->id.tc_offload = false;
+		trap->block_id = VCAP_IS2;
+		trap->type = OCELOT_VCAP_FILTER_OFFLOAD;
+		trap->lookup = 0;
+		trap->action.cpu_copy_ena = true;
+		trap->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+		trap->action.port_mask = 0;
+		new = true;
+	}
+
+	trap->ingress_port_mask |= BIT(port);
+
+	if (new)
+		err = ocelot_vcap_filter_add(ocelot, trap, NULL);
+	else
+		err = ocelot_vcap_filter_replace(ocelot, trap);
+	if (err) {
+		trap->ingress_port_mask &= ~BIT(port);
+		if (!trap->ingress_port_mask)
+			kfree(trap);
+		return err;
+	}
+
+	return 0;
+}
+
+static int ocelot_trap_del(struct ocelot *ocelot, int port,
+			   unsigned long cookie)
+{
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot_vcap_filter *trap;
+
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	trap = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, cookie,
+						   false);
+	if (!trap)
+		return 0;
+
+	trap->ingress_port_mask &= ~BIT(port);
+	if (!trap->ingress_port_mask)
+		return ocelot_vcap_filter_del(ocelot, trap);
+
+	return ocelot_vcap_filter_replace(ocelot, trap);
+}
+
+static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+
+	return ocelot_trap_add(ocelot, port, l2_cookie,
+			       ocelot_populate_l2_ptp_trap_key);
+}
+
+static int ocelot_l2_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+
+	return ocelot_trap_del(ocelot, port, l2_cookie);
+}
+
+static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
+	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie,
+			      ocelot_populate_ipv4_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie,
+			      ocelot_populate_ipv4_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
+	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv4_gen_cookie);
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
+	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie,
+			      ocelot_populate_ipv6_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie,
+			      ocelot_populate_ipv6_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
+	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv6_gen_cookie);
+	return err;
+}
+
+static int ocelot_setup_ptp_traps(struct ocelot *ocelot, int port,
+				  bool l2, bool l4)
+{
+	int err;
+
+	if (l2)
+		err = ocelot_l2_ptp_trap_add(ocelot, port);
+	else
+		err = ocelot_l2_ptp_trap_del(ocelot, port);
+	if (err)
+		return err;
+
+	if (l4) {
+		err = ocelot_ipv4_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv4;
+
+		err = ocelot_ipv6_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv6;
+	} else {
+		err = ocelot_ipv4_ptp_trap_del(ocelot, port);
+
+		err |= ocelot_ipv6_ptp_trap_del(ocelot, port);
+	}
+	if (err)
+		return err;
+
+	return 0;
+
+err_ipv6:
+	ocelot_ipv4_ptp_trap_del(ocelot, port);
+err_ipv4:
+	if (l2)
+		ocelot_l2_ptp_trap_del(ocelot, port);
+	return err;
+}
+
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
@@ -1357,7 +1576,9 @@ EXPORT_SYMBOL(ocelot_hwstamp_get);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool l2 = false, l4 = false;
 	struct hwtstamp_config cfg;
+	int err;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
@@ -1392,19 +1613,37 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		l4 = true;
+		break;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		l2 = true;
+		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		l2 = true;
+		l4 = true;
 		break;
 	default:
 		mutex_unlock(&ocelot->ptp_lock);
 		return -ERANGE;
 	}
 
+	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
+	if (err)
+		return err;
+
+	if (l2 && l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+	else if (l2)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else if (l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+	else
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+
 	/* Commit back the result & save it */
 	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
 	mutex_unlock(&ocelot->ptp_lock);
-- 
2.25.1

