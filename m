Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D76521D46
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344327AbiEJPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345205AbiEJPAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:00:39 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2093.outbound.protection.outlook.com [40.107.255.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B86173356;
        Tue, 10 May 2022 07:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSVFot9fbyVk2kxB4Qsx2rcKLTSg5mxpuj4xnp7AybjA7RONFRO9LrpdcHyH+VPXNzw6+Z1pDIFc26wGKD3qck+OsU6cllQBFHDVh+2KK+RXVwXDiHhzz0T33yBUfoWylsxSqlPPvFeJqWahN4tQeUqPRCitALwjIwvHITW8VGjGgBdHafNGR9lb6jBTYN/2I03aL2Vo+4Xrb11MI11AzCgU9fG1sxVIxhQUQq1kIJEVWmdyouA+nZ5Grt2gnlxaxSdEv01ilVPVu24BXU9Gu9pNVx9Jm5UnnuXyM0Uy1G+G2k3ol/9iVZDsVov/rRAQAS32YZ7E7WDl5eXEdQkCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHP0ObP+ohnHA57G2i5wBjCghCtWVCrzKqv/Q6fMWvA=;
 b=W2zoJxmMBOv8/3wND83i+47LM3eXPNcf+AVmAzG4N0iXJwqcmwLWT9u/340LGXdK5hkDnBCYmzJ76I7Y9YuSDaFD3Ret/U4vT5Iw00oIVdNNRi48m3Z0ftFYAIVdFWy59m7BO76bEUXqAGsQgLuJ/BZJFhnX/bp9ktbhvuIm25BZ4xkefsbW3vHUVDu4u9QZOnyIbXZWNqq8YDzgnMTljwSyoyQSzJVbEtxvhGjamsKuhCb14ecavd4QNe0GonRRtYnSuqU0w40ZMyjjAQqavVUroQ6Xr8h1wyH0fxz4ZfBMZ0uoj2p+wjwqGWgPFxXgK3vsPYPwimfO2DX7XsFhdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHP0ObP+ohnHA57G2i5wBjCghCtWVCrzKqv/Q6fMWvA=;
 b=PqKelzSK0B74uZrH5JwcqiaG71m9wRvcUI9+0D3OkCvuMI7b+BdnYco37LV8ICHQmK/n81NoGqT0LMlthDPY34h5u7QoioUP4QBgQS6L+VkK3bytpQxoRbuXgU5EBT4aF1+ubblalZR8q5RtZlFZfpIg322QrEfKDzrOI4wn9GM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 PSAPR06MB4056.apcprd06.prod.outlook.com (2603:1096:301:3f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Tue, 10 May 2022 14:22:59 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Tue, 10 May 2022
 14:22:59 +0000
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
Subject: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read() failed
Date:   Tue, 10 May 2022 22:22:45 +0800
Message-Id: <20220510142247.16071-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0196.apcprd02.prod.outlook.com
 (2603:1096:201:21::32) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6cf24ce-7b85-43dd-22f3-08da329094cd
X-MS-TrafficTypeDiagnostic: PSAPR06MB4056:EE_
X-Microsoft-Antispam-PRVS: <PSAPR06MB405667E34BC52F3210FBB2CDABC99@PSAPR06MB4056.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xqy8EW+BnxBB+zz48MAtFjIPidHUyeT7W//gxBtyKb8CLcCJZRWfvFRIlRmDEBvg28QrXPmXmj5obUJjyhCE5Ek8TJ5BR6gY9JZ4kY6iuzmTnmYWaVAvb2t/HbqzchHePnBSuN14vP9TaYPdrJgmZCKYOyKT3glxk1xSsesYRH4oXeo1PqnBI+ZZuTSrKXfh0X6gPwu63VRk5xidLcMScPDLsIcnHzb94RFGQEmlFnahcs8KdClfw9TSakCu1hPPNsGXmkpaGkzFbu6y4wmH9btr9sPrlQ5+CjTf8noDQNXFScKLbQePOjEykKOA7lX5kB6Tn0kG8Cesa+XPSLOlN6wQRLqReXuuDcx8un4/blDDWWc/uk4/+qUAB+ztO3Cw9vaUSBk/UGi8xJjT8oYg+ADiwmAP3bBiUunNfUO2Syy3SOlwgvxQ71LtjMZXk0TlPTpUA9OpQOHpUT8+KAMzsMQyzR6uprJrNnxC96FbKTAhTRbuqMeM77usxVG7EQUXV6NcWMFrwjI9tQtjZyW0Yp7K3MyRm/0DQZfAVVJeBJ8ROc/49VtrYEUMuiFdhEvExBctLnlxtjyIByP5BajGBWFzkgDRWlqdKi4zSgSU4Z8oS8qyl9Lqn1nLwBHENY1a89hWqUd0syOsmu788MPbzS9DxzzL/t2iPO7J7fhcB+758Ss8RRtiS/QluNY/MbETZ7jluwXZ8+L05k3Smn57nPSyPmcgVkz6m5HOAJ0GvqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2616005)(66946007)(66476007)(66556008)(8676002)(83380400001)(1076003)(508600001)(86362001)(6666004)(6512007)(26005)(6486002)(6506007)(316002)(110136005)(52116002)(7416002)(921005)(2906002)(36756003)(5660300002)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?olXXya/mmu0N9W7hkE4P+KrRFeb3OM1BV12vsiGcYk90sR/uKj6wRjZz8sLk?=
 =?us-ascii?Q?m0GubB0digv7u/TrG/CAclLgM4LuZ1DyC8nxwDgNxpV4lFVUUmh35C10kLQh?=
 =?us-ascii?Q?PT1lcjhUzC5ZafowaaUtqeb2yNqIuLVqkXHuM7gfJwiwcJkQtqOzfKSAirMx?=
 =?us-ascii?Q?JwlioF/QdrhaN1vQ43vxSWql+jVdb7HDstwQ5p9ouQh7nf4k6OCqrj6Q9+gM?=
 =?us-ascii?Q?VP2f4f/lAcMKHntjx3ECVHPbm7eRn1zAircZwqE1yscSPDipmMUI5LyGOG7r?=
 =?us-ascii?Q?OIb8+je017gF2MkKpBoscDH1KLE5jsPcwbruqqmB3TRzQ4gxQI0SFb8W5yv/?=
 =?us-ascii?Q?Ey4QNsTQjDHvLXvjaKelMm3JnoePj+Ry5sU+zJyhA6YfHDp18HuuPvR8S6p6?=
 =?us-ascii?Q?mr0mTNKHfxhAVAcg/jvf2Aq4esT4PKFaupCKt1sy1+K2ec1/nkdj+IZN8HM0?=
 =?us-ascii?Q?K7gS/h5xIZLK1wATryoHUILyaFRAOYVdD+ebojOM/WmRNjX3KdmQjEXaBrFy?=
 =?us-ascii?Q?8g8CYNwsTRx6o7fw8nHL0vDLY7YWwrY5+HsH4tiS3lEF0+blXa8zgAvZjeWN?=
 =?us-ascii?Q?xRiYGjfd9prTfLjOTe6Pgf4v8xJk7fDUOzH+l4/YzralpnGK5Mha/fFpi9NV?=
 =?us-ascii?Q?f1PuyOhgRGlmpDYlHh5qHmu8ISr7iw03haYBwA80VmlnulGRyLrYWlG758W3?=
 =?us-ascii?Q?LZpzuYkYj36xt2wEBViArbuescvddH0BlAatXRWbuZSYxJEFPiNBbTzTgrRH?=
 =?us-ascii?Q?KF6LN9xtgZHO0adO2MveRksIF0vzRIzFYte+LNktvWtvszjSARDLVwuhrGrA?=
 =?us-ascii?Q?LIuWSGZQ7SR0LnRwflDkDDpQR5ruw97D9sJwa53QQ+UO6PSXlweMVuMKrMJB?=
 =?us-ascii?Q?TH2Fkft6T29+daZZbF5gJChIEo6VDVppYPO2PoEuA1JqmezkYO3Au9UPs29v?=
 =?us-ascii?Q?e0+3FKQhxB7MYdr8NHRDJPbjM7ftAddRkLs1ggpXxw8R43gWfxwmaESk3iAa?=
 =?us-ascii?Q?G+lTHr9r2yhsQCVfXZRafCZej/z5+dmlIiuRKahdXGeYRrz3H1WiY7/VqBS7?=
 =?us-ascii?Q?fjgytqDys6H/geO513naSllSWVOTUVdXNc69ar5NGNfDhRyAfEwoy0TEg2FA?=
 =?us-ascii?Q?DK/v05BoC09ETrFcYmueQ22JFTaesEtQGKNxMFD4Z8sHB7SduAK8O0ueU3qx?=
 =?us-ascii?Q?8n93ylgqZWjyy6Tx8ncCRqc6ziwJNIJyVN4JcV9w3cLQJN4sCBEVVg6vjfmy?=
 =?us-ascii?Q?nI9Z6SixoVJx8SZafqzEaaCsedmOaWblFuQI+ZWR3jkhB+SImE9lzw22kRXd?=
 =?us-ascii?Q?px6wdVNA+/cIkQZxd2llk7BxODJqyXR/RYxCfzlME0oOXxPTgPDXb11dTz7X?=
 =?us-ascii?Q?tf9HYkktvltL1lLIz5lr/3UZ/9t3Lt3DX6ot/W2KfrEA03p+NPIpT/FNCu+4?=
 =?us-ascii?Q?CXYUCofNcsEevHGOe0QXDfBMolaNQL+zLxKimRN7YSjfNb/40Ej+hBd6/4OI?=
 =?us-ascii?Q?gfaG6KUo1LdC+a0eL71by3aXKVrAIZM4Gm2zk1utf9MNbncdIzSpLVYvVmzo?=
 =?us-ascii?Q?sMgT1wEPzCfZf8snyUysm1Mqj48//fy7fFqcQkwR6R9a3j7VQZH1X5m2ahSm?=
 =?us-ascii?Q?BG8iCz8OmGebNmYrRyaemJpo7PUOqhbyoER46pdauVezdphmeDZZEZYtV7dp?=
 =?us-ascii?Q?NlbtwoK2tp2YmmCs8u6L8HAtQxFJah61hJ7kzWyfiv6L8gyZFTzVySsCVkgV?=
 =?us-ascii?Q?mTb7t+aU6g=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cf24ce-7b85-43dd-22f3-08da329094cd
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 14:22:58.1528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVCVCNx/oVLEXQ+6TmhZvKh64I4n4VkFRpGLucDpnPpdYLZwGFibGEDiOWsFNccajzWulhWdKkD5TPMudJwi1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4056
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

The numerous callers of vsc8584_macsec_phy_read() don't expect it to
fail. So don't return the error code from __phy_read(), but also don't
return random values if it does fail.

Fixes: fa164e40c53b ("net: phy: mscc: split the driver into separate files")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Sort variable declaration and add a detailed comment.
---
 drivers/net/phy/mscc/mscc_macsec.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..58ad11a697b6 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -22,9 +22,9 @@
 static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
 				   enum macsec_bank bank, u32 reg)
 {
-	u32 val, val_l = 0, val_h = 0;
+	int rc, val, val_l, val_h;
 	unsigned long deadline;
-	int rc;
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

