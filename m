Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A0850B844
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447901AbiDVNXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 09:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447948AbiDVNW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 09:22:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2098.outbound.protection.outlook.com [40.107.220.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7A226F4
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 06:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGAe+qe3/v75EYTQT1Rs036pr/P8pMOy+k6ceDGH1zgmYoAkSDeP6qZdbODbspjONtHHX5uhLoxDAHy+pZv3cK6Dbck/MWbasgPFWqJm68rr7Msdv33g9STxyweandgelh1SpD2pWALIfSzp6BNxBWufyJi5CCFjaH+aTbojSQ9M8dyfo6UY7mgdamqZPEgrcBPGDVIZwko7wh4P2yrOQU4iFBm2eMgDY+PoAzxglYNybX0jUYm7apNfSDfZYFcLadxvg+tEQILqLf9h2kB2ioGulBB3HMkYVB2ElNqTZIBA2U2UN6WZReibOAIZagTtMc5uZYA6nSIQThepqWevgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JFeZlUgbtK9xCGl8iDZZ/soS02sv7ljrxJ9W9V0HKk=;
 b=CrI6eAZMZ5PvN0LDuTG8gFbWNdPr0RO5zY9Ul4W0TuYqA1zRzucq8VDh7HNjX7Vj7h7Bg92DyQzFBirEPBGdsiQ3EeDRJgIEVBacIW+Zw+iwicYROh03hDtyV2U13k62yzSx7X7F4n06MRfkdQSxiq4CfFFPyAQ90AgXcCV2Aw3OxNVyf4JVMNereZQde8Klx2Z3FaxM5ytQ45ivWDOdFTuTLpaxAaZbQKkYhb8jc3+VG5miYPUucgQ5XOBF6IXbB+7mW8GI9l0dTAeVLXpaAGGNaTBQuoHx34ylTSi4ImIs7dnT/bJ9UmYnhr1p0wf5cYD15lXT4HME632BVSM0rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JFeZlUgbtK9xCGl8iDZZ/soS02sv7ljrxJ9W9V0HKk=;
 b=UEHEWR90oPOgIDKUaZn6XudUxZg6/xzIOdyjMSthG5v3IzXV5FVsSf24HZVjmHxOdxCbEFOk57Cdn3TNgUzYQaFanyCdOT8FREhg4YvHnxlR1PGVeH5y7ic29+0WB4QaxmaCSQYkdlSk90yXE+3XN9ayCeR2qf1mP/avTka1rLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 22 Apr
 2022 13:20:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5206.006; Fri, 22 Apr 2022
 13:20:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>
Subject: [PATCH net-next] nfp: VF rate limit support
Date:   Fri, 22 Apr 2022 15:19:45 +0200
Message-Id: <20220422131945.948311-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0059.eurprd04.prod.outlook.com
 (2603:10a6:208:1::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2148a441-349e-4d82-12ac-08da2462ce35
X-MS-TrafficTypeDiagnostic: PH0PR13MB4841:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB484119777823701F29B8C42DE8F79@PH0PR13MB4841.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwQJARiCNL4udVd0CLoKUNfsqPe9zSLaylaI1LLHYAbKQMgpS26ZK3L3RJpB1U0UCTZGE8fkgYSbSJwRTnnAaZXhFQWy2+1hnr62R8dC3+zOIc9JHwWyduUw/s0SyFDbnpeCmKQLr04PazsMwAH2YnzQHd4ndv8N4XoVLFcLJBS6mhxE61z0zJtWjYv9I7FkzWh3cnt5TP+3o4kdGPvnPlwU4xaV6z+xXjBpuCmeYfvxYeSUcuygjX0CV9U1n2/StwF7xacYoXa6oM4x0n7dm6hlT/ST7v5NuRvYPQu1gZECxdhbqvoi9V21bsX+/tbqMVOSeluFTyZc7x8wmoi6OCXf73tZKbvsHeLiT8E6Y0O2QMp0xcA0bsRswVPLKK3IktDD38++gLh62bPh3pKjTUF9mhB6I3jOUpVQD5Gx1R+ce/6x2kOjTc8v3Gz4LV4rlJmCodG3MsEeQwaCZfEX7NxITsIalFK37aFVwM8s9HSJQf75Ndm5DBz6bH/3rGS4H6LJWc81T5H9mG+kMzbg6RKoPeKs4eEjWYa6b6dVHUKw99HP5HKKwIHFuBJG1xsHbRwMv6yRZ3nsoP7IsS4jbygNoaJcRD+j0pRdXULSnspuMnIku0ZE7FMjRbrDqecWXpkyVZWFq1bPk/GCHf21+F6nZN4dO7pC+Z+OctUMUuIgBWjQ80PQHmYpS0PqhNlYuemsXl45TpvjqdM9EZ0a2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(136003)(396003)(376002)(346002)(316002)(2906002)(66476007)(44832011)(2616005)(38100700002)(36756003)(66556008)(8936002)(83380400001)(110136005)(5660300002)(86362001)(107886003)(6486002)(6506007)(6666004)(1076003)(4326008)(66946007)(8676002)(508600001)(186003)(52116002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1gcX2kaa9h108Id54rZZs/kh7OJu8lsBt6l64ZAz3p14b271t//JQ2iJwUv?=
 =?us-ascii?Q?hzRDJQfEsy3F1znpuooGAiqgCUd/mhzgMpUhHlZKf6J3PgFRZX0rz0lw/qFl?=
 =?us-ascii?Q?dwKqN9XO44UrF4fdYWDzz4eff9r7jITBc+kATpcFnVa5zxzMhmd2KoI5ECKr?=
 =?us-ascii?Q?+QgAUH+pj7hxTURyDJ/VpaRTwbm3MI+yZg0V9b10F48Am8LUu4iKYNLLnetW?=
 =?us-ascii?Q?2yV43ts9fJVrOjas4yOiAv64KFpuWSwn9TNbehHDgdgywWGasKnDE4jeh+r4?=
 =?us-ascii?Q?nuo177COMLVi08L+OQ5B0tckB5b4agGNtyk7fA5c84hkrbrGMrnz+K/ya7r+?=
 =?us-ascii?Q?6+ogtb79JKsFUjYvmsu4dCUECy4hhPoxstHxKQSStB7vx/fiAz6B9Le001TZ?=
 =?us-ascii?Q?P24iXmWk+BLJ9zVEV7g/bDJnsSb7sKpA+3nggYYH1+HAcIthuUszlwbkNqyW?=
 =?us-ascii?Q?KfpFfBBmwQleVRuYuwJkWIVdi80MnYL6qaHcRZedYiKAGIqOa7y6LyCuJATP?=
 =?us-ascii?Q?w9bPur7qlK2hjPQqE3dyOskzf9Q9LSwWq3y3JkgRTKgNaHRKffeGYe/EorUW?=
 =?us-ascii?Q?Yf5NcMtVBCWrGtI1qlz6S0QtXT9yUoJdWaMV2CwHbDgFCP8eWncQizlhwdIN?=
 =?us-ascii?Q?0XtiFG16nQBIjRJxANyOqH0WwLkjCy6pJwhjw61EMhM84xrdPqkvi3WelsaG?=
 =?us-ascii?Q?kZUf1dO+HPyKwQxoM1/3C/BLvglakbk74IMH6jkcJcJPYlCTHo23EcSlCeEq?=
 =?us-ascii?Q?Tk4eiFpfJHK+w/Yuscm8AAd47XEezdzXqrIbkDTe9349nODhfrmP7HHEat+b?=
 =?us-ascii?Q?9N5TIHJuoJezZJvoaTc9FV33jcl7FDGTsrxJv0pf4Ujy3tM9KdlOasA2KAcW?=
 =?us-ascii?Q?Pve483GsAnIYH1NKQtTB3LOUvXqlx3JGGVe0pCDKy3kJqeK/LS+6BUdRFZn/?=
 =?us-ascii?Q?qgr7/JTGzneHHqKZSvly3CAFX+orQ7RF1r1GHgh+VjPCDfa6OM6ioB/7BJrD?=
 =?us-ascii?Q?v6Q6lmlbWl08FVUtMksf+B4RcdiMCD78qwwvqRQrTfSfEfAjAVprxggxxn3q?=
 =?us-ascii?Q?xgJpalTZhOYciyc2AZ5GZRCOnihJUfbprVlA3j9oKtcS8i3y8j/eVhZWb/bX?=
 =?us-ascii?Q?4DS+zk9IdHRU/h22jiCr9XctzubNyfZSGBjktWLG9zm+uuHDDdelt+7Mxk54?=
 =?us-ascii?Q?zB6cgVz16qz8j3e5B54YUrN66d6ltdk+XBV0EFJ/1L1exP3Raexy4nd6JcPg?=
 =?us-ascii?Q?puLXKrFN6qYvZqaFq1jmCAAo/WLnTcqkkOL8NMmW8VoRCjVj2vCU6iCPaoKH?=
 =?us-ascii?Q?xUlcK3BiHtjjqIx+0K4HRpfT3hN+NHMlUB7ocDaqy2QYUBHuGpQX8HoF2Miw?=
 =?us-ascii?Q?nM5P0B+VoDmRUS54hM1IU9T1G11VEhXkpVgLMtVPVyZWVURlYd8xvV+omG2i?=
 =?us-ascii?Q?iWHwUHNcTz+McY2Dc7dMPScuD5uhobR9uqF+8vnpyRnuOg5tRHLh5+uVv7EU?=
 =?us-ascii?Q?lKw/KrOTginxdJmR/z3vwhxCM58rl13ANl46zhd7Gib1rvXfhk+/UG4C/XC4?=
 =?us-ascii?Q?lSiemyXqssXajXRLYA43kP2rtkVbWH3evtGgdDWQnbmzp41TKuFYE7RG9ehi?=
 =?us-ascii?Q?2+MLnoBIV9ovA/gXu1mhEOMNUir0oDHiwaUW7P3kw2zAiAXTnHg+SCWf9E7S?=
 =?us-ascii?Q?Vgz4bfU4rx06jH1DS91eE5WTFomV/9qEd2PG2yUsCIq6r9fwV6/Kc3H2l1GA?=
 =?us-ascii?Q?YyMfLaXxcRZLczpqT2T+VN+bLHdRToDZsuZZCKPdaQYIY5IUYYN+lFvmoGne?=
X-MS-Exchange-AntiSpam-MessageData-1: zGjJ3hzGoMEkvsSOCM7oLlnORLUV+gRIqXY=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2148a441-349e-4d82-12ac-08da2462ce35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 13:20:01.3368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAEWFjfDyTMWsAhJHfqa4WJUXrc7JvrdK3mc1OPi2LSE1hMxcs0Mba1dBPou4udSwsiK78EcPKfnrOksmo/jx9zvFBrOqVvovndHXjeldv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

This patch enhances the NFP driver to supports assignment of
both max_tx_rate and min_tx_rate to VFs

The following configurations are all supported:
 # ip link set $DEV vf $VF_NUM max_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM min_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM max_tx_rate $RATE_VALUE \
			       min_tx_rate $RATE_VALUE
 # ip link set $DEV vf $VF_NUM min_tx_rate $RATE_VALUE \
			       max_tx_rate $RATE_VALUE

The max RATE_VALUE is limited to 0xFFFF which is about
63Gbps (using 1024 for 1G).

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   |  1 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 50 ++++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |  9 ++++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b412670d89b2..4340b69cc919 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1903,6 +1903,7 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
 	.ndo_set_vf_mac         = nfp_app_set_vf_mac,
 	.ndo_set_vf_vlan        = nfp_app_set_vf_vlan,
+	.ndo_set_vf_rate	= nfp_app_set_vf_rate,
 	.ndo_set_vf_spoofchk    = nfp_app_set_vf_spoofchk,
 	.ndo_set_vf_trust	= nfp_app_set_vf_trust,
 	.ndo_get_vf_config	= nfp_app_get_vf_config,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 4627715a5e32..bca0a864cb44 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -142,6 +142,40 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	return nfp_net_sriov_update(app, vf, update, "vlan");
 }
 
+int nfp_app_set_vf_rate(struct net_device *netdev, int vf,
+			int min_tx_rate, int max_tx_rate)
+{
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	u32 vf_offset, ratevalue;
+	int err;
+
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	if (err)
+		return err;
+
+	if (max_tx_rate > 0 || min_tx_rate > 0) {
+		if (max_tx_rate > 0 && max_tx_rate < min_tx_rate) {
+			nfp_warn(app->cpp, "min-tx-rate exceeds max_tx_rate.\n");
+			return -EINVAL;
+		}
+
+		if (max_tx_rate > NFP_NET_VF_RATE_MAX || min_tx_rate > NFP_NET_VF_RATE_MAX) {
+			nfp_warn(app->cpp, "tx-rate exceeds 0x%x.\n", NFP_NET_VF_RATE_MAX);
+			return -EINVAL;
+		}
+	}
+
+	vf_offset = NFP_NET_VF_CFG_MB_SZ + vf * NFP_NET_VF_CFG_SZ;
+	ratevalue = FIELD_PREP(NFP_NET_VF_CFG_MAX_RATE,
+			       max_tx_rate ? max_tx_rate : NFP_NET_VF_RATE_MAX) |
+		    FIELD_PREP(NFP_NET_VF_CFG_MIN_RATE, min_tx_rate);
+
+	writel(ratevalue, app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_RATE);
+
+	return nfp_net_sriov_update(app, vf, NFP_NET_VF_CFG_MB_UPD_RATE,
+				    "rate");
+}
+
 int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
@@ -228,9 +262,8 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
-	unsigned int vf_offset;
+	u32 vf_offset, mac_hi, rate;
 	u32 vlan_tag;
-	u32 mac_hi;
 	u16 mac_lo;
 	u8 flags;
 	int err;
@@ -261,5 +294,18 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	ivi->trusted = FIELD_GET(NFP_NET_VF_CFG_CTRL_TRUST, flags);
 	ivi->linkstate = FIELD_GET(NFP_NET_VF_CFG_CTRL_LINK_STATE, flags);
 
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
+	if (!err) {
+		rate = readl(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_RATE);
+
+		ivi->max_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MAX_RATE, rate);
+		ivi->min_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MIN_RATE, rate);
+
+		if (ivi->max_tx_rate == NFP_NET_VF_RATE_MAX)
+			ivi->max_tx_rate = 0;
+		if (ivi->min_tx_rate == NFP_NET_VF_RATE_MAX)
+			ivi->max_tx_rate = 0;
+	}
+
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 7b72cc083476..2d445fa199dc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -20,6 +20,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
+#define   NFP_NET_VF_CFG_MB_CAP_RATE			  (0x1 << 6)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -28,6 +29,7 @@
 #define   NFP_NET_VF_CFG_MB_UPD_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
+#define   NFP_NET_VF_CFG_MB_UPD_RATE			  (0x1 << 6)
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -48,10 +50,17 @@
 #define   NFP_NET_VF_CFG_VLAN_PROT			  0xffff0000
 #define   NFP_NET_VF_CFG_VLAN_QOS			  0xe000
 #define   NFP_NET_VF_CFG_VLAN_VID			  0x0fff
+#define NFP_NET_VF_CFG_RATE				0xc
+#define   NFP_NET_VF_CFG_MIN_RATE			0x0000ffff
+#define   NFP_NET_VF_CFG_MAX_RATE			0xffff0000
+
+#define NFP_NET_VF_RATE_MAX			0xffff
 
 int nfp_app_set_vf_mac(struct net_device *netdev, int vf, u8 *mac);
 int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 			__be16 vlan_proto);
+int nfp_app_set_vf_rate(struct net_device *netdev, int vf, int min_tx_rate,
+			int max_tx_rate);
 int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool setting);
 int nfp_app_set_vf_trust(struct net_device *netdev, int vf, bool setting);
 int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
-- 
2.30.2

