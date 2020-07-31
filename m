Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7898C23444C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbgGaKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:50:20 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732603AbgGaKuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVy99FGw8oJ5b2TFRbO+mApB61dp/uYmAc0Yu2E2tyB4/0tQkgfX/Kwsyj9e1x9+MprYjEf56/k9qwJxogmZilxwB6bOZBcv/smUXVH3NpP3+aYb2Hi4jWQYtsTm+1J3CV9ggAKuFetGxWXzvproQFDWHtnsXeHJUAyPdNx6CI1bxG6Lfek3Z3gDfotzFiNWsMLNOZqyrmNoQRgfZJV/eJni5td3Z6GW9CLjr2pch3ZOGX4NU6fTHkc8lZ5tS5JiuVVf2rR3ERVowOZBrW/74JgjK5RBYRtl4BnwvLbaDYQn0eleVGmGLaYCFt6t6eKc2UQrDrYyL1xsNQCt3Glosg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCJNfd5Yf408gpMdNay94myuUWJOOFpBuIoY/bSXHYM=;
 b=JNCy9xBeUlinEl0qoMT3NqdjSpM2vwY787H94lZlfzB+g1V5JPd2RIHJPJD0bPjOYJWcurQWe+F9Hdd7FR1DhRy3xHB62yeP/12IcxOuKPZiZ7Oq86p9m2G6r1m7QXdRMNHCv+G05uOPxRqF7iN2aJJZYTjXJ2HADkt2XkECxaSYnO1zBaO8b/wNI5u962U+YYiBsxBZD1El64gWCU+f2baYvPVzA4ab7rTdvE3IxVf6fqwl6I+HBl2aszsh0s3LfYaD4O+AUnnCqJd6I0nenwFf5A2UpwyelSxPgRhXUhnJTqEg96rBDe+QKKOmiT7fZ2VwoxaxPqO+HYarCCgfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCJNfd5Yf408gpMdNay94myuUWJOOFpBuIoY/bSXHYM=;
 b=gkWNt54Zqlvy/+1F36dDtYFMuxsKH+RQ85a9HCk+DinWyZJAZDZ/jwMgppV4/TJDd2B1OJ+vt+QKiOK0FHYpozSKM6Dg2AKa751Yl0WxXvyxlSIbwtU7u4EoVe1SlVHkPm9CwVj6EmTwmOvjsMpSoyYsaAkCh6b2GhirGo3Ljss=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:57 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:56 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 5/5] fsl/fman: fix eth hash table allocation
Date:   Fri, 31 Jul 2020 13:49:22 +0300
Message-Id: <1596192562-7629-6-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:56 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 127c2b05-285f-4cf0-6558-08d8353f76f7
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5943B846362D3A9E9BC5E8CFFB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf0ZHA+IKgAHKmD18Ex+0OT2He47jK3nRh1k670/fUp9zYJveHuPRPGcV8uZn5mCLsgRDmKt4WiKzeJGdlgWVEJV9Hj9Bv4FLJqWYM56Kn2EBsKBSeU0wGs1F/AnTCFyEOzadJahn0/pBZP6vhzYD8u3Zz27+LCIdzga3eppZTwvH6AvoozkS/sScVfIZIbHnY8uYRrOA+a0alobo9Qt7vcCH/LNWCgFRCduGuY4s9qjPsFjytltcpaL+9AGsOhHCjOudTY3vgFRQq/bIa98P7CFhKcVECNIAWc29ux4zfM+x7jlxNZDtEy22RHSO7QefiFNmxmxknMfZiG3ZhIZlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cGMgnhKg5Iwar+issXhydJrHYmpqiGlP/21bTWFT8oBlgTW8PGL0qzGpphqfhV/+qrxLAAmfWZnRhgOYlEULCVGf1RkoDzaNl8hwSwZXKUyysrMNLku1g6oUhYV42qcBoL81d8erNbQKeEN2QMez4BYeJ2r/s7cGHKj7F0TdGhoN9wm0zvMfiJNA2qNOLcVxuBadogMKT55nQ5pcfGtyq/vLytQVL1+W+1TIuK3YS8kv2asKn1tRb55v6iPt6Aju3HNigy20NmpOr81RMu38nLFfIC5DebHjQuI6HL5I29usIBvp0JFwIZSQRkKuqL1dh1IAZx1v299roNypMZhDS8lp+qBtNQs9YkXv02S43wXYRwVyCb65fKi8I7kUIC2ypbpo3ZlMgLeY8aIzenrVT5ARcDnHTaCuVpkMW0t9qmyCZV5CIIjj7cArfrITBvGy6ELbwlYkTcZJ0Ljzg0PjIj5V4KANIbQKKuMWAzk3ruXVNhNE3A+How4KsHCgvWnKmE+AeSVFI11v2aUHyoWKgI43Pa0rs9t9K32ht1jIPKagV2GQ1QzWjVP3kHpyuuAiy0lsJkqbuFsHmmt0wZwgp028VbR00lA/oh7lp9NLCqvzuQMeOVtXW4BmA1ldBCz8C/lL+w/P/jyu+u0cqgXXpw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127c2b05-285f-4cf0-6558-08d8353f76f7
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:56.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +j35fLDUmdw+tDvt/57JROgnjAP/ZXqzYXTgdSznXk5LGsPubEg6IeIoVrRr5xqMAiPl4V7Gh284zPYhplnxCyMtTid0ZYpyUZNRHkHs7bQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memory allocation for ethernet address hash table.
The code was wrongly allocating an array for eth hash table which
is incorrect because this is the main structure for eth hash table
(struct eth_hash_t) that contains inside a number of elements.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_mac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index dd6d052..19f327e 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -252,7 +252,7 @@ static inline struct eth_hash_t *alloc_hash_table(u16 size)
 	struct eth_hash_t *hash;
 
 	/* Allocate address hash table */
-	hash = kmalloc_array(size, sizeof(struct eth_hash_t *), GFP_KERNEL);
+	hash = kmalloc(sizeof(*hash), GFP_KERNEL);
 	if (!hash)
 		return NULL;
 
-- 
1.9.1

