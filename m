Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D622286BF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgGUREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:04:02 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:12961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728931AbgGUQyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:54:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArgWOXKfXfb+SE7D31M8vZ86+PbQXaClZP0iA++gkDQGJoCuNi9GNaEVqgbJqTBDk0AiSDNi5ZXUOTS3EGi3xBvYymaXMw4NVJQf0qnG6x3AYQkFQqFuCu+n3B3nl0YVgdFOrhqXgU0/N8W6ZfP+d18kmRvLkAMETFcCQ6yZNeX6cgSWy0+LnMw8ZZ4XFPs7CwiQ8DL/jjwiWO4Pzd4NKP1DjjbbbHyIEdugnH7+AK4TJp9fGlODMLxq/vHPd192XXAGuueKpZMFSZJWTLMBM+/rpXmKIqqPtai1RAszDBZsNAMCxXVkBhkG8j0oG+zda7kGA/dtcyV2b6tD5Ieh1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/q7FCc/JNOzl7EHoi5OnS+f9kMGfvoHYMy+t6Xle74=;
 b=mYAUsA0Fo1aFeGg8aw7P9GV6ZRB8stAU5m4jn1S9nSdbiJ7tOOkUaHnlnfKNdNaVlj7/sMzUXdIjabA2jeyadJChW8Lo6fK9oKCDoLSq1lLyfwKwucoNeErdjHcWDbVxmEK4JKpmbGL4SbXcc2mEw9fmSe3snbIAliyWiEbp6bnXSoIwMg4rEqx4kNm1VAWuKoSqVc4taIDAa4qdjG0Z2+3HbSeVskn9ys9R4eQmbhGbFShfRKFkL7QwQpKb87Wr7yGCXii8bdi7pbhYTHc+VJcYO0myF4/9sxb12q3DXOe4cvSpevjQ999lehX9LE3EvXuwQVOIG8XRENM3CKg1Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/q7FCc/JNOzl7EHoi5OnS+f9kMGfvoHYMy+t6Xle74=;
 b=Q7a9ZEO03Qm/U2ovcwcPBi4ZV9wolgzv5NmpJZPWse3H+b0BOzl9N85orm5k3lq8pp1aRKYkvnQbqEZu8kt19QUU/kIu2nvyUZuWtlvYga4jUuCJ2SWwTodsvXem+0VpPtuU92UzXJkr9c4v6MiobzwsA344jQ/G3N68TIRQUEA=
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
Subject: [PATCH net-next 1/4] devlink: Do not hold devlink mutex when initializing devlink fields
Date:   Tue, 21 Jul 2020 19:53:51 +0300
Message-Id: <20200721165354.5244-2-parav@mellanox.com>
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
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:208:be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 21 Jul 2020 16:54:09 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 117a73f3-92d8-4fae-6521-08d82d96b028
X-MS-TrafficTypeDiagnostic: AM0PR05MB4739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB473962F7B9DA5C4B8B2286A3D1780@AM0PR05MB4739.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJ1cZvbXPmk4g6YJgQQljmmjYudzTOThJNwSnvSWajWGPjkCfHtgOfFc+pht9cLrIPvcivcCk0E5Eg+UNoQ5fqvQqdi/hhdCh5YvmQdBsDXT4sEgeY96mZNFQYA+Ve66zr2FkEhrBYmPgEnkN2JtO0JdqxVdt+AJvx9rJvuU7wF0w56B/LJCToP2b4M1bFwYBuVdE9hlIVWUk4y5EeYifLLHOSqABR++4adWWtvgp2BPRTR8/5Zk+ydpZA809/MUwQFFiAeYCQqkwD3E5v0EdQdmVd56xC6p/W2Qt1zW580q78D+hsLaTjTrjxDdZIDI03U28zVcWTGRvykpSpFoHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(1076003)(66556008)(2616005)(956004)(4326008)(26005)(186003)(16526019)(107886003)(8676002)(478600001)(8936002)(66946007)(66476007)(5660300002)(86362001)(6506007)(83380400001)(6486002)(6512007)(52116002)(2906002)(6666004)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AhDDuhjDt//EV4n/PKUJ5GGjYwvaPVS3Bogiyx+17e6NCRGrUcocGwRH4DDsgj3+mDK0Q/wRj7nM/ufZ8l7uTr+K9aTV77PDUux4ggUoeFwie9zSsGOdgagkMoy7myVN9KhwztSujROkRZuXInmqkdKKCSjNItLUH8ClzxMh+WaGOE5/iSpR0mB+LsRtKVY9BfTAh7yx8CZ3kbSuLWsqG8OvaGocHDpj7kcZpkHhc0myFTQ0DziYabmmezBEvlApjpLKZyqMM02Njm7HqulFlJFSFgKUWbROUKnQdRn42aK7XyxyL+k42eFkDonMPx8jpBXlh4UTxsfu1KJfrWfQRFNYuSQ3qLsyMcEAziwm9+eQm7OqBsFT8Nf/GsZI/c0ZF2g9ChiMYwQPvywvzitSUXpypf1JM3Hc9mxGzli0v0Ki13EYEzLgv5HWZ7sZgfqhOcv5hxSHGuY4cSglE6TstbdLnuVIIMpsfhjrKP5LfimgYNKx6oTfgzQgdwHGTruR
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117a73f3-92d8-4fae-6521-08d82d96b028
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:54:09.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWChS7XV8xXhyrFC8a2ELBkDjnRZ+jXE+oFlWAPAyLLutu1TiJ1VVr6QphSV6B9sYtmc75YgGbsWOS3HBRK45w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to hold a device global lock when initializing
devlink device fields of a devlink instance which is not yet part of the
devices list.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6335e1851088..7df918a5899e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7421,9 +7421,9 @@ EXPORT_SYMBOL_GPL(devlink_alloc);
  */
 int devlink_register(struct devlink *devlink, struct device *dev)
 {
-	mutex_lock(&devlink_mutex);
 	devlink->dev = dev;
 	devlink->registered = true;
+	mutex_lock(&devlink_mutex);
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-- 
2.25.4

