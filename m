Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02AB689281
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBCIk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCIkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:40:55 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2081.outbound.protection.outlook.com [40.92.107.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35447199CE;
        Fri,  3 Feb 2023 00:40:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLQFElEKDnrKWIH3RdmggC1tjjJ/vUKSAOMdTyL/3nLb4gsT2ZehyFt0BS/v9OcjaCSEE9T3sXXmlJt+TExyoSkEP22vx7jwHlY3do22qYlpkNmwBxyMKowDuB9fFf89UrU2LdAMi3homc2TyaLCx9tubxNKf3wLeEpLgqKOWDka8Te+HhDBwTWActxRYZ4na85r18SITyW2+O6QOinT6QnFh2QbdxbwsXPG8seFdOnZyO55izZ9MkcQSLhX7MAZQpsf+qHv0Bbn3uc9Im29THm0pV0wYl8cWU1/hPjjHOaX/c6enelKZgTe/LuQ18FxPOcyJR/pVq1PPeYOS0j5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpU5aCfNgj32VEtawWbYg1iFEASOD8DEMQafUUDVquM=;
 b=HdZlxDht7jySMCqUTar30zbKr1eHR2VDUk3jtsf6VPaT1KWO5K7HeFA49BfQuJD3FF0PvzL4tClBdaZxee/wXV/5YZ01c+SjHRta3W1l4aqogjI/lgVaB0rIJyJdheKKFFW6tZyblsP83HfF2PRLN0h4u2dY7kxUe0f/CkAmvp8tIVWb7jkGe2Dr7CPH35c0VQXK/2zkDCLkc8qTnyp6sA+1sWisA72z6JHUQ0pVGd+CDNsxjNSspeNM4BDxLD0JeUD7TnFoh7XBkekU6Zi6yLW34Sal2OTwWS2xMkjVgX2GlNUjMbJywYw/ERoWehBZRFSJWPxEnR/Zzl8rvsKgZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpU5aCfNgj32VEtawWbYg1iFEASOD8DEMQafUUDVquM=;
 b=cKSa7QcZot+0ii/JD0HimB30FGC4lS57Y23OD4l+qnSlK6t7UKT9r4J1rh9aLexXtn+fPLfqAjm3J+XTJ8yYGwoMTvVsNqspyM7IirsVemscAilJdMVhf41FVYDpaX4E0ryO/wFvc82oKvQhdbEwx7WdWxTuxFD2as4tYRgUWn91fVY0k8xJrWYCOMgD6FPNPQz8xKlgWLm73tXz2VZOqCAR/cn8I+QoGuqHVqjMLMXyB5mq3qwaP31HQ2f2SVWbCCIwPdVnYzM8PxZRas+zxcg3F+FRnFnOo2SqzIE93NQg1uL2HVL/txhzppH0xHS6MZrHhKYUpz6qTnia7U5nTA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYYP286MB1498.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:11a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 08:40:51 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Fri, 3 Feb 2023
 08:40:51 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Fri,  3 Feb 2023 16:40:36 +0800
Message-ID: <OS3P286MB2295CD8900C8D4E701E08B4DF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [ObbqgVHpJCWMdlKFFoYXc6g37mwJ/F22]
X-ClientProxiedBy: SG2PR02CA0131.apcprd02.prod.outlook.com
 (2603:1096:4:188::6) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230203084037.249951-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYYP286MB1498:EE_
X-MS-Office365-Filtering-Correlation-Id: df71ff7d-f43e-4aac-973e-08db05c25b05
X-MS-Exchange-SLBlob-MailProps: C/ir7cSdGltvcxnaKBuC9k0g2cmcq9lai0TME1Ask6kECF3PXfIY3nNymXGbg5Qn7YzLm24HbWQb1YoQGvz4sDUvryraiV32RbI6kI49AwprKneKt49qZif8skO551EEL0p0OqPbCGxESh0ixvH4ftdmE/8lFUias+4RUvFM6CU22iaPAwd4epX9ixHPnyBzixdNv8R5lNcf36VNr7zk8Zp6FFi7ivpAnAS3P4NmoPgE7Xwlmooc/gBqCHNZejCeh2pR+OvDbLOMvtGzB0q/CXnvIWK3qqDQQkWRCG/mciuEv6dkVJg+1HpFWX0Vow51LSnG0zanp6FYliqpL8co3F5nv67ql6rCmO7BHRmKPEbM5LiYaj499g4bYJLf/bYDPI9fYurCG0GJDM45priy6lUcm9h6GZo03qu5dvDnsdxrE394KxMjkQRJkh1MeO9G15kzkk4xTwQ+5kRdeZdIB/35slljfRyP6odCAovheqC62u8ekfIYh3mWLkKAz9zpNDj7/ssZXXrXGkmOWTzEEMzO70QkyMgt/I9XHPXZYGNQDIXknOEJyBjrG8YD6xl9PbNWi6a0myQbJ1DhyBJlexnUTgJ1G/yFCGc38PsF+fddUyHctRB6NO5gBWAc69/CZUTYUnss+q8Zl5lrp4mDouZHNFOoa3NaBgkOncqlydvb/Iyn/OtFokQcoeXElePjeCK7Lw5FImLf5gnrPSO2JgCWIDRaAiyZbTC+/demLcoEtePNtTxZGabv5Hek7/mn
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8mfZJ96+OELVamSzChw5equzwDj/g0WBCtmGlB9KItLcYMOEXWKV7BDsXFIl7sp0spOLjiUoyLNpgDiSd628lVYBwSLUywdpr83TQnkIDmkCkDgqBblVU8Vyi8pAFAFTPWOVIXSuT8ZLVPG0j2zYWHmkKZrt8fB6wBpT3lONlB5WaFyxAoKNhVmmcrTqrK+0QlwcUMtJpOpjuQB04JzUlJkeUUbsqoszS5hHXY0gCR5/mwJEgiG1OnvuYDUAY2zvaxaiSshBPpZIGkmrSbTfjx/kQ+MN5vZbFMg72N/oLYwNwm0ytjz3/P1BkRAdiFbsrRTZ+a/WGik5PVI+8VhZ10/M7aoGzLERsZPOKtzpk+L7Ji9OP3PPKpxFT8UbBlWP1N714DUce1GcxqA81FhCGYwdftjB8RWeGMcAnC9gsRmuCm2pFqGPXbY01tjhPZFgDTf3QH8J0N9TSbONyzYZi463qt7msvQR4ofXFIyy6rtEV3yhdCY8KkuccPM9w8lJQsWBwsWBrIG3PH434cQsRMbQ4P68wyAbD5mEWRqiCdeICv5zS7SEZSd3gBTeywFr4gFx9rcOvROe3wzndLsCU3+txxQDVYksNMhF5bmpAj4YvR7Vr7uhp9x5G4bZSnTBOgn5YRTvu68kw/Tjp6ung==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GB5jdw37yrN4XAlyeSP0z1itxvAgHnVnIERykw++Ny1NoIxPUZBD4Npw27dR?=
 =?us-ascii?Q?CTkJDDvbszoLCFwk1t5eZXmm40eY8jj52oSSBIALNoNGcd+qkwfqkkQyJxdo?=
 =?us-ascii?Q?Edzw5GCklvq8fU17ue2Ggh8jWgLjyBxOi8dW4cG9pS3h1Cse25cWVOwpVXDD?=
 =?us-ascii?Q?dtlkA2VrRW7A0+UOrH9DD24zhadi+o8jQqGBPMGmQDObOEvapmWgNFvFoKSC?=
 =?us-ascii?Q?lmcHUFWoVjId/Sve4ZR2EXnO8LndM+jzCziwwB/7YqB0iMVfp191VvHl3+4F?=
 =?us-ascii?Q?iGXwVqhAv4v2tZNZOIUHvuic0Ma1Op4e7TyDtQ7AEIkaS/vtvND9GS2W3CSe?=
 =?us-ascii?Q?i3lNZVvFt/e5bcOrVvf8Z34bTewvi2RDqr7uQHwww9qwrxms87xRnyHVppS4?=
 =?us-ascii?Q?6kLV2dnkSSmGSx/ROJ49dVD9Bql6Q4zJAnz1M8kFurF1lMhzW5l4PzQv2SBL?=
 =?us-ascii?Q?1+qL8hm4sX6X/HrGkMWj23KCuaXsHFGRho8n9ss+U9H7OgEAK2YnEAn3c+8z?=
 =?us-ascii?Q?irH+3lIlmDUrge7lvG5ggVWVMAf8iL0LNufuZixB7PVez7W+xrcz/J6033VD?=
 =?us-ascii?Q?ktMQnvoWExEyxP7Dl0vvDCF5Z3GEx4gXP8FWVKvLQYCFK3PkMpM8SKMpcI+/?=
 =?us-ascii?Q?JpsjwJzhXEEPUIfIaElrcdhcGruZq1trST8QvXyoseEW34ILP+TwKY5kEwLP?=
 =?us-ascii?Q?BQc+8wVCnajyyw2ivzuLlN9F384QZNXEznJh7gynkOlIA823r45JzIPuAEVQ?=
 =?us-ascii?Q?RW29Cxa2Q9IljPuIvA69Rm+HPx2v7e6MEmM2obQsqhKoP5DTgZ0TXM9nAzn+?=
 =?us-ascii?Q?0d2kEZIfgrPpm0Odd5Xtf32feX80Cht7Zez6e6cjD3FSNgCCoW55UMsYbJeY?=
 =?us-ascii?Q?vWHx5xxaKF+KILtchVtP4cibTMkL3tOZ7ARiUP6c6GZX0sHoAcZ7rjZIhoPI?=
 =?us-ascii?Q?zLaUXjMKJfaH+q2wmN5JXYbzsOs9CzF16f1c6Fuup8yT2mxwQRGZw68d2x8K?=
 =?us-ascii?Q?xizrcpktwKc0xT40RhE0/Spt/ebCAtCYAI2bmKbmxOYsm6OCa0SFJz4fdYNF?=
 =?us-ascii?Q?CgGIUt6wkhU/FFIJ4QCdeMXyrgmLKqWwgIWV8dRRfsV5icSarxST7Sg5hEIk?=
 =?us-ascii?Q?lMTvr3lg5brvS8RmCOtxAaVzQxNuYsHWLRc806x6xwufBY8i3RsAyYX/HuFk?=
 =?us-ascii?Q?+ic206wZKAq+v1YCAFI4WKrSm//CinednQgnnljPjkJJ1E0R4VE29xIltGwS?=
 =?us-ascii?Q?0UUvr8hu7zlPO55hk9LGIQ20Y7bV/lieCCHw2ChiMA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: df71ff7d-f43e-4aac-973e-08db05c25b05
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:40:51.5396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP286MB1498
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use actual CPU number instead of hardcoded value to decide the size
of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.

'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
8192 by default, it costs memory and slows down ovs_flow_alloc

To address this, redefine cpu_used_mask to pointer
append cpumask_size() bytes after 'stat' to hold cpumask

cpumask APIs like cpumask_next and cpumask_set_cpu never access
bits beyond cpu count, cpumask_size() bytes of memory is enough

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c       | 8 +++++---
 net/openvswitch/flow.h       | 2 +-
 net/openvswitch/flow_table.c | 8 +++++---
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..0109a5f86f6a 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, __be16 tcp_flags,
 
 					rcu_assign_pointer(flow->stats[cpu],
 							   new_stats);
-					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
+					cpumask_set_cpu(cpu, flow->cpu_used_mask);
 					goto unlock;
 				}
 			}
@@ -135,7 +135,8 @@ void ovs_flow_stats_get(const struct sw_flow *flow,
 	memset(ovs_stats, 0, sizeof(*ovs_stats));
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = rcu_dereference_ovsl(flow->stats[cpu]);
 
 		if (stats) {
@@ -159,7 +160,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
 	int cpu;
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = ovsl_dereference(flow->stats[cpu]);
 
 		if (stats) {
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 073ab73ffeaa..b5711aff6e76 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -229,7 +229,7 @@ struct sw_flow {
 					 */
 	struct sw_flow_key key;
 	struct sw_flow_id id;
-	struct cpumask cpu_used_mask;
+	struct cpumask *cpu_used_mask;
 	struct sw_flow_mask *mask;
 	struct sw_flow_actions __rcu *sf_acts;
 	struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  First one
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0a0e4c283f02..dc6a174c3194 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
 	if (!stats)
 		goto err;
 
+	flow->cpu_used_mask = (struct cpumask *)&flow->stats[nr_cpu_ids];
 	spin_lock_init(&stats->lock);
 
 	RCU_INIT_POINTER(flow->stats[0], stats);
 
-	cpumask_set_cpu(0, &flow->cpu_used_mask);
+	cpumask_set_cpu(0, flow->cpu_used_mask);
 
 	return flow;
 err:
@@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
 					  flow->sf_acts);
 	/* We open code this to make sure cpu 0 is always considered */
 	for (cpu = 0; cpu < nr_cpu_ids;
-	     cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		if (flow->stats[cpu])
 			kmem_cache_free(flow_stats_cache,
 					(struct sw_flow_stats __force *)flow->stats[cpu]);
@@ -1196,7 +1197,8 @@ int ovs_flow_init(void)
 
 	flow_cache = kmem_cache_create("sw_flow", sizeof(struct sw_flow)
 				       + (nr_cpu_ids
-					  * sizeof(struct sw_flow_stats *)),
+					  * sizeof(struct sw_flow_stats *))
+				       + cpumask_size(),
 				       0, 0, NULL);
 	if (flow_cache == NULL)
 		return -ENOMEM;
-- 
2.27.0

