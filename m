Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4366BD6F1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCPRX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCPRWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:22:55 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63096B856E;
        Thu, 16 Mar 2023 10:22:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnOGuC4c44MX9aaUwl02Ji+wY0C0LEEgaKQddIcKn+MEh4NIcit9j3ophB3ub0Y7RD/oJsR0WHNiXXu7ralorcw9AROxlu4pqai4z8NCuPb5NGUFctafhwJXdI3ywn4wBUGy+f7jurIPNfljIbn2GgQDAhc6BdUSSRKIPuV/kCaY7ERbtDQ8tKyqjPMLLnSI03w0s0oNG4Jsu0M0P8wbAq+Mii0QuyJH1eXMytaQIZsJ0NI4X/xJUZzm1m8Z+6Lm99hzqkzS/tgKrLX/3TCK3bhHKC24IYqfRKzAxoyOlYA/OqMcNg0HWyAw1aAOni6pPwDrijW5MTnkrXJ3+YmC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaPSKGt9hUBQ0i7lstGETu/vw3C1OXKaJa9nti1zass=;
 b=fD4sF0lJ0TySgbrEHFIz/UmHIQ+AmNeiMulAn/eDhF2Y0gSRSzJXuU2qsLsjXhNGCmD1iO60crkBwNuYvUWKkagE+pfKmkeyuMlAPGu+fBvGVj0vRWWRcZmWinAXmoHiBHuwmqY1xB8qKGgefIQFULI7hGsFuxVIIOhBit3H3sbJyN+swpeFvisyLjltGLRmgR8vyjB7Gibc5L0E0E/MIkeZuM4J3/EQlbIvjuBD4+3i9U6jVCcaVZ6LBP6BVEXVVOFsv7lbrFn37e7Au2zg0e0mgbLjkfXHfe69Op0trU7n1ifrShThL/P+a+oJMOk4sIdODGSzPvfwSLKMH/uhGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaPSKGt9hUBQ0i7lstGETu/vw3C1OXKaJa9nti1zass=;
 b=HF4Ko6SZcmy0aYjWCJZDWm2b/AKlxAI2PxzZBWh/ei47y1A97Qww2Nlph+tW7cGaXnhx+538iUWS44/W1xXjIZ0xg0UnoXmoc+H/ab8sWfVENKjE/AUOJEExmR21fUnXiqjPutM8fvwTvYZGkY8z5W+toVAoSfRtZQUvfc37pFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by PA4PR04MB9293.eurprd04.prod.outlook.com (2603:10a6:102:2a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 17:22:49 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::d590:6d9a:9f14:95b9%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 17:22:49 +0000
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
Subject: [PATCH v13 1/4] serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
Date:   Thu, 16 Mar 2023 22:52:11 +0530
Message-Id: <20230316172214.3899786-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|PA4PR04MB9293:EE_
X-MS-Office365-Filtering-Correlation-Id: 520ed011-a2e1-4caf-82c2-08db264310f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PktzsulSS1/fUtWVtxy37mocmB0foHx8H2cOPfvdYGzZ3keEYDWvuwIOXoSEMdPFd6azeUhQNf2rjSDx6Y9ojp8cN0GCOul1jE1hNE8s+1zrJHQsHrK6OWTmphJjzEvU/yNzOGssHO9jrf474l/rnnWlfD/R38aFXmVpziLtoN0QMt6jq01innY+kUXqrRftGgthLztO24EQDMzLTAq9/EDnv3gwdIo5zObbZeOG0727j0MyAswQZo5+ptfpz7tMNiP4HfdUnjVcWU9t7Rkn0/ebiaH02xv/YG4ptS/1JF/olp/ETtkCHUqvXRv3P2HI1ba+RAwQ7bcFbJyH2unZ53eheZ9L2S0D5APnUCjnz9Ej2bCq6D0/AqL+kXxe1NWxNNn3IWJBJpaEC13N8UzW5P7oQwqtkGuwhhwOdm5rlnt8/Mxual8IDnvs1nI6W/daaxIkwPnzcnsRX2sDZgiZCQdlvUgwUV6CvoL0zecSSFRFBDxjPZT5s8SF01C5qtJl+WoTQDqdwh4nmZydSL+NeR+Mm6ddNz88sOnme3ylIdUbveW5PvbiZM3kRoVDeFhNmi9PPxn3gd8BtR3ppX2q5xaw52I+9fKpPxgZKaLhsduYmCKGaUQQr1KEYaAsnXqotdYibQND34zrgpoOvl7t0QvuS/VBxcEYFP1H5+NJQtiHp951t5hTxlH4us/ZKI9roWms0K1QNT7kds0JVEVZ9cxD1of9AQdpW0JfHCJI9Io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(6486002)(52116002)(6512007)(6506007)(1076003)(478600001)(26005)(83380400001)(2616005)(6666004)(66476007)(66946007)(316002)(186003)(66556008)(2906002)(41300700001)(4326008)(8936002)(5660300002)(8676002)(7416002)(38350700002)(38100700002)(921005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oNdupXC/Dq295GFhMnIlPVKjRYxjyLdUcSXE1dGXZrDTvEPKQW5hWbKiY+Jb?=
 =?us-ascii?Q?Tqpcw7basO0Wges8Jo8sytKMQV8AC8+pWtdn1ITNKzvJmIhrYQrvwkm1Xx/G?=
 =?us-ascii?Q?rcwQ5QYKQM4Wxi0ZHMAkWIP2Q2InZ41V/svnMQa4t58xd7Oh7MhVgnrnmJgi?=
 =?us-ascii?Q?fmm5ElrW+II/X7AOGPQeiqC6BgmMEGh62UG/cKrmgasUujTuxZs6o8958XS1?=
 =?us-ascii?Q?DfzTg2BdI0wXNsyopfpHoyWGPa65gWqDXCTLZE8q728nnXv+i1nD3nFvmKzi?=
 =?us-ascii?Q?WvBbNraYg387cRv1xySdG3vwWI8WsB5jfKMjUbuKq3DPKJKgiL2npuARcMrW?=
 =?us-ascii?Q?1SvbGhzDe4nKcD0tryxktjU0XN19qeCr03kq2VwIhj72h/7O8y6Uk8qEB+3+?=
 =?us-ascii?Q?HzyZuQlEb5IGGxXCdIImTK42EyuyGPi0lQbRQ8Y7TGPdU+OXWFUUE9wH64lo?=
 =?us-ascii?Q?xX+H/7KMpAwT6LdtnT9uil7mPDqcy9JVgmpFFWQy5jsW3sCjq5OeI7KOz2YY?=
 =?us-ascii?Q?9qKd84Lw+vCqYR+xyNL/eZ7+jShbUk1wwNFdka7KuNJY31hv/Ms1WL1gEpbt?=
 =?us-ascii?Q?wT4hLE6yuZ0T3DsgLQZ+yJDahd/95FGSAeWeZKNKpgttOrLvPunFLabIfVG7?=
 =?us-ascii?Q?dFr4eT61DgQKa9QVMGr3FCbyiHSwZYzwhw4hhZYPwBs+/XQlecHkjhG9CStq?=
 =?us-ascii?Q?dUckwDfK7r1fltU6m3Aw7+R8jQeNwY/o3lMIQyrVm59g1eQamNSKJjpVI+k1?=
 =?us-ascii?Q?w30kna5knxQRHNisfc+ed4vsPiBSpjD7HhHcKVV2VzwZF2KVKO/DVI/WRjsc?=
 =?us-ascii?Q?r2clncnW9daSHwlyD+UaHb3esmFPY+HOZGV0FjR9MmmBk7DytN/BmTif4qq7?=
 =?us-ascii?Q?Ma5p9+O1AA6Rr9Nvj8noOlRDGetE1DFywvP8eGKnUYJYb33sRWfvqh5egDTn?=
 =?us-ascii?Q?c+hIahVgFWRs5A+DRB9TOpkARRR0v6M+QJddwk8P01cRK2RhME/qz8fCnuWL?=
 =?us-ascii?Q?Y5p6+c22gjK0HtXeQkdhq541RvV7abhjG/hpXAv1S4e/VLnvPvbsbl/5bdKJ?=
 =?us-ascii?Q?fTKE485OxfArVmKA/JCFULFNcQKgxFanJhZmoSqm7dfr6jD/O7isPsnjH5nV?=
 =?us-ascii?Q?88KVry9Pq2Sd65MbBgujx424XnPT4BoXiOFd+aLOcgCYV8bXbXbdO9QzSAv6?=
 =?us-ascii?Q?VC3Bqd6zOLPfpnYGvMhwhGOw97dpfbE8ZWh6szkjyMrdndSy7DunR742rKmP?=
 =?us-ascii?Q?b/XYSYJzFE1g7BusNMrQ764iBpSKlkUSz/G1eRhJ/Wvc0BlFqS3m0sa4NvIw?=
 =?us-ascii?Q?1OuXTAxrOcEBx3s+QG0dcZiNhYgw5NVV+GSq03SdfZ+V2QU/He9XVBBQBbtd?=
 =?us-ascii?Q?yDy7Ul2ZzuO/+F/0LkQ6b3f7OW/IMhtbD0LgMhH79Ufa7jzb/3tqakcZNFXY?=
 =?us-ascii?Q?Lxd0F2hZg0eFaAhES3UI6gBoVSdD7YRon6jFmj2d4OprILfzQllRqncdFwkC?=
 =?us-ascii?Q?sV0S5h2urGF2XS58ahW7dETaF0IN0c40EecNpajND0w0a5dVg1nFMEgmnzBV?=
 =?us-ascii?Q?r1rxF/g/flZszrGZlRVRfF10JZrbE48IGb86SVXD8wTQpo6AzJ1+SvifhytN?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520ed011-a2e1-4caf-82c2-08db264310f9
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 17:22:49.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksvMqyCSIrujsNOQe4FwGlDceck7356z9cWugch2A0C38pVK7V+i2zTv9vf9ftd4nkP7MOxpoUeiKBTVdIQpjM176P5BPCB1MtJ9p3Blk3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9293
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces all instances of ENOTSUPP with EOPNOTSUPP since ENOTSUPP
is not a standard error code. This will help maintain consistency in
error codes when new serdev API's are added.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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

