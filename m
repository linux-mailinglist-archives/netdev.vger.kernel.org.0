Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20059244A39
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHNNQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:16:43 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:30530
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbgHNNQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:16:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGTUENVwd7wBGPTvN1ipZWa0YHo+lVXPI0TfPR5LByH2i2OGZuKeIwJo3hl4cKqet29rIxz3tUGS+PVtVw0iY9XPP04sERa6pQxFMoso8WjhoW6+0JkRgAH8jLxHqScKGV0Q/JmvfhRbD/i2nvQETe5R2iMEfxDvE/DG0OCsRl+bC2jVIp0ZZJUNxDgPkPlF/dxA1pQeey6eYKSzEvGrbYcNtZdm3/Z7RDmwWrqEmWNpOjuP9KhWlzN63B474wBF5XiorWM+xb0K6ZVcMPWfnCS39viv5kSxsJBvsVayTBdIxIYavXzgsbnorlsXNhHMTxSr75k6g/8hzwCSBmKZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+eDkRvy0t2l7VNyHLfnt4t/ZrB2XafvNS8uv1cX2hw=;
 b=crgc1QMZ6lPlclDKwRvPUcJybJTmf4m4EZWi3Lnsq2ugon+PgzlT/36kh8VMfbIeRL9jsFdOen1kqs+l1DXO3PrXVcN7+68jTDkYCGE5p0T0ZjGKCeDCeMVEMmqgUvjhS/pnGYajclq169l3g2r8p4PQ4/rnkTrdQXqbFgRwb4XUtHroE5zjwZ30cyph6qjnf0ht01AIKQlOr//yGqyy2pcUBBBYH6333TYvjI+OjxsXn0glLyAQoY9XGjUrGA83QSXob/vxkqbbEIAVbyXu7iMyKhTRc3kls+yCSG/zjOB6HlZ69xFCrNIFjBDYGH9YCzKfj78sGUwDek9Vk4BU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+eDkRvy0t2l7VNyHLfnt4t/ZrB2XafvNS8uv1cX2hw=;
 b=dWaRAexJw/rR8eZScTuIQs/KdSRxjOa7Cz2xcWhtA4+yRCnGEH0g4ojzIezGu1uIE2J5m6GYrFTJyqfqGADpdPZQJX+oeajg2UKIv3Bf0SLj86cWRAgBqLh+uIJQPQbKus3ANJXXdYPI4C3Y9oFV6W5DJbIZ+XXxl//fpD9itNY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:16:38 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:16:38 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net 0/3] ethtool-netlink bug fixes
Date:   Fri, 14 Aug 2020 16:16:24 +0300
Message-Id: <20200814131627.32021-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:16:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e59de1e1-4f79-4f5f-d1b4-08d8405446ed
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3605E2E27EEB6ED252998403D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9k8pxLjJOh/zZ2ZiHWvZ3+3/Y2BSiT/DnJn62+CCuOo91ZS4/gG65yNRp3eDOQ0KQ6DcGN2nnNM6dHcqMvmj0LfkxQ7BAOCwqm2CN32ngdvgKXJv7K/1YXXB9X2vZAtEt5t6ZN4WZNPPr1BjiqAuqFWf/GaYhx9T+33B21nTUiLeTsUObEsgcpBBMe8nEgWGz3twHzI+JzXoZgI0ocZeyOvELCWsAqKWcGGMwkQcICLhUppixgfCqqaxrDxH3NOAbMkIYezzq/sDi9tP3NdPwYR1FX0hVRNeVig27uBwAdfxlm31hxxTdMCGhlBcSlC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(4744005)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LIBONCLGcZ1APn/9w5HOpmn5NY4ZhWjxTGtEaxofij11yb61Idh8RPRWIlyBh4wtwnnqyjUKMS7XeDfDGsr+9NCGRQOQxUEKeb3NMFxF6oBxOgF18p0my/uHfyZj5Fj+2Svz3jGlJHSNNQiMI3Su1gjgQQyYblsxwzqI9S+jGhNhbK3spaXZQyb/rLbgLC30ULkPkASsZLhe2bpfOT32tl15e+UF5Ea0IKHf7OvFkyVcI3MyiJr1uvpT0Se81XfMMo1a82kQeeGg/Wt6VaKOHi5XwVVTOL7hYCVzIMR5u0q2mMNN2EeS8AyXMJ1xnbg8oTZWbTRqTbWXCjEUkKvqlSstoTlugWvufp9N5btz7Kswshrk3fIkNkajNmgKRFkl83N7WYZ3NGIpubku0rkGyXv2UlVYSb4l6hOb/gbAzELWYxpuo1uGFNheL5jzv7u3DGuZ+u4YpqBPSboGQmN7mvqjwa/O651yEGFwNeu30q2gonpKhE7Y/kPOaWDoPoQihU8jZRve/AUxas/K+MO/yttXzhVBCFf6Zt0TwGmIvGxWway63/whhp4+312HNih23TSBrrFXfnplHPzYP+0sLLyHUvr3cuZSiG2wK7Q+myU6VReFdUhRn/UkhLfHQbHf02marlYec8jW12paZyC68A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59de1e1-4f79-4f5f-d1b4-08d8405446ed
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:16:38.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSGvNIs3Dr7xi3PCgjF7Uy7YjJNUkeo1d1xsV5Br5Q4wLyj3m+hP1OogYTCx6c3uA3XkiuVtDNqmMjkigAEGbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few bug fixes for ethtool-netlink. These bugs are
specific for the netlink interface, and the legacy ioctl interface is
not affected. These patches aim to have the same behavior in
ethtool-netlink as in the legacy ethtool.

Please also see the sibling series for the userspace tool.

Maxim Mikityanskiy (3):
  ethtool: Fix preserving of wanted feature bits in netlink interface
  ethtool: Account for hw_features in netlink interface
  ethtool: Don't omit the netlink reply if no features were changed

 net/ethtool/features.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.21.0

