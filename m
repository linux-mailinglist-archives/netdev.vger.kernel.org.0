Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7AD24BFAF
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgHTNvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:51:55 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:20705
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729533AbgHTNvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 09:51:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTn1QZ1PhTp6o2M0adB061+e0SvUBGmo2wlt8z0AIMp7u8n+QSGNg+rVj0UbEBpIA/nqhRyTSOZ429kHGN2U3w9aWAX2gXmxKL/SDn52By5LSj8pLxwpuKp75U12X5hbk0mbpoB9UVMTQR9c43ujgpNgQbMN39tVcDYO0JgDQUWEpRJICcgV8ZmX21wzOGSHvk6TCe9kSpEUrYTCfWfU0N2ye+BvdGTH6nVoSI6UtW6C4bA/bTwSg3jzXxPlt4FrbDND/KDvK+/UE22evDU1v+d2wc5iMBLiWS4I0IarsqITDQST11XLu6bAExTo/Rl+RCQT78X56+JaJKGmdii2tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdcRDBwPe4wdiThHxIeqMUsVeVjKDrtYM3LEuomtOXg=;
 b=OawNVvarGR3sVGOvk2QHvQmBoYzrZkldzRLtBy8LO5PttVzs1HnAhJVJUW/F0sHEcTQ6ik1DTXCaBTcDfHKLObKl+8H+oqOLDXf3Qrs6Nc4s0DlUWUI1sJ700BTD9kVCLeq82Lg7LYI6CQRclgWqGUON98Jbq6wK1+R/M7ASkV/dCmnIFfGgDDi8YKVXQCyO3AalRErVi0aVTrnlHl0/Kq2GMZan1AA1YUNQw9HO7N5e1mc9CRGr/Nvz1ET1WhHrKWLbLvWHl2JQ/s6iz5bJVyFBt43/dHI87+kcO9JKCrnjvy79Pi24iXhPDeqBPW9sOgx6We6JVRQuZdu/9VJMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdcRDBwPe4wdiThHxIeqMUsVeVjKDrtYM3LEuomtOXg=;
 b=cGEfnYiuJ9EPM+9RJHzctvAtzMEpo9cAsLC3h9PgXLHJVQy/c0CSBx85ZoWIvpId82NTX2X2JOyLj8+DKlwfFwzTT3scYJoKbmt6akdx+uKpg7ITqp0kjGWSmGq2QSWKPGq2QZzZPHPIncxqwgFVtqmTsjUkCgGRnLG1AtwgOnc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR05MB5252.eurprd05.prod.outlook.com
 (2603:10a6:208:f5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 13:51:30 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 13:51:30 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2] devlink: Add fflush() in cmd_mon_show_cb()
Date:   Thu, 20 Aug 2020 16:51:13 +0300
Message-Id: <20200820135113.31975-1-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0120.eurprd07.prod.outlook.com
 (2603:10a6:207:7::30) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0120.eurprd07.prod.outlook.com (2603:10a6:207:7::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.16 via Frontend Transport; Thu, 20 Aug 2020 13:51:29 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a93df51b-eef5-4b8e-ecb6-08d84510243e
X-MS-TrafficTypeDiagnostic: AM0PR05MB5252:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB52524CC1BD57138E6A16FCA9D75A0@AM0PR05MB5252.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x62QekStM3BmDzrImLUgelMIDD8mbgNtKqlukdXn9wtxFY3nOsD7+gOVRFxL0gQ2XWpLxsyCWNjTtw6Ugh9Gg1jg9PhuaJkr5tboFsd1pahSdsoHPsZCIweRPcL4pqxLwEUGkLEiFHrcv9p4r9srcfXnoCezqCEDMqE9Dv4xsgM1+V/h2/dJFYg5W+/CQs37IbG9h2jByJakbr+kbewXYRu2nqmJm8TJyRu+k2LJghGVW2KbMxvpbGmlBNs5TrxUXAgougafvTPgDA4MNDSO2x9gebEENXhvpREfUGdkXU2EmVOD59yotDgr07q0Vh1qRnKZM7nUKQ0l0A80qnK+OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(83380400001)(66556008)(86362001)(6512007)(66476007)(66946007)(6506007)(6486002)(2906002)(52116002)(4326008)(186003)(16526019)(26005)(8676002)(6916009)(54906003)(956004)(2616005)(1076003)(4744005)(36756003)(5660300002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kEeR61lcTVEoaeJJm5qeyAwGeny7r+0Var4jw82hACjreT897D7PfX/Yc5c2R9HMep2u1rAbC55vQJE8AQO982cLUNsjqEesT/JFvDDoROsmHOqQ/I+guYkp0FBIG5XfnP1usdpEQY6EdJASPmAM/eJOP3iM7zD3+Ap+xJXVdil1nmdFd15rAc3y9EUcSwqOYvEvl9WJ3y8MZ6N4iFbtFKAfdBR4a6wDiYgIRci7EukgfShflO4Nz3lmiI5rzoSlNTSbkLP6WM41FcY0lYUiOAsY7PyemFYdvm7q+qMYCkVHMl3pqZyV0x4vQAsXou3DJmA/AciNywKhNOGaMS1yOdEIUbkRtaT8uXLT5baFoJwSK6LXANRz/txaf10NY4CeI+mviMyJmqzQ8sYhp0UFyhOoeuxxa8cNq004voENWM30WV37OMBqAL8J0+TWtY969NlnOFzlGmH/bpovnJCzkpKV79thdGSvjSahEwJ9MaNwYxf6oETCBS9VdtWULXZHs6oS9uLdMqZ5HCwk1t4CqJRmfmE9OZLwYvt+lkSs6dHM5vocYo8Fkip2haDQHuYIYcUPlVmLwuYi3AtAQ59a7Zwe5AMH6hEp+6Y9p1VhN9zljPWXCiUKCRLDlJfcrh/6/koZL0Kw5OBvuTjd4syClA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93df51b-eef5-4b8e-ecb6-08d84510243e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0502MB3826.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 13:51:30.6150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlWnmR32aKC2cR+TXXSNLVg6hrX+R6Jwu+nIGFveTsFHqPoEEoXZ/OlcTUd3GEmWMvXnKHEi2dveGRH2s6OCSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5252
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Similar to other print functions we need to flush buffered data
in order to work with pipes and output redirects.

Without it, stdout output is buffered and not written to the disk.

This is useful when writing scripts that rely on devlink-monitor output.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0ab0bca5..4b7d4452 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -4654,6 +4654,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_trap_policer(dl, tb, false);
 		break;
 	}
+	fflush(stdout);
 	return MNL_CB_OK;
 }
 
-- 
2.20.1

