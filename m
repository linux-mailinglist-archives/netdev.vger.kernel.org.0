Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F306531793
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiEWTKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiEWTI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:08:27 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20105.outbound.protection.outlook.com [40.107.2.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5921A33AB;
        Mon, 23 May 2022 11:45:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsEh4qDzb2sipvViYAk+h6UwmbPGi1cpXGmfU2d0y36PtIQifejPw0Wi9lBKJ8X7qwyZeMtt3jfrSzkdHjcRgr9sXw0rBS9prDYE+29fkK64FBK4cvW40C3BVAtLExLbupFraWOr+XfPb5KdQUy0rIbpeqYciRqUT7K4oNE08KGJc9P711FfhuQkM9qjx0pgPRHhGAFu02Gq5LRsvb9FLI4Scf1Yqu3NEmW0Xu9vl735WUKcNKqrkB/GfAqjGMCVrUeLQKEgNQb4zfD8nYZNpxaf141GDGcG7Qw7k41/b5p2uRE4/vS0NhoWhch5+AtBJpyPyxOfaRW3Bd8lEDBhbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U67xdfdlvOmaHYZwfOI63Wt4KwdhhSX57Gcnb42lSPA=;
 b=YH29u92ceGm4zCJn9cCxs1aKjz0GqADURglzleeNM2EVrMWe9iipeGOrXAmG0aq2VCVCcSc/rCBeIJLrdiVzO8Cx3J4Y3kYaHFQ4J5JSMF/D8crHIc4GhHzpAUo59VuP0xzXbWw257yCMK46MBTE/EnDcEsyqJ7m/Rcsqoy0kmWb1Oz20jtUfBL/e89hEXAdUyRGOYEu/8/Q1tZYI1QPrxBEXEVQIZm/wxsWsd8yRyJJpvSC4G01Mi7INHsG/mHek+UzQZBE6VRkRsx6oLDM4lu++gi6m4v4KC03ei2PkPf96FP45e7m98XAiVujhCkxDkOVNgp9ua5UE5F5GyubfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U67xdfdlvOmaHYZwfOI63Wt4KwdhhSX57Gcnb42lSPA=;
 b=rVK6s4T9mhtHQkbsYFVV5obiYh3ColJOUjP5kNmxhCR2hW6A9yaTW5ktmyul9f3YN/HC5EQfp9Pf63W67UBQ6RTE60ZrWi2Toy4okdWd8vmxZDUK+NC88C2ZQhKdmItVTKxQYh5YT7VdMxwO7XDoreIn4OpLC1vPMN9kW4Nb0fA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB6P190MB0535.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:3e::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.20; Mon, 23 May 2022 18:45:04 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::b51c:d334:b74c:1677%7]) with mapi id 15.20.5273.017; Mon, 23 May 2022
 18:45:04 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
Date:   Mon, 23 May 2022 21:44:37 +0300
Message-Id: <20220523184439.5567-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
References: <20220523184439.5567-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c2ae09f-742d-418c-9b29-08da3cec59bb
X-MS-TrafficTypeDiagnostic: DB6P190MB0535:EE_
X-Microsoft-Antispam-PRVS: <DB6P190MB0535635688DD843838F813B3E4D49@DB6P190MB0535.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ars8V0sLY90Ac4WrdMIpEfSlIrZBXCaB+STQK3wgjC8EZNEgmGVFg5Z+ZBgS+eeowox3dEtjUpQWzghPfb4cmByT/k5Im7BPPkPAxsqlqomyxwiRGkSjBFiTIvwfOVvau40QD9DJiqQsLFOh4S6B+hzQMKrpT3SWK7UDPFZEnhenc5q8WQi64czxRBljv5AvRSesUDJwlR6Rhc5x9HzAq6CPcH5XJtjRY0JxTrPE3h3JuJZ6LYeGUepYSQUbtlu52eCiSfhuDHNhNa2JeCge0O8ZbFRM7wVVZkxxZUBaoUkINPGshDOtlL+mI5V0XqK7MFcDRjooCO0BFNWzmceRsZ/QZ0hkVm9g+UiNzQjbMPR6hloJlAZwoVejD8oDokk+XFCsjK31YTaSAXBSHzvQ3KDRzYE9TWRULXh/eUZ2K2pdMzEPbWEBZ2t6mp1HVgv+9TSHou1ivoh3yoi0of+fVW5uCYAr9IM/sVjToJoSwEwXpnpEijXAYtzbCoL4w92Ly1n3cEpy1OZVEDVsjA2p5LDsaIx1paqBQ+9r4iKwFk8LBMnBAptbgGoM7yUNxBPlI7nEY+CR1tVVyd2tnqVQBy/bc/coEyQhWR2bcB/3+HcVH3Kwi2eyqJ7E2uu003YB8Lor+mPqX5W1GYmif8nyCh2z3OjeDzq/X5KIR+0ZETeJVgJOcgUEbJgbEbCdo0jeif7n5WpMCZN/s5VMPXTGoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(52116002)(6506007)(6512007)(44832011)(36756003)(5660300002)(8936002)(38100700002)(38350700002)(6666004)(2906002)(4326008)(110136005)(508600001)(66946007)(86362001)(66476007)(8676002)(66556008)(2616005)(1076003)(186003)(83380400001)(66574015)(6486002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HF1DUlmFFu1eTuMX4UGx5GEQUou2ZgHhF5aOnH/TXyPSIWPxzM0jr6c1k0cv?=
 =?us-ascii?Q?1ugQqkTLy3xDH758Nt3ezkys4SmsuWpmd7RMpS8LLu1ANPrDcyuVpHXIStPR?=
 =?us-ascii?Q?OqTvvSLXxobJB75rcVyD8N9g68jNwCqB0LJ7gzaNR7ZOuvpO2sUhvmbKo9k+?=
 =?us-ascii?Q?CVdwRYLrcI+gFuNfeuDbmw8QxfjIUba08D/adaLPgE1K1COffxLIFY5Sp6ak?=
 =?us-ascii?Q?Oab+fVYIK8cSWrodWfT0t0w23WABbrtp01JMLWf9FvLi4OlwFYFtL8Bynyge?=
 =?us-ascii?Q?DRnWrwYf1plJAvdW6qVNz3pesAPAb/o1HnDV+GpEKkk/zujYzA9/uffyND7s?=
 =?us-ascii?Q?4uJcgw3O31uaRcbaGomq3y3chdaU+TnNTDEIdWWGsfzCOI1V4MgLUBlD3MgN?=
 =?us-ascii?Q?pzU6H3DGu2xjA5/nS9JsjXhclET3Qh0osgU4eToP2lSXwlu6DHfa7r9tG+X0?=
 =?us-ascii?Q?nCtWYsm9GepgBHiOUdBWNcgWji0IoCslkhcP2Dly91KymCYOWdpgeZabTyw/?=
 =?us-ascii?Q?stsfHDTJTy+Ot77VqVxTS4tiHMHFe4G5HimPiBGtdJKZ3FjPeK3r2WZMJBm1?=
 =?us-ascii?Q?uu7oyuR2Q1WHHzFlHxnNbI/ymEcK8tRcKiWn7Nenvg3ZQvVaY/5bCaNqAowT?=
 =?us-ascii?Q?yao9uBmUheeLO/2heOAyu+My8Y/lseqRk8cHgi66zpsptm8evgDZ4JceFWxF?=
 =?us-ascii?Q?b84dE4oeFlAbj0Ap6ISp9aLVAp8UmwbEXhRt9BGcLV9PXg1J/fdN7/4qjGDS?=
 =?us-ascii?Q?BZdBiS1YjOJUStRJxWeWELlzkGWQuuelNjCuH6qgUXbBWnySwJcA6ZsJa9Dw?=
 =?us-ascii?Q?LfkHCpRS6WjPzzBiirl/4uz9IpnMh34A3b1ZHVYgrhC0v6oi7q8CiSHi62pj?=
 =?us-ascii?Q?Rzg7/BFcOIYpnd2BMG67jW+nTu9KjMo+uxjVN1sas548KmMcPgWZU+Uy6C+6?=
 =?us-ascii?Q?/tvMTo2zfR6LCMyG1h2RQDjuFzF3dPGOtT+HR9b7XGwgsBiukX1duIz5sXYx?=
 =?us-ascii?Q?RAMpK9t7K6edSi0Lyyq6ZE3jJYSAZeAk4H3E0wurGDRKyyPUsLIy30yNVAqL?=
 =?us-ascii?Q?7cJQDhiK25lMWlAIn3SzKiIZiL/o5CNauwRJtLgVEC6kGIPXIxBH0bH3Dob7?=
 =?us-ascii?Q?NPgUuEhlHigLMwG65/1TxAoe5EOieEyMmsQe/Ddj44mJYtSBfZ3cn748vBeh?=
 =?us-ascii?Q?XPxg3AQh7lJyXkkDZe+/XhxeQQeCOwxdGMQmIFcfqJYWSaC/ZJcFD2ICdjJx?=
 =?us-ascii?Q?8N3H0wA1yrOdxI7+BJobHi/sYHw812daVb0+Wt9QN2jEe8SdrgYcGxhNGnz9?=
 =?us-ascii?Q?mogoXyMN9S2qX3u51883aatB5M+bc0Sy9/0zTPhtquswB1mzLXd8euqTbDTB?=
 =?us-ascii?Q?xTY96tzgFhWV4KSMIR2Hb39UTLC6hXmLZOq/mh3TDcsGP6//vGvMQ7R33/Y6?=
 =?us-ascii?Q?UzSK7Ns8CL+k/66U+aS2wGp+KGltPp5WHAh5CmnRXQRwF/FmCPx8NGdpmsuF?=
 =?us-ascii?Q?G2Ma20CgcURkHkv00QmcHPs1uCoZuo4HboskzWbbxQRuKX4PI36m4LMV0ghE?=
 =?us-ascii?Q?zbrcQhwz3+/9IYSu7ap36m2svssWusokYYyqvqcamBEssQCWgvaTm9e9E511?=
 =?us-ascii?Q?IeiAIoYgXDI+1il9g8jOJvyTwSUuAYSdzcoupA06D9Hhz2KaR+DaA93BVcKB?=
 =?us-ascii?Q?fMbo3VKjqYGP7ayLFAFxlvMU9HpRSXX07ZqRBSKJSFYIjzOpKcTb6Cf/IDlt?=
 =?us-ascii?Q?U9KCfh7W3VZ7nU07cFTt9Mmchaij/MM=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2ae09f-742d-418c-9b29-08da3cec59bb
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 18:45:04.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OY/CKvaR+q+kdi4f4K+AYRRqxLOGZD8DkFwfFhU/QaoPaagE1b3ah9oPPa1se4keh2JjvJYLBmgudoqJeTpdOoQvYP2/c/ZAJBR2Z/9sJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0535
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
 .../net/ethernet/marvell/prestera/prestera.h  | 22 ++++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 72 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   | 11 +++
 .../ethernet/marvell/prestera/prestera_main.c | 24 +++++++
 4 files changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 837e7a3b361b..9c7d59fbbc83 100644
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
@@ -341,6 +361,8 @@ bool prestera_netdev_check(const struct net_device *dev);
 int prestera_is_valid_mac_addr(struct prestera_port *port, const u8 *addr);
 
 bool prestera_port_is_lag_member(const struct prestera_port *port);
+int prestera_lag_id(struct prestera_switch *sw,
+		    struct net_device *lag_dev, u16 *lag_id);
 
 struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index b00e69fabc6b..577d3c1d76d7 100644
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
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 3eb99eb8c2da..838c02bd55fb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -143,6 +143,8 @@ struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
 struct prestera_iface;
+struct prestera_flood_domain;
+struct prestera_mdb_entry;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -301,4 +303,13 @@ int prestera_hw_policer_release(struct prestera_switch *sw,
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

