Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881216B995C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjCNPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjCNPeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:34:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237305D8BE;
        Tue, 14 Mar 2023 08:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2gd9VIQVbT5r+9SaNImrOw1TlC20KYJlP00RXGF+F48+zuhXunugSWc2a2cUtc8pwWnTvOQe7WyfeUGJi+B56H456BU/Zan/9oWAZJ0MPO/LuE+fLnr41/WoVIkJ1WdTgZ65pUVOVDakd/QNF+Qp8Zyl8OJkAwo5GWPvhJsVqB8TnRrUY+xZGA4mn6fj5H1Cp96V1O6wpbNXlXa+Sq+IydqIfT6UMR/slnJze02WIIWXpYU5Mf/KSdTz+v+U7kDqqYTICFNGqO7hD4pmAgGSlv7p83a5uYu/v/ifvT+TZiU/Hm4R42mgEyQtIUUd1T8WfVGDQ/kJCdu30n8WlbdLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbfKO2z2RLDQiRJuc0MKzoMDOKV2wbPX89HmXfDG5tY=;
 b=Xx6VPtMkYw4Xc8mLplsfErn7J2jv8FiGAS+dtXc/xH9wmULQpy04QEGkon32RtHXzBTYPTbyrdrE6GT41E00WHD4MITGMO/SRjdzJWYmjnpwR8y9T4i2P62PuZTMeJgMnfi4o1dag7M+x8KcmenIDWqt42e4dAhdXpaFP8hrFqLjaNPFHvDm1bpHElerK7V09+PYeOf7a4OFYCFK987h3jaWYSPUfoNCWrsQ6wTL6JIQ7IY03RR/v2TbyNDz7yXnhwb1Zp9gwGWPMDDbM79t1XiyXMhht3LWiOzQt6a//ftpaQedACFJjKHNXv5Cy3r5sNProP1bLHnRqQb6AzFGxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbfKO2z2RLDQiRJuc0MKzoMDOKV2wbPX89HmXfDG5tY=;
 b=TbXOyDMR7kekUEbhI3Y4rxD3QxvTjW2dVCKkwLr+WaaxX+bjAl3VubqVj83V5C2Xna+32v81k/mVgv2tuZLR8xTwFWgzbW4K+HlJvzFmZGeOiNXIahbHQheaxTQXYzYFakr/+12xfQu2tLTYOw+HtFfOFWW8oh44u898bD8ZUvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU0PR04MB9495.eurprd04.prod.outlook.com (2603:10a6:10:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:32:52 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:32:51 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v11 1/4] serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
Date:   Tue, 14 Mar 2023 21:02:10 +0530
Message-Id: <20230314153213.170045-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314153213.170045-1-neeraj.sanjaykale@nxp.com>
References: <20230314153213.170045-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0212.apcprd04.prod.outlook.com
 (2603:1096:4:187::8) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU0PR04MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: f6752894-89bc-41f4-70c6-08db24a15fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9D5U0l8WEi23Mxo0Jqzx2ntnwcqkrp/rmaVvB7j+VV90CwMXLTDjGZDZVG91eepF2C5PooNLkR6LPy1FPvpQuA3Em7vmretVswqo2n4hrRRP+6sYNyzy+EP0Yb81I9zenyxsq4DJlzV/j2G7455ZkokM/TQV14CJ9+IgmgnpzfJYr5Sd80UL4NKtqULeQgWwDXTmZz/BL737zHIiORXC9+X+pcEgkSwi18Vt4kStYsgzf+c6rIAl7GUHNjX32uuTowFFXqRj+POQtv6CnCmZnNeTKCMnx7JsuoXY7MlS/nwFAjBxCyP1nBG1JhJLxPvHLho0TLAA+Zp7XfStxINiG/LYdLZmGtQQD91ru+zpkM/YIpmRX/RltF4rMLMN5r3lfzQFp9vfbh5DM7tGDq5GNaT+k0u1ScnjB9nXQuQb8dsw5yX2cVsHludQ4/uL2YEXppyKuq7SmuzdY5/aDF+wf2ZPFTmmksjcsh19zG9slJo4+6vwOe70OIOEK5b9qDxQ+Y+5hMcQg04x9/Yiwttpn4K9ETtwY9azz8DEb6EQ9oMx7VGz6cPgnp1+Bg4un/sVkEXpdo2aD4fKkz3w04OYupYWr/mYcjT5HQ5gDCtGMsSKyj04ONlQ+JC7wyiXq95ZcPZj3b/BoRixi7PczvrBFlvcE+IMluwN+SE+KZlOHzzbMUQcY2v1hQ+PZe4Acp/6i+7htBky+a2WibOGQwrHWwp19qPrxdLvKxeJfcGq7N8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(7416002)(66946007)(8676002)(66556008)(38350700002)(38100700002)(921005)(66476007)(86362001)(4326008)(316002)(8936002)(478600001)(186003)(26005)(2616005)(1076003)(6512007)(52116002)(6506007)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UACTLg9AwZ2sqecBi2sJxUFSYGmXnlzUJBFumxfzjNefyUi/fak7xvectIAr?=
 =?us-ascii?Q?h3jsDm/GBNeOOSz2Jii+IaOvjZMWrCvkhsJTqBXVv03TV5xQ0l5iK1eGiO/F?=
 =?us-ascii?Q?z0pjV5EpRTo6QbCPbj/YlnOxJAxHdWfhikAwdeQRb/DPzZJ6cXwWX++xR9d3?=
 =?us-ascii?Q?p0/WFzuWh3aoNKGvq/AtiUb4GqKj1ugLVP+J3UqHE/5peO9QwF3qorPkSP3t?=
 =?us-ascii?Q?Pmm+sp15IXgvvuWJ2sQSSLFe8n81NQFbolshoKz7icU6/pF6CHcUudr3m/7v?=
 =?us-ascii?Q?EvRyA+b1QCv5L8A+dhTxlISYsNgEPhL3+Qq1LgDzZ/3QPKkK3cvnkmzBO4Rr?=
 =?us-ascii?Q?Ph/f1rulnx4Pr0VpFMysbXnfr3DTOjuskWnPyROecL3JgIc6h0Ku8gTniE+Q?=
 =?us-ascii?Q?HpD7Pt1xKWF62WrXhdndd5re0mIYVx7zeL5qYlzL2icqMEYIvSFb2JHz9ak3?=
 =?us-ascii?Q?CzuAIx2/NEyCzdktq8bZLEPDogdF0uKA59JZKfcyMeOdcuxZGImUN1H54Ll4?=
 =?us-ascii?Q?H8tsij/moQbgPCACa5X3kFNRYSiq6xT17HmVKETLBKf7x79+PCxr7Cyxr+WL?=
 =?us-ascii?Q?AwBi1Vlb9pcQ5esnI9R1oFML1Tx5xyp6JOGZ4MW3GG5x44vhWRJFb2FMutaZ?=
 =?us-ascii?Q?ZgzFmjyMl5lt9tB/R5MEFA95l4sPo30tjShBQFSZnra7XHWwpykcGRLbWNKr?=
 =?us-ascii?Q?R17hSiZ0GKfGzVS0wDST4y2zp+i5RArtOVLYOmqVrUjfYbMZArqXAFAyzUcj?=
 =?us-ascii?Q?KvS1VLspfgQLkeHHrgSkcvgAUGkcXWIuDeFzE+4xOzGkI5plKpp4p6GMKnTY?=
 =?us-ascii?Q?Q41bM/d+ZzjiTxJwfgUWBZSvof4UMsXJb3VnZ9hLoHNwhWVyjbigoXIWw8dB?=
 =?us-ascii?Q?CMW1t+B+fRs+gowecAXs4MJDGJoe1lvZDhtKLn4Mjiwtpn+idsT3KTiiyry4?=
 =?us-ascii?Q?BljQ4CkCW/xDgFbD8UwitCjXR7C1DuYlFh29YExhqNpbJ8Iu9aO0qHjtPvub?=
 =?us-ascii?Q?hffL38RmB+X/tWAV7mK355eaW6R5IvTN1wmDfCxppp0rml1KUxcsCI/uV9L3?=
 =?us-ascii?Q?0EzzrQbRMqCsdPcLAF4RfXWYfgbTAuph1EDLAcSRRuxPXIuRCiVeynzeoIvK?=
 =?us-ascii?Q?UjJaDQm22t16yCilJ3zd0Ad9LtD1bIsMSo0NjvtexdVM0GIc4+N0xX2hMiv+?=
 =?us-ascii?Q?q8G4KOssUK0x9EC7+lej6fX5J0ALpwCf1xm2AxuhjQd/b73UhwuBImL9RQtr?=
 =?us-ascii?Q?19PGh8KQWEgv/hQMbBnG4KgPj81pbH0N66DhWeNIqkb2BHnjuMddiNjZRDI3?=
 =?us-ascii?Q?Zt1Gem2QIV1CputZwNhAvu9ql89RZggtgVkB/EON6iIM0fYJoYCnbIWzZh1/?=
 =?us-ascii?Q?1RYq1LXn13dP89Ht6sqqU9wnjf3ziStH12x1YUKemEmUwBsvCnyCA2yYj8Jb?=
 =?us-ascii?Q?TdtJsxeFwsx31RGN8v6NgKyrgLchKKjSuk1gu0avKmEPM53Yjp4P1xBFjUx/?=
 =?us-ascii?Q?+SLg2Wpp20LrkZXIHO/7XJ8kmzP0/4fH8ywk2RFKNKRLhwfOOtXWUOXT+ptn?=
 =?us-ascii?Q?OUKmsAeRiSTLGyv+ROk2P5chaWEi+N2zxDsnIitdz5gP3j816mfjoy1XfzbJ?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6752894-89bc-41f4-70c6-08db24a15fb6
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:32:51.8759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIZXTf1jLUjZxT+L+AikngL3Y20A7OuxH9DVIBiOVfa3+oncSnjxccL5tQ2qpPHTLieQXtTrQrlntJuVwjwSXoOjh0JL2Oc+DDQLYLs15xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces all instances of ENOTSUPP with EOPNOTSUPP since ENOTSUPP
is not a standard error code. This will help maintain consistency
in error codes when new serdev API's are addded.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v11: Replace all instances of ENOTSUPP with EOPNOTSUPP. (Simon Horman)
---
 drivers/tty/serdev/core.c           | 6 +++---
 drivers/tty/serdev/serdev-ttyport.c | 4 ++--
 include/linux/serdev.h              | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..d43aabd0cb76 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -366,7 +366,7 @@ int serdev_device_set_parity(struct serdev_device *serdev,
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_parity)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_parity(ctrl, parity);
 }
@@ -388,7 +388,7 @@ int serdev_device_get_tiocm(struct serdev_device *serdev)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->get_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->get_tiocm(ctrl);
 }
@@ -399,7 +399,7 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_tiocm(ctrl, set, clear);
 }
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..f26ff82723f1 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -231,7 +231,7 @@ static int ttyport_get_tiocm(struct serdev_controller *ctrl)
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmget)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmget(tty);
 }
@@ -242,7 +242,7 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmset)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmset(tty, set, clear);
 }
diff --git a/include/linux/serdev.h b/include/linux/serdev.h
index 66f624fc618c..89b0a5af9be2 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -249,11 +249,11 @@ static inline int serdev_device_write_buf(struct serdev_device *serdev,
 static inline void serdev_device_wait_until_sent(struct serdev_device *sdev, long timeout) {}
 static inline int serdev_device_get_tiocm(struct serdev_device *serdev)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
-- 
2.34.1

