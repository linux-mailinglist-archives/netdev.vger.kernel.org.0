Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB91D5C8A
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:49 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJjIlAXdVxlD8Tnk98S3RxW5XBMQ3sFWrp3MxsLCFJaXSlLUNLjCaDE9PIa76bCMpy0dKtFOd6cjlaTEu0yfiZgbYQN/Mn31W/sbPKFqnnGv0CHnf69OmtXu7IWmdrQKcek2eZj4C/E9xqj1G325VfwC8o+t7lupdA73UoljQGYv4MhTQamkKTEvz8kUDVGlF144uinr6q/y1g348JkPmaxZexupGa8VxEYS3eq/O0QbMVvPbiQvY1XJfNZEiJ3/lhS4vBOd4yO9xQIKrnGTDJG+5fMh4PDaD5lFSuDzw3R23MlAwT1EI2+fnLgobTgNm/mtx5YUZqjWNrTKgFUpuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofPzUWMWTN9MiB7bvTcIPs9/hEKAAago4BehvUPbMic=;
 b=LPbf11l+wUrnUkMalXj78Yculwfc2CPqZu2EEAdz2cgfYl2XHJOMpl2y+0b+KQh4gbbGha2h6i4RQ07QSgmrc+6DWsNHfSCn59l/cWCLGlkT0NR5BpRqEm65j5/Rq312vpXztc/nqnSqSajrOo76lLpbG6pWnesesNRhMNdfvlK2NT5GSqV81gdaaNhcs8ELS973PvQPRUrT1QsHGjX1n7vZc3jTrNs5ixo5amHfzkQVwt71qvN50OGJdyZ4qe0fHTeBOjLS+bARqkG4/oGPv+dce12AfnF/L1eorQUoc9ioqL+iiUO8TQreHsPvcwu/ocTs5eKiXrzVpJaj+yakvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofPzUWMWTN9MiB7bvTcIPs9/hEKAAago4BehvUPbMic=;
 b=eUIHSLDf5gN7U/Owjm06qv0iW6UM21uPlYU43zyesINdoRSSfVM2/l2lqxPl5JshFoAjnSzMRhpJn5gPxBt8Z2wBEf7sQjqElbM4QAQrYm+/BCensJnuyI6HSCqxuxsI+Zq3YrchPQqJaPloJvKKOzNvVyzuHP5A6tNiqPq/cVQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/11] net/mlx5e: IPoIB, Drop multicast packets that this interface sent
Date:   Fri, 15 May 2020 15:48:52 -0700
Message-Id: <20200515224854.20390-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:36 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 992fe7f9-a664-484e-fe88-08d7f9223f34
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200BF0ED51B194162FCBDE3BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c63KAJOYJn7X2fE3pYKf6xQtmiIOwtvVwaroFnUDMN4/Nb6TMCKcr0CLbrXRZW7Byr9r0AW2aFG60mfXgcHanLSHU0a36l0pS56dao4QOijWKj99UJieKiIfvenYjigVS9TjU3Zdw2OntBoof1k56OZDBwKWPCxOPjNVCRtimbDv/ddluwYIRJCdD0/aaJKvMpo4L7ijItQ3DcfkfzQVWRW9tMK+VdQuU3HndEEcvC60BwVhiY7tcquJpdPfhS0b+78p15GNVoYb6sM8jQf+nvdQwX7PChugdVtqhIWz/IAvFZIMPqMb3gvVBTY0wM/6xjJFrc8jyUsZdhD70CE4wan8FgOKHzhQ1SGFAxGDsoAYfzcD5TLrJabYFoO8pPJsVV6QZwHL8YLfd+pIPVybUTAvbpmvrf/L9SdfnwC0dT9FDo4tJlLQseuwp/S0+zdGt6D37lg/e80tvVztzqTMlO0mMv/Au3UMfEbtKwd+A4P9NXCYuVLOlSpo1ylQ47mF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dMq1ZRJBVx1Oc+KQkXyJpsdQqax25j2Y/2gphKHMeRhSL1mj/lp/JrqaUrYaEm4qhso/N+xCSdVGBX5DudA1nDQq4EfeNwZN91QaDKQh1SIN4875YBpA60aZVNG7d7f7Cm4rWDtIjPjUfophEFO5RF8T2WAgmZl4YHWL+CYF1JrEURw73Av0YnFmBDQ2U/cOc4m2U6y6gR9BFq0FMgrHbfXYvkA94c6aoBGNaJKvpQYRcwsKoay2L+vKfqBkduzpxd+o/RrsV4opaZm9/S42ORMLkCw0sZldbmP0xeb/CksVqqhj2wjl90ouVUIcL8tJT/Vj41Eu0ExMi7qmWddxXPF8XV5zHkHInxL9k0cwYpoQonOOVA24CzwjT++weRnEHIz/JlviNvvUo/UgoqhMAfvqzK8T7q498EssBhxruz4KgViTGjCpgVcmqhQN6VQPN0z1WPdX3K6jw2C1VylZE3DAtqhMbGrFf+mqBYvG1gk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992fe7f9-a664-484e-fe88-08d7f9223f34
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:38.4574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBybRxY/tjU5/opzSY6IGGpXJM50LmGnGBxUNlVgRg6KA0a0f7BwKrQRgDM5zOcH+3sImKlYaV65onukHA1pCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

After enabled loopback packets for IPoIB, we need to drop these packets
that this HCA has replicated and came back to the same interface that
sent them.

Fixes: 4c6c615e3f30 ("net/mlx5e: IPoIB, Add PKEY child interface nic profile")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 821f94beda7a..a514685fb560 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1489,6 +1489,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
 
+#define MLX5_IB_GRH_SGID_OFFSET 8
 #define MLX5_IB_GRH_DGID_OFFSET 24
 #define MLX5_GID_SIZE           16
 
@@ -1502,6 +1503,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 	char *pseudo_header;
+	u32 flags_rqpn;
 	u32 qpn;
 	u8 *dgid;
 	u8 g;
@@ -1523,7 +1525,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	tstamp = &priv->tstamp;
 	stats = &priv->channel_stats[rq->ix].rq;
 
-	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
+	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
+	g = (flags_rqpn >> 28) & 3;
 	dgid = skb->data + MLX5_IB_GRH_DGID_OFFSET;
 	if ((!g) || dgid[0] != 0xff)
 		skb->pkt_type = PACKET_HOST;
@@ -1532,9 +1535,15 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	else
 		skb->pkt_type = PACKET_MULTICAST;
 
-	/* TODO: IB/ipoib: Allow mcast packets from other VFs
-	 * 68996a6e760e5c74654723eeb57bf65628ae87f4
+	/* Drop packets that this interface sent, ie multicast packets
+	 * that the HCA has replicated.
 	 */
+	if (g && (qpn == (flags_rqpn & 0xffffff)) &&
+	    (memcmp(netdev->dev_addr + 4, skb->data + MLX5_IB_GRH_SGID_OFFSET,
+		    MLX5_GID_SIZE) == 0)) {
+		skb->dev = NULL;
+		return;
+	}
 
 	skb_pull(skb, MLX5_IB_GRH_BYTES);
 
-- 
2.25.4

