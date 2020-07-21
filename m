Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D52286BE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgGUREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:04:00 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:56928
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730138AbgGUQyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:54:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1sevlU8AlX2aaK+40cNLCfVVabN+Atk2Hp0zsN+o9ja0ZgsCIpMyj2vzHAE5+3fVnBLsrK+EA3pygFj02k8WrXo1g902ySk+Zy4uYnLL595BYtCbn2UuzdEr9ffG0ZAUkSfkhuwTkym8RTQvZI83KanEp32QXAqSXpCkvuP6/43x0T0NJ7DZYI8SaAzlscvpGT5rlYzdOyXWfeXUEwXqDJIw7aLv8UJsX+WksDU4bg3Au29rRXOW7X50XKjOvRkKZdiUcbvDoOpX4hIDqlOu+Moat8Ii2ttrLJRKWfNSvdLhZPOALGlbShDDnCfire6GhCBWcKk7R+JBIwpllPCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XPLNUGn2LgmNozr7Ibkk/FWTpRcX922OJB2TVv0QWo=;
 b=hE9JvYLjy3e5ek+MWwv3ql00txwRIs9Goa2igTkkRUQslU4L7VbiwW680xRLEQV8H2ReIlmM43bjxVH260H2qShuLKQ4msJVUBPlbk+OmUrGCml5HA/HF9ME9vXN9gEw5M5uLhMS0aXjqhgZVx25CQwb51X2P0K68rgpetfJNAWhMc+mbI0bmq2Itts4zMtYEBZEaPRX06c7w/ihnU6YDivD+c6Ig5IjeihAvz1VekLXWlQW/SR96+SnrkfpDCtbeT9qWpKGGsi94cbCUCYtEl11xpQeOsvfTioiLNABKtZJgqR8HFMOxyL+revcu3jDgC10fxr+mvnTAUOBz2LY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XPLNUGn2LgmNozr7Ibkk/FWTpRcX922OJB2TVv0QWo=;
 b=TKGlcxM9XfgqJOvjm4EzFh9Y/6Rpp0HaroLQDUrTg3gmoM01UtVLZ1S1B6p9bk3/cjp3JLq7G4buRaASxmutFF1xThYXe+fbsLKBloVBx2D0eyRQRZY3sjX1n8BJGT3F6I4KPs9XR7J9DvroU2wAwLhzVV/vuOmk13QCtdDkVTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4739.eurprd05.prod.outlook.com (2603:10a6:208:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 16:54:10 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:54:10 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 2/4] devlink: Avoid duplicate check for reload enabled flag
Date:   Tue, 21 Jul 2020 19:53:52 +0300
Message-Id: <20200721165354.5244-3-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200721165354.5244-1-parav@mellanox.com>
References: <20200721165354.5244-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:208:be::14) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:208:be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 21 Jul 2020 16:54:10 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93b85bf7-9406-48cd-975f-08d82d96b0b7
X-MS-TrafficTypeDiagnostic: AM0PR05MB4739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4739BB753BAC9ECB33E36A61D1780@AM0PR05MB4739.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAbdorw8GzDPrCTnJfJf/iLOyeunHOwZUIwzlofJq+krE3UwRj9rGIEMKutTyhdzVAqce1NQHaJrZx27mwfnLRjQQEI6Laty9r5l5sC1aTN+08MJDxE6PurOGQCGLviHHtLFnkebsTG8fXANCg14hFbXerS86MHxQo4d7RdLwztxiXcWIFqK+sCJwpaA/vmMoCno4eplMrcu83ewEKsMJoZLJM1lpbEmaxckVbLuaStoZtFwr6M0x2xL/God/yTv9saOUDO8Dc25f0N24sboNeK+UQ4CD9u8nUjSAukgoDJnY4nNg3v9MfEvB1Po7UejJa+lEcBaEdy4jkebeliJRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(1076003)(66556008)(2616005)(956004)(4326008)(26005)(186003)(16526019)(107886003)(8676002)(478600001)(8936002)(66946007)(66476007)(5660300002)(86362001)(6506007)(83380400001)(6486002)(6512007)(52116002)(2906002)(6666004)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +l0bQ4BmZFE7hT/0PNA1nnKkMyNVu1QaSUuUwFF+CLTbV48l7LWDBP/sdo95j3C+Nw99mvrnNjNLMs85zlgbG4rUGCoYKU6v3j9f18A7XvR9K3vaF19hJ5Zy3I5zf+q00dhFK9/en3++1ZSBBkpKVQ/1Z5y+77hmKqy7bYMkk50q2jmr0U4HETHbEhM9cPYhT7vOnyxNYAd3zzJesbSJ4hf5swiA8dWblOODOsA3U9kofwMrbWiqTJzR9Dc3xMMBHsieLeF8zV3ht27Fee0jiAc6/9sHOCn9nuNsLai+LqADvHZ/JM0FspP9FdH6BXEh+udSowbqv3tzFTNN1DTtAdmrL1f9tAyM7PFa8xGzN7H1NrYImfOXU5TkbeEr92MZSZsdldjTYqSLXbCOS1FmW4tII3LV9h61fQr79l9csI68hQJYAxwFKo+GqFALPtcla2Iaw5K2mn1pNRlTb9uSd0xvbWwwGGr2qls71jhY5tzrLpjQW8Ffy9VJj/LvMIb3
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b85bf7-9406-48cd-975f-08d82d96b0b7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:54:10.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ur3wbRb2FLGTlDuC0X2Gj0CWG3LIs3R0TRXgdMtbtvcgQFXVCjSUmRRvt4E966AXaXN1oDs7KG2DghmCo7jSFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reload operation is enabled or not is already checked by
devlink_reload(). Hence, remove the duplicate check from
devlink_nl_cmd_reload().

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7df918a5899e..5c74e67f358c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2967,7 +2967,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	struct net *dest_net = NULL;
 	int err;
 
-	if (!devlink_reload_supported(devlink) || !devlink->reload_enabled)
+	if (!devlink_reload_supported(devlink))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
-- 
2.25.4

