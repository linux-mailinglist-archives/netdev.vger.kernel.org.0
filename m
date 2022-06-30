Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0468A5618EC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiF3LSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiF3LSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:18:43 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130131.outbound.protection.outlook.com [40.107.13.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AB24D4D3;
        Thu, 30 Jun 2022 04:18:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbpjtpgY35S2O6ZRRgB27EzSvSWsJIpDTU1yB+STf5Lvog67qMgmQhKDT7aLghVNOlvPwwYIQVvtIMm6BhBn37P5Uc/b8qj1xCZKvl4kLvtuei60WyguvNmTAnzZwU4GBXvBfCjJd/jjM1iLFw/L0gouDMgG/8PR7YMUTjqeI6uITGrk2CcmmiCk2KkrdiL9fQUJXU14OUbvUiGeiKoYTlR7/ipsXfsyeV6aRMZ1VU78WkVNtff8USvHcfRNa2Z15qeYrL6Y4DMneQ17jX+fsUMC2sncvt9Ou+tK/drOFNe5VkZM5jUkbCAQxt1BmoyCBb7dlie6BXDtJVtklov58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=eD4ZoLrMHz8Hor3esCuGo8llELp01v62u06nndshVxq9M5Hen8Y6GHhxWVl+5Gdh0dGBbcHqvYd3sCzzxWMrCx/6I3OgUlnL3gWbI23nyGbm7Ou+YmDzzYv8k38ybsGhIWE3b2lWvihGhP52IEmeIgwIrU/2DOH8qCLqimr78ZWHyjwuJDc8xv/xXWYPQplkeUKfj0uprOaDquRHLLiaDFoJGxahaYFaQXxEN5BDIkwwiOD8Zqn6dDGEzQnce/bVkM0Ue2bD9vgpnJzJ7DNFCW4XYjVqwfpqiOEg9cdNp/O2iv0pvPlf5UPN2VeY2e+JBq6q2t3YdDbd2A814HM+lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ksutx2RW4x0Lz0Iho5G2F5CgEfNeQ2Xl0szoV1ygqXA=;
 b=vEgv9uFXcIYT8Qc3/Gmq2S6eiKfoOolJmrPekzG+wE8ca0uhvnU/aX5wADzn6c7J+/Yw4EvOzcskQountcfIj+sL1E69weTd2vj3QPWeoFjp7+TeLv2JDodJdIGT8He4Nw1Vbk8VrnpmlPImO7eQvdEA2ABUacRqZbZWUiYykU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by HE1P190MB0489.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:60::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Thu, 30 Jun 2022 11:18:39 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 11:18:39 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Cc:     lkp@intel.com, linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V3 net-next 2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
Date:   Thu, 30 Jun 2022 14:18:20 +0300
Message-Id: <20220630111822.26004-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
References: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00580347-ac2a-4fcd-c75a-08da5a8a480f
X-MS-TrafficTypeDiagnostic: HE1P190MB0489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXG+RCALcY2JfFYL9PGxVcpU8nVoE3W9gD2pm7aNaK57l99JG0mRpKmzeqSLX3VPlT74yJ9Z3VdM+BQJaqe4Pzhg04AnhtKF+zzZ6RX1lxWRKFL3WMkId0y1pyp2q3N7bRXvcAfQMej9Na+WgvvKXyOUQ/IrqIdEjNpDZQ9jCv7R/4zi2hHof9uu2ogde+onOha424HfftiDw72Jv1uR7CRw3E/tKnK23Oag5tD2kWvzEXH5b9H3e992YV6ofqyP65UG4UsKnQSra7aRjKsjiPJboHsvFNqb8EJvPbIMKUeBE38Amc3OrKzbZaf5xsEwb6/Dd/rWmZrdAQQaLDaFhUNu04d73yc1OloGlALc4wXUDWuDSKiSQWbwGSoCGf0PcLO099m3eyIa04+njMzao/tmxOf1RE7KrilRiGK73ka004qtz0T4ez+RVRCebL2eeosdZRGwp0KoMJL0RbDSO6nseQCaqzHZLmZ4oiEyekXd0iCtGaH/BbOYxkbOM52VAO7BeE13xECBBgaRjS74577ck1ZRQaVuMTj+lYZ4ahVHVAXoXuSWt4X6UtyPKmU2AlDr1A3ihwcL6xYHE6k7kaDqFSmP+sXsaqYUayN2DDzOH30hQ9c8VD/dB8lK1hJJUar6xC/RFrxQvKz450GVQpB8+X25cAk6H9XwJ2Zdn6xAvVbTYhwSjrK2kSSdejpDpEC3VQunOfqlofAmACWuqOBWqrPPEm8Cg6N51U6ewb0kG9S9vHyv0oIUJVR8uxvIykd7Ko9acUQHtDDYrj+pysuEu4w4VOo7J5DR+AT3TVxOULy3Z4MyvyqY9oA+1sHD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(39830400003)(396003)(136003)(5660300002)(66574015)(86362001)(36756003)(30864003)(6512007)(8936002)(6666004)(52116002)(38100700002)(2616005)(44832011)(26005)(38350700002)(66556008)(186003)(8676002)(107886003)(66476007)(478600001)(2906002)(110136005)(6486002)(4326008)(316002)(66946007)(1076003)(41300700001)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YA73X9SxCLnCmBD1uVrDG3afXJIfKCLMw6Mf8jXQq0pCV2KTLY/JH6J7HQ8F?=
 =?us-ascii?Q?rQTggSDqmb343WYURxpYa6fAICzA3jxENtsuNbzDDkqki9vG6c987ZPsgGNZ?=
 =?us-ascii?Q?QfI8o9JFPLhtmXyPtwFN/HUSa1eeo5v3GEawsgFYwoITYRS1AJnFrbdk9E76?=
 =?us-ascii?Q?vDm07z+wqTZojf7h9sGlJnVlxz8PPsMqGK6w4onMMskVDbNfkpDG+XQytvrJ?=
 =?us-ascii?Q?9+6sTMx2E+dL1zwN4MVfdwnWzifGRELjM17WFcDMkaUxa5Is9ATy8cPEG9QU?=
 =?us-ascii?Q?bDYuJ8crt4d3jtgZ6NbbXooH9SqXRNHvUnDGt2x3c6Bq3EauCA9Y7Hgr0qtJ?=
 =?us-ascii?Q?25oy45qJVNs22nR+eiyLcHQWBd3ELVGa4awC7OUCyjZpqyyBLull4UGAbnHR?=
 =?us-ascii?Q?sHwIcW/y947PGcqhAKT9GjfpGeArPwS9/oZD6dYOhOmi5NsB5EQWr3d5cUoL?=
 =?us-ascii?Q?0cU64lwWJrcMNZ7pz/iphszjVPTnQdYXofLxzP3ZLqZMBIL9v5CzDdGdg1a4?=
 =?us-ascii?Q?aLjzfx5jW/UqRVuDOQe5IQ8L8AN0Lo7QreHXNoZoH7Bzeq3kVvNRxQm9CFw2?=
 =?us-ascii?Q?+KG2Hv/nnBOh2CNuKU+eENSgFYG6Eil+1C6XaFv058PVg43CVJCXtpdZfrXq?=
 =?us-ascii?Q?yuHHUL4zYnq6nwiN6I1ss3T6ZG6T6wSuXI16MkAh4RWd81UihLE/f6Aorq/6?=
 =?us-ascii?Q?T4wgjgxCdfo4QxJrCeqYDwiF+mqlYV1r5yfuu+ZQacysJljqVTGktSMtlgBm?=
 =?us-ascii?Q?6L3I9sKKZAW9afXCgOQPCsMEChXqi5/YVZpP7HswYZBScHaA3Fi7FBh/CUhB?=
 =?us-ascii?Q?X0JBVB16IEFqS03ufWcm34iLM+0uVS1cU3cbjK+YvQoKoXJe2Dxqa2Pmb9dT?=
 =?us-ascii?Q?wGV9Dh9Ags+zPHurZmNzEn9vPGDg6U55eudPDI9qhRiGJrb0d5oaU7xYKg62?=
 =?us-ascii?Q?M/KcrFccrPNCi1Y7fQ++bc5o6U/BchKJqmRBrIY00h/90k4Hubk+lWhC+vl6?=
 =?us-ascii?Q?fzYjvcAW12gH7LnisUMe/D19MoxoI1OyL2u+BnfCEG5JUeObm5oseNpwM0aG?=
 =?us-ascii?Q?C2JscMTrcKIuG6DKRhQLQTmmR4Pnw9jW25B4kg87kFAn0VasKBsvQYDbkjRb?=
 =?us-ascii?Q?ekV1iCyxeSwv2t0NXT3P/mrl0VSdw7HKmNCb9LuN5B/ebkhsTV/iJfexHE5H?=
 =?us-ascii?Q?M+OwCbx/aHNUSq1NCMrBkZoUygFUTN5xsAEFtl0zn2IRSh0CVgYrOHqIpXaX?=
 =?us-ascii?Q?o+3eMl042JHBZHsXJCLGUxPzkRb7AQHg39TAkfKGK8lf7pFfmGp9KniGdNeG?=
 =?us-ascii?Q?AR6FlknCSEY44L4ZYTbPSg6uA5c0jDgqXB53YmSILBMUFvyGjkgwMz5nceGe?=
 =?us-ascii?Q?Kz2slAusCyDJ2R1dSsKYwO15ee9RbAAU+eqmz23J6mY8ruiGqiKTXojwW5Ut?=
 =?us-ascii?Q?DnkFhP872oVVdjOtjlS+1RJ0WpVe53G0eY+pUJa0j4DxuJtMthSOzG9Z+5MV?=
 =?us-ascii?Q?hQpaBPw/cr1Nt+X12kZ+OWHqnO4Fm/NKLs0CnuWg3wzQGIsaUW0iqkt4CBm6?=
 =?us-ascii?Q?af6E+duEAHr4xNBaGFQJYHXwcxsgDWuVN+K8kc5lcScEXMZq0HB/k2kDqIEE?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 00580347-ac2a-4fcd-c75a-08da5a8a480f
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 11:18:38.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBlOjejH0hbSZpShedItEbtS4E/6l5qekiaF6IGn23eDmMgXORbVgnRvxJQ1dlYXyYxa5fbGMkrF5Wlh4Kc/+daue/9/z+xsBa5x9BiHhgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define MDB entry that can be offloaded:
  - FDB entry, that defines an multicast group to which traffic can be
    replicated to;
Define flood domain:
  - Arrangement of ports (list), that have joined multicast group, which
    would receive and replicate to multicast traffic of specified group;
Define flood domain port:
  - single flood domain list entry, that is associated with any given
    bridge port interface (could be LAG interface or physical port-member).
    Applicable to both Q and D bridges;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  22 ++
 .../ethernet/marvell/prestera/prestera_hw.c   | 202 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_main.c |  24 +++
 4 files changed, 259 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index cab80e501419..bf7ecb18858a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -20,6 +20,26 @@ struct prestera_fw_rev {
 	u16 sub;
 };
 
+struct prestera_flood_domain {
+	struct prestera_switch *sw;
+	struct list_head flood_domain_port_list;
+	u32 idx;
+};
+
+struct prestera_mdb_entry {
+	struct prestera_switch *sw;
+	struct prestera_flood_domain *flood_domain;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+struct prestera_flood_domain_port {
+	struct prestera_flood_domain *flood_domain;
+	struct net_device *dev;
+	struct list_head flood_domain_port_node;
+	u16 vid;
+};
+
 struct prestera_port_stats {
 	u64 good_octets_received;
 	u64 bad_octets_received;
@@ -342,6 +362,8 @@ bool prestera_netdev_check(const struct net_device *dev);
 int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
 
 bool prestera_port_is_lag_member(const struct prestera_port *port);
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index b00e69fabc6b..962d7e0c0cb5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -60,6 +60,14 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_CREATE = 0x700,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_DESTROY = 0x701,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_SET = 0x702,
+	PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_RESET = 0x703,
+
+	PRESTERA_CMD_TYPE_MDB_CREATE = 0x704,
+	PRESTERA_CMD_TYPE_MDB_DESTROY = 0x705,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
@@ -185,6 +193,12 @@ struct prestera_fw_event_handler {
 	void *arg;
 };
 
+enum {
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_REG_PORT = 0,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_LAG = 1,
+	PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_MAX = 2,
+};
+
 struct prestera_msg_cmd {
 	__le32 type;
 };
@@ -627,6 +641,57 @@ struct prestera_msg_event_fdb {
 	u8 dest_type;
 };
 
+struct prestera_msg_flood_domain_create_req {
+	struct prestera_msg_cmd cmd;
+};
+
+struct prestera_msg_flood_domain_create_resp {
+	struct prestera_msg_ret ret;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_ports_set_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le32 ports_num;
+};
+
+struct prestera_msg_flood_domain_ports_reset_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+};
+
+struct prestera_msg_flood_domain_port {
+	union {
+		struct {
+			__le32 port_num;
+			__le32 dev_num;
+		};
+		__le16 lag_id;
+	};
+	__le16 vid;
+	__le16 port_type;
+};
+
+struct prestera_msg_mdb_create_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
+struct prestera_msg_mdb_destroy_req {
+	struct prestera_msg_cmd cmd;
+	__le32 flood_domain_idx;
+	__le16 vid;
+	u8 mac[ETH_ALEN];
+};
+
 static void prestera_hw_build_tests(void)
 {
 	/* check requests */
@@ -654,10 +719,17 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_lpm_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_policer_req) != 36);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_create_req) != 4);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_destroy_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_set_req) != 12);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_ports_reset_req) != 8);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_create_req) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_mdb_destroy_req) != 16);
 
 	/*  structure that are part of req/resp fw messages */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_ip_addr) != 20);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_flood_domain_port) != 12);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -2194,3 +2266,133 @@ int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
 	return prestera_cmd(sw, PRESTERA_CMD_TYPE_POLICER_SET,
 			    &req.cmd, sizeof(req));
 }
+
+int prestera_hw_flood_domain_create(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_create_resp resp;
+	struct prestera_msg_flood_domain_create_req req;
+	int err;
+
+	err = prestera_cmd_ret(domain->sw,
+			       PRESTERA_CMD_TYPE_FLOOD_DOMAIN_CREATE, &req.cmd,
+			       sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	domain->idx = __le32_to_cpu(resp.flood_domain_idx);
+
+	return 0;
+}
+
+int prestera_hw_flood_domain_destroy(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_destroy_req req = {
+		.flood_domain_idx = __cpu_to_le32(domain->idx),
+	};
+
+	return prestera_cmd(domain->sw, PRESTERA_CMD_TYPE_FLOOD_DOMAIN_DESTROY,
+			   &req.cmd, sizeof(req));
+}
+
+int prestera_hw_flood_domain_ports_set(struct prestera_flood_domain *domain)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+	struct prestera_msg_flood_domain_ports_set_req *req;
+	struct prestera_msg_flood_domain_port *ports;
+	struct prestera_switch *sw = domain->sw;
+	struct prestera_port *port;
+	u32 ports_num = 0;
+	int buf_size;
+	void *buff;
+	u16 lag_id;
+	int err;
+
+	list_for_each_entry(flood_domain_port, &domain->flood_domain_port_list,
+			    flood_domain_port_node)
+		ports_num++;
+
+	if (!ports_num)
+		return -EINVAL;
+
+	buf_size = sizeof(*req) + sizeof(*ports) * ports_num;
+
+	buff = kmalloc(buf_size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	req = buff;
+	ports = buff + sizeof(*req);
+
+	req->flood_domain_idx = __cpu_to_le32(domain->idx);
+	req->ports_num = __cpu_to_le32(ports_num);
+
+	list_for_each_entry(flood_domain_port, &domain->flood_domain_port_list,
+			    flood_domain_port_node) {
+		if (netif_is_lag_master(flood_domain_port->dev)) {
+			if (prestera_lag_id(sw, flood_domain_port->dev,
+					    &lag_id)) {
+				kfree(buff);
+				return -EINVAL;
+			}
+
+			ports->port_type =
+				__cpu_to_le16(PRESTERA_HW_FLOOD_DOMAIN_PORT_TYPE_LAG);
+			ports->lag_id = __cpu_to_le16(lag_id);
+		} else {
+			port = prestera_port_dev_lower_find(flood_domain_port->dev);
+
+			ports->port_type =
+				__cpu_to_le16(PRESTERA_HW_FDB_ENTRY_TYPE_REG_PORT);
+			ports->dev_num = __cpu_to_le32(port->dev_id);
+			ports->port_num = __cpu_to_le32(port->hw_id);
+		}
+
+		ports->vid = __cpu_to_le16(flood_domain_port->vid);
+
+		ports++;
+	}
+
+	err = prestera_cmd(sw, PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_SET,
+			   &req->cmd, buf_size);
+
+	kfree(buff);
+
+	return err;
+}
+
+int prestera_hw_flood_domain_ports_reset(struct prestera_flood_domain *domain)
+{
+	struct prestera_msg_flood_domain_ports_reset_req req = {
+		.flood_domain_idx = __cpu_to_le32(domain->idx),
+	};
+
+	return prestera_cmd(domain->sw,
+			   PRESTERA_CMD_TYPE_FLOOD_DOMAIN_PORTS_RESET, &req.cmd,
+			   sizeof(req));
+}
+
+int prestera_hw_mdb_create(struct prestera_mdb_entry *mdb)
+{
+	struct prestera_msg_mdb_create_req req = {
+		.flood_domain_idx = __cpu_to_le32(mdb->flood_domain->idx),
+		.vid = __cpu_to_le16(mdb->vid),
+	};
+
+	memcpy(req.mac, mdb->addr, ETH_ALEN);
+
+	return prestera_cmd(mdb->sw, PRESTERA_CMD_TYPE_MDB_CREATE, &req.cmd,
+			    sizeof(req));
+}
+
+int prestera_hw_mdb_destroy(struct prestera_mdb_entry *mdb)
+{
+	struct prestera_msg_mdb_destroy_req req = {
+		.flood_domain_idx = __cpu_to_le32(mdb->flood_domain->idx),
+		.vid = __cpu_to_le16(mdb->vid),
+	};
+
+	memcpy(req.mac, mdb->addr, ETH_ALEN);
+
+	return prestera_cmd(mdb->sw, PRESTERA_CMD_TYPE_MDB_DESTROY, &req.cmd,
+			    sizeof(req));
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index d3fdfe244f87..56e043146dd2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -144,6 +144,8 @@ struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
 struct prestera_iface;
+struct prestera_flood_domain;
+struct prestera_mdb_entry;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -302,4 +304,13 @@ int prestera_hw_policer_release(struct prestera_switch *sw,
 int prestera_hw_policer_sr_tcm_set(struct prestera_switch *sw,
 				   u32 policer_id, u64 cir, u32 cbs);
 
+/* Flood domain / MDB API */
+int prestera_hw_flood_domain_create(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_destroy(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_set(struct prestera_flood_domain *domain);
+int prestera_hw_flood_domain_ports_reset(struct prestera_flood_domain *domain);
+
+int prestera_hw_mdb_create(struct prestera_mdb_entry *mdb);
+int prestera_hw_mdb_destroy(struct prestera_mdb_entry *mdb);
+
 #endif /* _PRESTERA_HW_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 0e8eecbe13e1..4b95ef393b6e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -600,6 +600,30 @@ static struct prestera_lag *prestera_lag_by_dev(struct prestera_switch *sw,
 	return NULL;
 }
 
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id)
+{
+	struct prestera_lag *lag;
+	int free_id = -1;
+	int id;
+
+	for (id = 0; id < sw->lag_max; id++) {
+		lag = prestera_lag_by_id(sw, id);
+		if (lag->member_count) {
+			if (lag->dev == lag_dev) {
+				*lag_id = id;
+				return 0;
+			}
+		} else if (free_id < 0) {
+			free_id = id;
+		}
+	}
+	if (free_id < 0)
+		return -ENOSPC;
+	*lag_id = free_id;
+	return 0;
+}
+
 static struct prestera_lag *prestera_lag_create(struct prestera_switch *sw,
 						struct net_device *lag_dev)
 {
-- 
2.17.1

