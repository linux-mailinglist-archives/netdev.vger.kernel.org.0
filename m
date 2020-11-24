Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591EF2C1AC5
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgKXBU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:20:29 -0500
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:2850
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727107AbgKXBU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 20:20:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3EeuWQ2ojJhVbED90Ho+pep/I3r+m+sRkTdctQ5pbTzK7532+/3bB1g/JyLM1PN572KSr55ZMhzoJwUyL6jcq6eOX7CVWg7jGXSmyAGT8Vt/mGfAhLhfO5ybMstGMd9cCpKcZUcVg5yAYGBC1xDDW4jhBfAUB9qEt8zNVUvGlodIEiyQ715anS0/gwYMIy8ZesMKH/ysa23UcoxXkASVc8WB6F+LeIGuCNDUQ8TXPr3e3JRZGHU+ARzl5U9ql8OdugbVPtaIam1koSB8BFrMsTZTHtaBYpI4dRXkEfpUO/6J2Ka5k+m9jbiZKQHXpKANc9uLwKWQdhS9lKZdAKQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su3UV7uMa76omTV244N3XUPMumcg00h/9aeDjmIFOWM=;
 b=aUuWNjlY+qHYHoU/QF+dpKC7DqxwMrVR0UDrlPBKIyQf4/q3xMbOOF3sVeMoyXk1OsJc0li68KDtEBUUUejOoWHJ6jhRT4xss/bLD1fh9hsv7HcnRFjSq2dnOzkJiWmFpK5eufm9vqovNFNhdY2F8XWXMheFq5zE6TqhSdo8TJzxuKO7gIZKYZbnSbtbjL/ITJgyK6DEnp+cCjTp2hOgTK4oNPgUdn5hFAL/DuIVztfXZLWFudnGvP/8z7QGQEqUeBhrreVWbhZ24gQjpF3J9SBxGd991A6gEmo/9p2X23iIh22ulhyrJ6KTPjfSROYXYkO3toOrJhniy8AeRbdDkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Su3UV7uMa76omTV244N3XUPMumcg00h/9aeDjmIFOWM=;
 b=oT/E3p4lSi25z/FNqLsTpwpd6uFHha0EgoLPt/itg6i3eCaTA/WUM/9AsjUapVgEJJGMfgo0QPVZP5bq/oM1bE4Fy6M1b5PxFbXWtRUDke9gz4pEtzq8QRbzyWu/9OMQ+gGGvIihvbSb01OrPlkHWftRZrawtOK072hOveRkmbw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 01:20:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 01:20:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH net] enetc: Advance the taprio base time in the future
Date:   Tue, 24 Nov 2020 03:20:05 +0200
Message-Id: <20201124012005.2442293-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: PR0P264CA0164.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::32) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by PR0P264CA0164.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 01:20:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2841a6dd-a7f4-47ca-0b01-08d890171d73
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66395798F1B87E657D4E659CE0FB0@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43CsFiVFP7+CP8381b15k091e38t7WSwwuWzQ3SqvFkoD4LAeWSaarHqYH1Qs5oCq8SL9XgWqtLhdspSYhz2pU8oP3qNJYyjZDI33//+xuxkjxZ16BsajPGz5zFXuxW748A8qou6p0BGurmj88FVdzGdnB8ZjlaymXkjfcY2lZpZu7MFHhDEfut2AuZ4FpNeN8Bifi0UhyUkD0qYNSVXKPBcfKnXnzzyrauuD+B1BjsBRjOhMe9pKbzPtmCGeOZ4XzvdmMUo+lumbF035PCHnwG4D7Qqa+B06c8OIo0qKokCrEnqGftm2uBBjVe+ipFtAlSicf2CgOrqnM2OnJswpWScDaP93z2VKIISJ8IxVUKn2s0dOufMAlHBIXLSUxnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(6666004)(8936002)(1076003)(316002)(6486002)(6512007)(110136005)(4326008)(2616005)(83380400001)(2906002)(44832011)(956004)(36756003)(69590400008)(6506007)(66946007)(186003)(5660300002)(16526019)(86362001)(6636002)(52116002)(8676002)(26005)(66556008)(66476007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /mN9AwlPpudo6ssQ1afVD0ToAV2EmVp3U4NCMtfSPEKPdOWmhutZCChn5KefpeYupbryY56slx6YJxo1zKwfzbMlEthLFlS8WWcIHmb0odLqebUXp+M5NpTgLnEcOgYkyzvzHziVijFlXTvEVhdyl9kEfjh8YdyeZcSdLWZeTpgl9OQD2yYS8V6noIxqxA1OkmAfFn/hvpMIzDYOHCNyqB/deR93dhl/ccCdv8pIsQylKPxpfTeJAAwk1cyI5/jzv2GRPGv0pW2QucCy4C1vIzdEGHP3OsdscLRTh390+cmWe1TULtMfSSzQPn2o7s4fjUgJ2baV5wrJ4O3XvtVcvCWdNlSJOP6iJ8Qfs2ES1ndcapfvwarbXl4xCmPUgosEAolQY5Uvt1l5cyNHNex0BOIZgvILPEVSZPy+TnUYsSUVNFDjhkk+rlKgz7pq4jzte1jNMNlf8gcUB8LsNetDIbkh24gURrQyu30QsIK1VBTHGqiNrMb551U9vylw6kXeHtI/I3Q+fR2DaUiybdB4rqL2MfUOs38vrjKsEoWISWRCtUf+miJDKvVPHX9hX0YZTGLVEMU8TRP7opFj0j8xUFxUkfJnP0mVcgxd3gGO3E0Ah3Rr+G6/RLgvMRvZYSiPqimuDmvXQDjgYQOt83rksbbEf6INSWEhyQMojtupcx0gDxpoSMqCrOF7r7n6r/QvPu2CVohsmLd9dGih/a2zrv0LboyGHqpAwHKiYFg74nL7wqMTTXK/p8z4UmpzyAIoPKuTUMmQRfAcnrJAELnxvPH6sK72uPxIVIjQ9vyFFwQUxvsAUEPVCRoKE7a1VbSws+bNedkXZPabk08idlrOL+WDG/6JHBLLFFTVGiEGkRtFJhRVFg6ro2TXHx6lBdO4Ybo7rgkO7Sg56DKdRlK/lA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2841a6dd-a7f4-47ca-0b01-08d890171d73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 01:20:22.8219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xl/Sn2LV1g/Et2suzypyJ3osINdh0JcCwFnLOeb52tlf09dU8/X4uGGFhef7j23ZDgx8TkN7CB1Db7Kevv16yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc-taprio base time indicates the beginning of the tc-taprio
schedule, which is cyclic by definition (where the length of the cycle
in nanoseconds is called the cycle time). The base time is a 64-bit PTP
time in the TAI domain.

Logically, the base-time should be a future time. But that imposes some
restrictions to user space, which has to retrieve the current PTP time
first from the NIC first, then calculate a base time that will still be
larger than the base time by the time the kernel driver programs this
value into the hardware. Actually ensuring that the programmed base time
is in the future is still a problem even if the kernel alone deals with
this - what the proposed patch does is to "reserve" 100 ms for potential
delays, but otherwise this is an unsolved problem in the general case.

Nonetheless, what is important for tc-taprio in a LAN is not precisely
the base-time value, but rather the fact that the taprio schedules are
synchronized across all nodes in the network, or at least have a given
phase offset.

Therefore, the expectation for user space is that specifying a base-time
of 0 would mean that the tc-taprio schedule should start "right away",
with one twist: the effective base-time written into the NIC is still
congruent with the originally specified base-time. Otherwise stated,
if the current PTP time of the NIC is 2.123456789, the base-time of the
schedule is 0.000000000 and the cycle-time is 0.500000000, then the
effective base-time should be 2.500000000, since that is the first
beginning of a new cycle starting at base-time 0.000000000, with a cycle
time of 500 ms, that is larger than the current PTP time.

So in short, the kernel driver, or the hardware, should allow user space
to skip the calculation of the future base time, and transparently allow
a PTP time in the past. The formula for advancing the base time should be:

effective-base-time = base-time + N x cycle-time

where N is the smallest integer number of cycles such that
effective-base-time >= now.

Actually, the base-time of 0.000000000 is not special in any way.
Reiterating the example above, just with a base-time of 0.000500000. The
effective base time in this case should be 2.500500000, according to the
formula. There are use cases for applying phase shifts like this.

The enetc driver is not doing that. It special-cases the case where the
specified base time is zero, and it replaces that with a plain "current
PTP time".

Such an implementation is unusable for applications that expect the
phase to be preserved. We already have drivers in the kernel that comply
to the behavior described above (maybe more than just the ones listed
below):
- the software implementation of taprio does it in taprio_get_start_time:

	/* Schedule the start time for the beginning of the next
	 * cycle.
	 */
	n = div64_s64(ktime_sub_ns(now, base), cycle);
	*start = ktime_add_ns(base, (n + 1) * cycle);

- the sja1105 offload does it via future_base_time()
- the ocelot/felix offload does it via vsc9959_new_base_time()

As for the obvious question: doesn't the hardware just "do the right
thing" if passed a time in the past? I've tested and it doesn't look
like it. I cannot determine what base-time it uses in that case, however
traffic does not have the correct phase alignment.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index aeb21dc48099..379deef5d9e0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -45,6 +45,20 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 		      | pspeed);
 }
 
+static inline s64 future_base_time(s64 base_time, s64 cycle_time, s64 now)
+{
+	s64 a, b, n;
+
+	if (base_time >= now)
+		return base_time;
+
+	a = now - base_time;
+	b = cycle_time;
+	n = div_s64(a + b - 1, b);
+
+	return base_time + n * cycle_time;
+}
+
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
@@ -55,7 +69,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	struct gce *gce;
 	dma_addr_t dma;
 	u16 data_size;
+	s64 base_time;
 	u16 gcl_len;
+	u64 now;
 	u32 tge;
 	int err;
 	int i;
@@ -92,18 +108,14 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config->atc = 0xff;
 	gcl_config->acl_len = cpu_to_le16(gcl_len);
 
-	if (!admin_conf->base_time) {
-		gcl_data->btl =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
-		gcl_data->bth =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
-	} else {
-		gcl_data->btl =
-			cpu_to_le32(lower_32_bits(admin_conf->base_time));
-		gcl_data->bth =
-			cpu_to_le32(upper_32_bits(admin_conf->base_time));
-	}
+	now = (u64)enetc_rd(&priv->si->hw, ENETC_SICTR1) << 32;
+	now |= enetc_rd(&priv->si->hw, ENETC_SICTR0);
 
+	base_time = future_base_time(admin_conf->base_time,
+				     admin_conf->cycle_time,
+				     now + NSEC_PER_SEC / 10);
+	gcl_data->btl = cpu_to_le32(lower_32_bits(base_time));
+	gcl_data->bth = cpu_to_le32(upper_32_bits(base_time));
 	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
 	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
 
-- 
2.25.1

