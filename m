Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55CA650516
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 23:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiLRWRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 17:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiLRWRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 17:17:05 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2090.outbound.protection.outlook.com [40.107.14.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ABDDEB0;
        Sun, 18 Dec 2022 14:16:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjTOgCC3oFmT8E8oKHhxhOyt9Uc5xvtJG7Mv4HtSdjgiluNL9EdlCObGGXHMpD2XAs3F0m62KLM3lHuFfs1BzBQQwV3sXrCB1z4imiJTsxE3aa58+TTn7uTLL9bi5j2ytbw3EG0dh/8QJmafueAcXNZdIWdhlQUIQJ8O8CB20kpau4D2eXJQCvl8nGtTWTpWueB1vcI4+DR4OLGoNS00omOw8vlMpQ1KsjXvc+AcD5xxvaFIiGBwiuSWKtqhXWlBdWY2USYG/w0ZIR0CzxRC3zV6A5JZmfv6zLkuK6ALwPE5NaWeAnahxujfCn1OER8rycvI4oSpCFBNjy/Gy5a5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVl0bRnwhCyCunAdFaJQgHmqfLtc3gHzshJQsRbq0p8=;
 b=j2MNwKrJTEowI/v2o8uAaW1e+7yopvrwqXQ1OMyqLnRadn2qGB2kLIu7LYtQP7/dCL6yfieeicDBegU1xWwH9E6caiFaTHBli2XfpybS45Sq8VUDwo5LsFFZXYqI7dwtYvaiJ6kuhMNGechCL6ZQcbEJ34ucOvCGZfaz56Yp7v8nydUXB53zUyJHf2vov42g/AfKY6wQuDoxmVzdijrgZ9UknjI/XM4SooZJuye8Nmcuj/jOCeGVcJrmzAFKA1qTm/iBjMT4ZiVUuTO57MfbWJKH5EjG8v/w9OPGFwGJBhIo64UOEr+ojeXCGgj03Cg3c1La9Q3KMZMntDUMhVEPow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVl0bRnwhCyCunAdFaJQgHmqfLtc3gHzshJQsRbq0p8=;
 b=A1z3vkH3yBssnAcICjalW6yiE9Z4aLg8q/Kt+sMovHIx/jTh3DyT5+8EwJU1EV1UMOWhC8BHnhVTUoKOI95EG0Qn3X0GC45kd9GOs2IimYNUhfOEE6w8iaB1aJm9yrMH16P+s+XTH33FDyZavK4rt8UIjAQOhh5j391HeNzj25E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by GV1P190MB1874.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 22:16:54 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::16a:8656:2013:736f%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 22:16:54 +0000
Date:   Mon, 19 Dec 2022 00:16:40 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/2] net: marvell: prestera: Add router ipv6 ABI
Message-ID: <Y5+RSF0Had10xizI@yorlov.ow.s>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::6) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|GV1P190MB1874:EE_
X-MS-Office365-Filtering-Correlation-Id: ad724323-7af3-4247-49a3-08dae14591a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNc/CDJ7Vw6ci+PXuLS/Q+/9uJpeuAeie27Bbl6TZdL52l1Ec94QGG/UbCd1ripsF64voGf8R8cpRR6xfZ9jivCy7Hzz1WkzsYLagm7Xx9NSORZKGdNeUVruqEKLK3t+xHsJ2UFq2RcX5zbqZZFWpD0lP0K52Lb7rneGwopEduiJrGRabvpXX7rseqrR30nXkDZ2GJ5zuI+fmH79CYp4Nq5QiT2nzaBlamc3OJrL52gA4a+hy29fL6ItGD+Rg8rj48umK4Uc+pvn3NubxHpL64lKI9v5eYcBgcT9+ALY3MA7T2yRcsSdYsVSRAxzLHMplAd82D3fbRM8vCphME2CFWPtRl5DLnQlM50Z//Tt5Fm4VyBUEALO0IQbWMt70SEqV12S4VLp9MeR8hPSx19UhKMkHjc6C+mxIul6g+MyH8EwGGmaFwNJSda7arx7Fv4LSJszEI5US+bocBMLU4XKs4qJLHQjFY/aTs6FCXvq8Ouw6qO475zyBSv7Ghrqf4G9kbQI1+saPJVcsEglx5iquE2CzQ4R1zm82x2pNLYLj0Fk7dWER0bybNKpb3MF+O+YcROjexBKBvfPvtLWWAKO+WY/VPBk648wsrZD57/Mt5Kp4uG7jWv3XkJuA0yLOdvM7K428ZHkuFC4xt5YhGJ1K3ATCjeHytSf3gjwmNm+CMSBs/9R07L5c14s3FR8+gSy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(396003)(39830400003)(451199015)(6666004)(478600001)(6506007)(6486002)(38100700002)(6512007)(186003)(9686003)(26005)(41300700001)(44832011)(54906003)(6916009)(316002)(2906002)(66476007)(8676002)(66946007)(66556008)(4326008)(8936002)(83380400001)(5660300002)(86362001)(66574015)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gv7duOs25p/G5diwXe9639lzl8BtV7OU7EudshzNBBVb3TgsdZN7gcnIxvZs?=
 =?us-ascii?Q?0xPQzHNT5uf+aUm27gzUxq6o07n1fuddrN/3ay/7l8lPeefwLbDL4TzKHR6y?=
 =?us-ascii?Q?IOVQFrR+rw6tdjQHweo78FSqFhR3SS1iSepE2EwsKJAvT+rVemAJSQma5MAl?=
 =?us-ascii?Q?laFz9iMA11UVroVDtwklmAPXu3YhsaR5gpYv0LmhfZQJu9WVaTFWwoTYgJyJ?=
 =?us-ascii?Q?bwOMecICCI6EOGdwMzsxxgyAYkODE+FAAmJufBAmcHsfW6K8v3H+TX12JGKP?=
 =?us-ascii?Q?+FTP3ZUgqI3M76fwnLSUcgeL7RIc510yXdu6C5VBuarcj//urqM6SbpNiiUP?=
 =?us-ascii?Q?654Lob3wjUam4Y4OBqe+OqO227T39Xa9uHWnzWql/aIa7Z7L1bSq8UBmjDkw?=
 =?us-ascii?Q?F6AECTlfeBuoWcnTr/SajUqM7Xs9SWOYdc63VFozzSQooqAWhDpUCjsTSdGT?=
 =?us-ascii?Q?xyhFHPjC1sQmcshEyxF+7FsdaouBDXf4/ux5DLbHyvZEcv7wRQgG0msXsZRD?=
 =?us-ascii?Q?9iNqkS+xeaiHdivNGkRp/+7AOjh2Awz3JOcy4BtN42g+4Qias/s9LxteaREO?=
 =?us-ascii?Q?A5YokrQNML5tjwqLVNSVk6m426Tsbinx2Yz2XOqAts4egLloCXf71ZCHg1tx?=
 =?us-ascii?Q?XOL6ALpoLDBKNgUaWct3LxEsWJ5q6+k0OlCF1RqewClYbZUVt6BaNJVravdm?=
 =?us-ascii?Q?SUeyNl6lf62FI9R7FRL0w45xWs1W0aXotAdkglWvC9SxzBAVa0K/ZW2d1QVy?=
 =?us-ascii?Q?VuV7asb4tkDagA+ra8/sZ2Gg8pDWe+WZxypMruR4oaYKsdQ3CDxuGBR/lLXA?=
 =?us-ascii?Q?RKi0Fc8JJwk3IeLPTvngvIPuQSgglUh3m6FBNTyxm5nK7ayrLbLc6UZZiGRx?=
 =?us-ascii?Q?gJjyt+Ozsh+E5GyF4YYzhJcQ+tWSiyVar0itpLfSfVuogiJj6aoCtpfSWgjn?=
 =?us-ascii?Q?7aIoU4jSsf46I4tfgjAF3Fi1PD7fkuYfSKO2SjhNPRYD1SL8hbiiA0FZCFU3?=
 =?us-ascii?Q?aNcUYiUL9bdC1PuR0EDL/VeVhMdcPe2i4Hlu0lr2OTR9k1TjNP1FjeQCmHxT?=
 =?us-ascii?Q?0LXmQMRB/GHqpJHtHzWc1RG+FjFwNLJo8gWZwXTqQkDe0grNr32a1/m4ItBH?=
 =?us-ascii?Q?bCoxVsuWDG/2P38YMOaoU7gM2NsYxW3PmgIaM+gYdi2oxkI5LFo7a3z2qyxV?=
 =?us-ascii?Q?tZKLskdgGTlIlqanePOjFHjTj+ZvECWVOEfYiXKpwXKKuDdwmYjFASISWxfq?=
 =?us-ascii?Q?Wb0K+xNqP+kUXWBiGmDkNWLUaXm0nIa84XFVBLZdSIQp5+NgIao1XlDsbKf8?=
 =?us-ascii?Q?Uqt+B+PewFRN3cqVQdSvXrfZz29J364iGKT7xpJzT+PhMqIPnqcqiDY/YiXl?=
 =?us-ascii?Q?P7sjoE9VV0CnNNGWXvPkrYWY2vq+bCPaLJsdQwW0qJzKQrI5jEIkptIIVn+l?=
 =?us-ascii?Q?qhy1ekbf46rJHWl/gg1M3Mzeqc82Vvb7zJCyoo/WP85rHFkdMSyxYsbd3z9n?=
 =?us-ascii?Q?S1ap8Od0gKdcjmTumrJe94o9zFNiuEbm/5CcY71Jw+vncXOKOL7/YgVTOBQx?=
 =?us-ascii?Q?AGRIu264Q55fjz4BfDV3ysKOyK5/TdKA78VC64qsf2fUo7j18ex5vvvVUyG9?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ad724323-7af3-4247-49a3-08dae14591a6
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 22:16:53.9871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Wcqjobo0UHGNia8udHEdYtVos46uG4NQfJgku2739RX7rUkqsv6ItCO+RiDTY2gNjAPPLLvfVLOHUeX1i2RfUumat9tJso4x6VYKmJN3e4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P190MB1874
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are only lpm add/del for ipv6 needed.
Nexthops indexes shared with ipv4.

Limitations:
- Only "local" and "main" tables supported
- Only generic interfaces supported for router (no bridges or vlans)

Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
Co-developed-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 34 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 +++
 .../marvell/prestera/prestera_router_hw.c     | 33 ++++++++++++++----
 3 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index fc6f7d2746e8..13341056599a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -540,6 +540,11 @@ struct prestera_msg_iface {
 	u8 __pad[3];
 };
 
+enum prestera_msg_ip_addr_v {
+	PRESTERA_MSG_IPV4 = 0,
+	PRESTERA_MSG_IPV6
+};
+
 struct prestera_msg_ip_addr {
 	union {
 		__be32 ipv4;
@@ -2088,6 +2093,35 @@ int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
 			    sizeof(req));
 }
 
+int prestera_hw_lpm6_add(struct prestera_switch *sw, u16 vr_id,
+			 __u8 *dst, u32 dst_len, u32 grp_id)
+{
+	struct prestera_msg_lpm_req req;
+
+	req.dst.v = PRESTERA_MSG_IPV6;
+	memcpy(&req.dst.u.ipv6, dst, 16);
+	req.dst_len = __cpu_to_le32(dst_len);
+	req.vr_id = __cpu_to_le16(vr_id);
+	req.grp_id = __cpu_to_le32(grp_id);
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_ADD, &req.cmd,
+			    sizeof(req));
+}
+
+int prestera_hw_lpm6_del(struct prestera_switch *sw, u16 vr_id,
+			 __u8 *dst, u32 dst_len)
+{
+	struct prestera_msg_lpm_req req;
+
+	req.dst.v = PRESTERA_MSG_IPV6;
+	memcpy(&req.dst.u.ipv6, dst, 16);
+	req.dst_len = __cpu_to_le32(dst_len);
+	req.vr_id = __cpu_to_le16(vr_id);
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_LPM_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
 			       struct prestera_neigh_info *nhs, u32 grp_id)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 0a929279e1ce..8769be6752bc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -266,6 +266,10 @@ int prestera_hw_lpm_add(struct prestera_switch *sw, u16 vr_id,
 			__be32 dst, u32 dst_len, u32 grp_id);
 int prestera_hw_lpm_del(struct prestera_switch *sw, u16 vr_id,
 			__be32 dst, u32 dst_len);
+int prestera_hw_lpm6_add(struct prestera_switch *sw, u16 vr_id,
+			 __u8 *dst, u32 dst_len, u32 grp_id);
+int prestera_hw_lpm6_del(struct prestera_switch *sw, u16 vr_id,
+			 __u8 *dst, u32 dst_len);
 
 /* NH API */
 int prestera_hw_nh_entries_set(struct prestera_switch *sw, int count,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 02faaea2aefa..1c6d0cdbdfdf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -581,8 +581,16 @@ static void __prestera_fib_node_destruct(struct prestera_switch *sw,
 	struct prestera_vr *vr;
 
 	vr = fib_node->info.vr;
-	prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
-			    fib_node->key.prefix_len);
+	if (fib_node->key.addr.v == PRESTERA_IPV4)
+		prestera_hw_lpm_del(sw, vr->hw_vr_id, fib_node->key.addr.u.ipv4,
+				    fib_node->key.prefix_len);
+	else if (fib_node->key.addr.v == PRESTERA_IPV6)
+		prestera_hw_lpm6_del(sw, vr->hw_vr_id,
+				     (u8 *)&fib_node->key.addr.u.ipv6.s6_addr,
+				     fib_node->key.prefix_len);
+	else
+		WARN(1, "Invalid address version. Memory corrupted?");
+
 	switch (fib_node->info.type) {
 	case PRESTERA_FIB_TYPE_UC_NH:
 		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
@@ -661,8 +669,16 @@ prestera_fib_node_create(struct prestera_switch *sw,
 		goto err_nh_grp_get;
 	}
 
-	err = prestera_hw_lpm_add(sw, vr->hw_vr_id, key->addr.u.ipv4,
-				  key->prefix_len, grp_id);
+	if (key->addr.v == PRESTERA_IPV4)
+		err = prestera_hw_lpm_add(sw, vr->hw_vr_id, key->addr.u.ipv4,
+					  key->prefix_len, grp_id);
+	else if (key->addr.v == PRESTERA_IPV6)
+		err = prestera_hw_lpm6_add(sw, vr->hw_vr_id,
+					   (u8 *)&key->addr.u.ipv6.s6_addr,
+					   key->prefix_len, grp_id);
+	else
+		WARN(1, "Invalid address version. Memory corrupted?");
+
 	if (err)
 		goto err_lpm_add;
 
@@ -674,8 +690,13 @@ prestera_fib_node_create(struct prestera_switch *sw,
 	return fib_node;
 
 err_ht_insert:
-	prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
-			    key->prefix_len);
+	if (key->addr.v == PRESTERA_IPV4)
+		prestera_hw_lpm_del(sw, vr->hw_vr_id, key->addr.u.ipv4,
+				    key->prefix_len);
+	else if (key->addr.v == PRESTERA_IPV6)
+		prestera_hw_lpm6_del(sw, vr->hw_vr_id,
+				     (u8 *)&key->addr.u.ipv6.s6_addr,
+				     key->prefix_len);
 err_lpm_add:
 	if (fib_type == PRESTERA_FIB_TYPE_UC_NH)
 		prestera_nexthop_group_put(sw, fib_node->info.nh_grp);
-- 
2.17.1

