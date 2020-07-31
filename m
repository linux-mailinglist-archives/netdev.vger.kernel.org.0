Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5FA233D0C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbgGaB6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:58:24 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:58208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730904AbgGaB6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:58:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsrpPOYIZyIt6dL9AVg4BKUqXfkb6UxP5qRAzfIPcXXVqsFYVPzZaiXR9gdhPuncn/KXRuP1mkEjKrWAJ0BHZ8a2jXhEk1EXXcmdgjB+1ObZCjXmr2ha0Y1U4Au03JmXtMqUFzlJNwzGn5XadX0A+SONXjQeskI1npLWuk/Hjg6DTEIQSiiSVvvBQcH/msOGnOZsv8wXN1tTJN8Z6rNhKPIAjNSrt/Mumb5zNoR6AFbC75K6qc0PIZqwMxzIE7eopaEspsPRDDkwCpgYLDfdm1uPKKvISMCLaj8CcCfheHK0nhQYSbjgLkYqeNC3SxY0WM9IfiMNlfbx7ON61T1iRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ejt3eQFapB9t3wDl+yzZEgAMQ2QkyYbrWnkddLenOxs=;
 b=fTsH9+f+QGOTldYhzMatEorqhPfPcOv1XhtbkdtgacufaUpmiCBsFRDg96/gLO+IKpCjo5jgBIqm+Ght9P/IQCCM0omZPz2xOoLxZiRVlGDVsUvt0sBB4DEtBbeE/+cT0tkustWsQd1OJwtNbJ59dTUtzUe2F2l8CmGBz9AIztlY2NjLasQVDuJrcV3YkQaMv2H/WkP0Pk/OqBOt4gtOT2d/bUrOnrHMVtqjLwcdTvm4MPpGfTsRdvhBnDErmUBTgAmtNPyMOvAjH2xz49ZcoXqHaGg5wrZ6B2VuBhvaYfaZoAFQlAdnv2Pk9uAZixm09P4Pkc63RSJcN/zuxB4gdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ejt3eQFapB9t3wDl+yzZEgAMQ2QkyYbrWnkddLenOxs=;
 b=CLMS6EDgaU8YY9lOX2RgIBIubOys0OEJcwjexZmqlGu4onFLinRZ3wzJZA+VytHnEs64mE3khFKHrStfpTa/2VcbepE0IF6WJvD4VGcxI46iMApcdKmatq8S5WCEeXsPVj4MUihTv5PaSvM9yeK3bKpjWigXtQ2E6ztRnvoSPVU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3997.eurprd05.prod.outlook.com (2603:10a6:803:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 01:58:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 01:58:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/4] net/mlx5e: CT: Support restore ipv6 tunnel
Date:   Thu, 30 Jul 2020 18:57:49 -0700
Message-Id: <20200731015752.28665-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731015752.28665-1-saeedm@mellanox.com>
References: <20200731015752.28665-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 01:58:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5a5824a-8f8d-4fa5-a179-08d834f530e4
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB39971B332F0813ECE03A4761BE4E0@VI1PR0502MB3997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wbWoO//ZwjtmxOMIvAP9+geD7jtRsNc36MVKDSUET0D8FXKpHMiBE9BB3wBLwmzBElsxXjcRRWPq+0DN8xNL3030xsPFGk7hLK0w2bMUGwdTZ5td6TAjiqs08IWnJQ+0uiQjTm6PLYrgWsgXyx32sq/086Ttr1k6iNbvWC0D6vE7DebRmOMRVKtGNfiVsAYn3Kv31wIldwzXAtmxE7JCenxIP2wk8wmz7/FimJfvZC2aVplVY96AWfCyfboeAIcnW0eHJwr9xwLpVOi24UhBLq9+jkWSsOuueOFK0071+rlM7lHmtKgYQKtSWJGEcM5aj+VmZ3eXL9R/wXF4OOsxmlXE2bVzuG6nA/UL0f/h3pl8HSPR7MkCn7KQakQCiHi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(4326008)(5660300002)(1076003)(16526019)(6506007)(6666004)(52116002)(186003)(26005)(478600001)(107886003)(6512007)(316002)(54906003)(6916009)(8936002)(36756003)(66946007)(66476007)(66556008)(2906002)(83380400001)(2616005)(956004)(86362001)(6486002)(8676002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ETFpN1/Dt/ZdO587viZlvQlabZDH3K9bfdey+BybJcCyiltxabavLDQqIMDr9LYtMdBR//dsX0BEMaDG5N5Cbc921F5w3NPYH5mNE+5Z1XsnhW7gyTZ8nKPZtRtPQQFwFQ+7cqL90WvW9TmQA8kfTLNNOOF0rMowCrNmGwOrLGpXjrlHmQ1tC0u1AZGuEgBH5NwhGJhk3hk+eMTzYyD+uYX48ZNHopMpiC1Ib/yD0NwQaogvIyQPmBKCVFz0pj/TC5D5V0XWBtdVovLGTehAPQFMkS4nODC5CzpvgrjwHFQO66DQPSkA916Z24kU148lVedXfa5Tc9ue+YYKYZG0bfpRoRWhR7EqTZOzcYtLV47yTO65o/SMvgCe9NIWDI1F0H2z5mVxUFCqJIPdKCbdDS/eYD5dRIhby9jI6alRjNJAv0zEIPWwL152boXGhp0nO1HK6o54C8DYOsnxmHGbUIJVl1QK2rMk+gOzAPdiu5bad7JSuNEn+SV0Eec8xauMJOd0xhb/i7fpLnVBba2XvEC5gWMZExsi8lV7TiqVXRYpqSljd6+sMBoWs2aR/iCDO7Pa76dG4lGFjEo7evuk9qqIjiMeqTplIz5lJkLapga8GR/oSrK+aCnrc2eZ1iffgseV7ormo2qSoZ8nKjIZOQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a5824a-8f8d-4fa5-a179-08d834f530e4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 01:58:16.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hn2eU7V01qCs4G1NtB3t6Yvcd2MGrFAG/Z6NuYnm3SaYuYAAwySyuK6/vk0FuUWeWzwPvbMWAcyGGKFyPbVGUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

Currently the driver restores only IPv4 tunnel headers.
Add support for restoring IPv6 tunnel header.

Fixes: b8ce90370977 ("net/mlx5e: Restore tunnel metadata on miss")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 30 +++++++++++++------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index eefeb1cdc2ee5..245a99f69641d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -551,19 +551,31 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 		}
 	}
 
-	tun_dst = tun_rx_dst(enc_opts.key.len);
+	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
+					   key.enc_ip.tos, key.enc_ip.ttl,
+					   key.enc_tp.dst, TUNNEL_KEY,
+					   key32_to_tunnel_id(key.enc_key_id.keyid),
+					   enc_opts.key.len);
+	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
+					     key.enc_ip.tos, key.enc_ip.ttl,
+					     key.enc_tp.dst, 0, TUNNEL_KEY,
+					     key32_to_tunnel_id(key.enc_key_id.keyid),
+					     enc_opts.key.len);
+	} else {
+		netdev_dbg(priv->netdev,
+			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
+			   key.enc_control.addr_type);
+		return false;
+	}
+
 	if (!tun_dst) {
-		WARN_ON_ONCE(true);
+		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
 		return false;
 	}
 
-	ip_tunnel_key_init(&tun_dst->u.tun_info.key,
-			   key.enc_ipv4.src, key.enc_ipv4.dst,
-			   key.enc_ip.tos, key.enc_ip.ttl,
-			   0, /* label */
-			   key.enc_tp.src, key.enc_tp.dst,
-			   key32_to_tunnel_id(key.enc_key_id.keyid),
-			   TUNNEL_KEY);
+	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
 
 	if (enc_opts.key.len)
 		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
-- 
2.26.2

