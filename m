Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96F1605B77
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJTJs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJTJsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:48:55 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3841C881A;
        Thu, 20 Oct 2022 02:48:54 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K7VqcL002877;
        Thu, 20 Oct 2022 05:48:31 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kb215rs02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 05:48:31 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 29K9mTjP057555
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Oct 2022 05:48:29 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 20 Oct
 2022 05:48:28 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 20 Oct 2022 05:48:28 -0400
Received: from tachici-Precision-5530.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29K9m8YT015451;
        Thu, 20 Oct 2022 05:48:23 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lennart@lfdomain.com>
Subject: [net v2 1/1] net: ethernet: adi: adin1110: Fix notifiers
Date:   Thu, 20 Oct 2022 12:48:04 +0300
Message-ID: <20221020094804.13527-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020094804.13527-1-alexandru.tachici@analog.com>
References: <20221020094804.13527-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: z1x6z2eFDpGC18EHuskYP_Pz6xmAiKah
X-Proofpoint-ORIG-GUID: z1x6z2eFDpGC18EHuskYP_Pz6xmAiKah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200057
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ADIN1110 was registering netdev_notifiers on each device probe.
This leads to warnings/probe failures because of double registration
of the same notifier when to adin1110/2111 devices are connected to
the same system.

Move the registration of netdev_notifiers in module init call,
in this way multiple driver instances can use the same notifiers.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 38 ++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 086aa9c96b31..78ded19dd8c1 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1507,16 +1507,15 @@ static struct notifier_block adin1110_switchdev_notifier = {
 	.notifier_call = adin1110_switchdev_event,
 };
 
-static void adin1110_unregister_notifiers(void *data)
+static void adin1110_unregister_notifiers(void)
 {
 	unregister_switchdev_blocking_notifier(&adin1110_switchdev_blocking_notifier);
 	unregister_switchdev_notifier(&adin1110_switchdev_notifier);
 	unregister_netdevice_notifier(&adin1110_netdevice_nb);
 }
 
-static int adin1110_setup_notifiers(struct adin1110_priv *priv)
+static int adin1110_setup_notifiers(void)
 {
-	struct device *dev = &priv->spidev->dev;
 	int ret;
 
 	ret = register_netdevice_notifier(&adin1110_netdevice_nb);
@@ -1531,13 +1530,14 @@ static int adin1110_setup_notifiers(struct adin1110_priv *priv)
 	if (ret < 0)
 		goto err_sdev;
 
-	return devm_add_action_or_reset(dev, adin1110_unregister_notifiers, NULL);
+	return 0;
 
 err_sdev:
 	unregister_switchdev_notifier(&adin1110_switchdev_notifier);
 
 err_netdev:
 	unregister_netdevice_notifier(&adin1110_netdevice_nb);
+
 	return ret;
 }
 
@@ -1608,10 +1608,6 @@ static int adin1110_probe_netdevs(struct adin1110_priv *priv)
 	if (ret < 0)
 		return ret;
 
-	ret = adin1110_setup_notifiers(priv);
-	if (ret < 0)
-		return ret;
-
 	for (i = 0; i < priv->cfg->ports_nr; i++) {
 		ret = devm_register_netdev(dev, priv->ports[i]->netdev);
 		if (ret < 0) {
@@ -1688,7 +1684,31 @@ static struct spi_driver adin1110_driver = {
 	.probe = adin1110_probe,
 	.id_table = adin1110_spi_id,
 };
-module_spi_driver(adin1110_driver);
+
+static int __init adin1110_driver_init(void)
+{
+	int err;
+
+	err = spi_register_driver(&adin1110_driver);
+	if (err)
+		return err;
+
+	err = adin1110_setup_notifiers();
+	if (err) {
+		spi_unregister_driver(&adin1110_driver);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit adin1110_exit(void)
+{
+	adin1110_unregister_notifiers();
+	spi_unregister_driver(&adin1110_driver);
+}
+module_init(adin1110_driver_init);
+module_exit(adin1110_exit);
 
 MODULE_DESCRIPTION("ADIN1110 Network driver");
 MODULE_AUTHOR("Alexandru Tachici <alexandru.tachici@analog.com>");
-- 
2.34.1

