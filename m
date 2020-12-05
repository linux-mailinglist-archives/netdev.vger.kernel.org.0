Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12DE2CFE2E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgLETUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:23 -0500
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:7011
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727223AbgLETUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVS1023gQ0dFhaMYIHFWk5R78t+ilfCVU0OqTlUfw1yS7Ssil0iFKyOIN4rUlbgiTdkCnWT+ixjB+JNma6KtGgm5dEft6Kf4uLi9Iyt3ewvcsf7GDLUNltV2BSApi3fxSwA+d62ZCmBNDA1rq0lxvAIvFoO5KUUenMiLfqjyikOCKFM+9c+myb5w/klGdhjUDaxcMjJAj2xGQ7Qzr05djYj7kyeGgasoi0dyXTyUXG8XMJN2BO9lxkws2chMKBqfatpmXXhjcMgN1waLixs21Auj6ShGs7bnpZSC/zVJVayhaJZKZ+6xJd34KGBCOK978sSAKyjNxADyvfK3Nf0SXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zKBHs8LCaE1OWo6oLZhEwPWsaWUQu0HqN4yiGP2cbA=;
 b=NDxz54P3k7XgpA1ntZYz7NllFLyew/4HQ7yOscG8eoR6SzBWqKcaizbyiouHsacvxeEz3c12oc79XkroNlS5SgCczWo316FaY1m51HOLMB3nXE5xkO11pLWg0tmKGiv4zGULrvn8JlaF3yNAFBjmpit8VETvmehyR7mZw+QqMI86AC/aCSW+rs0cXVTJiwznpr8v5guhLjD2nqWVgdiNN0Dq7BsyqpYG4A4p3LkpuX7qbEU0p7WrcbjRkZsjjNC6nx/DX2B6vi4L+XFT4DnKUkcZDvbuv6agbfM9QYGCvAzbq6P0vV5hPM/AryB53toxM8V6JLceNJMjBCx9gh8/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zKBHs8LCaE1OWo6oLZhEwPWsaWUQu0HqN4yiGP2cbA=;
 b=ikZ2/JEaqHPLuw5whrOoVJQfV/pv7MtZTYlVMZQWvdwbXYk1PyguZCjA1eNmHbVhDdedF07qYUAVdafeafo5szUqQGeyZiIGGIbW7u1nceFxysNAZjjPZDTsUd/Tzsrsf5BGSX6YrN0YyYinV2fkKQXOCsb6UfvXJjJ0Ak9H65I=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:26 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:26 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
Date:   Sat,  5 Dec 2020 20:17:34 +0100
Message-Id: <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c1827fa-d0a0-4c3b-e84d-08d899528a5f
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB136321A0616EB8A562BA8F9793F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcFWVYt250Oxn3E+1pY7hfTuMNxjU2G8wwQ7qhqCdy/uGGzADVFbw2b2WLhaX+L6GPw8glpERLHWcGx77Kd5gUkvdUfdzuwphcdI1avQukB22U4A6O5YoV6Psffz4sLTuf8yfY86KeBqu2p/luE2I6Bt33zB4moCNSETIL9Ag3GCI6QMMtKq7AWXD/xTL3Y1OvtatjhA55zVSj1Hj8VuL47ih68xsZBQnSMVO1Gesfv9RrTyyzaCzHHe7Rr1d193N0ttQOK3HB1FsTkPNziaOCLC1v0kTsqEs+yHBXDxmMJJ9e7aHfa6sOjYyY7CdeojotPq9uo2dtYdayxtUgMngA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zq5B/zpr510dEv3tvndqlUb/2jGJPB0HeuAg16cIc02le5QLcRxsKccmwS+f?=
 =?us-ascii?Q?Roz7Oni0jhwzbhegHxg9r8Y7HzAQ9I0fET7hDfR0/BlA8pcEDwACTYUB6adg?=
 =?us-ascii?Q?6D5lNVi46uUH2gpG3SmJfjywjSF+o4albNRDBmib1zsIiNzs/qN5agrKTKet?=
 =?us-ascii?Q?fK6uJCRoWLhhu3s6G7nureWTSXaEZ2HIjZVD1NF+KZzc8BKFoY/GjE0RfutW?=
 =?us-ascii?Q?WUCoISF7USO9h4cU22Vj0Y8GMRaP5t+QqmBulf8ebMb7ZMntP6OyRgDo9qAH?=
 =?us-ascii?Q?8Nrlo+Xf+Ozrsx9bZp3dAuN+FH0xW/95ycQkNMhhESGXq/m0g30ebgqTk8KN?=
 =?us-ascii?Q?DFf9qp4xXup7bVijqBJ1Anx7Gn0LVk50av80qnTSWZRZBLvcVPCbeZPpFKef?=
 =?us-ascii?Q?oE7qt9gJqCOkD6xC0koxjnqlIzH6p1FkU+RpWxOmYbYTADN7O269BrBm6yrL?=
 =?us-ascii?Q?bBTfXuElFRtHMc/a0v3Mx6YFrQXFbz55GkW/g0zdYrNfAUu/kdTJrmEFFtU1?=
 =?us-ascii?Q?stxNRRcgoiBFZYqzNFZVirINcPd1ie1OZYwf76Cth9rFrBpoQjV9G3cuJyD2?=
 =?us-ascii?Q?TOz6LQTciO1gr8A+Of0ZYOJLrh3sARwDD5qjOhL4NW2bNsI2wbKQoxM28AmE?=
 =?us-ascii?Q?Mj7erk9kELPFrWhcoBKlkL7sNZkMzXywPGJny7P7MHVWAhiEs4VyiqDln1Fy?=
 =?us-ascii?Q?DPRRRjfljCwD9H0dwyfRt/TJS25wLfmThP/S/39kwO8bs/++ihQiZ0uNQ78Z?=
 =?us-ascii?Q?i4xOTk6e64Lfxg2+OEBaiEjr/iBa3zzKGKn+FfzxS5n4QXQaop/DTzJGzhW7?=
 =?us-ascii?Q?x8Iaf9+UuLrHYDfEwOIm+3+r+eYbCktqnr9hj8cAVc8ksit8XsiJ4aOZdnaF?=
 =?us-ascii?Q?vKspONwPCJOvU45iefZteIMbZTAac70ifHsZ3nfn0+u7sa8MEJvWKE2Y5AEd?=
 =?us-ascii?Q?oMQUzW+WZ7aUVX+vUnQw6T0Vq64riXbuyXbASxU4f8MQdBNXxS/fAkpoIeQi?=
 =?us-ascii?Q?TJ1I?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1827fa-d0a0-4c3b-e84d-08d899528a5f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:26.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0CwB1I+xbnFBcHKL1JlGloKN2nCVj/eKKIA1ONnowqDiufxgUmCGPsJBJmJtr3xjXhwrcQICMYzU9bmOzEonWJjYgc/0EndPPGV7IGV5eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ugeth is the netdiv_priv() part of the netdevice. Accessing the memory
pointed to by ugeth (such as done by ucc_geth_memclean() and the two
of_node_puts) after free_netdev() is thus use-after-free.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index b132fcfc7c17..ba911d05d36d 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3895,13 +3895,13 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
 	struct device_node *np = ofdev->dev.of_node;
 
-	unregister_netdev(dev);
-	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ugeth->ug_info->tbi_node);
 	of_node_put(ugeth->ug_info->phy_node);
+	unregister_netdev(dev);
+	free_netdev(dev);
 
 	return 0;
 }
-- 
2.23.0

