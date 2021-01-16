Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630862F8ACB
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbhAPClQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:41:16 -0500
Received: from mail-eopbgr40114.outbound.protection.outlook.com ([40.107.4.114]:48708
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbhAPClP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:41:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3q20/Yb+CeyjrXr2GCF2/VncxJbJw1HeWaYX7yoidaMSpwRzsKK4GifXboCHiXGvsh4dWR6wIt/8wl9/2UP8MUM5gBNj1ds1e7tmznQg1VjKekvGJ1YnDfr8hPJ3mUnwXQjYo9ShhkwA8MyBFT+KR13ePYZvYZi1JuUo2csa8B9QeL9NnMZMqXUyqO7KMi89futfR6gsYRqudIzFDRtxtwZlfKH5iTFs32kx2KZWE7kASoy52wqWdsD1uuSCjvNOW3cJcrxmNWzOq2XKcMD/jXy3d6BbeePTsv1OVbTN11zoZ9BJ40XhjB4hJwjgGabXMnyteNzHbDN52GfotJtFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cjqi7e0bg1AbzISssH2R14XYsZJAShrHQj9Y0LBKqCc=;
 b=dslZ1Kca1kR5Kv0gB7flIzN375lAB7xxcZ38mqNUs0RsRHYJ3hunuVr74rlMsZi8mwbiU/4JxcYkXGV9+CM3CNxsky+j1gojmjxFq19hoa7JgcNngZeb78MLtFg5FUIPt2W/w1jlA7eSDs91HKHZYqDykQeXxUttiYoGi1PNC9kwtyJB4Wwhh12iRCZIp2CvB1pZVr4jrOD8WFppWoxOhXQJ+t9RFX0zFF5yt4WUHGcmjR7yM03nY4y6AUVsa55Z8tRskRY1xyEAse6XiTLG9L5+lMiyBelm01oXbeogfUZOqDXPzeldtxhFSCQ5i2NM13Y/Qg3Q2wWHOo7tORMjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cjqi7e0bg1AbzISssH2R14XYsZJAShrHQj9Y0LBKqCc=;
 b=FuvMJak8xt/a5XkO6AQfzytyAPEKhYg8OtchnDdLK7LJyS5t8avsOUEwSTKvWoUp4qUubFLwDuowTzT3n9TlGCqgoen95qd7TOWjtxSu8A0JEYTljClfhbw7e0dVrScqzj0yikC907Pd4RNZxy/rAGPam0HHtDnCZ6EFUZyp/Yo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Sat, 16 Jan
 2021 02:40:03 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.012; Sat, 16 Jan 2021
 02:40:03 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250
Date:   Sat, 16 Jan 2021 03:39:36 +0100
Message-Id: <20210116023937.6225-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0025.eurprd06.prod.outlook.com
 (2603:10a6:203:68::11) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0601CA0025.eurprd06.prod.outlook.com (2603:10a6:203:68::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Sat, 16 Jan 2021 02:40:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 338c34fb-7fb6-48c0-bbbb-08d8b9c80705
X-MS-TrafficTypeDiagnostic: AM0PR10MB2674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB267416E7EAB260E72176866E93A60@AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RD45UtQcrO1rxC6iDmF3YizMaWfPPcPJcMJwqIY/Zl7gGP836E4F8l9k2ov+kAmg5giidHK0rqP91O1IapIiXqW7mLrQBAANfN36fhtl9ooPrf+qyuTe3hFmUYN0wSIP9W8Va+9G2OFcqdnqEWxUgqiqob2njs1oFvuBSVBqjny+CwoE4ruYaui3OoMkVYRvnWex2Iy3UddqUtgh5nd0ql+k/9q9eT5Un8n1FYbmb66AkK/QEbP24ZHjAgORbX6gixDDNJpo2XqX131LodszBsMb+z5RXur3Wxwx4dOeC3vjPPfXnPz6aLAPn5glPthu9CiR/nOzgFYxWROIz0Wgd+Pw3CliCP7zLHV/Bf2IeheaXHjFrc+PWm8jJ7VD/YGwvv/hZiQc6vKzRTemOSYA0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39830400003)(346002)(396003)(66476007)(66556008)(66946007)(6666004)(4326008)(5660300002)(36756003)(26005)(52116002)(6506007)(8976002)(956004)(478600001)(2906002)(44832011)(8936002)(6486002)(110136005)(86362001)(83380400001)(1076003)(6512007)(2616005)(54906003)(16526019)(186003)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rMYq16XvhYtwOnD5WlBGSbfM3ZDfkRspmA0WhWRc1Pzb55/1Ff+XlE5ryr5k?=
 =?us-ascii?Q?YnHJXQkVZj4hQuFaQjIfyFNEzPtQQpIHUzoS4Ahj9470XTB9iGDlZGSxaxsH?=
 =?us-ascii?Q?bSW2u+5S8dx8rK3FoVJjhWGKGJxHteFYcb3ilG3Cn1P2woUnmdnd9OUiCv16?=
 =?us-ascii?Q?g2PAVmjIV0YjuWECRXJtiERUhabEZBTg14qMcjOI3fPSVnHlk0bilmjBTRlD?=
 =?us-ascii?Q?9ExXlSZq6eb2PIqgjtJWfwmqQ+EtnaPK9jUjy+TqlzmIsYAKAih1YyDH4cx2?=
 =?us-ascii?Q?pE0FKO3wVvJt7AFrC99A+VfG7tZA/XmPae1liAP4LIP7eyAG0bliky05Z9LD?=
 =?us-ascii?Q?ts/NfjdhN3ul3M+Mm7whXm67Xvy/NHpZPSe/pkYy8I7JLfeOc5oEIk3TnsVE?=
 =?us-ascii?Q?Dz/nzTG+M+2I4ztiXg0xP9sDa/Q8XQZo1cxUTpMgzKWWB8dNNQS0CM1bpmyq?=
 =?us-ascii?Q?OJp2h+AdCWSJtUNwr4AN7O9eYEYnjXLQ0VBr/sx1Ns7Kxczk0vV8LZ9KrdP6?=
 =?us-ascii?Q?I2MrUNsB5jlBKnNNjXxUjw1h69ysZ/QSdGwgKJDeUVgRVywET+pu/+sKoIJs?=
 =?us-ascii?Q?TkGdz4oH4V3JV3HERveKre6Hh5bFOulGDVYna4NcKUiXL2CawET7gLOAc+G5?=
 =?us-ascii?Q?ytMA0ZGex+mzZOdsaPoIvZJGyEzv4cmy9jLRIXKaKwGOZcn7tDBVIlZSwUns?=
 =?us-ascii?Q?i+3Nu3v99unbOgwka8zHmJvrOnyRahq5IxyHC0lhVSmCom9SoDA9WNPDH/Ab?=
 =?us-ascii?Q?zCtDVtA9wW6qoahUIttgjIpU8wqww9s3laKfwuA9q7LhMcbsmmrtD9D0hnKN?=
 =?us-ascii?Q?Bd27CoqC5eGsKlJ7BvMDTktcfbxo4SAh3aCiKlSKiRzmCWEwREtS6A28kqEF?=
 =?us-ascii?Q?4jtqwFCp9JQfVn7RI1KGzjsgfowGm489gQxZ3nPdpgzjsTgdJYOiDTJGp0EH?=
 =?us-ascii?Q?t+wG6gygSoOEv2SE09KzBxjuYAmy9fq+5aoTRp58ArWzBRH1xgraxfKVrtQ/?=
 =?us-ascii?Q?0IGz?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 338c34fb-7fb6-48c0-bbbb-08d8b9c80705
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 02:40:03.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nf3OU4aPW/rSmCwsgNY+GjlsMbc0nGFhvxwCPsm7Nl6rhZrfFKjdFN4NY/QsVzQKg89LCSqCnrhXUVaXKYd8BHL/1lfskzLDzsBgoNKUkqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6250_g1_vtu_getnext is almost identical to
mv88e6185_g1_vtu_getnext, except for the 6250 only having 64 databases
instead of 256. We can reduce code duplication by simply masking off
the extra two garbage bits when assembling the fid from VTU op [3:0]
and [11:8].

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/dsa/mv88e6xxx/chip.c        |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.h     |  2 --
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 36 ++-----------------------
 3 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5cc1465fd635..8a0df1e903bf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4023,7 +4023,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6250_g1_reset,
-	.vtu_getnext = mv88e6250_g1_vtu_getnext,
+	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6250_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 80a182c5b98a..d2dd2f4e4730 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -336,8 +336,6 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry);
-int mv88e6250_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
-			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6250_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 			       struct mv88e6xxx_vtu_entry *entry);
 int mv88e6352_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 7b96396be609..519ae48ba96e 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -336,39 +336,6 @@ int mv88e6xxx_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g1_vtu_vid_read(chip, entry);
 }
 
-int mv88e6250_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
-			     struct mv88e6xxx_vtu_entry *entry)
-{
-	u16 val;
-	int err;
-
-	err = mv88e6xxx_g1_vtu_getnext(chip, entry);
-	if (err)
-		return err;
-
-	if (entry->valid) {
-		err = mv88e6185_g1_vtu_data_read(chip, entry);
-		if (err)
-			return err;
-
-		err = mv88e6185_g1_stu_data_read(chip, entry);
-		if (err)
-			return err;
-
-		/* VTU DBNum[3:0] are located in VTU Operation 3:0
-		 * VTU DBNum[5:4] are located in VTU Operation 9:8
-		 */
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_OP, &val);
-		if (err)
-			return err;
-
-		entry->fid = val & 0x000f;
-		entry->fid |= (val & 0x0300) >> 4;
-	}
-
-	return 0;
-}
-
 int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry)
 {
@@ -389,7 +356,7 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			return err;
 
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
-		 * VTU DBNum[7:4] are located in VTU Operation 11:8
+		 * VTU DBNum[7:4] ([5:4] for 6250) are located in VTU Operation 11:8 (9:8)
 		 */
 		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_OP, &val);
 		if (err)
@@ -397,6 +364,7 @@ int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 
 		entry->fid = val & 0x000f;
 		entry->fid |= (val & 0x0f00) >> 4;
+		entry->fid &= mv88e6xxx_num_databases(chip) - 1;
 	}
 
 	return 0;
-- 
2.23.0

