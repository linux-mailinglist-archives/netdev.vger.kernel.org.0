Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C471A3EA6
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDJDQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:16:30 -0400
Received: from mail-eopbgr1410045.outbound.protection.outlook.com ([40.107.141.45]:47552
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgDJDQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 23:16:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJIH9JOGF0x+yFp2GSug2SK1wMbWGyLByq2a3yHzkLB0bvOkXYjdFYR6HEdvtO08CDwe7qtZ0Qcl7A8WQ7D/2/YrnvpRYPhNXRafsw0cuE+BzmoKIHjkEXBWd2A3N12QgzjJ1VuNy2HmBxpkU03Yn6F4JXhn8DlM/BQ6zs7wsrwktkiriWoJb7VuFroxtLB1MQcUvSZpcVscj6AxchthVvXkoszkklmAJ4vcwJP3XAvZDfT9VXWvUVJKWBxN3qRyiYQvi7JPdbn3Xhuh32B3M8DbCAo6wB2FoDQJdtJL5AX+jb60hBs6CbYHKCjyAoVB8GbImJMbo08/bmN4GbXy8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2MQey6v5EzfiPNlUPryW/W1DvPGz3P5rVYx78+tU/s=;
 b=ZCPiMZ2GQYj1EmTnGtIPY6jFDHm130vOfmn6MmlRb1FrFthlg3vNMpg7QW425Ce7erWm/6PRjdUHlvEYrTl5OZu6NEEPNoX0kwIceciv3WWixDQ03zf+jJXfwdONRgZFmw3mgm2p1JXKwBcs6e6fzsLJeT8S9m/VUq8d2zjQDnSZd9xVS/1ogxTXj3Prj4/X57JyOvEL4SVshoyHXRlcy/FBY/t9ngHEjvfr8sDJDBLJHsn4DJiNRaKaBXoDSFY+HldZrhD9hkC1RFb4AjR1S4IsvE+ziDgUMMKHNwX3HJdaPGJs/e8oi5LNRjgpGLJrd+3hKzZXLs9QBKz5J1kXDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2MQey6v5EzfiPNlUPryW/W1DvPGz3P5rVYx78+tU/s=;
 b=CtTKlxjkpPjlur1mW8eKlaQ3xuRepyKvg97KN59+v3NjWleNoYVql3YENRkoHciPVkwpl52vzne+NPJGTmVSPxQTHnKi8mxvcPFsA7XTcOnQppyMmMOBuXaG4u76G+hC9aVW5nPBOKmnupChTrxq8+H7hrTEDaGULZwN7YAFiWc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atsushi.nemoto@sord.co.jp; 
Received: from OSBPR01MB2087.jpnprd01.prod.outlook.com (52.134.241.18) by
 OSBPR01MB2198.jpnprd01.prod.outlook.com (52.134.241.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.15; Fri, 10 Apr 2020 03:16:27 +0000
Received: from OSBPR01MB2087.jpnprd01.prod.outlook.com
 ([fe80::71ff:5526:838:a89a]) by OSBPR01MB2087.jpnprd01.prod.outlook.com
 ([fe80::71ff:5526:838:a89a%7]) with mapi id 15.20.2900.015; Fri, 10 Apr 2020
 03:16:27 +0000
Date:   Fri, 10 Apr 2020 12:16:16 +0900 (JST)
Message-Id: <20200410.121616.105939195660818175.atsushi.nemoto@sord.co.jp>
To:     netdev@vger.kernel.org
Cc:     Yuiko Oshino <yuiko.oshino@microchip.com>,
        tomonori.sakita@sord.co.jp
Subject: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
From:   Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR03CA0012.apcprd03.prod.outlook.com
 (2603:1096:404:14::24) To OSBPR01MB2087.jpnprd01.prod.outlook.com
 (2603:1096:603:22::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (61.200.21.62) by TYAPR03CA0012.apcprd03.prod.outlook.com (2603:1096:404:14::24) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.20.2878.13 via Frontend Transport; Fri, 10 Apr 2020 03:16:26 +0000
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
X-Originating-IP: [61.200.21.62]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 174373a0-7626-47cf-bbc3-08d7dcfd8e6e
X-MS-TrafficTypeDiagnostic: OSBPR01MB2198:|OSBPR01MB2198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <OSBPR01MB21982A38C452D9DA0FFB9EE1BBDE0@OSBPR01MB2198.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2087.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(39850400004)(136003)(376002)(396003)(346002)(8936002)(52116002)(86362001)(107886003)(8676002)(103116003)(4744005)(26005)(6496006)(5660300002)(4326008)(478600001)(16526019)(66476007)(2616005)(44832011)(66556008)(36756003)(6486002)(66946007)(81156014)(6916009)(2906002)(186003)(316002)(6666004)(956004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: sord.co.jp does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wO96pYYA6Gyi7Tvg7G6ARNPTazhOlRCzrzWUQtGVUw0iws4mkQKJDDtOd+iw8s1pOeRzgL4uBNRtZkl4eGzOmxcL04FwGRe/tLbTsGJgXVE5SrsXfAjO4XC+FZQFEf8jGqseq16AmokDzGfN3VWeJEku8TB519XbRCZ4JA0enW+9cou0HDQUA7lVb9IA6QXGE/a/I49gx1zXtbA9gvtBKMwgPzYye9hiTsWpNfJOYxaTaNiEfekJSr1znXGCAMY/TZatZtF6LSisOrjxYWXPRJV8XgyMMPnvP4oS+4GNG86aW0Wh67fUcKW5ZmjUBPh97qqo5ldfA73HEHCqaHFfaMGPpOoH0VY8FbH89WsJxoT0TqwGrHnFhgpedwxxa7MOErnTa0HqwLSI7g7/TSNiGN2z58rehwq+T5u7tgzUwzbdfHQOU8Vr4QHXW9WcW+W2
X-MS-Exchange-AntiSpam-MessageData: QmE1BxMyo2DvNCXGJnw0z+1nrztryYkBeODFrenKViXb/abzqtZSwhHgx3sgJE+W9idq7dW+03ge4AiqAOOCB8CSnDmJtcCwvXOXOWgiUrZkkRyThIsni2jAYtjqhBbnRcAcagrZjASa69nzzHvtpg==
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 174373a0-7626-47cf-bbc3-08d7dcfd8e6e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 03:16:27.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yKfLQuxjUSzqJPHwJBgFsi9N+vHbqRvt+6LD/ODZrBT6unMa+4HZnsDAIC0qazl5VgZufIQV0eKlTHVQPLhYvdXCDrQwc3o21t8OQ9USHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ9131 will not work with some switches due to workaround for KSZ9031
introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
("net/phy: micrel: Add workaround for bad autoneg").
Use genphy_read_status instead of dedicated ksz9031_read_status.

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 05d20343b816..3a4d83fa52dc 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1204,7 +1204,7 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
-	.read_status	= ksz9031_read_status,
+	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.11.0

