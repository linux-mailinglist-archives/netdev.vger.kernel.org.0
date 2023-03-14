Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6946B9967
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCNPfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjCNPei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:34:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A3A592E;
        Tue, 14 Mar 2023 08:34:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fc/SvX2KW24S69zhQKPz5uCsP5oh7cnkx3bCcdxQ6iy2tgVVwR5nWX8zV5ZeFKeWS6COM5xhEM+a8ug7//VAXaHcNzCEvcn8ViSBfuaAxigE5Ud2qDBkHLhB8Wuj8DwqAMel3jSSY0ei0abHnIBQ5ZeJ5wPENZYv1l8WHTmP03NrZ9FszSl8FuhLj2wxUlNn5kCuzXScFXhIdrmfqVrKyqOxhlCyTpxnDMdQPIuYSC0sMGB7AVRvcHKFDb57mU5DGEppoXIpsy6Tm+BNAOhNULgbhPtb1HGEe7TDebBilcXf9KrD/cN57ggJxRbhPoszKI7n3Z60v9/kbpZRdDKKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nBPLnQZTmbjcXxRT01WcUGU4Offe4k8SEV+HxYAerM=;
 b=mPfqqZk2fFkVBHseYdBczTraltpRnC311dVQ3wnrvYj8lvKTLmsH6bNSHQBkGgjqaiG8s9PzC/JJY+BVHsELt6QymHGvuV1wldRyWqLbpg4W0tyk/Dt3sUoJbt96ZV/ZVudKWnl3DEgoPmavw6dzyJZabO9mnfhZgGJ83+zVekrLgudLRwLsPTJdn7+JeQEvTn121nKZiULOEtNRLMLJ79z9YsrgT/mnQNosWsATtFlKnHWUd5wezjDNOqtRAaaunRzAuE8LSC4RXuFigsg8CF3kMyK+uuVyWCK6eUyvCPdAtuqGNLfkk4fgUZtdYSVEvWz2qq82jKlIQq7i4FmMBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nBPLnQZTmbjcXxRT01WcUGU4Offe4k8SEV+HxYAerM=;
 b=M/80NcPww9CgPmL/Tl8m0zAgIxd+Nbqp84Nj3Dve726dGiKJobCLJ3isncACW4PNosEsrndMODv7uMzJKEBu85r2Wey32hJesE4JzlG4ZCdyHdj+Jo0NG2V0FvyRPkb0TFroD21oDmhglEqr8ylVnKsDO/wdCdCRo/EmnID95qM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU0PR04MB9495.eurprd04.prod.outlook.com (2603:10a6:10:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:32:58 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:32:58 +0000
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
Subject: [PATCH v11 2/4] serdev: Add method to assert break signal over tty UART port
Date:   Tue, 14 Mar 2023 21:02:11 +0530
Message-Id: <20230314153213.170045-3-neeraj.sanjaykale@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: c57eb41b-e4fb-4bfd-7fbc-08db24a16388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AC3VtLbpt81RE2lOLA+7izxm0H44UQU4HyRYlbQK2YdSWtBYfM5g9zfD3nV1iPJIApMWrQzx91mz0/adrDn8jXOO+alFlh+8G03lV6hTZ9TnKflo1xodn40jSmkCOXd/f09LyQZkqkT4Rwq7vnd1DB63J+jYMIA0nJA5XtMWEUIBXwp6L17Ecek5kDh89jYXiRK1xTQ22voBPTaslAJFg2Qiszqq9zs0Arh57y5MSxMbDjw5T4U28XzCRdjErSR/cG3NKcyHmCCCIkNXXvqV9gW19nUVOp3Xn8bBIFWbj/HxVxETin2T8Ihm+iYw8k0/I8SWqRkC6xvc0KGqJCCh8080D4A1z0JAni4kwrKqYMARoJl0u1E2Sp4YNLbaQfsClv8nB1gMriX4UpRytCfaCyfJIgG9ZZpC67la37fpFZ/G0gfkRpFOYNorbIzWpsvomeBHFuTV9e9/gnoE2ACTtEJmGytsvMg4HSYZdMKXzNtar9j+p+FHHICyKNImSMUkYbaO1OI4Nu5nEyPaGfBh+BOA35kO3/nqo3zu2eiRJaitvwn8knt59lDR9CdaIGhYMjS6cXoDfkpQWbklwpGqPebiV6bwsWKFsSgxBDTEEHQQyR3HjiaRi83n8X8Sm59ZkbYofcyWJHF/MSJeVrcdOa513jDgd0Z1Ko9f6Zd2ZDAZSo15Rq3rQ9dKz9jenzSNlJjL/2H9RI8TdVCt7YGUKURYWtcA/m2vIAWkubQ51rY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(7416002)(66946007)(8676002)(66556008)(38350700002)(38100700002)(921005)(66476007)(86362001)(4326008)(316002)(8936002)(478600001)(186003)(26005)(2616005)(1076003)(6512007)(52116002)(6506007)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bIfM+lqCTdba4i2e3/9cQwMEoyy4EEVVZZkCWl2rvfFQj6Qx1BQQj0m+X2IT?=
 =?us-ascii?Q?3H01ieDlVH6F5W//a4i5t5l40cVjbZ4ibD/EOCJLS9B+HF4U5DYvPGEdLRT2?=
 =?us-ascii?Q?J5XW/8BcFPAkl2bOhr725TFPnoAjWdVYWWSvoHq6jnENp4sAMymVL5+w/P7G?=
 =?us-ascii?Q?2sWavZ25vVWi0nPKy+diCuNrgOR1IoQ8dHriS53QdMxrkjlnHCSQwPsJHn2z?=
 =?us-ascii?Q?1iJt988Gyb8m48we2D1QaeuYwCam7ikNC2y9EyT+D1PmKHC2bZJMVgtbLI/0?=
 =?us-ascii?Q?lelYUCI9OnXM+hj6AzR+tPQc2g67ol/aCjEoVR48vjLI6sX7QLnLqkD6ioMy?=
 =?us-ascii?Q?aRWqG9muPhfo3VIEAP9xtQRgp3HOHhlfFPKhoqR002BPlneX5bM1ukHO3YzG?=
 =?us-ascii?Q?yeyP5G93BLD14x9jJu+ZasTE8suaTeJUwjLYvkbKzvuXo+BstwDT2lcK3FIg?=
 =?us-ascii?Q?c8lgHS7zO+NCQUPCOXPMvsrWjoRLKhQsl09UNFnpOOzlY1LLDIMaPoBos1Y2?=
 =?us-ascii?Q?AptphKGUeE6NCbf1zn+klaaOj7iFSg+wEk99D0YQC3/qwdvzSpfdAJ3FaDaW?=
 =?us-ascii?Q?ymiEyzWWUtlaR6C9T/tFNHUkvjsvw1WCSQHyxxWPZ//0wvImYHhPTj/z5abn?=
 =?us-ascii?Q?/66HXvAcnrHPpsDxOoZZcuO0xagzcdAfZrPn/EYAY3GjgTWP07ZFOwK5gKlY?=
 =?us-ascii?Q?bc2hrsq5M4SJWbyAQ1r59Py3PDNpuNpUIMTgYWp5XoQ93ckI8dwSYfsR0LUh?=
 =?us-ascii?Q?oPFG+uuUAoOlbZl5bhUvFPB/lVQc8pydr66PuFdV7uC54T6K/ZZFYz6bw6V5?=
 =?us-ascii?Q?Bzy5/ufi2RjPgzKZud6Ftvmxiekpcim3pzeX/6qzymL2HMgFtWZENG32I1Sz?=
 =?us-ascii?Q?BdxWDLb5PpIWx3fUXI9CKwQiz2/2wzn6499BmZMfI+Xy++yE+JJgBMZKXH0D?=
 =?us-ascii?Q?7LqHrpd9uA7Vu5/HMEZ9KIIyTmxsvzfaa1l0wdFbWZW31ZqjS7j9aaACABYF?=
 =?us-ascii?Q?wPhXBL9vgzrP7p9oi8zaz1/+1V6roa1ParzxhQt5Xk8st/gK+vzWhBUFxg6F?=
 =?us-ascii?Q?eNOCq9k9OXUPncMzdVtSy2VmWyAcPo8ExxC8jus/BX6NlgSQ9lVM5kRGY8na?=
 =?us-ascii?Q?yIZdYvNtz0N120sYVLtzaOozADiva9dIoky/XcOdHicwt0LWL4ON1XllML4f?=
 =?us-ascii?Q?5eKdIFrezBfWjVLewJBGXsRHVqnyeWbVyHnPYNBU9/qtDivf8JdDxnhv+OwD?=
 =?us-ascii?Q?gmJNpPF9KRYQR8g5ofqE7qJyL3ABnnf3Gv+vkJuHNhwkplvtGD2BEwpGbO2z?=
 =?us-ascii?Q?lUnGbFU8bj5uzlut1fFcdSJ8DNBUjsJgasVR/D3KfLhZjgkGsMqohSn8KpFh?=
 =?us-ascii?Q?s8SgZ9xlaq29MFdUBcpnJyzKZMtwW65M4xQnphLhwogoUajGhrU7UcTVIGrd?=
 =?us-ascii?Q?LFzzeCAmJi+pzHqAXoV3ualzuRpUr5FHa1j0FDe97pr36DiImoxljYjBod/I?=
 =?us-ascii?Q?Kc/NTo3yCBVVEAV015nv00Uvb5dAQC+yjX/e+pGWEnLdNdflx7VSf8TLmw1f?=
 =?us-ascii?Q?qhJ2TTKV+pPsib2CJkBUXHAeP+OnzoXL9H1w95Bs1lKhGZgDYl7C3GriaIkJ?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57eb41b-e4fb-4bfd-7fbc-08db24a16388
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:32:58.3312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vq4ZvNKXO81WGSgCiGpJ2V1TFchFIjZcwLUaw7fCz0/hFwf4IaaRmAFVgHnsNa4H7zycL86ihKdybqN+Ch3qPdCfw7Z+DozycgoRmrpzoF0=
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

Adds serdev_device_break_ctl() and an implementation for ttyport.
This function simply calls the break_ctl in tty layer, which can
assert a break signal over UART-TX line, if the tty and the
underlying platform and UART peripheral supports this operation.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v3: Add details to the commit message. Replace ENOTSUPP with
EOPNOTSUPP. (Greg KH, Leon Romanovsky)
v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
(Simon Horman)
v11: Create a separate patch for replacing ENOTSUPP with
EOPNOTSUPP. (Simon Horman)
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index d43aabd0cb76..dc540e74c64d 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -405,6 +405,17 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 }
 EXPORT_SYMBOL_GPL(serdev_device_set_tiocm);
 
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	struct serdev_controller *ctrl = serdev->ctrl;
+
+	if (!ctrl || !ctrl->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return ctrl->ops->break_ctl(ctrl, break_state);
+}
+EXPORT_SYMBOL_GPL(serdev_device_break_ctl);
+
 static int serdev_drv_probe(struct device *dev)
 {
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index f26ff82723f1..8033ef19669c 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -247,6 +247,17 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	return tty->ops->tiocmset(tty, set, clear);
 }
 
+static int ttyport_break_ctl(struct serdev_controller *ctrl, unsigned int break_state)
+{
+	struct serport *serport = serdev_controller_get_drvdata(ctrl);
+	struct tty_struct *tty = serport->tty;
+
+	if (!tty->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return tty->ops->break_ctl(tty, break_state);
+}
+
 static const struct serdev_controller_ops ctrl_ops = {
 	.write_buf = ttyport_write_buf,
 	.write_flush = ttyport_write_flush,
@@ -259,6 +270,7 @@ static const struct serdev_controller_ops ctrl_ops = {
 	.wait_until_sent = ttyport_wait_until_sent,
 	.get_tiocm = ttyport_get_tiocm,
 	.set_tiocm = ttyport_set_tiocm,
+	.break_ctl = ttyport_break_ctl,
 };
 
 struct device *serdev_tty_port_register(struct tty_port *port,
diff --git a/include/linux/serdev.h b/include/linux/serdev.h
index 89b0a5af9be2..d123d7f43e85 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -92,6 +92,7 @@ struct serdev_controller_ops {
 	void (*wait_until_sent)(struct serdev_controller *, long);
 	int (*get_tiocm)(struct serdev_controller *);
 	int (*set_tiocm)(struct serdev_controller *, unsigned int, unsigned int);
+	int (*break_ctl)(struct serdev_controller *ctrl, unsigned int break_state);
 };
 
 /**
@@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
 void serdev_device_wait_until_sent(struct serdev_device *, long);
 int serdev_device_get_tiocm(struct serdev_device *);
 int serdev_device_set_tiocm(struct serdev_device *, int, int);
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state);
 void serdev_device_write_wakeup(struct serdev_device *);
 int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
 void serdev_device_write_flush(struct serdev_device *);
@@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
 {
 	return -EOPNOTSUPP;
 }
+static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	return -EOPNOTSUPP;
+}
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
 {
-- 
2.34.1

