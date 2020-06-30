Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C7320F267
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732308AbgF3KP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:15:29 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:6261
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732152AbgF3KPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 06:15:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQqsfNpmq9K936HKUJGHoSstoPgupOryAFT7WSQrC4aROALS8NBnb9rVfSGxzaZ+Hiq8TPYCAtbYqUSpxIhiW3KmldlO7wtCkZ3O13Usj63p1rq1kUqU5wow47nFZL3vUUpcz75WIuom4y4ATZieF18OnAVA9dbcEE29eE5izyqLE7IkqvDgGll+13TmGOuOfDAp0AnY2t+FSljRA1e9+1XmyAyz8zxJEDtt9cRNtcDv5sIOXOnyxMX64wTjEgYNujd811A9aKDf6TlMYBZuetKY09qGApW3VOA+2Xgybjo0BY+tKjLLmoEo/BDuPn8g2kK56xzX2j7lq4M+nobQgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxdpXo7jQzFsbHqqUB0EBJmSyht6vtbl+S0T/P/pLI=;
 b=XbtjDIRl6Zk8IaI2ZZdt2Amv+Ipdv8GBHq459oqTyeInnGWby5vMTEpBge4ndemHGQHCRsowp2W0LH13/r5Wjb2tbGyCFL8tr20IJkAstetBL8wB7qRw4WNtolKmVVxDJ2Yc9WnouQN02Cm0VjIA5o1+WiEzTwrJzPWqT+6szaYv+G1sn96Uq6y+GC0vTGCtUr62hPX5R1DdV5oA7oij9V8JjxarhMv4UAZZdqsC1ZHPtFMBcWinz2aQuTTGuXlFScG1K04K5tMtDPaqH6mRUxn05052Jt2igsRCdKc/XKH1v8vUFFCU1jQ5Y9GoA4pPnxSq854nPzkPVqtl9NRKIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxdpXo7jQzFsbHqqUB0EBJmSyht6vtbl+S0T/P/pLI=;
 b=gqqRKZBK9jOSK1E0KmAjzFaMRHitu9axnm4wdDJTG4FwHCHxFJhqdWMuvtWBbJp93MXAPPbc3cfGv7JKmhJkJ8X5y38B2CU6JeKM7WipTk6cCXEAB+43bDgrQzQ14Jq2eda89O6hocbzH1rxEdJ7y/xBOOvEYYUd9WOkRMPccSs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3417.eurprd05.prod.outlook.com (2603:10a6:7:33::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.26; Tue, 30 Jun 2020 10:15:18 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 10:15:18 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v2 1/4] uapi: pkt_sched: Add two new RED attributes
Date:   Tue, 30 Jun 2020 13:14:49 +0300
Message-Id: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593509090.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593509090.git.petrm@mellanox.com>
References: <cover.1593509090.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:208:be::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 10:15:17 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0973cec7-43d1-421d-840d-08d81cde7d10
X-MS-TrafficTypeDiagnostic: HE1PR05MB3417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3417F8EC45E25D2D3668307CDB6F0@HE1PR05MB3417.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDRtaX/cWCqrzXUSH5mPHyT4/yICO6+jnKxdQIonGAYivg9o88N1NdR6TkA5dn3Bz1ErW00SA5j7/85s9A6AbTtivGpVbdbFADr31oGqKbsFZTtc2nicfcJO/Yd7JdOqyZ+sXp1TxM6YOXN81Nz4lv7xfmCtb1uPG7GUq+sgxqtU/t18V6V+FPZ30gVhTvTtTTZ0p/TWEnsD2G0be/ZS3szPD5CJLHSZT7AxnvH1Ch1Mw9gRKFitDmgsP89yCF0whFBsaqRLT+juy0OVDA3e2e6hdSrOXlj7ELfcNMhVrXR3BUdx4gyT5UX88dSmvNZzca2KhcYk7abZNvq2MqLBRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(6486002)(478600001)(956004)(16526019)(2616005)(107886003)(186003)(4326008)(2906002)(6916009)(8936002)(86362001)(83380400001)(6512007)(316002)(36756003)(66556008)(66476007)(8676002)(66946007)(54906003)(6666004)(6506007)(52116002)(26005)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lbs66AHR0Qruw2N26aWTsQtuGqjk3fhlRFIsSDGYgkY98VM3ELlw4NwttcYyj1ZLmZl9TbqynVxuYuMAVht5BxJRUfn1QbO5SQ2VyGtwKfPhQLc0N+aAlAxRyAvbilv/H3cQfnVRcHRuEdVmWCFa0yyCgYkwwZPFmPOLdvy8JZ0xLy41++E812tSXuxX1vwrZGE4yjym65jTPh63x/az4lDavptAWTqpnpJKH5LzJ7Ub+4xn3Gqc+8WpqqISCqmwcYpkG7IAtNqMPgd6dekEXV1OuNHrBFF1kAsaoqzDI4H4CEL7tsM1DRILvax/ur00OOq6CIw7bTFr7VUYRapEc0w+1RjBYJ96y1PpM1mp5Ren2K6qQK5hSYqAwVGgyZ7HAm96Iaf+TrKq8YJnGiTBQzNMZK48zDRbrs0y32VyX17Wal0eAyFP1ETChfYrADtc8NJsZ0oDnVfJfjxCa2D5TPUo5CEjO9EiTTLfI7RlNGg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0973cec7-43d1-421d-840d-08d81cde7d10
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 10:15:18.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgQkfSRrha5gGHKJXTMLRK6m6OAImAMsHw+wqsZcBU0jjubBjiLKcpaHK5exnvW1bWXkeULuU43EPsigvug9kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index a95f3ae7..9e7c2c60 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -257,6 +257,8 @@ enum {
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
 	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_DROP_BLOCK, /* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
-- 
2.20.1

