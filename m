Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A485BB9C8
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIQRvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 13:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQRvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 13:51:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CE527B16;
        Sat, 17 Sep 2022 10:51:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELuYb9pGQfUR5XT2nw6MOcEqj/lGI8u2crq8doaKJg3M/K29Weqr+ahONpZhgjMQrQ6aiXLNvbzlj2w7aUT9Zf/jkrOtdQO/8nKiVE5Qd2DfGzctJ0EtAskZ56kpAueFBG81tosNGoy1lAT3qYyEci+fHS6o/XqV9SmYGz0KL65UR7K0j7r8brOB99jXC3Qv+GkT9JCOD2ydS2JOgSeXRwixQCSvH6hLhkra3fZ2y62aXeeof7jynyN4REUkLJeTJoQnyrm2PbyL+SC4GQA3zyZa4atj2V7gHp9Jhe8s75qE/58SuJDbppAJcECJPlC55fqfO9Wq5UgI3Ve+FO80jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4N/TKcvNDpZF0/hnRDSfAFCjOiUMlWIYjyyK68djk/w=;
 b=YWo5Km5fn8iYm/asbyBeV0gkkaP9d3gckadMjmzHncefD5QC9rwtrvbj4NLGKQS2/vaW2h6QjqJbRwy7wBnCEy4SeAkJi3rAd2QBwZBsgMQdRbZ5k3fcoemJsroJIdWWI7IMQgZQ7A8eFVoohbaKkgl9xNnupTSGDh6w1ZAl+a4h+taZLrq8tYHIf9c/NYsnR30J+uaPXTBUiJ8BEA4DMzdKg5LAmesjmaFrFAXOYFvQMvfMEltKHiyE+UCKtFQ9UlgBwhzvB4Jf+e0f/m++BNDkNHGrxJWqGU3PC1/L8b7reMT3jNPmXbLshYnjVn3mdiaF9QXqN9ODZ0OpOnFJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N/TKcvNDpZF0/hnRDSfAFCjOiUMlWIYjyyK68djk/w=;
 b=zN5gO+3lSdNg0FMr7KYD20/BBXzu3peq6Jd2nh9kF5zblom+8TuCXNT5uPmChJUBNEIOgVMb+QLKItG85hAEa5Wwjpkdqr+sWve77Cgsbaiyf4u6pHJU5wJNKRd1DQw6P090VWtt7txuh0mKi9NtKyPIYXiYo0uYWZu33KQldC8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4523.namprd10.prod.outlook.com
 (2603:10b6:806:113::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Sat, 17 Sep
 2022 17:51:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.018; Sat, 17 Sep 2022
 17:51:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net-next 1/2] net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
Date:   Sat, 17 Sep 2022 10:51:26 -0700
Message-Id: <20220917175127.161504-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220917175127.161504-1-colin.foster@in-advantage.com>
References: <20220917175127.161504-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f1e926-de3f-41f8-ff60-08da98d5472d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sv354KRKX+IRL9Q0K0xCFx6RgEN3hcmLugR4JTCXk1r8wpfaaWu8NRnGNHprUJaCH00YLCVPnVdJaznHYmbyBFXL4gVIbBY8OePSXiXazF5AGMXX5vlDA+vq35IDbL2Q7ktD5HBQj/xOxs7ljv5xOkTIcwqPdg+TR49TmR6kgTpsa0jfmWkun3Ucc5CChDq5pZtfJxSotblUyCL5AYm1gb2TTXUi57+Atf0stcor/W+aZ/FpxXeB5okFLgLVtEdOGCGITxiUKLJpWIWofcXPAPaOjlBJ0zyiA5LPGWRT2odhi0vAXJazir0Pmzgs2c+GmZLcm9jAcsMIwTnPSoEUxi3o1d6N3uQH4cvvq7yM+0uegSIpOKaEfSgn532Yts5l/N3WLSxM4xR3MtYLyNXkAfkNONiMCha+05WOTE4WK/b9JYSKDodZdCIThEESn4EbUF9DnfACogXBkkLhR46OVgeztdGKT89hBHzjl3oze5sHtL6kmEb2UZ2yxbNYfvzKcCwlFPsncV75tSL1nU7Cyt2M0n6U7YpEY1zcWbnOtNhpyW4bzV8nM9Sp6NmoprFZu7cSA7Rxk7Vj4z+IHU6HdLDltpN1feI7DOClwLrHGnIq2FP+eLAa0MJy+icn7SZTVzvzSf0qpItGDcxGU4eAsjMk3ysCZtHwC+YP+75I07cD9CFkMOfWf5Vjn+intPewaVXKdr6UadO4xJ8XnNxWRor9oq6ruLi/kwqTKZbhM4O4BQ7srZm1q4QHYVOzAKz6yIYZJcosPifd19AnO8qHvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(366004)(376002)(346002)(396003)(451199015)(36756003)(5660300002)(8936002)(2616005)(7416002)(38350700002)(66556008)(66946007)(38100700002)(8676002)(66476007)(86362001)(44832011)(2906002)(4326008)(54906003)(478600001)(6486002)(83380400001)(1076003)(186003)(52116002)(316002)(6506007)(41300700001)(6666004)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rpaWPo5oD6BO2tlNv069AFE76VfGq2dww4+cU3PJ6R3WY/9vQYTveDxi+kMQ?=
 =?us-ascii?Q?L5GS/xNr1fv2qwZ3x9ZbH1zR6QtISTf0ukIR5RAxWm6XT6yN99nQPGFQ2h+W?=
 =?us-ascii?Q?R3u2UUBvOddgk9AJ3MhkWT9VnT/1NqqBdh1Cd1WZ40hW69gp7RxVHS3ao2ZF?=
 =?us-ascii?Q?Az5tO2QP/cXYAOUZawziLSkDRMlGFVplsnrdLy+x4bpx3NKaRfXI6B4oZwk/?=
 =?us-ascii?Q?5DzVQ7Zz60JJ2fR9AY6IiiFcqCxihiZhAFCdQXrjBcp0LMGkQ1R/YJCccTvZ?=
 =?us-ascii?Q?GcZjVniQnEhTgxGbN8Xc1WDLj2UaRRj6Zbq7CcUFhJG9jlpZW2jHHCSlNI7n?=
 =?us-ascii?Q?zqWIW4pnLLJuCkmq/8KRSZ8Tw6r4/BNACXl8iLOVK5k+i9n/2xq6zrIBSO7x?=
 =?us-ascii?Q?CmW4cJt4FlXmeoEXEPCjFpexFmnvcEXjBY2mXIrpNvY2ojmEUIlSEuXHpwnv?=
 =?us-ascii?Q?n9OCOGZKS/DNdhrs/6kLZ3Pd5JWcnAhT5O8rfCigqW6JA7fhaESDrgAP+g4y?=
 =?us-ascii?Q?jUzXQ6KbJT9U90ky8HrzwlKStx+9QQYTaahRrQ9BkAaZ6VjUo7MOeQ6WBw77?=
 =?us-ascii?Q?r8tht+16l6nxPpmYcld5jRaqZto1G9h1KAZmcImp0qspOXndC5u+DeHeGCqY?=
 =?us-ascii?Q?V75Z/hrVXI+IPVzMih+jFbAxuRHa7NvdIV/Y1n/bHl/anXHm5xZ4XrpYaPBW?=
 =?us-ascii?Q?T31SfJeboqe5fuPQ9QhKfPTU5yCwUmXkfM8JwnkdZ1+9SQnD01OWgOtrvncu?=
 =?us-ascii?Q?32GldJzaAXv4afrUFfTRg4J96zcCrsDkbg+gxOCH26dgiG4xzCv06PUBDOcu?=
 =?us-ascii?Q?A1NqdsjjWiCtBmdOwPT5SjFSeTzxrzMd0MHmucdcbw5k+7nmMy+8+tczwDUf?=
 =?us-ascii?Q?dw7YfiIgo0Mg7bchpAq/1xXf7tiKww1jikqgZ1aEkJMq4hhSA9HozGCCPEX3?=
 =?us-ascii?Q?2yMj/iILU9Q4gNjNCo7T7TkfcSIcyoYqPI1C36vpVdqDh3GkHB/VyrlCb18J?=
 =?us-ascii?Q?SC/uovvpaz+5/La+6Co0nviyzMOgit6noRacAFylnHDQTmvAeliWMOV/e1KX?=
 =?us-ascii?Q?xIW0rtDMmh0FdqSGofPnkTyjFKo9hKdr73Id6XQTBu3ZD0zuh16tAkANMYlb?=
 =?us-ascii?Q?L5l05K2AOfAsRtHFzWOgb2Lg5dlBAs7ZccjWsUZwGXJQZjqPCPcBfkIFe9ii?=
 =?us-ascii?Q?yIC9ElrlIOi/HZphwl6qqSF8MscbRUPSgcCXQIogvmhauwyEoT+bNPzYx5UI?=
 =?us-ascii?Q?sxHWJweeKVdGucVPnnb1PdlvEiBjInUvv23wSV1ra4k0lJ0OWE6yOTugSPDC?=
 =?us-ascii?Q?tlSuPranwdB15YIgubJQQTKiSw8yHS1bS9xY3DHo9hsiVrHkZf2obPQC/YxO?=
 =?us-ascii?Q?3i5vd4ykq08tPDL0mZpheOg3OmtosU0JtVR+5xcl7gQKaXj4exj+YSX5ZucJ?=
 =?us-ascii?Q?6E7BIzzJzfuteryC9TqCMU1YrIlsblVpoIxKwsrr907LMo/PXNad2yljseOE?=
 =?us-ascii?Q?SnTZWbUS7PNNPz6bn5qHMUhjuGgXQ2gJ+RuOwtkiP2dOTr0fyWU01NhhXtOS?=
 =?us-ascii?Q?tazIHXnNzE/tnpdoHAmK9ZEeEyR3tHLDYgaAwBBjGxoB1A6tonBE/OAuocI1?=
 =?us-ascii?Q?lch7JqGNrtEaMvgx1y36yA8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f1e926-de3f-41f8-ff60-08da98d5472d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2022 17:51:41.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81pEUVeOw8NY8+TNoTlHGSZ6m9rovPD8c/cjHtLeXg+sQKT/KYfvlM1CLnkbPLQjROklT6OQACu6zeVXJ9CxmEmzmvRUDN5kKLJ8+hqMBVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4523
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the reset code by utilizing readx_poll_timeout instead of a custom
loop.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reported-by: kernel test robot <lkp@intel.com>
---

v2:
    Remove IS_ERR_VALUE macro compile error for 64-bit
    Add Reviewed and Reported tags

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 32 ++++++++++++++++------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ae42bbba5747..3fb9183c1159 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -6,6 +6,7 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
@@ -25,6 +26,9 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
+#define MEM_INIT_SLEEP_US				1000
+#define MEM_INIT_TIMEOUT_US				100000
+
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
 	[QS] = vsc7514_qs_regmap,
@@ -191,22 +195,32 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
+static int ocelot_mem_init_status(struct ocelot *ocelot)
+{
+	unsigned int val;
+	int err;
+
+	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				&val);
+
+	return err ?: val;
+}
+
 static int ocelot_reset(struct ocelot *ocelot)
 {
-	int retries = 100;
+	int err;
 	u32 val;
 
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
 
-	do {
-		msleep(1);
-		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				  &val);
-	} while (val && --retries);
-
-	if (!retries)
-		return -ETIMEDOUT;
+	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
+	 * 100us) before enabling the switch core.
+	 */
+	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
+				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
+	if (err)
+		return err;
 
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-- 
2.25.1

