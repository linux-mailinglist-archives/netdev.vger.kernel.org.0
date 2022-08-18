Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8145984EC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245394AbiHRNzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245424AbiHRNya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:30 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CED92182
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:54:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am9cYFsw61Bn679Z/csW1r+w/onHKe7WCuvb6ZPrgJ1F/DidJvaUkqdEuhLQvgQ+JFqSZFpRqjO9Y+Ob3wVtCPerM/1wHEI0ODnuviNmOj4JNBVse8Ckdv0uAHvQjUhHBHQoBZoY7mSTzopH+8qfIiat/QQeXP4kxwh6vx2o0aTZqbdjtoAAoDhNW/zCszT7r2GsGD7qR0s8TcEoheAfw9bvECO5Tl3cnqKtTFA/mymDc98Xg1JLbgVVR/Pj6c9KeTieLMdqSkWvBqcZe1lKFMOT12nAgR3pJJaPmysUU/IXF+dpjTSPpGbx/LUPqbayNxceNb4gxZKlbt/xTs7XXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLJdku3fABdj1pvYCtT6z1dPgPP/wzpl9ZwgYi1IuPo=;
 b=Sv2UYlJk/hW6Wio1bBM+A1zkrvyzXHdVwV65k6v6lyERjp9tJFqSrRN05mOmqLG0cSXZI0IxbzRSWopo2F5gdUeJjVYK7z+4ytkKJQsYEEOmQOUAeYRZb2RC1S2od9bjSF3k0nt5TPhSnPS+aQFoDHQr+aAgCPvQVp1HkMLaHtSAfUR2u73yVznciIb9aDotkK22Nvtpgn61lgCj6PLoNk6Uegnzpee6TGGErAqnqc3vGFuFC4EI9ElTvDrcN6KUNkoirY4W5fp/OX20C3XA0iO5/7m4hEe5B/eZ1O86RVtsjh23wPubX3c4kpNWR7bX8l0SmAyHA3GAbYeWAb1haQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLJdku3fABdj1pvYCtT6z1dPgPP/wzpl9ZwgYi1IuPo=;
 b=VAsZ6qUa+7/+zwXXAyoSu9jHkUsS/sEfXNmmfFZFZupTnv7wwevoPUaWUQ8lSiUU0HBZAjPb0neyXUci/EeM+QyqypJnOBxuAbK4dKvJCqAv2qIJZaWfS7Zs80JCVBsauz4Qn0R5WV2Bwom+Y880CSFPz+pKar9VgvV7ln+uY7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity
Date:   Thu, 18 Aug 2022 16:52:55 +0300
Message-Id: <20220818135256.2763602-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bda0988d-0483-4b05-f3f0-08da812102f5
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i42SDeekvYf4Kp2z+61RATqX40w3lvrpUBjYG4kndfoyPiuUXs8/8VS9yCl/TSuObtqfeE/klhfVRJXDThQnBootMGgMYYw1B9yi17IkipfY41fR65kcssFJ5ZHVsB9nrJ8/TPy7EfETil95s5vwmisWgPjpbFsXGjaQ+bfS/df6+6YzMX7eIoVHA8SnvovGLGU4A0dnU8gO38ymL1sA+VKV8PRf1TJMqoffA269hn3aryLDwjlLeFWWKqWw21furA22F84gpgpvSVlrQOrPw21AibthcX31N5uJIEXXQ9qqZjceHK3ikByfh3SA0Ew5rZFZwAp9S9ULcsjgjMS2ByZagl3yn26cJbB8GRC0+DSsDV+5LKqHrbeSb5Jva2ZvjTze2CzBVJzJGlSoLww5DSEzm+03iytjBKp4FcY1eQnYOHfVRNsY9KsNIvwpYuLtZBeuvzOpq+1PNss5JBNsTeSU6yK6LpiluNBNdekleE0JVikYEgnj72LqmB7xra6z1IJFYx1A+0bRTK2S+1Whdx6VPn77/ogZqpqNCGpZYrQKorxZDAOXIxc8bmU5APN/u1/Ll90hz4hLgoZxW/+pkePSscld/pUI1FoPPBJSH6pyDgx3G/XZfNkZ/MMvnIUnzs2JRTcgsAQhlA2bd5zc1/UyVsiuQxP0EWdm1RcfRGRNOeOu2D2dBhpfxTExfcXKTZTCZNR7tAIvX241dNWvZd5e/UHpvu4U3r0iIBi5IqFboisTNP6naawgfcikMTPc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+JagR9nywon/a0qGrDYxKnNwUUnjzhtD7HjM/ZXojNr7PpLCuEwu3eICa6Tl?=
 =?us-ascii?Q?PChfvM19LXtcUjelUQBulYgATLjC13QUH1Jt8mgtH8RLd3nrCC0fef4dj18F?=
 =?us-ascii?Q?fS8Yt8gpP2MxlUbb3kWjX1yaoun9PNQLF5Q4sBMXJxcHIWvxOlUpEVhRh0IK?=
 =?us-ascii?Q?/TRQCTFi8ktpAapP2uja4dAb4Caa+H7KHVlzSaapjmZtpUfKb7OmLIETVhQC?=
 =?us-ascii?Q?ZoQNgKx7bXsyvVUeqwEeFOHHcsWrVIk+nIC6PlPdR5FJLCbYD143kz2ajLEP?=
 =?us-ascii?Q?uGfZHvwzBTQzxR5MT9xGWX7sdu1HbMYQVvGgI6UDMz8hK9kTd838Ari7lBqG?=
 =?us-ascii?Q?A4BXQk2jF8H0aJ/wGH8RKIGZSBALPmtR81k/RnuyGwwiLYK+GwyKgS85lvuy?=
 =?us-ascii?Q?geUdD0rdhOnjn8gS/+e1cooGUuC9jqAnhLzpTO9oxbYKqxV/JzdogGkDjI8X?=
 =?us-ascii?Q?VwpK1oYkcEyFkEAxT09VahJBrmRZTkTadkP4wVE7FcITUdpVulY0JLs9e2OS?=
 =?us-ascii?Q?sWo0QP5I6GL+TPC+KQHmn2ZwQAmHEaZxWGAASP2mY2d5xKlxu710hmw1kdQm?=
 =?us-ascii?Q?DdfNOFNuxQjLzPbaI5zejoASwGukppf9/iHsn0R31Eb+tpKfR9w4Vf7eMOnh?=
 =?us-ascii?Q?7sA5VMhqztIidhlq/7kW98G0kjUrOlsLvKDHsTXGI5hrOk4LrYP8AxvS0FfL?=
 =?us-ascii?Q?Ikd3K1PyxyN5CBOFjRYGgNiszttxZdiVQ1I7bb8CvL4I1yY1uTIj9LFtgL9K?=
 =?us-ascii?Q?7YT+4FnrzWC4aC5AexJhEhx/n8LDw3l7SiOMpUsnEIv68X2MTLak3gQecJn2?=
 =?us-ascii?Q?RQK904G/BAW0foJwmaMtm9RhACZzkmeNkjMq6bt9xAYfZajq20skB2O2hLFL?=
 =?us-ascii?Q?U7Lb+TQMt8QL0m8LgA7mmqvNnTWKlI5g9oJIw/CZlg0ArWzruVfA27DRqSSW?=
 =?us-ascii?Q?FCsAbXHZlU1/eStxe76EIndAfen29D5qnD93X+GrOP6iUmMgrmdzmw0yLLbu?=
 =?us-ascii?Q?ENfJR2kIym3YcmeNpk703gyD2kc2g9TW3WjCOG1q62IB3lDhWHVpKuEQarqZ?=
 =?us-ascii?Q?+TCpVcAudxj68JIXuzJchyXql6o8ciN3mPd/cdNhyHrRSkhvMRTR2HDG2ayY?=
 =?us-ascii?Q?xKjk0S1CH3Z1j5et5NXMenDGLJcpgwwD1P/t6HONUK//MV0jyB5/y3zFYzS2?=
 =?us-ascii?Q?LrNPFRG1a/gMBWC0TflFuBLK+WMu70VYcCanSQcFbXtoxWZ4McI0d4E/UnSk?=
 =?us-ascii?Q?QfBNwY9mZs5IH9PfLW3bGY3yANoz/VeBwvCeB81RimiDHXSKqgG8BmrBILU6?=
 =?us-ascii?Q?EMVyKx1kwmU7v/lK62BOlw77/ZF6A4WyrPtyA+JQmqExs8vqgAcRqrpOF0LU?=
 =?us-ascii?Q?ZN7d1kr7hebOPCooxy0sqQ2+eA+rP2l5gbvBmtSAXsqxnhphRsQDPeF3DTs1?=
 =?us-ascii?Q?w+460+AV56HGRfp/UeKC8VbiIFN8DZ87UoK2z6AUrvlrtjuyk+H1nJwLXYki?=
 =?us-ascii?Q?+3uvgVk9RTGWVzW4geUq/4juqeeTWhaOphB285YWbg7ak17UrIZ8Jq/m1xLj?=
 =?us-ascii?Q?NwmEl6oh5evh2SKjM+T7SOztohxeyb2tIYTyJDjCwhN+IB+W/7MH4lT/PSeo?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda0988d-0483-4b05-f3f0-08da812102f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:21.1329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJLx3+1Gll9vIpjauwPWM5laOz1HYy7pgr8OS4NfLgPp0dXPBHsTeIwbAFLUSvReVgXyAAh6q4KU6MT+FYMkxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial revert of commit c295f9831f1d ("net: mscc: ocelot:
switch from {,un}set to {,un}assign for tag_8021q CPU ports"), because
as it turns out, this isn't how tag_8021q CPU ports under a LAG are
supposed to work.

Under that scenario, all user ports are "assigned" to the single
tag_8021q CPU port represented by the logical port corresponding to the
bonding interface. So one CPU port in a LAG would have is_dsa_8021q_cpu
set to true (the one whose physical port ID is equal to the logical port
ID), and the other one to false.

In turn, this makes 2 undesirable things happen:

(1) PGID_CPU contains only the first physical CPU port, rather than both
(2) only the first CPU port will be added to the private VLANs used by
    ocelot for VLAN-unaware bridging

To make the driver behave in the same way for both bonded CPU ports, we
need to bring back the old concept of setting up a port as a tag_8021q
CPU port, and this is what deals with VLAN membership and PGID_CPU
updating. But we also need the CPU port "assignment" (the user to CPU
port affinity), and this is what updates the PGID_SRC forwarding rules.

All DSA CPU ports are statically configured for tag_8021q mode when the
tagging protocol is changed to ocelot-8021q. User ports are "assigned"
to one CPU port or the other dynamically (this will be handled by a
future change).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/ocelot/felix.c     |  6 +++
 drivers/net/ethernet/mscc/ocelot.c | 63 +++++++++++++++---------------
 include/soc/mscc/ocelot.h          |  2 +
 3 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index aadb0bd7c24f..ee19ed96f284 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -445,6 +445,9 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		ocelot_port_setup_dsa_8021q_cpu(ocelot, dp->index);
+
 	dsa_switch_for_each_user_port(dp, ds)
 		ocelot_port_assign_dsa_8021q_cpu(ocelot, dp->index,
 						 dp->cpu_dp->index);
@@ -493,6 +496,9 @@ static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 	dsa_switch_for_each_user_port(dp, ds)
 		ocelot_port_unassign_dsa_8021q_cpu(ocelot, dp->index);
 
+	dsa_switch_for_each_cpu_port(dp, ds)
+		ocelot_port_teardown_dsa_8021q_cpu(ocelot, dp->index);
+
 	dsa_tag_8021q_unregister(ds);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4649e4ee0e7..7d350c944521 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2196,61 +2196,60 @@ static void ocelot_update_pgid_cpu(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot, pgid_cpu, ANA_PGID_PGID, PGID_CPU);
 }
 
-void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port,
-				      int cpu)
+void ocelot_port_setup_dsa_8021q_cpu(struct ocelot *ocelot, int cpu)
 {
 	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 	u16 vid;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->dsa_8021q_cpu = cpu_port;
+	cpu_port->is_dsa_8021q_cpu = true;
 
-	if (!cpu_port->is_dsa_8021q_cpu) {
-		cpu_port->is_dsa_8021q_cpu = true;
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_add(ocelot, cpu, vid, true);
 
-		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-			ocelot_vlan_member_add(ocelot, cpu, vid, true);
-
-		ocelot_update_pgid_cpu(ocelot);
-	}
-
-	ocelot_apply_bridge_fwd_mask(ocelot, true);
+	ocelot_update_pgid_cpu(ocelot);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
 }
-EXPORT_SYMBOL_GPL(ocelot_port_assign_dsa_8021q_cpu);
+EXPORT_SYMBOL_GPL(ocelot_port_setup_dsa_8021q_cpu);
 
-void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+void ocelot_port_teardown_dsa_8021q_cpu(struct ocelot *ocelot, int cpu)
 {
-	struct ocelot_port *cpu_port = ocelot->ports[port]->dsa_8021q_cpu;
-	bool keep = false;
+	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 	u16 vid;
-	int p;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->dsa_8021q_cpu = NULL;
+	cpu_port->is_dsa_8021q_cpu = false;
 
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (!ocelot->ports[p])
-			continue;
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_del(ocelot, cpu_port->index, vid);
 
-		if (ocelot->ports[p]->dsa_8021q_cpu == cpu_port) {
-			keep = true;
-			break;
-		}
-	}
+	ocelot_update_pgid_cpu(ocelot);
 
-	if (!keep) {
-		cpu_port->is_dsa_8021q_cpu = false;
+	mutex_unlock(&ocelot->fwd_domain_lock);
+}
 
-		for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
-			ocelot_vlan_member_del(ocelot, cpu_port->index, vid);
+void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port,
+				      int cpu)
+{
+	struct ocelot_port *cpu_port = ocelot->ports[cpu];
 
-		ocelot_update_pgid_cpu(ocelot);
-	}
+	mutex_lock(&ocelot->fwd_domain_lock);
 
+	ocelot->ports[port]->dsa_8021q_cpu = cpu_port;
+	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_assign_dsa_8021q_cpu);
+
+void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	ocelot->ports[port]->dsa_8021q_cpu = NULL;
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ac151ecc7f19..4c8818576437 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -875,6 +875,8 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+void ocelot_port_setup_dsa_8021q_cpu(struct ocelot *ocelot, int cpu);
+void ocelot_port_teardown_dsa_8021q_cpu(struct ocelot *ocelot, int cpu);
 void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
-- 
2.34.1

