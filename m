Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA06487B8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiLIR2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiLIR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:28:35 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABA65BD70
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:28:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lv+1lpbMqoWRiYzrHOhI/Ws5rcx0RZyBpjTthOvQkTxuQIiRjaUfXi/Vvqim5tDnEq17lIqUvZKnRCcu6BVxxw72LUPrVVXGCwcgMg1+He0UhCw/COpNLAgJ/fseXgJT/qQrpx9dBgrCQ9J00cZjr15vVEJ56o/CaTvYPzCPbpGbKf9jejDAdXoCEZFJrmo3XQ9kYLEPlwl7Zwl6n/7MEk8ldpqS4TAnQnzjxvuQFRCs87a7ARZVJuEc2RkLaza06QgU9Jtm6P02u0E0hK300ifqFtDNmrvyA/ZCuWSN/PuHl4XCTmaAukFqD2zIX2orWaAn20sosWqb8vLn4qDxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2/DLs691WXG0xbwkGw7D9VrKAlZpsk3D3BRU6Qmue0=;
 b=JxVGUHSt8E+zIKXpdkec2E9lTBaCfBF5wxjVJSrnNwt6cWm12eL49v8dV1kOCPA9JgtabPB1r8mFddy3G9+TwKJ6TLs2R1cJM8HSYmjO7TPp6/sJ1RBGWKBIQev7SpZ/GGcsttiNJDSLpSSuNqjRYxmbuOEK9uyFS9cTUSmClR0L+VBdShamPPlIddIWSDZ2Kk/NhDGAF0RmRqEoOYKGvQXmVUY0VBe758FCd1bXW7fegBmZkPVJXGHEKnMKk2UJn/JAj9cWLwm6I4YDN3x4ByQzh4zKgjKq+MomcOVScnxttzSVSH0SpWBigiqIeS1732aYNAiUUM1Q9ler4r9QDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2/DLs691WXG0xbwkGw7D9VrKAlZpsk3D3BRU6Qmue0=;
 b=NPsOZwU2QCFqlzu3+zkhKivegStTr4XliX2B3s74WM78b3zY/OQe4YdWhJf16bq1K7F+JA/gdhaZjqrseDw/UkAPFUtFc4S3RJEdedToZf2lJ7LLGPfbbDeT7H5fMu6XNfv6/D5KQVhszdK9sOhZS7g1sixdops7JaY0IMks3lE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7253.eurprd04.prod.outlook.com (2603:10a6:10:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 17:28:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:28:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next 2/4] net: dsa: mv88e6xxx: read FID when handling ATU violations
Date:   Fri,  9 Dec 2022 19:28:15 +0200
Message-Id: <20221209172817.371434-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209172817.371434-1-vladimir.oltean@nxp.com>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5e2306-c64c-4eab-7ce9-08dada0aca5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7HJ+Iak6bPdbCf5ZaDfPXmQgcexS50uHd87p0xdrbpSVbevFiP3Of3Z+GJtP1lmgrf6M9mP/b0DdNBVW1vbEmXfuMdvBrrZ7fO5RX/JnhHd1n2GGatRPRSOXd/FcGEAtCI6AN7Hsd7UVBuuLs2/6PC+4OdzJGPLqWgbxd+c6O2uBERCM8+Zj9DHaFLkB8lY05rOdZHrM4LPfcxTXZvPnNx6UyaRRFmn9Cbavc7N+gViaXwRYZQFEWSVyvUACiuWPth2YKaRO1T5gxbB8j1FMV7oRmqNMnCEOoG66U8ptXUTIbXJocwoPMBHKGQeAVylJ0K6PXUM2HArB+qfvi+bkwAiqWBn/6EwcBXSRsYGcoN9NShZUyvEkRWbHutjagQBEz+A97tQGJpQmn8zCkwIkAgOS0uXNXVx1Z72EL2M9wl3mpMpV7kVjmbIKLgBmGxNT+u7CiqHFCE6PiaAOdxI8GQAz4IgRvMlfcqW5FrQYZST/aTabvrlPi8zlWHrxfz2/5ROhH1ZiXs1QgeyDn6bFtneG+NkyncgOVLnTbGx5ugphDd3XDHcovL9rvuLCJMZVecm0zSzrngQAa+ZVxylWY3pNYeMMI5yQgnjDtg0/swzJDYM1hCG2ZP5jbGJtPCqIJ5NO0tUM1nzl0ejz242y+yeuUxtV0WSuV62GIG3pYWZa0+WY/0dqF/Hq2eEaVazG8ZmvO5uTKz08VWKI9vZ1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(86362001)(8676002)(6512007)(26005)(6506007)(6486002)(6666004)(8936002)(52116002)(36756003)(66556008)(66476007)(66946007)(83380400001)(38100700002)(4326008)(54906003)(6916009)(316002)(5660300002)(41300700001)(38350700002)(44832011)(2616005)(478600001)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ExlO9fMerNpWfaLmPf2Zv2CA5rKHzobuQTTK4iywiMiurQUF6JH2Rxux+jkO?=
 =?us-ascii?Q?vIzs3P32ghob+gMNmBoYXSqsp30fHjvo/o2uyVnM0Wt/dH5BYucNrcP8mEVN?=
 =?us-ascii?Q?rCcQSTIBuOWsBuvyjpLYgs/rzwvuN2ZP5x6nO5kGYcZITm48ykpYm0ducQiU?=
 =?us-ascii?Q?Uf5IXUElfX4KzZ5JmhlAJ736srzsRYO0Hz8CP5QRKd5VWjNFBg8gR6m2Gfy7?=
 =?us-ascii?Q?+XF4Bk12SDWmrABMh2APOumm3h8Zz5ZKp8wHrPfTJL0Pz5AKgEOyKVkdwzqy?=
 =?us-ascii?Q?OL6DC/f2EfMV9LcFAAiQdhXkDRtOrXIR7rUBWL7I+G1Dtnwoiy/ZW28SnarE?=
 =?us-ascii?Q?XnXxCZPo+gM/2Ogwc3qZMJeDJIpvC77IkhQa9N9Wbscu4bf13SpTuX0TVZ/O?=
 =?us-ascii?Q?OL3UKjejk5J5UyPivqwG4/jVD2yEelnWbHYZy/BCucNNwiQ9BPbtEPRs2Hs4?=
 =?us-ascii?Q?vABDWB5Bx6JL5HbYtVQ6r6ZUBi1jYZGwyV/wq9T0QcNMGmVvUgUd05lr41zp?=
 =?us-ascii?Q?/b0UC5pceeUl6Zbf43fpAFGk39FgjV1Wt+yajOPalbCdmc1UkpluYyvv0Fle?=
 =?us-ascii?Q?C7OnQKECI5uuM+Hxy+UA4IXTIW5+SrLkuR+YRPU1n3J6ShFF5Z30fmF5kNkx?=
 =?us-ascii?Q?tNwy6Pjazv7OX2jkT6ynYd8RLN7hZqvXdtuCounMhQ3OVJnN4/CXZyQl2mh9?=
 =?us-ascii?Q?YO0k66lccTMVMUrczFnCWKRDyHnu7mjuPV003LChnuYUuuM0ABCO3LGCxLc6?=
 =?us-ascii?Q?SR3zDT7yujlj8n7UVoCgbRqqDptuRkLbTpedW4ywJIjWqcOAmMioIY7o5oAr?=
 =?us-ascii?Q?1YwA2hsMwzPy87DZH/4FOpMnQkMUrIR189Ipr8VCW8soJ/UgJYZFEpA0Hi7c?=
 =?us-ascii?Q?tf0IF82RHKu9bIvuX6rtdirIBqflhp8qbE2B5I6BAJrvF8G2002nq5N3DZgK?=
 =?us-ascii?Q?4cdevvn39CSxN8Ud2D4LVm3B7A0uicNYZbKmAzlgFcc+S9Sr9eoGRHHjx5Ob?=
 =?us-ascii?Q?unpXu5AGzAtdXCM4LyoUkIsL8R6heYesqCt9kuoXfMtaIiVN/L1+Eu3mWZmk?=
 =?us-ascii?Q?tOwmx3TifyJgnGHAifBNpdvFiVz0hfX2ia7eNKnjZgs7TW7oQaAr1gpenDBO?=
 =?us-ascii?Q?Inz4qB+9BJRse8eN292mu4YC4p8b71SOks6v1j63K4mkiTV5l1+YO0YpvGcj?=
 =?us-ascii?Q?tZzco2T9Z5k1FrXk2nVsBhYumHBSlgbmL9yYqrLk4G96uLY0MeEhDZzLuiDR?=
 =?us-ascii?Q?gNcA+rs4I663hJyt9msDu3/LpcipNZSJmgt0qZVcOo9n/qokxBdJDlm6X4H+?=
 =?us-ascii?Q?RwGXN0CeYAFpt4MHDRWzif4CAxwc5Qjn81ll3yU2PbBNbgQTubMtwpVdkpR9?=
 =?us-ascii?Q?GPb/tunUtxsveFZyozr/khgnqfpKt6qKmeE7TxOW+V9XpKGZfAqSwmbYmKPI?=
 =?us-ascii?Q?vMtEXQ6ae6lvJIyIWavirzd6jKi5vbBavj94hVl8MCCFfF0mxGSH427zdmWL?=
 =?us-ascii?Q?G9LCtJLuS24xOUBqhQVYn9g4tJb3HGMMPjmxF1B9lGcSjGKekfSRo9lVfsxT?=
 =?us-ascii?Q?jw2iziEzi+ZXsiR88/cZ9Q8H1qBhM6AtL77HNbLmwWBZks/Xqy28bH6mp73E?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5e2306-c64c-4eab-7ce9-08dada0aca5b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:28:30.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3weVAbIuPw7uNPsEb8mjZL/5yfeJn7Y3L4Cy2tBo1XT5iPkyg6mCGbwv3jgTwhPf4TFio3YhIezQfPn3VM07Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7253
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

The FID will be the port default FID as set by mv88e6xxx_port_set_fid()
if the VID from the packet cannot be found in the VTU. Otherwise it is
the FID derived from the VTU entry associated with that VID.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- remove FID printing in ATU age out violation
- add last paragraph in commit message

 drivers/net/dsa/mv88e6xxx/global1_atu.c | 72 +++++++++++++++++++++----
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 7a1c4b917339..b7e62ff4b599 100644
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
@@ -380,22 +430,22 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
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

