Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB62B01F1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgKLJ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:26:31 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:44384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbgKLJ0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 04:26:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsdJCql3vapK4h5mFDe9ZtDw1EaTDZq+KocIbcA07E1DmFOwZ4Um87p2BdSIJxxmAa+SlPk6RUaluN4eZJbBc1upuyDxH0Tdb0Wcx4E0bUZopzHkVnvZ3yaP7SYn4IVs6o+sNJR2f+h80rsQvM5T5CyvlvrhqRvvl8/uAEWUBc4+qRkxnG6YS0cfL0otsri4aJqAtZSdEFZrAhMi0dxtM024toMS2skiyrQ7cugKJzKPmz1TrPhM49kzPrkuJnt2CGOUegKNU9vaNV3DaYMuiQFqs6rAQljyOq48Dl3+EUW4FvlR1k3ddk7eQC7VlcCJdeFwoQWJbUV7AYBP0KxK4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LW5V7vavo3K6A1EiIYj1cguX7jueHHc60WKxVU2ffs=;
 b=SKwxSp9vO//YwCjkD2QaA9QIPLGgONI6CnYhtSE1Ldx0DxPb3MZ7NBqQYWb/CjvbAETibMy2xfrVHw9X10PtsnmIsdiewhDJDbIMq3FDEW+0UOMr/AT9IClM7zpS6UjC8sgiivtKpUPU4ECKRI/zGUVE5QkhDrKup18ODo4o36kCZr7DvOSCm0WlFxUE2aYc74mtUoT36RXrKSkD4PDtPzrKj86qCZD6tljqyLEMPuGs6NY/Y4qqxpVJt7PjEgFsSSW5IYGuhrqL7kP9JZieZf6unWCnBuUYZg3sIXIMTQbki5afqdKJ1j4earm3xHeAq7RUF5KNW3b8PxddkkLHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LW5V7vavo3K6A1EiIYj1cguX7jueHHc60WKxVU2ffs=;
 b=HPtq1DU5uruddymy1d5aomuRFudPUK9D0F5BqCI5hJRcwe32WPBBrHsHWZmxaNKWjB7Q9Km28AUIfcv/6QtUodVJ/Fdbh9fq3LxufyccYXbPi/462s0DXdAmWUA41Md12pn3szP5hVbcqww5n0uoUq1IEM67XZ5RCcDcaDgpkuk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=windriver.com;
Received: from BN7PR11MB2658.namprd11.prod.outlook.com (2603:10b6:406:ae::16)
 by BN7PR11MB2722.namprd11.prod.outlook.com (2603:10b6:406:b8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 12 Nov
 2020 09:26:27 +0000
Received: from BN7PR11MB2658.namprd11.prod.outlook.com
 ([fe80::e187:114c:b6cc:b4c2]) by BN7PR11MB2658.namprd11.prod.outlook.com
 ([fe80::e187:114c:b6cc:b4c2%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 09:26:27 +0000
From:   Kang Wenlin <wenlin.kang@windriver.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tipc: fix -Wstringop-truncation warnings
Date:   Thu, 12 Nov 2020 17:34:42 +0800
Message-Id: <20201112093442.8132-1-wenlin.kang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::28) To BN7PR11MB2658.namprd11.prod.outlook.com
 (2603:10b6:406:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-wkang-d1.wrs.com (60.247.85.82) by HK0PR01CA0064.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 09:26:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ccc6fdb-e038-476b-49c0-08d886ed07e5
X-MS-TrafficTypeDiagnostic: BN7PR11MB2722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR11MB2722F5BA6114BD22803D946FE1E70@BN7PR11MB2722.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suN/OSmrq1rFALcLExQ6fjdl8bi8E5mImNknFbTC9OVWihiP3Sz4mW9YmfBvmLkViuDYEM9KIMX/eM4qxGElT9vBcQyROHlikZZkyNfUw6hwdqfJfPBnot5Qv5JISHC6l1T/kyEdas/DUD8cWGZ6OtkkOzRl3Q22JA+z8CDCB/9tzo/2vJueljOPoc1lU1plVLMU/rrLNDB9RDjJrghWfnw9Ii++426Y/K5y8FO1f/o9s+iYfQj07xOikqZmbmyLsRii6TfSikQf4ixrXX867yGWY9fjorsMbky5O97B+01ScYHfpMDtDPjqJKzwLu81uCDujRffNUS9ADQdqMBwnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39850400004)(136003)(396003)(8936002)(8676002)(2906002)(86362001)(1076003)(36756003)(16526019)(4326008)(6666004)(478600001)(6486002)(6512007)(66476007)(316002)(66556008)(26005)(186003)(5660300002)(2616005)(52116002)(956004)(66946007)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZWvcTZDqQPIRHR8p1r9DsTYik3psr+mjUB7zY72QCDcJtTqOpnzCrlttD1Rfl2lmmSmJjmvnp660XDbUCeAGsQg75qN7mmfhhdbeQNFDPDl2A9kKd17LKOQeAgl9stL2br6aigcdBCaYadd+VO7a1+2I/AgAyC2HiaTrewjfH77duI5hUUoc0U24De+SEz8fe7yK4Crd1oSCjflXeR/IP/GCAGZBznvJIw8d82WGlNw2A1PMHoPivoB8PNP0OwawruiUiA9ug6MNPQ/ZSORlZJDdbMSSz6MQ36CyBfo9pkCHqylTdS7PMdiFDYXmUhjpM2SX89xyoxZST/oO8thxWPd4+/8b9RMC0YOGhxbJQmZB3s4tvAUAFntTpF1zqrlLuB9JIvDOJIHGJYzMX9Jk1TPaaeIlQVUty2gCwpSAPq+N5gO043F5S/7wY9snUQUUEsxNsu/IJ2CZoVu6YK14LbwMCJu1dMRK32MqWn/Fie04hSYqfxXkQ/UAdg/tHMiCv/bNGlN4BKL91O4WUN0LQixZsevfMwUXKjWj85oZh8ynHSOpr+WADIriSDXM++Qg8bR037+Ej914YNbSCbgcenvDVqvP5OedDeceuD73cflvaBIaTJRNCGCt9HEdsgUF362l/kvaPf20dvUPUdDgKsCTms5HQRtBhio+NSjpFeRHQAFu6TFrOkclGcTLSaQHtW/oCGLSmsZTz2akLbpAD9W40nsfW0snR2WPR3JzmDmhVzGQtUj5ZoDnKhARwTz2MbUm7K4ms4t5VNIJqRlN3XwYzhq6hq76yA3SpCOZceTKfL8tZLSnr9qa+gMHZ8CY4TIJy4wZa038IiLqYxI9NgSNtUSs8wEzFod17D+wjozWr6OjB0KsRwVzusFxzHCyqUyAwbPRtgBk5tzF10uYsg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ccc6fdb-e038-476b-49c0-08d886ed07e5
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 09:26:27.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOOXqLWfVLilHfidzb2JOql3c0VgGfJVvDzl4RTx9L1fF1eRgUt5V3tMCkCwLgFzpcCYhT9v+Fv3mnGf7ELq1wVftGcxLRjhzm2JEWXB9xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenlin Kang <wenlin.kang@windriver.com>

Replace strncpy() with strscpy(), fixes the following warning:

In function 'bearer_name_validate',
    inlined from 'tipc_enable_bearer' at net/tipc/bearer.c:246:7:
net/tipc/bearer.c:141:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  strncpy(name_copy, name, TIPC_MAX_BEARER_NAME);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Wenlin Kang <wenlin.kang@windriver.com>
---
 net/tipc/bearer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 650414110452..2241d5a38f7b 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -139,10 +139,7 @@ static int bearer_name_validate(const char *name,
 	u32 if_len;
 
 	/* copy bearer name & ensure length is OK */
-	name_copy[TIPC_MAX_BEARER_NAME - 1] = 0;
-	/* need above in case non-Posix strncpy() doesn't pad with nulls */
-	strncpy(name_copy, name, TIPC_MAX_BEARER_NAME);
-	if (name_copy[TIPC_MAX_BEARER_NAME - 1] != 0)
+	if (strscpy(name_copy, name, TIPC_MAX_BEARER_NAME) < 0)
 		return 0;
 
 	/* ensure all component parts of bearer name are present */
-- 
2.17.1

