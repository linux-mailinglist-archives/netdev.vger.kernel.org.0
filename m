Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B384520C77
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiEJD7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiEJD7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:59:18 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2136.outbound.protection.outlook.com [40.107.117.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1006424F20C;
        Mon,  9 May 2022 20:55:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WodftNU+nVJrKcrhqGOBHQ68ZFdgz9wdYRpxAzcgPFJB+1CVadGXv8ztQACc9OskZXCo99RJtyvGDXsnB5wSFs1lNIx19I4TNpi/8WyXxheq6yVI59QSmmOVj13QXJlWLKILaRKe1Tmd+J66PKLg4ypmz9Z8agtlhldpFQHFi6X0bt1Xos+Qe8L+zAVFQlYw69Ct/0mcg7eBAncxwZOxFSbgrRer8QIRscZCC3GTEPgMtSVvpYYpRZvRJ9va9T0edcuMMiCJ1GMpeGJNwvQDgLKyh3rjPNOdw66KZT0uIuHlV/mDj71ZUysilqPmBCNtsIvCR/aA/ZvmJTNrUUnuyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZM0m6PheztQwPuKOvtvW5s60dBqt8HfLTHObtmjdG8=;
 b=kq+8Qt9Uxn48VuOQcAycEsKiH3YR8W1T2ZOGfHzRTE266upc/BaWhe71hdrYV60ETasDKqYSz6efa2/YRGzzRoNfnFT+dfjXBSUpjML9dlW6FQ9J+Q22qpBHtOYDpLyCh1Fq8yZXaZMkENAY5aeXJnx+VgmAAVEbPbNU6KAfMkJQ4ptDnAYIq5I1YMXxIkk2Rl8nOVyOTJQRctUP05XZ1y+3Z59gTDVNRN7Y8rrevA54wf6xcr4xU89A+KA+X/v2BMHHXl1QikTwRcg5U0BGAF/pyzVlFb2bq4JHkTJLkMOpHJTMI0wKXYWn97k6e9DVknZrC/FyCBGkbwhLa5flGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZM0m6PheztQwPuKOvtvW5s60dBqt8HfLTHObtmjdG8=;
 b=esmftOwbpRr7ky1LZbLuqmOjimio1OGCp6dkR9s2VVfo4/iUTTA4ecLSa55Eq4QdLC0uikHNOJNPmN4SG/nBIi3wcGiauKs3ZK8xdaro430VDOY+QEoTyutEXLlgbn8msZsgN7cC/skxkD/UBeGFQY3y5lLQjmwJn8Ppw7EPgUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 PSAPR06MB4022.apcprd06.prod.outlook.com (2603:1096:301:3d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Tue, 10 May 2022 03:55:17 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Tue, 10 May 2022
 03:55:17 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH net] net: phy: mscc: Add error check when __phy_read() failed
Date:   Tue, 10 May 2022 11:54:56 +0800
Message-Id: <20220510035458.9804-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:203:d0::19) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e3860bf-b339-4d77-f6d8-08da3238e511
X-MS-TrafficTypeDiagnostic: PSAPR06MB4022:EE_
X-Microsoft-Antispam-PRVS: <PSAPR06MB4022BD5222EC478B4E51CEECABC99@PSAPR06MB4022.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8IgrgYEGchY6MKhReJfO72S0kLoE0jRe3GKJQDvINeoyAri/P1NBkIQ/pUliB+0vY0g2gr0GrYuQkta0d5gPOSRnTjRLFLQQWcDVZLCpCaZZV6ZdM36W4+OWxOE/a9K5JqKQt2q83uvLgTl7BDldM84r2eEdimB3Ua+Yvfeg9YhWwKR7UQJ1o2/FbTfTw2kEqX27CXx/R8vqgmwr9er3bqxar6g3d0+JtmXxI13BDQnp4rsJLGBcy7veIK59TuNhRFbv+y9MhIP5vBaxE7nfbtTEIzMNlSXgH9Im3ZkrfuPU955aSpGS7wnGdBbwPVYmtfldxP35rl94yM6X3ztyaHHLvcsR7O7FDsxR4m2eFiM05yJ3yHVAbsgrICihIO1PICPRpZdQ2rcJCkONinq1grtEt18Ae0J1XqKcpOshM1cOmBQKOBVaVdVz5jBxg9QfCMEJs9z2yyfHkyElhx0RiLK+vrRxnVMJFKjIkgrU8h6eDWQWxJQBcFv2Op5w+is5MXfWbnw36ttkU4r+wATHm9YDu1+cuIJA8+6bjGnYgyWP4Jwx4udMb+Gq64gY8DJrS3n1yo938cc1fV/h+8awc4zRjwT2jyxXfog2mgJXsXkifTC0cYgZWeXcXc76T7zU4bIzMn8ykfpSpVLZZQvdICFf3Id75oiGzX6ltInCi1EmI/V+AP8PY47ytYu7v/a2mMbsVkkoLDF+eASrAfiKu1oG7i2+5Ue9WqNK1Vne3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6512007)(66476007)(6486002)(6666004)(66946007)(316002)(26005)(66556008)(2906002)(52116002)(186003)(4326008)(8676002)(110136005)(86362001)(921005)(38100700002)(38350700002)(2616005)(8936002)(83380400001)(6506007)(7416002)(1076003)(5660300002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tKFFBYuD9IittKzKTYqCnPbS2exTTMNy8+/VuxSdyeIMEeoZx7y08qKMX6RO?=
 =?us-ascii?Q?7KubhL8OgK4ZPhBAGW79HjXX7p+ob70H9JNOz+qRqskHnLpuV5/4Ibn3356q?=
 =?us-ascii?Q?ZqP/mdUYy5WKmMgO61fZcLlTWYKap/aiwga03QNg7FfLAVU21F35X51Ls+ns?=
 =?us-ascii?Q?RoOwfzzesTpvZc8oQL86t2Rc3vJFRj/jHtGLf4x2N3I48jNJz1yqWYN9KKzy?=
 =?us-ascii?Q?xRpBK1eZY8ah4szktJCqy82IAwkd7+dknYiJtmObLJISGTII/q2rcZrjrbSE?=
 =?us-ascii?Q?9MZ4H6OpcdfTLYDGcA/H69Hxarqqr6Yy9iAe1uNgnJ/OArqbT6hoE7549tjM?=
 =?us-ascii?Q?9GlMU3sNT0DIEVFGOBdiRqkFrundqBk8SWhW9YxecYvMmnYV9eJAIPtMZZRH?=
 =?us-ascii?Q?Z/Bl+4zhdFfVP3jbGCxaHEy5kCa8Xj8Heh9NotQz0/3Jfa5xHXYMRi6H/7lI?=
 =?us-ascii?Q?S8pHQS0mcM7FyGbtzGmpODTVmrgzFIduPfPTVdMS1dU3bHKzMeAEx6CpDxSg?=
 =?us-ascii?Q?VXaY2dUFhsSKzqADPHN6LgzSIPln3u/TWSgYW07SdupjvIh+W9xAGn1D1uxU?=
 =?us-ascii?Q?mxdG2Lwzo473NGVDa2giM6LJYoXUm9OYXWmqAzmhnb/OrD64KNPWqJMsVX7V?=
 =?us-ascii?Q?u+lpnNk23jORBWGlj4c1J0owwUOLm53F92jKcp2Hof5V4OsOhK27P3tfTRyn?=
 =?us-ascii?Q?ZyhOYNDULKbQc0Z4ZWj8Ysrl3k+RHSQit0b1dkAskLmQydXNO2g7JWxsAz2p?=
 =?us-ascii?Q?Nw8Is06l6NWqOlniYwq0nkjtsVnzmONn8Mkq/VDFoULFMD7r53RC5/3NkGhu?=
 =?us-ascii?Q?umYOg9l94NATgn97ngvdx7ptURi1dJZPai06c4rGImDlvfmJI5+e65erxVCQ?=
 =?us-ascii?Q?zi6ZlzHIZyuzxFgxy21jJpwwyIzXn7PWjdsxMZN2QK2pMvi7/ociYkX6UeQs?=
 =?us-ascii?Q?/SpMcbUhXiONU6/uMvJ9dErf42V/aXASHfjlGGKAXeW2mKbHWiIaM40EE3OO?=
 =?us-ascii?Q?wrctYY35pXORH22hLcI8fS9VSLLcAdAvQfX1hdZoFn/IsXvP6hW3/55cDRS7?=
 =?us-ascii?Q?m5r4hfFcAaf4U7DlOaJPTTYTdm0A34/Hc9+T4HsCq98QM+/vZvj7NKpYuMsQ?=
 =?us-ascii?Q?na4CApaNq5eT8ZsHX0A/fd2LjpHO10VGxF7vm5k63SqssHUsAyd+cztMEGMX?=
 =?us-ascii?Q?Twnb6ISppuN3WgsMwIT2j1eMWq20LioRXI0SrYrvrIocH6vfRnPdnW5tY3Do?=
 =?us-ascii?Q?0kRC9/5H49QyZ7t8AlhmBvnE+VwNQ6WnU8UtFTT0MnROYgaVR+zzsptKlT10?=
 =?us-ascii?Q?fcipV85zBeOBNkl4W9Hf1l6sLPCD9h0/VS6E4xhDAac+d5L/ctS4Rs7MZZ53?=
 =?us-ascii?Q?m60PoQM7BTXVrAVTC+rHf8sGRa05s8yrOvofq+0KloBQHRvdVTM7WWU6Y784?=
 =?us-ascii?Q?PDcllnNmPv2CSCgjuiGrF66NmpQe7AiuLfQNN1yYyLspPNAVPZx7ZIfzN+Cp?=
 =?us-ascii?Q?U5cPqDJHNCxq74LeqOtvbcKFF4vDXnQfRLbZNVlBcmioBC3j138HdXaklLox?=
 =?us-ascii?Q?w6Vtilbm/gXIoVel6j5+8TLgZzlwRL6qVxt1nOfyR2LdtoGZ3BHmkLZ1ix7C?=
 =?us-ascii?Q?Y2zhq7XWOFnQXvL2L82JJbmqZhRABsyv64jHhJxg2VRcCkMJev7OZwQR/Qqm?=
 =?us-ascii?Q?8mWs/K9p8CKrwim4ve3HNWaZLM2nSXJU8UvCQ3CHyz4skjtk9qPMgCZ06weB?=
 =?us-ascii?Q?Z1b3giTWMQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3860bf-b339-4d77-f6d8-08da3238e511
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 03:55:17.1407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXDUP+DIC8iTkyUipTPIjBuJ4/ReR8SW/WFHe8iora3aksdj3JOk8yzHiUdUdPuIpw9YEu5lJllg3P1HV/uIVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4022
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling __phy_read() might return a negative error code. Use 'int'
to declare variables which call __phy_read() and also add error check
for them.

Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate files")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..8a63e32fafa0 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -22,9 +22,9 @@
 static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
 				   enum macsec_bank bank, u32 reg)
 {
-	u32 val, val_l = 0, val_h = 0;
 	unsigned long deadline;
-	int rc;
+	int rc, val, val_l, val_h;
+	u32 ret = 0;
 
 	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
 	if (rc < 0)
@@ -47,15 +47,20 @@ static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
 	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
 	do {
 		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
+		if (val < 0)
+			goto failed;
 	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
 
 	val_l = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
 	val_h = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
 
+	if (val_l > 0 && val_h > 0)
+		ret = (val_h << 16) | val_l;
+
 failed:
 	phy_restore_page(phydev, rc, rc);
 
-	return (val_h << 16) | val_l;
+	return ret;
 }
 
 static void vsc8584_macsec_phy_write(struct phy_device *phydev,
-- 
2.35.1

