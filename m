Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A7B244A45
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgHNNRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:17:46 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:48226
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728451AbgHNNRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:17:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXo4iqVrMrZMhCbuaA47YeQzW50WvSzKlp/DXzELWlZ/1wZlz/vvQFpnaiNX/JQA3JHZ5+lTtZNnuq1XXrx0NahBe1YkRIRbkMWDrZt2sIWCR7E6J65e6/n3UBC4W6ggfiHoOhhV2fxw9fPGYnHQaD/2MYxRFsN58PF2UdJuGi3VTR7sb8o+kFaRIBTlZfkTT5+vFVSwhyjnRqdAearOK/+fWojetrm5E/ZHpQU/U+tt3yctnf/zrqIMZSyjc1xcH+cvqmXjz1TCuwwBWs3SVKLwbS8ACmdtnvdLY1rC7CddkaQ7HYiFPgrAitNFXICbS/sk6/0Epl2GVndx6tihLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBOTzYfSWaYMJFBI5N3HjJyWXkatfKobTPNn1ykV6WA=;
 b=Szcw4cdq1sIfTdJWSRX9/Pom/RHBF93768drZK0ORyTKdviBAzANjkgXM7Z83PMvbh9XYqlFeJ69KOybXRXb1G17px+NmJ54UsbaoOYbTsRYbU2LOf1ar2tZ/W8yqjmiyYsaqf9nUWXJzmXmT5iM9/5qKFdjF+h0Cozd0TlkICYUTRL0tX6bUZoIyF+ytSKvNDetfMuVx6NrwTyCdVTZf0Pv3dYioa7S+hLQL7Wb9RYIQcwsRXvdY6kvhJVl4X65feRnQJ8l2TRWYCnOsd7+4lYWzhWHTRYv0voU2X9qhLDA7SWdtBkhwdjOmcA0/3EIvxfW9qmBNQ4OY5J6s8OQEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBOTzYfSWaYMJFBI5N3HjJyWXkatfKobTPNn1ykV6WA=;
 b=Rja8Qt5s8N/7Cbrfb+WqhPBtsdUA6PQcBUr6dAI20RXqtDxPrYI5bh7Ywy0caO87fnGnDkHHgz23KDT42df902GbEcByZSuJDgQ07W/oKVJYheUHtu2ONr+vdybAq+I/ml8uFDp5XoXXbZiQYnp7XeD8nyaeZbyVdMibSjwXVqU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:17:38 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:17:38 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH ethtool 1/2] netlink: Fix the condition for displaying actual changes
Date:   Fri, 14 Aug 2020 16:17:44 +0300
Message-Id: <20200814131745.32215-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200814131745.32215-1-maximmi@mellanox.com>
References: <20200814131745.32215-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM3PR05CA0156.eurprd05.prod.outlook.com (2603:10a6:207:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Fri, 14 Aug 2020 13:17:37 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a018ae9-1601-40db-4d44-08d840546a67
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB360575A5649026A32D3577D5D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isJX3/3Ve+dBSXcY/61kBRtNHT/fCCF8cZamx5ZHors3sRJUc4kfyp9RGsFZ1CPZTGtysCWB2nEnsV76GdM4BmT1RKLYyIbanG/MFryOkqTeOY9CcG5taNMog5amAmMRDMprUhGELIXaId4KAR06YnlRU+eKUhXlHXZEW2FqcBVg2mGRFzngSeJVI4n889u6vd5SQnX4Qxm8Jr2qepn3Cr7BJhANNiRB1N4ArUOa95JkCOrQMYOWQotYYOE36+ihtVEG92b04czUQK8/6O5lWZVsEy9lWHr6H3yQ6lpdjlX2UDsIUc9ZPfRC5A0ZrYHDrmrZ8B9lmGpI54acvbdbAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hVB80Cp5NwOvDo1iWQb4GoRuN9iEYPEuan1Td2c95scyqxOI1yJ0KBAGGjoPISJH03WdKZ8ZZfNIEvrkzxv1kXg04ZG3dhuVc2bEGZFeB3EYZvodMh6zMPGjF6uec+O4z7DHOo+p+ZlMu3I7v4Y15msDJeMoTcZiNQBG/lba5nbEMkNQEDAso/gbCKQ+GKptGbGeha75E5kgSRHAIJiwOd1uk514uRjWf8SigSiKTMCjaKuym8cs/gtRjwcmJktZzCaiAxFXNefTO75OVfd2nfwTejz6/v5JWE/7xpHb9uae+DHSw9W+GonSI8eDcclicjyKPzR/F8DiwSn37sdXgOG7Ge31V03xZ6oj0yV+U7waCEbnRl7clSx3Y+6E4zUAGC3FBGmJYdGuCSRJuYtcxQGIrxjElk+o+OZSf/VN2GR2ELQvRvdYJ3+6RqGEVESXJgLXKCP5jja9UahB7VleOHOdcL+IyfxJBdHqUq9n5qxdi8HM21vqmwXUGRNxbdtvsEO3353eET+TX2iqigS0Ht/HtpTeJgFCMpc9eDUbb1Cv26T6V0qxXTVodTnxh1RqgPQ3spxQXuaP55lewpj9ltnSSXckW5IDsxmF6jCIVIrhMnLyQVM39pZQudrt2oil6V9oUidrPffxhQlxAEyhTA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a018ae9-1601-40db-4d44-08d840546a67
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:17:38.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyBnTJd05I1uqxnpzzj0Zldxv42p+7sxZRP0SNepCCs+Bc4OZLq5YtXZ0kMth0TSpSExhaFKYyrIiJ0FrUNwrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This comment in the code:

    /* result is not exactly as requested, show differences */

implies that the "Actual changes" output should be displayed only if the
result is not as requested, which matches the legacy ethtool behavior.
However, in fact, ethtool-netlink displays "actual changes" even when
the changes are expected (e.g., one bit was requested, and it was
changed as requested).

This commit fixes the condition above to make the behavior match the
description in the comment and the behavior of the legacy ethtool. The
new condition excludes the req_mask bits from active_mask to avoid
reacting on bit changes that we asked for. The new condition now
matches the ifs in the loop above that print "[requested on/off]" and
"[not requested]".

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 netlink/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/features.c b/netlink/features.c
index 8b5b858..133529d 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -413,7 +413,7 @@ static void show_feature_changes(struct nl_context *nlctx,
 
 	diff = false;
 	for (i = 0; i < words; i++)
-		if (wanted_mask[i] || active_mask[i])
+		if (wanted_mask[i] || (active_mask[i] & ~sfctx->req_mask[i]))
 			diff = true;
 	if (!diff)
 		return;
-- 
2.21.0

