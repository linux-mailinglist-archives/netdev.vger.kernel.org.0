Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65373279B6F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgIZRcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:32:05 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729987AbgIZRcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:32:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tr8Sm+mrFdxWGBEtjYaci3Ms4VEPuqvR3kwIzMYdEnYfL0/SntGCMEWpgOf/ObCxWS6TdyCWVbhV4JLkNq09qyTmv8Qf6jftbm813RL8XVI8dNcRM1q8FAKuLx2BGeo4jTonyxtS5DZHDP/KG4meQc+rFUls18uHf9Ctk4kavfaCdnemVm3OiQLbvWlle7rq2ccYyVe8SvUs7z45/rYw0VW46iVMVLJlW9DF+/4ZbYyTcVOlFRSZtNi2P6ReEeJ420zXE1xj5WRv7E1XOI2R6T70oWeqDr1UKio5+jpYIwGoRdZI+rpjB+uL4XUJkW67dzFNPo/4vY6aM5mnp15Kxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C1GXg3UWDHb3T6MqRCLZS1RZjGvI5uL7THK/GniwY8=;
 b=lyU8lTagwk0Ui8JgD4+RoxGrm/Mmgr+p4Q57kkHwr3gQ+8lmy14TA8TOEUFTI3WYeWgugksNmS984PAY8OBxIQN63m9BsD96iziPf7PKDKYA54c2/nNqEzSNY7wGlFKeLeZqLfBr+5+96s44o9HBrKm+GtGsVZon+ihdNpkDHPQN2Mk5GDIecyeODIzNfxZZrHluUdILzLywaRp2OCZ+D5WBiX1EVR+8If9UBQdFDaXF2RLjnaBvVqClOnisnTycYD4P5Z1HTj5Nrc9zEAc2Ma9lMw134MOF5dahGNsNrpmd/x0zJG4agrRaP8H/DIT3IJzjoZwSF3WjyKzw/waMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C1GXg3UWDHb3T6MqRCLZS1RZjGvI5uL7THK/GniwY8=;
 b=SLPC4javnt/9zD+VvAdRfW75ZWNKXtZZtA7J8PWZVT1cE1nl5FLssHfGNijSIWE3gwVxAxBKn21thinTakN9XfhmchoedBXrOgJoeJ2S5fHSkx6iSduds/ZKA85ABKt9LH2FKAPRd6EY90y2NfnJRsQp8Zl/XYPPBs8GCd4LAR0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 16/16] net: dsa: tag_rtl4_a: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:08 +0300
Message-Id: <20200926173108.1230014-17-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:35 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e099cac1-d281-4d4b-0efa-08d8624204d8
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481302A4A38831B7D4B25C5BE0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QYqz8eRwtpRsDq59bw1dJbs2EmDRlQU1YnUUgZcKzRK+TBbijde2r4vbApj2YRKBuGhLBtvNMAwTMbaVsTILeBaZSF1JPN1+PlYaCJi2RnM6hNrDakjAlYEKF8lhXbJeWqY6eEUcaMj2dWOBnJyltxxUZuyiPVechK8yQqzZlQASw7HPXfUaYZL42RY/Tl7zkZ/+Z8rYKm/aBzOpIJ/S595Hw40q7OrQV2bTyUNy5bfUGdqsNqhx+Xlct1zIljA22QLsdPwHw2bGi2jXZi+G1NtmC9k8co7nR49CAgSsy8RgoFcu0QpWHuYPEdu+C9UPZPEpl8WNlX+HtlAy3KBTQGS1/c/palRD6O0N9iCOXTv3OTCl/kX+Baec+qIeAJpG3Tvb6qX6AqmMSQU7PtvwVIrAj1DrdeiBkliav5/ALL5hGslXE1WNetUcSAYb/ax5OJLIWTDm3SKvRAeNys+6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ej0NHnEDIBdnuATKumMpBRtPpuF8PVTBdanWhyQLyfcuIIoRxojwri1pYg/KHgy6SG4I6jb6yigmgL0EhSH9EeBACgokvgwmleMgjHzXa7DDxqG084N7h7m03uP2Xb74dSmNB/q1swkn8iWnroh2uDETWFO9q9Qy1+dQN9KrbTXQzNmHrQmBbCJPpxozzRktKTeHhPCVIik8Ku6k8Kp511bZc6Pv4ZpjcjHcdH3erFq2Sgz1wVkIrfjn5Wdy4AMHw+Vz+HinG6yj3NPtkphyWyBwbrQSTnae8QbU3IURtG7+ZDWoT1Muv7FrNmY9zBS6ZudZUIctu4PJD+BnuDIvd8vOijQtfKfVKyBFSkCbyGBZnp5x+REbVRCuGH4yC7ioZ7dYEPiMSB2kgvwozEPAMiY3S5j8ka1y2qztAadH+O3ZmRbdYbNGZPRnfoq7Z9rRgnYQY0g98rw6F++RUTmEvUBxQP+TS1ACRWiIVpSGYSIXrjW6jfII8FRqDrZ416gBvbVwxrzv6vK2p0UX+ShdW6kA0F9EUe9N0Wp7IbQYYA9Y3cuOnIFhhj+J4j1WS4XUA2OmaMfVbCkKlt6P2Y6a/qFHYJWUXYpuH5ddxS93S5hjS5eY2etDkz/0UeOBqDgbjooZpK8OrHqQ0Y6P4lT9EA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e099cac1-d281-4d4b-0efa-08d8624204d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:36.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUpzp6YYNPFg0waWAUlpE+y1A1RusndXsUxfVLHWAIBIe7ObY09O6bW7SFrXY5mGeQqGxqlPvRxb31nTHKDcKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Realtek 4 byte A tag is placed before the EtherType, so refactor the
.flow_dissect procedure to call the common helper created for this
specific case.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_rtl4_a.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 868980ba1fcd..d2237a6a06d6 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -106,20 +106,12 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 	return skb;
 }
 
-static void rtl4a_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				   int *offset)
-{
-	*offset = RTL4_A_HDR_LEN;
-	/* Skip past the tag and fetch the encapsulated Ethertype */
-	*proto = ((__be16 *)skb->data)[1];
-}
-
 static const struct dsa_device_ops rtl4a_netdev_ops = {
 	.name	= "rtl4a",
 	.proto	= DSA_TAG_PROTO_RTL4_A,
 	.xmit	= rtl4a_tag_xmit,
 	.rcv	= rtl4a_tag_rcv,
-	.flow_dissect = rtl4a_tag_flow_dissect,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 	.overhead = RTL4_A_HDR_LEN,
 };
 module_dsa_tag_driver(rtl4a_netdev_ops);
-- 
2.25.1

