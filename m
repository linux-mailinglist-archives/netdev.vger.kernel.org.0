Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E03C24E085
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgHUTPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:15:10 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:30460
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgHUTPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:15:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LixFd5gn6W3TycZJKX6v1sTRrDf54qOzCgsfIBTK258ZL8erxK9q1h9GIaU2RSYhO5dWZz8QT2zYMhrqxNaao+HnjrLBhvI3HPtdDyJGyg80sibEcomxl/SaCWLHhvRLaEp/5Ruou9IwSGqc2hUTKZDIM8Mpf3iB6Pin+kbE9pDdraJ8Ly1+UwkB8NwauOz8VYALXyEyP+TSa7iMhPJcmbSoCtmYLRBKq2/45Yj+N+GTr1hkXAiaiIMgiAOdSQFuIaGbyRP5cM8Bx3TDs5gTm2Tmpxqbudr0fuGjg7q1G/QKpAqizkNu5oPkS3egyTGIM8hl7dnHOh+L0TB8h07ygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AXFHDVHwb4C2VtCIx12tbY8LSjWQrB/IXdENpBvsTs=;
 b=F3KZcauryFZ0g9Ay68trUXK61DZa2Ufzu9reAFMw9tFyhyOFXFjZ8OwFKQ1KRS16A60JC5QzpsixcN3T0DEk7VNFj+jc873Q+68eU6JApAekkiUa5MLEeBGNdA39kxOV0aBLlTQrufn6byaXqd84/TmAwUVtckm4iGCCm4MBaWuHBOBcXgzhrWljDsZsxasn31YMGKDxpSiIvg5lILfbcWJl1bHWPS9a/5QtqK+NYwAXOlzkSEIZtr2sCjSs6CuWNGIViX6saJHbx+bYnHT8urvrkt88Lf9MFzweY2Y75K9L70Jshc0+GL5qHY/N4RY8eVk7ItSp4lwtWX6kjouWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AXFHDVHwb4C2VtCIx12tbY8LSjWQrB/IXdENpBvsTs=;
 b=QDzTJl/kjbTC7U2/Jc7aWCzYPycgj1u18fgXoY3GJGB7lWjCjlYqtsh6EUXOTnodyBd1NZ6CzSyzfyAGCH7cSvjE4X9p1llN4+gHqi5dO8hardFmZHsGMK6o5SE9D7H2MxlFuFWnMa2iPCeNIhLePVEoY7D+F/EGVtp839B5FDw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM4PR05MB3348.eurprd05.prod.outlook.com (2603:10a6:205:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 19:14:54 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9%6]) with mapi id 15.20.3283.022; Fri, 21 Aug 2020
 19:14:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/2] devlink: Protect devlink port list traversal
Date:   Fri, 21 Aug 2020 22:12:21 +0300
Message-Id: <20200821191221.82522-3-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821191221.82522-1-parav@mellanox.com>
References: <20200821191221.82522-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19)
 To AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 19:14:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 076cd991-ee3b-4945-958c-08d846067c13
X-MS-TrafficTypeDiagnostic: AM4PR05MB3348:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM4PR05MB334810AEFDD40AC89A90BB72D15B0@AM4PR05MB3348.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJ6lUAndeHzP68FR/u0l+zUJoxwrYt/D7bEuEhf/4Cg9t8mAbQRD5ZFlBVzJCEDJFbkTrtquFpgPGHvD2aZ99E+GdhWU4s/vZZJO1+AJIs0uJSuKhgkMsSL5bX5H1fFg4s00pZtYbuMkqk1Wp1AuIDJKjv1WPF+MhwY1FYek4A+unO6h2Y5bSmig9Gm0Bde0/j6GRETXRTaM6pS8eWhAd4W487PgGhuO9nDMgHPzmxIFIVwFi7hYsDM/6y/WJ6/Gd0iHFZyyMKlly3wldWICPzbhsvE7lnqXuf2fK409UKGyF3Iu2OUeoAm04ulRlgXE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(5660300002)(2616005)(316002)(1076003)(36756003)(8676002)(956004)(54906003)(6666004)(8936002)(508600001)(66476007)(52116002)(86362001)(6506007)(66946007)(16526019)(6486002)(66556008)(83380400001)(6512007)(186003)(26005)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UjBl97Zmo+O0x0uVlUbfxF/nEFGiHytzmPkFf+xjr+GiWy2p0V2gZHQccazGEmjPtTy9vEEiDvwEsKQpWwETwqprbfTeVbBU+gJJZfA/APrhndxFyldRsSt5medWL7ilGVZ7rz+oCiuVjS70fHUgi4J0wbVK2UgjZstIZd+n9RKVXVwfGTXq+/KV5lZPrZPoBZtTndXtPR+dbSHk11tugkJoqDSuZ0x3PRHYKy4jFYVRnWeCvcjYxSetPvcefLocY1I94f3A49OO8OqAksJRmqwQtKtnD4jLR9XHIPyMsuLZCBYox+R7uRPzOsihsHq3iYSzVzFWLInVYUi+k11X+W0vCVRd8LVU6mL8JEHRTB4ZQ9jdQo4SQ5ht5tUsJvmewNU9NZ/7KAInEiUAoeiYMUGvr97W7iVJuMnL4AFYE0u5T5xHiCj+Bs8wMB2kYySGXF7VgCZhUUp1cNCl23H2rekqAI8rPY7E55LiokvvQ4l4zXFdFAGYY07W/SmxI9SfFs373xWDAzmlWtEXrCV4Rwb8vEDDz1TOks3G4bfSJ/SgNjXDZEu0jFuUX7ARdpdDD5We95VeE7n0ddPVs69EuKDhiGxNASkgWGcTR5GbKACd8PsNP7la2unmkNTI4Rcemc3obYr6IuJu9WNTUhIB+Q==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076cd991-ee3b-4945-958c-08d846067c13
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 19:14:54.0910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvMJdnFw3gALkw7RkAaWIRb0kHOTh2VMFxFplxHvM9A+W9jmxlspQycsUARUZiK6vOFFgE3IafZ8Z9WBH/O4Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3348
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Cited patch in fixes tag misses to protect port list traversal
while traversing per port reporter list.

Protect it using devlink instance lock.

Fixes: f4f541660121 ("devlink: Implement devlink health reporters on per-port basis")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9b01f7245fd8..58c8bb07fa19 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5895,6 +5895,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
+		mutex_lock(&devlink->lock);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -5909,12 +5910,14 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 								      NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
+					mutex_unlock(&devlink->lock);
 					goto out;
 				}
 				idx++;
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
+		mutex_unlock(&devlink->lock);
 	}
 out:
 	mutex_unlock(&devlink_mutex);
-- 
2.26.2

