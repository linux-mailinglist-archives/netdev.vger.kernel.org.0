Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF6550B2F3
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445530AbiDVIex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445529AbiDVIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9739A52E69
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTD9C26VRxolaUXP57ufX0q7sRDoiFA+i4f9+5uN20K9oaaqmAkKi8oTttSwBHnqHxmuEUoTrU9/YWPOQq8uNSkJUpD/0Fq0CVbLzalGo1ylyWUriQmA1w8JnD5330miwN4oYqRs9mLW7AdStVgsFhaM2oFhaWhHMvf4gAch/9qYYwBVyTFt9M+vI00d7Fw6EjKwA/BMrpoExusVEhVeMqz6aJ+S57VtJ3RX3eJAN8G4fRWxkEGPQLl3NnlegvfkeRm+AEW7wQSywWdSNQE1whidNFXrnD8TvhLuqK64rHRZpMiNV8/RG87OgWM82T40MZcE16GkFcArOjticoxxzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vb3x5BV93RiIowGj0a8+FV74nWiFRzR+0kGSQrT0EYE=;
 b=YndFyvvhPwbDaDL21mHUdtG/3K8+QbHPuaTEp/u6uJiZLQAY+UKnF8wyjx5A7/FR2DpgoZNielCun8OzId8KbFFi44DZFmFgKqA1K6VVN0LU+MQTXSz4om5X8sx1NpVWfz4F6bF7YAGHfH3snY3DHdKvCanmo241zCuhTt4G2IE4iENrseA0i+3gUCJJuNrNcMFpfnJOrZzdCpDHZWHn5dkYUFDrspfGqjpUoF9gbVnjQbEx2c3iRYRqxDWR2P50Cl8uIfKNZZr9eOS7IahAER33nvd+ReFTEPTcRL0SqYmc8d/+fcgvo7Aolcbq1lm3C5oMm+a3hxXnpzngfPbDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vb3x5BV93RiIowGj0a8+FV74nWiFRzR+0kGSQrT0EYE=;
 b=Apu2/dkDtxYIA6vwAS6V3tQjg0xsKj6tOL5IUfJtsSlE1gWMViLulzLZbsr04HN1Fb4TbF3IHxwQ/whvvQUEw0yoTjS1s7JnKV0wcQBMsh3Yyy9b4EZ4Iu7kXI+RnJNm3x9CM2OAs490na3VYghZRbHLCYPT58zDzSZJU6ay8CravfjpGDKIOYSRvy8kQ9oTLcgWUaOEB4rduTFDhZ8usE6yFX+3GpQmdM7BrM3Ct2NRZ6nXy3U7OqibcDm6lsQd7B+pYigQcaT3pq24r2wo9mc4ACIxonhG3/FrXjlzPZU2MNqjWu0avJ07alL1PTt18QKGamX+WKBgxv6jk8NmZw==
Received: from DS7PR05CA0099.namprd05.prod.outlook.com (2603:10b6:8:56::20) by
 MN2PR12MB3920.namprd12.prod.outlook.com (2603:10b6:208:168::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 08:31:43 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::83) by DS7PR05CA0099.outlook.office365.com
 (2603:10b6:8:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:42 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:40 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 08/11] ipstats: Add offload subgroup "hw_stats_info"
Date:   Fri, 22 Apr 2022 10:30:57 +0200
Message-ID: <10e22980dbca5f96408672266a96baf32b88712f.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438a0fe5-c1a6-4f17-cf84-08da243a8803
X-MS-TrafficTypeDiagnostic: MN2PR12MB3920:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB39204E7B9C37E783E68AFF93D6F79@MN2PR12MB3920.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UW5Oat1ZGcp5OB4THbbBd8UHYXN18azesPuPTJs7vB+ijB3oJfPvSS0+mglFADtyiXsgd184Vw60zkJs/hLOvg1a3WACEhA5UaWoaVRCOr7PcgMSn2U/tc1XQbGRi3VIyn8Wkzm9ENt04boH9ZkXoQitWg48GJjjZpdFSgnUqwPQVtQ1fY3UPkqQ0wZYGjjKMGX+AsiO/263ELNVG2pOZBfwdVhFQQBVzh3XcuUmTqRzEKQDi5sjGTdrgFY4fBWoGWxuWD7KdlQ8JPI8yO/7Tthlcf/4+umdycBN9HfsLTpDKEpVXhhtjPLqdlCAPcFj9782kZa3/ex1SczSsKy3NlsLoXEZpM9R6729MiYCuiVE1NDhi5MXFAlUXHCPEEI4x3SD8OwoSDAeh+6bVx6sIVboS0bhngmPtYHUzCA6zNnytwnTxch9nnka4YLZWkK797wrU6WAvNw7kImlwcWq2f4qtcc+vMzbTRsst5HM1pa7ycdJerg/dUnbR+p1E46H8bIpCjyn08CgeYieufuZmI1i3cv4C0oY7acbp3GRs7KyuytDUj8wA3Ijf+1L2QxPFqtTIqn3JhLv+L/vjvkZo6zeKum1CK1hj8yqxy9MzN2+N76vyz/KJJGU5ZCAfujtrdIByq+s0+f5j/qiqneMPK3mdiKUKk/x8GjI9UB18ITG65hhiWURjQmsmA2wLlAkFliOtqpay4QBo6SVJPptfQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(426003)(70206006)(70586007)(186003)(16526019)(47076005)(336012)(40460700003)(107886003)(2616005)(26005)(36756003)(83380400001)(356005)(82310400005)(6916009)(81166007)(54906003)(4326008)(8676002)(86362001)(36860700001)(6666004)(2906002)(316002)(8936002)(508600001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:43.3594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 438a0fe5-c1a6-4f17-cf84-08da243a8803
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3920
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add into the group "offload" a subgroup "hw_stats_info" for showing
information about HW statistics counters.

For example:

 # ip stats show dev swp1 group offload subgroup hw_stats_info
 4178: swp1: group offload subgroup hw_stats_info
     l3_stats on used off
 # ip -j stats show dev swp1 group offload subgroup hw_stats_info | jq
 [
   {
     "ifindex": 4178,
     "ifname": "swp1",
     "group": "offload",
     "subgroup": "hw_stats_info",
     "info": {
       "l3_stats": {
         "request": true,
         "used": false
       }
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 217 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 217 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 283fba4e..4cdd5122 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -164,6 +164,197 @@ static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
 	return 0;
 }
 
+enum ipstats_maybe_on_off {
+	IPSTATS_MOO_OFF = -1,
+	IPSTATS_MOO_INVALID,
+	IPSTATS_MOO_ON,
+};
+
+static bool ipstats_moo_to_bool(enum ipstats_maybe_on_off moo)
+{
+	assert(moo != IPSTATS_MOO_INVALID);
+	return moo + 1;
+}
+
+static int ipstats_print_moo(enum output_type t, const char *key,
+			     const char *fmt, enum ipstats_maybe_on_off moo)
+{
+	if (!moo)
+		return 0;
+	return print_on_off(t, key, fmt, ipstats_moo_to_bool(moo));
+}
+
+struct ipstats_hw_s_info_one {
+	enum ipstats_maybe_on_off request;
+	enum ipstats_maybe_on_off used;
+};
+
+enum ipstats_hw_s_info_idx {
+	IPSTATS_HW_S_INFO_IDX_L3_STATS,
+	IPSTATS_HW_S_INFO_IDX_COUNT
+};
+
+static const char *const ipstats_hw_s_info_name[] = {
+	"l3_stats",
+};
+
+static_assert(ARRAY_SIZE(ipstats_hw_s_info_name) ==
+	      IPSTATS_HW_S_INFO_IDX_COUNT,
+	      "mismatch: enum ipstats_hw_s_info_idx x ipstats_hw_s_info_name");
+
+struct ipstats_hw_s_info {
+	/* Indexed by enum ipstats_hw_s_info_idx. */
+	struct ipstats_hw_s_info_one *infos[IPSTATS_HW_S_INFO_IDX_COUNT];
+};
+
+static enum ipstats_maybe_on_off ipstats_dissect_01(int value, const char *what)
+{
+	switch (value) {
+	case 0:
+		return IPSTATS_MOO_OFF;
+	case 1:
+		return IPSTATS_MOO_ON;
+	default:
+		fprintf(stderr, "Invalid value for %s: expected 0 or 1, got %d.\n",
+			what, value);
+		return IPSTATS_MOO_INVALID;
+	}
+}
+
+static int ipstats_dissect_hw_s_info_one(const struct rtattr *at,
+					 struct ipstats_hw_s_info_one *p_hwsio,
+					 const char *what)
+{
+	int attr_id_request = IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST;
+	struct rtattr *tb[IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX + 1];
+	int attr_id_used = IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED;
+	struct ipstats_hw_s_info_one hwsio = {};
+	int err;
+	int v;
+
+	err = parse_rtattr_nested(tb, IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX, at);
+	if (err)
+		return err;
+
+	if (tb[attr_id_request]) {
+		v = rta_getattr_u8(tb[attr_id_request]);
+		hwsio.request = ipstats_dissect_01(v, "request");
+
+		/* This has to be present & valid. */
+		if (!hwsio.request)
+			return -EINVAL;
+	}
+
+	if (tb[attr_id_used]) {
+		v = rta_getattr_u8(tb[attr_id_used]);
+		hwsio.used = ipstats_dissect_01(v, "used");
+	}
+
+	*p_hwsio = hwsio;
+	return 0;
+}
+
+static int ipstats_dissect_hw_s_info(const struct rtattr *at,
+				     struct ipstats_hw_s_info *hwsi)
+{
+	struct rtattr *tb[IFLA_OFFLOAD_XSTATS_MAX + 1];
+	int attr_id_l3 = IFLA_OFFLOAD_XSTATS_L3_STATS;
+	struct ipstats_hw_s_info_one *hwsio = NULL;
+	int err;
+
+	err = parse_rtattr_nested(tb, IFLA_OFFLOAD_XSTATS_MAX, at);
+	if (err)
+		return err;
+
+	*hwsi = (struct ipstats_hw_s_info){};
+
+	if (tb[attr_id_l3]) {
+		hwsio = malloc(sizeof(*hwsio));
+		if (!hwsio) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = ipstats_dissect_hw_s_info_one(tb[attr_id_l3], hwsio, "l3");
+		if (err)
+			goto out;
+
+		hwsi->infos[IPSTATS_HW_S_INFO_IDX_L3_STATS] = hwsio;
+		hwsio = NULL;
+	}
+
+	return 0;
+
+out:
+	free(hwsio);
+	return err;
+}
+
+static void ipstats_fini_hw_s_info(struct ipstats_hw_s_info *hwsi)
+{
+	int i;
+
+	for (i = 0; i < IPSTATS_HW_S_INFO_IDX_COUNT; i++)
+		free(hwsi->infos[i]);
+}
+
+static void
+__ipstats_show_hw_s_info_one(const struct ipstats_hw_s_info_one *hwsio)
+{
+	if (hwsio == NULL)
+		return;
+
+	ipstats_print_moo(PRINT_ANY, "request", " %s", hwsio->request);
+	ipstats_print_moo(PRINT_ANY, "used", " used %s", hwsio->used);
+}
+
+static void
+ipstats_show_hw_s_info_one(const struct ipstats_hw_s_info *hwsi,
+			   enum ipstats_hw_s_info_idx idx)
+{
+	const struct ipstats_hw_s_info_one *hwsio = hwsi->infos[idx];
+	const char *name = ipstats_hw_s_info_name[idx];
+
+	if (hwsio == NULL)
+		return;
+
+	print_string(PRINT_FP, NULL, "    %s", name);
+	open_json_object(name);
+	__ipstats_show_hw_s_info_one(hwsio);
+	close_json_object();
+}
+
+static int __ipstats_show_hw_s_info(const struct rtattr *at)
+{
+	struct ipstats_hw_s_info hwsi = {};
+	int err;
+
+	err = ipstats_dissect_hw_s_info(at, &hwsi);
+	if (err)
+		return err;
+
+	open_json_object("info");
+	ipstats_show_hw_s_info_one(&hwsi, IPSTATS_HW_S_INFO_IDX_L3_STATS);
+	close_json_object();
+
+	ipstats_fini_hw_s_info(&hwsi);
+	return 0;
+}
+
+static int ipstats_show_hw_s_info(struct ipstats_stat_show_attrs *attrs,
+				  unsigned int group, unsigned int subgroup)
+{
+	const struct rtattr *at;
+	int err;
+
+	at = ipstats_stat_show_get_attr(attrs, group, subgroup, &err);
+	if (at == NULL)
+		return err;
+
+	print_nl();
+	return __ipstats_show_hw_s_info(at);
+}
+
 static void
 ipstats_stat_desc_pack_cpu_hit(struct ipstats_stat_dump_filters *filters,
 			       const struct ipstats_stat_desc *desc)
@@ -189,8 +380,34 @@ static const struct ipstats_stat_desc ipstats_stat_desc_offload_cpu_hit = {
 	.show = &ipstats_stat_desc_show_cpu_hit,
 };
 
+static void
+ipstats_stat_desc_pack_hw_stats_info(struct ipstats_stat_dump_filters *filters,
+				     const struct ipstats_stat_desc *desc)
+{
+	ipstats_stat_desc_enable_bit(filters,
+				     IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				     IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+}
+
+static int
+ipstats_stat_desc_show_hw_stats_info(struct ipstats_stat_show_attrs *attrs,
+				     const struct ipstats_stat_desc *desc)
+{
+	return ipstats_show_hw_s_info(attrs,
+				      IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				      IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+}
+
+static const struct ipstats_stat_desc ipstats_stat_desc_offload_hw_s_info = {
+	.name = "hw_stats_info",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.pack = &ipstats_stat_desc_pack_hw_stats_info,
+	.show = &ipstats_stat_desc_show_hw_stats_info,
+};
+
 static const struct ipstats_stat_desc *ipstats_stat_desc_offload_subs[] = {
 	&ipstats_stat_desc_offload_cpu_hit,
+	&ipstats_stat_desc_offload_hw_s_info,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_offload_group = {
-- 
2.31.1

