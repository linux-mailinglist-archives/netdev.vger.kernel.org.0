Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80FC1E8DC7
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgE3E0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:26:55 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgE3E0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:26:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbHU0qNqE5JdIh/mcvrReMr+8IXAY/p7AioArXzCoWs0bz4rIGxYy7d2EQe2pQJ2f0txTypABiOcXaZKyppzBp7LUQLCEqfcYYSihVKIoicMOWXRiqpqdGv4N10PTIdINid2wTd7m4eD7wR9qWnkCcuFHpo42YYlXpramGrr0JlP6Sn0fkjYryOuEqNDcyFy7yrrzxsD/rS8V0diDi5yEq9CMtjyC10g5SNLPDeeWTeI+RNedJc4Kp42QBiBY6fxyKq4xX7ADbr4Q44l7+8XfbG76OTJE6Ymggt7F46sctNpXOLvsXeyEzkVEou9jENQCHpXj5Ac4xYO3X6/r0XnqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvdwobTABJU6EMF+nXn05OmjHQ3yMSzQII8TtC5yZ8w=;
 b=d0ECFqtV6pK/QqS1uuKeedfouNxHIA7VoUZz/TnKnLguEDCY0NZhV6PTrdNsnuvh88gEuRhxyR0fA9m9WklUZgXIbiUyIeTiEyA+67+JjzIWG8LCPyEuKzBJi7Kd72IVkhSfFCXucDI6aAHF/QUBZSWnUUP5AgWhjoBljZTJFSzgUNzJ7Dr6Ydq5s02LN4cssPcfhObYJj5GNMjUxFnAlMgAYi/1gEs8joBFe457qqJa6CSGJm6XZZhJ390D5GTEB3pr6ITXF/j/PIp39kg3nhf8kdTxI/+Glggm5ePTzvpkA1Ag/gmanslx1ZNXC5/xksJIRKtCHb7wvZKgbnJCeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvdwobTABJU6EMF+nXn05OmjHQ3yMSzQII8TtC5yZ8w=;
 b=NhZRRRaby1gFErQ6+ark1XNxm55SeNH7X7Hn6vcJrodyPyRwSmpmpZjCBpyn2UfJ3lxn8TzJ+T3l8oAuXK7VyMh5AEwXlkd3+9/zHYL/xwh257pdu96WUYJz6rbiiQpKC3PRgWqOZXsh/lJbJ0sRouU0KlSMJxyXjdcPkEQb8gA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] mlx5: fix xdp data_meta setup in mlx5e_fill_xdp_buff
Date:   Fri, 29 May 2020 21:26:12 -0700
Message-Id: <20200530042626.15837-2-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:47 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d86b16b-c5f7-4c10-57dd-08d80451aba8
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408D12C38D318E09731037CBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GD6PqQL5rVB3e4Hz4rj5rEPe6+dzHql8B+wQXJIE9qqca2Z+TIuGumByvy/9lIOAj7VyMImGCQCTRT/lIE4y94qq5bZRllnf6XAgOIWp6MQyXDFzYRKe5r89SSBlQnN3tvKyxpjJOcArpebxE3y/3Yov0GG84N3Her18fKttcm7i+6TMvop5lb6XWz+zACkdsOLnwowJ5voFR39fj38qn4MZaGGtsCo0+4st4CFzpVnCBxL3Snm/iAi8mUwyzQ7J+YzuNp0gNuMe40SlaVFfTEZOg1eRspVwAFpQCSlj3tk2obM6lSWRKSeFOX1mGloPvSpXyOqWL8QpOmpNDwWhyHuDySUgnIITVe9VxBu6vj+8yLUFCb5UwQBBOEuNkdd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SLxP7OC6nWmiyaova1WJ4/2rakQoWwebUCXZ4M2TGZfPMnOGiQ8V8yZ9zFtubM4DSyHY9mMmkPUMXBWKUmX/O+l7jIqrpYJ89OVVP/vXXT5NgJRkBqGiBcuMVZxV73kvOVgN6BChGS6VEJWYdYAN8wzSzafXEaW5/t2TV4fOeP1tiePgjq0Z+OIxT3zj6wzGDQXlRP1OtZjeqTqIC38UZ1MHVeN1bNB6PVN05Ts0eLdOHJwvUcurOOX3NACNMZ1bgoXJQBi/uRMRVdlkQLjshoyGuNk1g47IbuwpoBSl9TP2hncph5h3demrhwkW3NUD1EG+DggbYILwwfxr0MipSnh3JPfOVPd7/mGEXZrpPAt9nTkwZlO0vMJOmV7AWHoF/NWS0t3bgUeGsNe9sSHhLsyXFZL4Tqcy/4cpoUAssipZl+ydHsJLmCsR9bqoBIiYY1NfJUPTkIVn09V9yi/6eo+vY3oSIUbonXkVWhfGzkE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d86b16b-c5f7-4c10-57dd-08d80451aba8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:49.5531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVsYBwTjunblNrIFKaSjMX4GXxrnO3T9EzYCd+xeCbQfZKCnQC3ItLEF1wapbRIoDrJUVt1fgK1dYQpemY5v4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

The helper function xdp_set_data_meta_invalid() must be called after
setting xdp->data as it depends on it.

The bug was introduced in the cited patch below, and cause the kernel
to crash when using BPF helper bpf_xdp_adjust_head() on mlx5 driver.

Fixes: 39d6443c8daf ("mlx5, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Reported-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6b3c82da199ce..dbb1c63239672 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1056,8 +1056,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp->data_hard_start = va;
-	xdp_set_data_meta_invalid(xdp);
 	xdp->data = va + headroom;
+	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &rq->xdp_rxq;
 	xdp->frame_sz = rq->buff.frame0_sz;
-- 
2.26.2

