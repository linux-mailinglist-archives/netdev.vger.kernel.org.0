Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7735D1E8DCD
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgE3E1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:11 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bW6hIM1ZBknYQbpQxBAHj2nvps/ZmJLoNrjEIowEaAjLHqKKfnpFqZxNZYAsHfKTPx7uN4O16Hn2NpvQ7lSP5KY8I7n/wT8d2/axIP5gdkftLD3meMhBaxB41R0EW87sPCsyHuf2CNCPX25QLXLU8+BP/J7sq+aBeiFFurAj8vwd1rVu+v1eb6xN/u4egz4mVLVJQJdjvpQThfl9Rb+NEv4aYFLZRMF+D8LYXwRZWq/eKXdQIZeMZ5vZqepDCsKamYRq8fELiPFjn+koWQfs8AnqnZ0TFCFp9dMfJRxdhRCSs08HAk3THnIHL2DCzEwXkthFAR+TYGqfZw+z3PcvXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGgODeHiIU5ib3j5u5F5CN44CDWE56jA+yGyQirGf6I=;
 b=dtJHP2ec1wZWtdvsAMwwCS/nuVQmIpUp7kfPDwi8nU7wBJpEipTCpS49fbwRa/UUhdctw3Wqeu2BN3OiQuqx6ME/WKpb1+4BWnBU8dOA2p2AeNyxNPQxqWV26/1gIWVuI0o8h+kMKNDiaGs6BpIv9ARminU1L/UCRPYLW9iTQOhKQ9pQSJQ8HB6O93eYDBpB/V9Br176FGhoiBeBMHImUXCqpXLXLXOOBhEyNbdQ2GPvsbbN8iPU3Bf0hWLIP5USVI6eWqehmd2y0EWyN4P3WKmzA9VpbiZ3PuUb4eoWkjWarWzG7R8dK1IFyt0dVf85OLh2/Wy+uTiQmCekhR5Tag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGgODeHiIU5ib3j5u5F5CN44CDWE56jA+yGyQirGf6I=;
 b=S7TdpNOhsme2wMEbrrQoVHYo1rZQesxcmuwtRwJujLP6ml7GiFT57WoPbYE3ITSV6z28MdrigHtLBHLuy2PayXvnTLYpLYeWptR6syyoDj8yGbSdmIwhPTZbXc8S6CZpeoX2DFfc/YiBeY/obK6NkUujiVk+KA88dMdAwZhyYwg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] net/mlx5e: Use generic API to build MPLS label
Date:   Fri, 29 May 2020 21:26:17 -0700
Message-Id: <20200530042626.15837-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80860fee-31b4-4744-7c2c-08d80451b24d
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408BE8F4960AE93B3E6DC20BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5kwdIVRTjE8Ye12wZDKFy1uGU1ThYr9+/5gK/Y2kgHcFirmrpi2MjQMN5hbL5hUqEz+WB4A/5LIOOMUpe646SV7MHx/f+2rFJrEJicWHAjmobZK6ebmOw9SerDXb0nCIDUocMOzi1MYziNyfErWyK8Ycu6xH27EPsCiWl+qgvWFDBqzH2Q1R2vrRhu8pahMzs5U/Q0zqJFgixH9IpOPstZBsS1tntheoNKjykzXehC+q6UggGgiTEvNmirupg4x2ynUCbHcJhg9YKmmj5jA++EQom2tsOCDnay6pXIfLthtBrAtFHXqIPgKxmI6lgAcS7kPb/LIbnSQu/E0qYV/Uqf4ngXbRD+8EIqYoJ10jypOAJwjBp7jz0iNN2wvWnYiuNa8mRYt20YRW5pH8P9RdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(41533002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r2snFaequIV6R0NFqGAeEy5PwJuVhxEe79E7D6rbC4FXY7Y7U217u95lgLkvpilJgjKG1rFVQrVElZL3++iFCNQnYItKgAxD6PcOwLBBawe7IN6NXqRchwcwF5mZ166IqNAVWQ/aRP0aOU1fQfPftYlfbeTP5f9AlDlSAwYuFiLv4s4UgUA6hF/GqFTN0rMth5MmfH5pM5ZpspoUhRvXGa6NBsxyF6pVObv119RIHexoTFHkFVQ+K71uSaqLGLL2+lD8z5PjCdL0wLpCY3ZUCowvz8gZ8GWnGOFJeUZnClHsi1xGHfhdMjULdFedPdBNFujGYC9tnwmhOz5BRLreQ6fTRo9NfAgkIu+49hatJ8usDs9X89t6UAmfrqFf0lPmggQaR5RukC/OgrqfifE9shuixueZLlrwSFVIeOrXeEZSesZUDtu49G/ZYHgmGUzZGS9fwARAESlgb/7jrf6LPN5uCvqT85qINoXXoxYqJe8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80860fee-31b4-4744-7c2c-08d80451b24d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:00.5448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWaB+CpEImLMC/LXRkhDgwK8dipoCGf1HWz3F9c4dKVWg0RgPNuk2dvvJNcbVupLeWOrhbgyT+kIviUWX5tmIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Make use of generic API mpls_entry_encode() to build mpls label and get
rid of local function.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   | 20 +++----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index b4a3c96d34fdb..1f95262442221 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -25,35 +25,21 @@ static int init_encap_attr(struct net_device *tunnel_dev,
 	return 0;
 }
 
-static inline __be32 mpls_label_id_field(__be32 label, u8 tos, u8 ttl)
-{
-	u32 res;
-
-	/* mpls label is 32 bits long and construction as follows:
-	 * 20 bits label
-	 * 3 bits tos
-	 * 1 bit bottom of stack. Since we support only one label, this bit is
-	 *       always set.
-	 * 8 bits TTL
-	 */
-	res = be32_to_cpu(label) << 12 | 1 << 8 | (tos & 7) <<  9 | ttl;
-	return cpu_to_be32(res);
-}
-
 static int generate_ip_tun_hdr(char buf[],
 			       __u8 *ip_proto,
 			       struct mlx5e_encap_entry *r)
 {
 	const struct ip_tunnel_key *tun_key = &r->tun_info->key;
-	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct mpls_shim_hdr *mpls;
+	u32 tun_id;
 
+	tun_id = be32_to_cpu(tunnel_id_to_key32(tun_key->tun_id));
 	mpls = (struct mpls_shim_hdr *)(udp + 1);
 	*ip_proto = IPPROTO_UDP;
 
 	udp->dest = tun_key->tp_dst;
-	mpls->label_stack_entry = mpls_label_id_field(tun_id, tun_key->tos, tun_key->ttl);
+	*mpls = mpls_entry_encode(tun_id, tun_key->ttl, tun_key->tos, true);
 
 	return 0;
 }
-- 
2.26.2

