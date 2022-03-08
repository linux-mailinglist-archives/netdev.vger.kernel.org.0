Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739EE4D197A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbiCHNo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347192AbiCHNo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:44:56 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2138.outbound.protection.outlook.com [40.107.215.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB014993D;
        Tue,  8 Mar 2022 05:43:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Va76eCuOTxbGmRYvv/KZMW5GDTM117zBcgYSZkVpq0VNWgei8PqkunfD6zWZ0i/EWGIbsKeh41KtdVSadWYlQa1p1Mdb1gG6u3ENhohlNv4EJYKxfIEWS7zp7ifkDhw0rLGhuoAl+MBPalUkFPIqHz1dnVsC4obfr0R2rQdJciT6KVGacU0E8W7TS1tcTnfEM2vVKVgYLkM48dQF3lVR2IUbqsZ9kuDvF8nVXUjETnfz0+l3PFpJCnR2kSgtc4DHD2bX1XVc8NAd0OVVsClQoFuYYbPJwLuUOZaigsuPMp3XZsGtd5w63Bx6f/yd6hrEYyckwKNuIyMQAzHV+67/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11sk1HWue+Gc3DUdOgISgCItkerxhKT13f/eR1urjLU=;
 b=FDQ1g0cmJhRe5T5eN8+Rx5B1JRP2M3pQAxZ8Sb/BaV4Srx68Sf3aSgdr8V5euZ4fWdvNC9h6RZAcLbe8PfL65+eSsZVyFFzMknmRJevuDu4244Kh769ADvmx7Ql4uz2Bzih8c4zDhVSAeHLQdaSIk7qIxNYxyYFQ2ELmpZNmaNxcKCD6LbAi+BKP1TFRRXUCLBUgiUhEAJHOervnpHNDIhHXBwQTFxBzO/zn8ByUdjmzksx9mhfSAQO9gotgHBF+5aBWH1wNsKkZ+6fRBnQUPVBRySKEfzdyUtfAnBrrF/tco5aBIFhwqhJ/nXck2O0U54K8eiwFOnp+FkD+EtOOjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11sk1HWue+Gc3DUdOgISgCItkerxhKT13f/eR1urjLU=;
 b=NmpISThN2dNzug/jMx18ekMYTbyEkzw5WrS8eHG3potca716H1Na4kW0caB/luOKKQ4KCSQyYWLppj7pQw5kW0GjlitTovcUYZcOco+Zm6ZIzCFmzK4MrO3hG4Ii4riTjLcVHYQA69eOp02tmxNFCBOr7numzlz2J95qTS5/5jY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by KL1PR0601MB4482.apcprd06.prod.outlook.com (2603:1096:820:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 13:43:53 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 13:43:53 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next v2] drivers: vxlan: fix returnvar.cocci warning
Date:   Tue,  8 Mar 2022 21:43:09 +0800
Message-Id: <20220308134321.29862-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <38c7c77ee46ed54319b7222c2fada0039a980a2e.camel@redhat.com>
References: <38c7c77ee46ed54319b7222c2fada0039a980a2e.camel@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0046.apcprd04.prod.outlook.com
 (2603:1096:202:14::14) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c739f1f-5559-41a9-1ed4-08da0109aed9
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4482:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4482FC51B5FB688A93511C06C7099@KL1PR0601MB4482.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TICJ5Lqh54XysIVBZrJLxLVrs3dw3Y4q4XCxYKO0/VxkowgTfXngKLLy94MQ4C8DDlWoK3vbjEaiaLvbAwzL3nPZ+vyw7v5+grb9ERYpM0rZxXTINuMT2XiNUU4kjrMJNpRyNLG1zKyha4FL03XDZPTpZA5cSvY10FcgvNr3BigSgb0QXjtZ5AUfQvp4sLFn0sDZVTyd/jNVWyRajubVHVAzlNiyo2osHyzrdGAX5mvuAz2WIT3BBoVOmzPzKsxgQqULXCZpBUWJ+5Uewydxm+5WdI941XX2xrEYJOU5WqMQQ6XzSIttkWl9fKRuJN5YAn4GLBtzxDKLc0I3zPxvf2BXXUf7xU+ipb3Z+/HVecJeFUhrkTMLtzw2n1yV9ZOYAw5YPTLWMKL3DoJ8buXQt5Ouk8NbHIuhr8ZibAwF73AzYJFtMbCEOvdEr8rAQnROLhz6Eh5qysNU9cHLh2ZRLC94XGri9Zz08VDS1+3zscYbcT2i5Og0LS16hGOKcUIf1pG3Urk767GoHcqXi0jE1dSsEFObwK2Hqj7XO4irRX5rXzUs4pdORpQXlVHvdRzXQcDMLz0TLJluuRsNLIXnwhV5wCqTO5/sPZf7PWvcjhOAxLOYayr+w2TaNcaGI3MVttLVblfR254b3/IXH2SD3Ib3Y9uFD7d8ihdTrdG53rcTHllT7rR1iiiAA9efm3VPJysrPfA29BlZmlnxDvENA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(8676002)(38100700002)(107886003)(83380400001)(186003)(316002)(110136005)(1076003)(26005)(36756003)(2616005)(6512007)(2906002)(52116002)(6666004)(6506007)(86362001)(66476007)(8936002)(66556008)(4744005)(5660300002)(6486002)(508600001)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f50DK2YFaSrpgH7ZyO/2aQjoL/tOaq2uU9QuJXZhzsMIl2/DSYviaz4ZawDB?=
 =?us-ascii?Q?ea7LNKg+dx9KNgwC8FLZwmyG3NLO1fweEV0mHlvf3tUT5EZRzNHQyezhxrcA?=
 =?us-ascii?Q?Nv6cEyuoVwcV8KC87kcemzMc6CpVp90XEBqCuA7uesQwvcLXOX2OYiY47txq?=
 =?us-ascii?Q?ASQCxsbmNDBHtuJL8BE0QnK8Dx+f1uQ8e4it2c4lzgt+ZlTwSNGrQ4eZr8i7?=
 =?us-ascii?Q?+vJp/BFoFk6OWKFmNEGp1sRVQ524o5YLuhKrPeCOJ0nIfti/Z9R6A0EhROx3?=
 =?us-ascii?Q?2S967GWHScZw9stZCCQtpOevp3XCv/9L8jkNE4rD0gDm4vRMT1nyHkG49VLF?=
 =?us-ascii?Q?Z0ZIaZM8IcZ5yz/E8V0P390gm9J2A7tpABfg1Gv93eo/N5UPTIuvkKecazH2?=
 =?us-ascii?Q?TOS2SqIcZQGEKS2exN+DcWiNIL53WIz62/GW++ayqDnu25s9WLEzoGfVHD24?=
 =?us-ascii?Q?mqNAf2Xy8dPNbNJJrbr39JHM6m81n7dHALyhQD9XE+yQnSpoA6oM/J7wuuD1?=
 =?us-ascii?Q?Ft/eHZu6F0eYU+APf0zv8KPXKSWEH2gW4FEk+EnSh0abkHxVW8o4sBPpkjE2?=
 =?us-ascii?Q?vwquytaP43gFyzqvLoYNxj0q7v3jTW3IC8zQP8cWTs+i/MCX3l/aNfJBKipN?=
 =?us-ascii?Q?crV7gIjCezLGfaV+x8h+D7e8TV/kGk3LBcQXL4Z54RFCNSq8FwzynKDeKEXo?=
 =?us-ascii?Q?LUxRWGpUDXSP2W9PyKe925+12CIT5D83/PxM/3WZWMlroL6z7iYPthLNRQWb?=
 =?us-ascii?Q?wlCCfcfa6PwYHGLv8LAtqYDKDt0Wnjd222lzhS+0MoP/VHpkxxpI9lFM+wUr?=
 =?us-ascii?Q?yvAEfNMoKqSbOK3cTcOrAZcNTi5svasVSO8iV1ZexkIjjp9urBkbcCoaioUy?=
 =?us-ascii?Q?PfR0J33VYLL7C7pg/+xxZrlGl50S1MQEhwlkVJXj9Gd69TGCjpI33+hd8Mi2?=
 =?us-ascii?Q?+bMJKCR1wkdWo7FvUz8WnlnxKMPIkIKXKYFE3WkOkb+qqaxON6W4u2nfSkNj?=
 =?us-ascii?Q?QifkynR9xyqtJA/jSnsR6jlK8ezDN+/61BUReQTTaXHmzWfDJjalgW6nrlza?=
 =?us-ascii?Q?LdQ+XEFNUiB7lPDiO4fQqPSEiQkRnAZuErC20IEJSUUbUJwlVJcIBANQiKMO?=
 =?us-ascii?Q?AG6qcexQfAYcZ3dMUD4HtzBvKmf0otiFDWSudjCZLwWXTTkKc95acvn7ZPz1?=
 =?us-ascii?Q?4HV1NAo4tN3fRt9r+Xogv+byZcjhP5KPCAhrcTM9ZqzBtmdVOTJCXDbwpAJV?=
 =?us-ascii?Q?mn3pyGWTBHbZ2a3D76ZUOS9HUuoEVqj3Sidb0OtFUQAaCR6Mx5ti3l775mVZ?=
 =?us-ascii?Q?cyJUe6ylNNhDlVh2qA8dzNFYpQ5Cy+MPUVxgRlXceD0yMwILChG0XknOcWca?=
 =?us-ascii?Q?KcnspjwaD7r3P1Tl2iVgft0EGumxW575io2+yQN+vKJq1S/hnL8H6R08vCqQ?=
 =?us-ascii?Q?CpRz1VtSdH3phOCvYhEdudMEXb4pw1bUQ0boOybEFQaINKO6gfXxpXNo45EL?=
 =?us-ascii?Q?P+A4N1pYexxKjnTMp/9CEFWQgnNgggY0Wn8+J/s1T9DVyJ0XUXusdnYg5x+o?=
 =?us-ascii?Q?gm6KrCu8vGOOYD1HPZzqd+AHoWkoubRMqG7Z6I+5ujPywuxM3TU4m3Oe/ocV?=
 =?us-ascii?Q?qsPPoGkJeokSqPj6zgGDk4w=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c739f1f-5559-41a9-1ed4-08da0109aed9
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 13:43:52.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDBHTUnVPXcLRg3KzgzKCYf8C7QhS1btDuptxIhpjtcD5/tSSdheU9VAeWNJ+fme+5+5X4Rq7zrrwKtR+UpD0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4482
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/vxlan/vxlan_core.c:2995:5-8:
Unneeded variable: "ret". Return "0" on line 3004.

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/vxlan/vxlan_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b3cbd37c4b93..e06158a42823 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2992,7 +2992,6 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 static int vxlan_stop(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	int ret = 0;
 
 	vxlan_multicast_leave(vxlan);
 
@@ -3001,7 +3000,7 @@ static int vxlan_stop(struct net_device *dev)
 	vxlan_flush(vxlan, false);
 	vxlan_sock_release(vxlan);
 
-	return ret;
+	return 0;
 }
 
 /* Stub, nothing needs to be done. */
-- 
2.20.1

