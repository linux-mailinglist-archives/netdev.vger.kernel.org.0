Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8F669A239
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBPXVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPXVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:48 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53084C3C3;
        Thu, 16 Feb 2023 15:21:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQdg4ZLibWIAjh/JFklBEbrulErK5/3ubktNJpJZPqReRY7Aw4LCSdn/E6rziZ/JmZc+pXugbgVvyUhDp/nr/ytYgqs4meCW6r+aI7TeLhZOtM0fhc613eEcHGRQ/6Fsi4roSpPp4sl9XjMo4n2Reg+mas3U2fBHfnxVLGsO6FNL2YlEP5qlGPXwuDXTK2alKXPmulxZ/bIInHpcbTgiKjpIfOHTZkoOvet+xFWZ+0D0jZ6wDeCX+wvw3d0mc/Gv9SmQ0Oj43g0F1arZBfFvzlY05awM9zRDV7zWe2NfrLeIC1kpPP3UFNIJ0gK0iQQVGzQgfXZtMuJgivxUyiWYsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ua7VzKZotSf/owtZxk1sEG9iE3xyW+WtDobxxo6yEls=;
 b=im3adpWbRi7vrSseeV0ERKY7EznTIA55vbel98D34DRl+sp52wqMWD6GSA15EHc594bMxndivx9N5v94+RPduUvy1vYWsEzqQtthVsWxmrAbMiM4TJXADt0borUPA6ZW76LcqsWErIGREqqNcac/1oQp+wrQVTWGLznlRRMEfQRA78baBcNoen03Wg1aSMw+kWjSW9RxZj7KaXRUtxKsjzUdta5VKP8fa0mMDYIUtuXX67hiDsJK3ejnOQ/RUUsfTlVnqknGjmYSpXwydFQhRKBaIfh2gv5jtfUHE56qxL1ROtm8ysbz/O4lf+40I2Cqya1u5AauG2ZRUhDR1lnnlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ua7VzKZotSf/owtZxk1sEG9iE3xyW+WtDobxxo6yEls=;
 b=nCza2ZG5+Z7r1r3qgP3zQjaQrxQSSMC8T7yamXlGmSk/dOQzZKrjnHCNVG80eCzSbpObAZ88F6pKDmF4gIoWLCLDH4gr/GxsoUcLcRXodsF5odwrO/5257CgqyXQcJKXsDjMGGHFCPFKnuAtJj4ExD8H7QueLqU9cdfERKvmIfc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/12] net: dsa: felix: act upon the mqprio qopt in taprio offload
Date:   Fri, 17 Feb 2023 01:21:17 +0200
Message-Id: <20230216232126.3402975-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 73668702-de3d-4bea-ba0a-08db1074914a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRF7gsJ0f4QZhyRnqoFhumqvg6vs+kcgug1DGKdISc+Q7Aur+INe3B7wFgBxply+picEsMZlSBiPTbq8pSMk+VYmUscjxXFUsLyAQZn27YNQ16LQ1GeNfmYhhSOnGYRu/rWo8PNjhdm1eQBXyGhnrqDDsSD5cdm+hCPMTJ2//e/bvHlLhPP2K5JS4Ro66YwvKEM/cxQid6lXEeWKqjIGXSDg1z6RNcBn1kEinPBCCzSWO2L1F+FX/PYuCtKzTYOIYetjVcliOm8p40SZri7WxAKM1SwzexMZ0bxoYXbQ64qIIPCVU7rG1rQtIM/hngIJ0Z7MybjukmAChabJGKnPISD92iDOYm1ocx5rEvZl/sC6tXVlL1cIV3d7vb9t3GrAPOdTwZfCR+nB3ZTpLVZDYPN3v8oBljg5gZw5dAs5nGyqAa+iaiXTqXbnRtbAjItpLvJGsUXbIEevxOKkzcur9Wgl7QljNM3E4Yisiv0Ns7Pqs0V7MafbAjOvVrGxrz8I61Hnxt+p775tL+QH2bKC4//3RTaRbkKG5wPW++uCcN2GxqSqkucgHsABt+wyRbIgFthgRchC46LOY4bp1l9M+6fwXQVA4UGz/m8nfF8M5lLsczWXBekzZ76sfAG6UqYI02EarKv3FfG68S63oXbErUEQn84sTGV4W9mLp+S3KcXMH5YIygccQiDXsQsxfR0NcUzqPfytWOP3r2D7YwVrVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nw0J4Rg/0mej833mXSH5E71g9eII64ZiKwLa5SnFT0ZKvtQPGDj/L08UrS2Q?=
 =?us-ascii?Q?RXHLN+p54QwyA57atTHa1vxm95CSGbTQFASwLu3U4l72ZpoqGy6bsMBK/PK3?=
 =?us-ascii?Q?jS3yZbPlRWEUz8BiMdztX4/jfAtHLfI64V7EEjD1z1qTYt8u0LJLUpD+Hoyd?=
 =?us-ascii?Q?7T5Jlq6Je/UxHErOr8e8gteT2QabmIs5SuOix1c42ssLYokKAhpfwtQb9MY2?=
 =?us-ascii?Q?FQOQ5n/jYBJNSdUZnZ+pcTNv7B+Bw+QZ1fPlH+5XBiEKbcD+j780eY1cR4fr?=
 =?us-ascii?Q?kQSF+QUxOus0qAEvUKwmkckqUMfua0b2/SOSZnipTMpyoc4znCYOtsNbkHVq?=
 =?us-ascii?Q?KxOkGRRP7b2XPQ356h4D/gq6OGlQ0thlws9Os16t8ZdvPHF2IrJAjDFqrakB?=
 =?us-ascii?Q?IQx101c3BjRQ2S9TcJewFNKGXJ7BD1OenSU8m4wgucHMG8Kc+MoSj0YU0Hv9?=
 =?us-ascii?Q?eZ+Np8zqyJ5DO/DN6isfE3LcEaycfy+/4Om5m/uxlJGd3BLq7dK3rtThSqvW?=
 =?us-ascii?Q?EpRjV08ja3CrmUesy7gSc3kFCXEGXmtdT1eGqBElrsw4ffMe4dLrzG9eCs0J?=
 =?us-ascii?Q?3IbUMBOtnVSUo9Pp8vBgVBN8z45p7N/hUpKkK0FfGzt/T0VHKbNXE1ijskZ+?=
 =?us-ascii?Q?4AL6amvzyUgaDMdTYtG0CPHeJ90ou5rFePXlBdVicRbv1yfgbR3C5kpmFtTT?=
 =?us-ascii?Q?sM3t4s0411bA+IAu74g1laalVy2ojBGP280PCLH3VR3ZvKoJPHkdyL3pMgNT?=
 =?us-ascii?Q?EGkGltkFwQFO5sF2ECTlpgLqB2CfEQq1p8Tw4N2oAl31ZVUkM04A4C0xLdnl?=
 =?us-ascii?Q?RNjPDFJUJuDfcgiYdsIBSamOtHaZin3jGV/9cZHKIyue+WHPMSzKExl8SnL+?=
 =?us-ascii?Q?/x8X/boYwsa/jlfxoiQj5w0idmihAYzzf/qaG1qRlzW+c+xPd8vA0E2HU6NP?=
 =?us-ascii?Q?Ih/hl8joG3lM60HmjqjvWBmIg6yvyYjMazr5jGs9VOymwiyzQyruuQY4U3wI?=
 =?us-ascii?Q?eP22W758N6H7KXml6xuYFCNbm2RrvK8tGyp77JaYZzhUQPB7c83EhoJUWI/m?=
 =?us-ascii?Q?7mQ/4+S1IFLcftYf8wU8+0GTZ5NFZ2vLzkY6oPgRNrILilNy6qeZqZDiYFe9?=
 =?us-ascii?Q?mx+QC73Mq+2d4ULqFGMS89g7JL09GAK1Wq2PwGEAo4q3HKuMS0648JNqyp88?=
 =?us-ascii?Q?H1FoNgEdaevKdvaHAKwKS28vbFHZmiemAJILQkP6be8L+y5itZSpwVqLVPsL?=
 =?us-ascii?Q?eH79WjiidramWjrYM4YMAKv5B1IQ5a2rpgz0hZ9yicMAt7NLKzWm119UdnmM?=
 =?us-ascii?Q?XQQUo55pU4U9Hk1ES8PCWbpwfrCrMDXcnX69XnNmQGerLBnJWFdgY6IPQ583?=
 =?us-ascii?Q?AVBf1N9YqSC2u1qHoLH/ezP0IDVUrSMYmXGG330oIN/1ZCMT3nri0YS8Ajrk?=
 =?us-ascii?Q?RxYvenWAtnt+keCMQM+EtpyitY42+GmwGzPiUIcMxoQ9eytAlZs3G+Qdgk+w?=
 =?us-ascii?Q?2l9OGU62DSYnl4efCq/KTucfwhrQkOJQd9/hGxLAOTQTapkHBz4Vq03GSQvJ?=
 =?us-ascii?Q?xr04KPkKJFZkbTpkMnQvCpmma7OTcUEFgKtOdFSB6vGirPQAvli+Gjh1yxMh?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73668702-de3d-4bea-ba0a-08db1074914a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:44.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cU72zsQ/Zmr3TCVdomaH1vOofvw8W7kpqCoEFR00lzPgXfoJ6Qmfi6lDmlINKZSKdciqevnibbfMFEpmxb/Zew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mqprio queue configuration can appear either through
TC_SETUP_QDISC_MQPRIO or through TC_SETUP_QDISC_TAPRIO. Make sure both
are treated in the same way.

Code does nothing new for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3df71444dde1..81fcdccacd8b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1424,6 +1424,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	mutex_lock(&ocelot->tas_lock);
 
 	if (!taprio->enable) {
+		ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
 		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
@@ -1436,15 +1437,19 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		return 0;
 	}
 
+	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
+	if (ret)
+		goto err_unlock;
+
 	if (taprio->cycle_time > NSEC_PER_SEC ||
 	    taprio->cycle_time_extension >= NSEC_PER_SEC) {
 		ret = -EINVAL;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX) {
 		ret = -ERANGE;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	/* Enable guard band. The switch will schedule frames without taking
@@ -1468,7 +1473,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
 	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING) {
 		ret = -EBUSY;
-		goto err;
+		goto err_reset_tc;
 	}
 
 	ocelot_rmw_rix(ocelot,
@@ -1503,12 +1508,19 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
 	if (ret)
-		goto err;
+		goto err_reset_tc;
 
 	ocelot_port->taprio = taprio_offload_get(taprio);
 	vsc9959_tas_guard_bands_update(ocelot, port);
 
-err:
+	mutex_unlock(&ocelot->tas_lock);
+
+	return 0;
+
+err_reset_tc:
+	taprio->mqprio.qopt.num_tc = 0;
+	ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
+err_unlock:
 	mutex_unlock(&ocelot->tas_lock);
 
 	return ret;
-- 
2.34.1

