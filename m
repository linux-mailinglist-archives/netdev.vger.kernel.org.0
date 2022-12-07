Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9871964653C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLGXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiLGXkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:40:12 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E418B18D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:40:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEWM36DSOChxagq9LjWgS9+KFfm5M5wh/teA8qS3zOsedwILjDij2VdmFbW7K+JVUlWICOww3B8x6//3NYULn9wDuSmOg8+Tqx+12p1Ivwohnt07dAJOytNX+RztgrxudCXhUVwE0SZOg/1inLBd3rz/pXtRxZ25q7vWLkncKNGwoe8V9Evv/SRrUy1zKkbm+smr7VMJc5bSYal+RLpOyLhJ73r/4k3AKUW61PIA2V5OPuPdbBzy1FacvU9bjH6uqSxJIBirigtbDTAFoZF1JXBUbYrKreo9Gi9UGnSbhmqTXPKKjf3zfn41GbRaRU3JLwE46Z2APZ3da9+LqCvCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjV136m3oPLdV1ykVfMdGPcazhfTEZe4MHnGQtwqiSI=;
 b=XZjc2CIX7dn9fVaYqMKm9912QMAYbTUD11u3gxX0+d6oSv+vgE7z/UdRXKqjaf+FKgGJEHwg6BcpHHhBZj6aCJdJ5bB3Su25OFxUBq8ADfCMc2rtqFE0Af2xdAvkmn03NHJszS/WJ1kFkDaCmkbblV73WATsTapXOFH5UDL6ibK+vMt18S50NutcDD/lwE07F07gzMmQR7HFqEHRHjtU8nsy6YjKZ0jA36lipmCKCM1XD4cNUr+MJ8U1MRYe7KYPaEaxa6Pi/xvH3c1ELg++o/78aAzzjirZh7oMidkmnZWPO9aPagUZszI3Bkp6uVoHFsldfRWcw2XaYAra9BMm7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjV136m3oPLdV1ykVfMdGPcazhfTEZe4MHnGQtwqiSI=;
 b=SFECjuyF3k09wpOABCB2wXDxc3va0CgoGoGvNjlt1YmXK0zvuJp78UCT2GxwGaF2+cyEDAMVdwI5YSNEway/vQ+bOIIdnAuQLoGTxfKeoYF8VAoBUBqvPhD4cRA9fPemIK+7fIZoeWsAs6/V/1cJScKhBUFyJFaYryhQ6V8ChZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9659.eurprd04.prod.outlook.com (2603:10a6:10:320::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:40:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:40:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: [PATCH net-next 1/3] net: dsa: mv88e6xxx: read FID when handling ATU violations
Date:   Thu,  8 Dec 2022 01:39:52 +0200
Message-Id: <20221207233954.3619276-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cffeeda-d18a-4245-d107-08dad8ac5ed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epjehEBR7fNfy7DL5z3H+jf9J6spQyqmtnW1D1kiTw8P56ZHbha/N7NboaN3UP76KbrQteA6+0ib5LKp74IztsIXlm65ZFrDkoaO0Tg06sJkSBZe6Mvr7MJyG6RZlQ+hi+SVbmPKKswGrZ7t8z5hN5nrub4pRm4/056c2RPpFsGAJabDAp9Pw3RMONFwUUAi2T1Y2PbUSNR5JVFuGbhdP5RxKblKoChk5t5dLv6Locnin0oGzyoi8pXPtSckT7fFs6aT+Ynf4xmqgUN5fWEDAcCvd++7TRArJWJQ7NUTBa5IF5FIg6n7cu4bITmT8wVLOmMgMHgT5K+udZrT+M+kDOUxTb4+Eu+lVD2HB1FZfcWU9lWzL8F1f/eY4lXCfXVNWDSeAXVgif0lW1aLNgQNER2TUFN3dj3jorvoirmcNk9Ws7Ng1GcYOeR/S7xS7jwBDS7PKL/mlLilFhxZDBzDlc6zK+CRufSvCtmHnfnPDFncv26YetFpcEEH3CFOI/xdGDpTXQJNWAcsziqeGf4ut7tvbIEG8pqrJuAId5U9X9qVhIXZ0/tm4Hxlp4rG9NmatmPW8kfpdgJ8yR/DAoRlhxEpJ9VwMahfHnz8SADuV9a93TK1BGWlezBgUnbRi08Nnn71BXB8DMh7bUZprzn4lUgD5zzSuiIVYTJmTyCRCxB5ZcRiyT41salvkw2nG5o5FaO/EhZz+yr3XfZVfMEObA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(41300700001)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(8936002)(316002)(2906002)(5660300002)(6486002)(478600001)(36756003)(54906003)(26005)(186003)(6916009)(6512007)(6666004)(6506007)(52116002)(1076003)(2616005)(83380400001)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3I7WjLoR1jw+JxmSByMZeb9ndjODgMkbxAgsPVVn/oJdfAI0XVHucreycGpv?=
 =?us-ascii?Q?Vrl7Iosnl4LHl3PUwGciwHQNkSPMfeGPdJzeCJh8s+LpA9MbnvgGcy+PuDcI?=
 =?us-ascii?Q?B/fyxxyA9kbaEf2GRK1HjYoAyzj7c26GGMRrfG17YMHDkhw4Ihzfg2qfI/Fj?=
 =?us-ascii?Q?98dCIZ4jnBYgtMgt0OOiYWjI2iuPfSY3hiyRDUikwaTZdhBDTkukbpx87p6i?=
 =?us-ascii?Q?qifkqO8GxX7k/KCVc+6iPeCoUxPJZriuZhKI4ImL2f57/YzQDvSV775KwxeX?=
 =?us-ascii?Q?tZJs8zsPmxUskIPrDmc/2XQHzMXOyn4fDjt6TItq+KAF2GzVhSVDcZ5P83NZ?=
 =?us-ascii?Q?sKdfSTC+cFihNZJsQ801XVffiIYAIrhTEJR/ut9r+miH28G+tHUuNJCBYFcf?=
 =?us-ascii?Q?0JQeJNYh1siwou9u9qH54ASYllv0dyBUKZosaSxBMNNZfXsfdcXot0cF6xXi?=
 =?us-ascii?Q?AqUBidhzc9B4YsrXeNhGp/9qkcMhr182AK3TxUPWFmwaM/1am67O3YSnSwS6?=
 =?us-ascii?Q?ADDWas2vkjblv+bL/nVoEmkyzGg08F9lpAWs7BVNwXgKf+XpQu3ZkDk7/t9/?=
 =?us-ascii?Q?hrYiQzNZQ0fKRUTJDVRxnLUTzrZrPRBJhid5paRmsZ39Ci4q1e3pYBv8KUbF?=
 =?us-ascii?Q?WZJDH0fX7chxSFM+f6PzHYm31V3R4W5nusiy5OmTE0Ztsy9E5GxqlH26aQ3q?=
 =?us-ascii?Q?eF0Gc8nmfzIQPeaoftHw+w29KXXVTaQW8tkzAga+cfk7T7JqyWzJfdplxK33?=
 =?us-ascii?Q?EcsZIThawiM4UnOSH5q97goPl+wukgHGQuwrCEm72TmfS6/BqK7YmtJvj+is?=
 =?us-ascii?Q?9RBr7GyI7xEr41Ee3Mk3xTGcFFMb7xEqh+rkrU7fVbukhunMhX4NLLBlNsjc?=
 =?us-ascii?Q?Z5mFClS89cenHAszg8o7vJbDer2fsN7fzmEA0sdgN5I6NsyXAg9NNJBJRvBv?=
 =?us-ascii?Q?a9jT7Pk2wyPkf3Guwxu8RGnu8JK+Du7Vg4q/3ndwl0qlE3mWVp36SaKohaOv?=
 =?us-ascii?Q?ThJ/00v6uEniAVAd/TgICpUwXH+1YdlNukeyR17frv8CQK4PeRWHInlW1o68?=
 =?us-ascii?Q?Xu2jMGNcgBsLuaSfT1v+NVAzlXMdhNQXilUn225+EVgD50l9xuwKfnBWUwcr?=
 =?us-ascii?Q?1PR2MmvKVLM55+dJxkicjE7ZzdWx6tlXIx04GVfkX3UCHgXzki+Nx+G7Mgl1?=
 =?us-ascii?Q?FSU3i0TQTu3TfXgii2dOLvjonD13LXhdXsBT2OGLBRyHfqo5C6vZfm2R1N/4?=
 =?us-ascii?Q?LTyjIzWDFsmOb2j9Ozw3CHFMUDAKM9OBXmbX+6ZqyQYD3QRFTA2WEsnY3leo?=
 =?us-ascii?Q?SbmyP1PJkqPrepz9MtaZimYQbVGyZ8Tp3PIwqZGmSbWnawzdhE17jQ6vgndc?=
 =?us-ascii?Q?hhifKejgnxaQDjgs5y7+ZaPYq/9XsORPUFVF32cuGGV4sMJ/p1p6jSjEqMQP?=
 =?us-ascii?Q?fy/D+Nd792xhCOwdit3TH20DM3AN34JBlm8jFjBMSlZrmqWc1tgZ/dX8ilcN?=
 =?us-ascii?Q?hetzB3dVqctv1cVbQTWP1RmCeD8pjAmolCALgKsWYiBpv+bIHQIiBkx+GwUv?=
 =?us-ascii?Q?HwHlznoWKAxJH/5L4GzPMnGmPGwSvlC6pXLEIvIilSkqy8vpnQnsiKiaHXnK?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cffeeda-d18a-4245-d107-08dad8ac5ed2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:40:06.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xdRK4hcWKxuIanM1JXMN3PpfpTxGylP26utwewYKRNX6PwPgW2TxBq/jpvMZzvun0zmgvU0B2lzKwm1/tE5gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

When an ATU violation occurs, the switch uses the ATU FID register to
report the FID of the MAC address that incurred the violation. It would
be good for the driver to know the FID value for purposes such as
logging and CPU-based authentication.

Up until now, the driver has been calling the mv88e6xxx_g1_atu_op()
function to read ATU violations, but that doesn't do exactly what we
want, namely it calls mv88e6xxx_g1_atu_fid_write() with FID 0.
(side note, the documentation for the ATU Get/Clear Violation command
says that writes to the ATU FID register have no effect before the
operation starts, it's only that we disregard the value that this
register provides once the operation completes)

So mv88e6xxx_g1_atu_fid_write() is not what we want, but rather
mv88e6xxx_g1_atu_fid_read(). However, the latter doesn't exist, we need
to write it.

The remainder of mv88e6xxx_g1_atu_op() except for
mv88e6xxx_g1_atu_fid_write() is still needed, namely to send a
GET_CLR_VIOLATION command to the ATU. In principle we could have still
kept calling mv88e6xxx_g1_atu_op(), but the MDIO writes to the ATU FID
register are pointless, but in the interest of doing less CPU work per
interrupt, write a new function called mv88e6xxx_g1_read_atu_violation()
and call it.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 76 ++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 40bd67a5c8e9..a9e2ff7d0e52 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -114,6 +114,19 @@ static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
 }
 
+static int mv88e6xxx_g1_read_atu_violation(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_OP,
+				 MV88E6XXX_G1_ATU_OP_BUSY |
+				 MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g1_atu_op_wait(chip);
+}
+
 static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 {
 	u16 val;
@@ -159,6 +172,41 @@ int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid)
 	return mv88e6xxx_g1_atu_op(chip, fid, MV88E6XXX_G1_ATU_OP_GET_NEXT_DB);
 }
 
+static int mv88e6xxx_g1_atu_fid_read(struct mv88e6xxx_chip *chip, u16 *fid)
+{
+	u16 val = 0, upper = 0, op = 0;
+	int err = -EOPNOTSUPP;
+
+	if (mv88e6xxx_num_databases(chip) > 256) {
+		err = mv88e6xxx_g1_read(chip, MV88E6352_G1_ATU_FID, &val);
+		val &= 0xfff;
+		if (err)
+			return err;
+	} else {
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &op);
+		if (err)
+			return err;
+		if (mv88e6xxx_num_databases(chip) > 64) {
+			/* ATU DBNum[7:4] are located in ATU Control 15:12 */
+			err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL,
+						&upper);
+			if (err)
+				return err;
+
+			upper = (upper >> 8) & 0x00f0;
+		} else if (mv88e6xxx_num_databases(chip) > 16) {
+			/* ATU DBNum[5:4] are located in ATU Operation 9:8 */
+			upper = (op >> 4) & 0x30;
+		}
+
+		/* ATU DBNum[3:0] are located in ATU Operation 3:0 */
+		val = (op & 0xf) | upper;
+	}
+	*fid = val;
+
+	return err;
+}
+
 /* Offset 0x0C: ATU Data Register */
 
 static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
@@ -353,14 +401,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 {
 	struct mv88e6xxx_chip *chip = dev_id;
 	struct mv88e6xxx_atu_entry entry;
-	int spid;
-	int err;
-	u16 val;
+	int err, spid;
+	u16 val, fid;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_g1_atu_op(chip, 0,
-				  MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	err = mv88e6xxx_g1_read_atu_violation(chip);
 	if (err)
 		goto out;
 
@@ -368,6 +414,10 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	if (err)
 		goto out;
 
+	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);
+	if (err)
+		goto out;
+
 	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
 	if (err)
 		goto out;
@@ -380,28 +430,28 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU age out violation for %pM\n",
-				    entry.mac);
+				    "ATU age out violation for %pM fid %u\n",
+				    entry.mac, fid);
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
-- 
2.34.1

