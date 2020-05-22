Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A21DF351
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbgEVXwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:49 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731233AbgEVXws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDnbmIj4vsVKuVyEbMsQYrBenEVVB3jjfF165e4SBidmCPfr6/b5Vwwaznvadbb9jKm1s8WlKV/E8D0+lR7fnYB+EJzvGkdjliMlmaASfl21P+qWQMfghCFeFQHSMNeRgL5KLp5z3IFxa3ie+x/If0oKzUX4B6Bpf4PfV6ORmB+wFHuwhadAA5P8aLtoRd5hSA7JAal+ZxwYX++zicnNPLvY5VBA4VpoU5Or2JielZxFXWQ11jvLVVPbRAWuaGPphLkvjSQH5ZIUbSkO8zeqhL3MUnMfxdPe9VpH2W7jX5RjSm8jvkJck7lflU0tUeuOBi4xsaHJQHSgJjOMGnxAgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jUy/irwuDaghCZwExpeHF0fBy/uBOH8bIRjx7H0g1Q=;
 b=f32YLIk2LuLJKENOm/4AsJeWpf6F4NH32IUzR+MYAI/QJoEDYdrbbUVums+sgbMoG6HFX4VjLg/sRE9EXzUjDS/2uOOsS0Y/Us1czic/zeR8sFV1Vzr5qUo6LqN0Hx5Mf0QW9CdN6/0Q9YmWN0+WrM6XcAA0OxJeg3bM13ZmnO/F/zqmlLiRif4P+NcJjGuPK7755XhpEq4VhUcnnK2+5eK5hyoJZZ5DUO1FowMB8TV+1e4RS/NFYBXwAzmP/AayYn9qEUDrunYWUEYbCRQ8DMTuepkBh23uHhv6cNN0dDgIyO35ad9BbB85+4dmmZPY2WNYKc2Titb1trJbeLTpWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jUy/irwuDaghCZwExpeHF0fBy/uBOH8bIRjx7H0g1Q=;
 b=rfPVncJQEkBYCMOsKOkJI/YI6Bq3kIYlI6cWyxLygVn/MYMV+dDndpz4ZmA8dmhbPF7RMBH/88aRVeLBk29x4DcIBtLo0j8IdH/1L0b+C3UabtE7se7fj0vBlUdLu6SAYy6h1lKDiNsxfdLCio9b0qJ8qqkMpRluvOaEKAwielU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/10] net: Add netif_is_bareudp() API to identify bareudp devices
Date:   Fri, 22 May 2020 16:51:44 -0700
Message-Id: <20200522235148.28987-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:20 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f720a22c-0b1a-49b6-f1dd-08d7feab2be6
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45449CEA255F80C327154AFBBEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIHGe8FzlyWoRysM4TJTEw0TpqF2sY66uZlYDEl0CPaD4iKBH8QXskS5zPovArJzp7H2HDKD0hpQzeEwHGyGxg/icEHS9+HnmiExt+flG4Yy9KOH9hEG43fyEms2Njdm73MKsiA2bv7I1y21HVXeOdwH+PBxM4ywRijiuzxKOOPuRLac1lcSBLp2VB1BGQjkNcX0tMcuBIbTxTqA3EnS5BnWqFLUDpz3GGLyWqS3j7wseeRz8eQvXRTSaoHTmeVitBBeTuTFXYnNmxNTpRivRYXkCPoG98vCxihfCZtNxjfTPS4SQI5VpNheZ3mggMvnWrlMTzHwLPPKK9NQ/FywPkiFvKwYuqC/b3J3Y0aUYVspaRoFuqBUB9NHGTJu2Ydh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2hm3FKb4ZyZvaJ9Vir056kdYj0wXWFUkPyWW6rk7kNISG8s40/kInTv4riX1GkRXGo7OOAOePG7MIwmz70Subao5rPzysahYYScJBqeJ4aoAVeSmLZv/eOUfFcZ9kzPIqjJ5El9AIycdjx1Ru3DGHrcIjfqKSowBfZwA7GnK2emBrrCDD72G+ZqG32gu5q3kTEvmbIapoqcNfPCen/9FwtLwjyDWszThvZ7UsIe0tTB52dkP1IM5EpoTl3qGRBJ1Ari7gHbF5Jdx2nrmhjGIqIohHjmuSy1fWbieWjKttNnfyN7CFjrJKTcFhjCzfwSxSdTRbrpD8DEG0XeXHw0cjUF8ptvRF+nmssZRS+ONwaj4M6iYPHcumCjUxrIGZctkLyQJynn3oavI72XzMIL+CgT5XR5YbRwGu1Kb77vmEV0DAIzGQQiwrnM9dcfEIJOSTnYqbTbL0qhkwB6sLaqGrV+eDPv3pl/dDYP0wGXNpOQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f720a22c-0b1a-49b6-f1dd-08d7feab2be6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:22.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gm3hHPTrZ8MHNRMpHxdcL+mHGiAOFtsWnpXB1qYRGxrBd9cSCvtn/zE5m/s74yr+QZkC6d0RuEZbfLONGiOXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Add netif_is_bareudp() so the device can be identified as a bareudp one.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/bareudp.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/net/bareudp.h b/include/net/bareudp.h
index cb03f6f15956..dc65a0d71d9b 100644
--- a/include/net/bareudp.h
+++ b/include/net/bareudp.h
@@ -5,6 +5,7 @@
 
 #include <linux/types.h>
 #include <linux/skbuff.h>
+#include <net/rtnetlink.h>
 
 struct bareudp_conf {
 	__be16 ethertype;
@@ -17,4 +18,10 @@ struct net_device *bareudp_dev_create(struct net *net, const char *name,
 				      u8 name_assign_type,
 				      struct bareudp_conf *info);
 
+static inline bool netif_is_bareudp(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+	       !strcmp(dev->rtnl_link_ops->kind, "bareudp");
+}
+
 #endif
-- 
2.25.4

