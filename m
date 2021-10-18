Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630F44313C8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhJRJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:49:59 -0400
Received: from mail-eopbgr70107.outbound.protection.outlook.com ([40.107.7.107]:38266
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231468AbhJRJt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 05:49:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAdBEHdRDyTaWrSRO8wEbWpU5SUs8GGZegXWOvG8Dbdmfcjv4KXv2Uk9lOtyC5wvqII0olmImWQEQ103iXt1ZXBo9N0fi+/vLTi2f5i1SifiTiybvHGyY9aceAA4NXSaWEtJx2s4ZJzuiTOZuz098Tkr0BJC26vyyo/bnxU1NMvk17wiAnqzymz2EBIFTQN793tNC5czzFDTa0EJk7RODEjpR5j25YjhVyNjzy45ieZprH7l6TZ5mqJBvmiZUkTrYkwC5hVmOf9rEHO18YkIzfl+SpqlCzEYmc28sWsUafHFdlZ9R1rUo6LY3ciKh9HgQCvUbmi9ws6+ct2PjvBmlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKBFXW8PBkYDZt5ElBVQTJ7oBDS3mtrETh1Hop4Q/fY=;
 b=XuzqkOk6LHwPuWX/BpwqvAgXHYZDUQfXNDTsIb0gL8CxBIjAaJ9TiKUP/ubbqbcSR7ZUCmA2kXXRRnouf3XEstXuyXwqcGb8RjhnRyxbV50cELyfTzQUygmm2gxIGDCy8cVEJmwlJE1sidk2pHCOdXT2p3pqLb8oy/SujBaJE7Y+d0noteRXUegC80DG6ypySdlCKoPttcjUN8Srq6aK+zhfxiG6lHfx1cHEBzagTdlnTdQKoQYrH4REgw64B+fhl3E3eDsiA9M6it36ItvXb4dku65l/A2AOzLzJxmM3KjEjjsBC9qGPnm4cU2JzFuHo7XK993xtX3NOFbCxADUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKBFXW8PBkYDZt5ElBVQTJ7oBDS3mtrETh1Hop4Q/fY=;
 b=D2XOxc97G2rT56HleXVxRoRfi2Wx9HR9v61/qZbRxrHRmc/387761m/FzxRUli6bGHh0Vt7ap6JMxFIzmUkgUb3SRpMjXNhtCsUjp9tzY8TU3GrVa3qcgmt2tXNqGLln2Nk63qvNOu1uIbDnqG8YA2qbb4vBgtpvts+Ijkjplgo=
Authentication-Results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=toradex.com;
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com (2603:10a6:10:1a0::8)
 by DB6PR05MB3238.eurprd05.prod.outlook.com (2603:10a6:6:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 09:47:44 +0000
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783]) by DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 09:47:44 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     christophe.leroy@csgroup.eu, Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down mode
Date:   Mon, 18 Oct 2021 11:42:58 +0200
Message-Id: <20211018094256.70096-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To DBAPR05MB7445.eurprd05.prod.outlook.com
 (2603:10a6:10:1a0::8)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 09:47:44 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id EB74710A08AC; Mon, 18 Oct 2021 11:47:42 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3129c3f-1838-4c07-93d1-08d9921c55b1
X-MS-TrafficTypeDiagnostic: DB6PR05MB3238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB3238A0E62C486EC9CEAF68C7E2BC9@DB6PR05MB3238.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tisc5kfhQ7j7dCCptNyPGeDkyPjx+qQIx5isTUi6xAGmtE8j7GzR6a88w88G85eoBED6dRfoJjMC5xNy5/ZnxrHbSGtYlYteM/MyveSGywC2DPjxOD/wJ+0OhqMsSbFiV8QHeC14XqYEdChNT5PqC1uD5g+deFL524BPLyN886jDqZu4gYnqd4he/S3Z32i7CyRG5P5MmpgGREGPM0joPghd8tV3PqCH9lYXdz4gtEk+sdocCP/1aTh3w/hlIDVdWzjrx1namq8UihrM5qZDdefF2Zg9Ou9cUEpqYp0nVaYMPxvewiAKpKb6PE4Dj4OAjZ4cx+9yO/VOF+nBNe5oG24eq2DCUW41EAbCSCE94/7w/e4paEOK7yPgFmXRlb1pWEONUHa8lwg5e/5ITmQa16Thj2/1RDQ1rl4EzAG/x8bphdm9ds/jNX0eEVZceGD2haIkfCKMxRYNDEpu9JV/0pNmQ2Ouef9iIVFnPoXH9D6ZMT6t9SZKr/wlHO17FBv13kvanN6kkgZWk9bV0HQPatCb+kr5Cxv7sPPC7njLv08jS/BtmRTCvbUS9KLbTixE8lHi7rkoO1Ff7x1ZFOjITW1t+VX/ulQI5s8gBFVYZ0wjRjX0m4Y1XUshsOSw3s73ggNSsl1/jEV1zPnRQYiw41dihogHAoElyrl27N4zUaqe/oc+B7prb/pCY6IjkF4D61vUY7LEBbApG2Z87HsA7JHpfhJmbNFsnRSBU/jYIjk+/ICa4GDA7YCV2YOaqtUc34tKRjGOKjNaN1j3xUowHpR79B0mOC/nYzMVAKxJgfY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7445.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(396003)(346002)(366004)(136003)(508600001)(66556008)(52116002)(7416002)(66476007)(66946007)(83380400001)(8676002)(966005)(186003)(5660300002)(6666004)(8936002)(2906002)(26005)(86362001)(54906003)(4326008)(36756003)(38350700002)(38100700002)(42186006)(316002)(110136005)(6266002)(1076003)(2616005)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PnYLSskQfCcbwrCxk7AlRtcDR6e9r9pWTV/VbGQru3iL122xVF9tkT72Xl4m?=
 =?us-ascii?Q?wLL/lE2SUtGemPGOLVw1DUY0xrgZMTCAD4kKdcYb01fHRwC4ZrOVDim0XhaF?=
 =?us-ascii?Q?TMnyygINWOovdq6+mrO/KDdjb2pB9/1yo66ui43o+E1I6fW2UlIDtEh8c4Nx?=
 =?us-ascii?Q?E46R1EGm9LTTXtpYNcloVZrwBBn3QQXH2YMDwP7f5cPpscEC590TiQnhnFG3?=
 =?us-ascii?Q?QI0j0i+yBbMg6gdihXDJJD/+1r11N64nvGImx5IGx+rXBpG/RBqW7IOg7QJO?=
 =?us-ascii?Q?WF5mk9QAs6YQO2x1WCBWuRccPuVBPhtIUqzMPU55vOY0H6vrr/zN7idGm1F/?=
 =?us-ascii?Q?PPCc747vXD6yao+b//GXjgJJjfQ4AEx7gV99pl+5oATtMQ47aHrSUol6dbbq?=
 =?us-ascii?Q?eyTsmS+P4q05Ul8UcYEpSX2tq41Xj54Zjz2Ckk/+4C+KACM5Tph5g/r4LeNt?=
 =?us-ascii?Q?6E1+PoJIlCcAyRhdi98QX0BKqnQ0RoyPlECkTPK4mIp3KObZjypz1DnPlurT?=
 =?us-ascii?Q?X0XGwmfAwP/QBfTLD3ews1uGryyq/n3Zzcp+axIkdE07wioQCsUwDeTdCS48?=
 =?us-ascii?Q?VO0yyS8sXFvjCnFHoSfBvR4wzhXlrZxRvzXntisWHT63yARD8MM1WMBAT1zQ?=
 =?us-ascii?Q?gRqbJRTypq6ERC6+/8io7TWZ9Nk6zjprZjYfR6H0BJq3Fk/kr/J1hvXSXrCV?=
 =?us-ascii?Q?Mb6rI1E4u1yNuBCYgqRLIVkWV+n6VZcb+C5zt4LQafQNw4aPMzr4phScAvAs?=
 =?us-ascii?Q?NMN0Vmgb3r73hVBEPfZFfOvrLVzOTJYzaJxYqmQ+TLW3A1RQMsm20jn7rzxB?=
 =?us-ascii?Q?NHqxZ+TGBNsPtiqDD5j8+mbrqxefIsEbn9H8+QOFnlFZ0pD2o4OQTNZUKfAi?=
 =?us-ascii?Q?/FhVQW3sDwfIQ3Rs040qwFTKs/s4wu2g8jJ5uwucJA7JCrnNv6Y453KzMm7Z?=
 =?us-ascii?Q?oSMk+8Z68jUXRQQDg3z0za+finXofAhbcKxa/Sn31Sk2a5ZMgIOGdZmcFTKg?=
 =?us-ascii?Q?0O18xf4cgDMMZhEMvaIUK8gOaVwvgmq0vI1VzTruzJneEoynEAG0rJCKIehz?=
 =?us-ascii?Q?FbX4KztAqDafHejUniC+HYzlaOAHcid7w2WZva3bEnIxwX7JTkCLWN3H9m69?=
 =?us-ascii?Q?3GnDuUALltV2aMQ+hBDSVuKv6EBAHUAG1T7UXUwN8EOk7buLCk4clS2TVtDH?=
 =?us-ascii?Q?wOAIT9s24CnY/rCophGBetvK/RjnUDiVJPK9qebWj9mrS2CIS0/js3rhawDP?=
 =?us-ascii?Q?tB9XsboITpuKwGHvic65SkPtEhSdRe7VSmECTw9CfCqPOflIQ4BM81YBdnxM?=
 =?us-ascii?Q?3DD+SvSpawN8uGGqlufBPWDz?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3129c3f-1838-4c07-93d1-08d9921c55b1
X-MS-Exchange-CrossTenant-AuthSource: DBAPR05MB7445.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 09:47:44.4783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rRu/JrdCPWjYxvkeEmdrE/sVKzpSgbjIaJ4XRBByKDZLEfZFeKDE4AzwZP39M6hoEsUie6MMnV6ZFVcPDtwMxqUsA3Psmx5rdas2EbKxFfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3238
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
the power down mode bit (0.11). If the PHY is taken out of power down
mode in a certain temperature range, the PHY enters a weird state which
leads to continously reporting RX errors. In that state, the MAC is not
able to receive or send any Ethernet frames and the activity LED is
constantly blinking. Since Linux is using the suspend callback when the
interface is taken down, ending up in that state can easily happen
during a normal startup.

Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
clock recovery when using power down mode. Even the latest revision (A4,
Revision ID 0x1513) seems to suffer that problem, and according to the
errata is not going to be fixed.

Remove the suspend/resume callback to avoid using the power down mode
completely.

[*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

---
There was a previous attempt to merge a similar patch, see
https://lore.kernel.org/all/2ee9441d-1b3b-de6d-691d-b615c04c69d0@gmail.com/.
---
 drivers/net/phy/micrel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index ff452669130a..1f28d5fae677 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1676,8 +1676,6 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ8041RNLI,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.25.1

