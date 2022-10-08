Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CC55F86C0
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJHSwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJHSwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC54C3F1F5;
        Sat,  8 Oct 2022 11:52:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTX5Hdk81YfrJ1l+9nxGy8hbPdx3N+ftckSBw4rq1X+txos5YkovDOhOYPQzdsNnunvc5ZVAhw3NCyjJf7HfRXVx/hot9xE5In3wmWCEZv32Z0oF2AEY7Lo6lsvN+EU4XwLml48+346siTb46AJCSwqZg4Q6L9ruQB1pWzPkTVYleSR3d0cNcvxY9iuK+anLz1Jg4U9YVoMumUhBVXPWgy//1G2ONBBwcQ3mgoWLPq52BYwGpl/JGOdhlK9MJbBeaycinQMFOlAoQ3iLV39B9kLqBSww9RVC9lPFIMhaXpaxr+TjvRwjlsG1kT3MCzd/q5kSA5Zcgc9K8uhltbTalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KabyPpxqHaUVuLst3aoqtRb3Z3BPXs73xlm3XX/dlW8=;
 b=Rz5ar7y8N7pftZZEMpQGQNnYgUOd1DXNdTExBU49v4hQjSD9OcYfRS5J60/faeZW9tUyfiTe2OFqP6Y7Wx/GtMbsDJLwm9QlqVJDLe0/jQ75VFciFDZ+E7Xuo5xTlF8OwRXlp3ynPwlwiMhVOuwjQRsx6eQKUc2gH+pSr7cXjr7J1tsnPCNdMR6kRFiy8JJW/Jq9qNhwe5lqilFxmSdWzrBcK+XY95a+xyhgA7u9monC+cF7ReCM+48/eR8JuwysEgpMj5lBrJ+6mXo2/bl4g0dpYveJ3ytqYUFSZwsYJDsAlZbffu7z3Gopi32gAw6zxQdIa1GE5lep4LSber4sEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KabyPpxqHaUVuLst3aoqtRb3Z3BPXs73xlm3XX/dlW8=;
 b=yFE44Na/HwPrJJLhivtqf4JNRYN6Wka4EaQj78LCvU/sPP0RrArTMeLkzJeIQlQ3cvLwsiPc6sLLoRUr6BUDBU0RqFxFSPTCdy+9ZCuUFcggyLSV1LCHAhQdOA0OuGcxdvoL9slNHHs3BfftDd6+9kF7SreuuuHbO/+R0Yg3YEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:04 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC v4 net-next 01/17] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat,  8 Oct 2022 11:51:36 -0700
Message-Id: <20221008185152.2411007-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c85711-904d-4306-0bdf-08daa95e30d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OgvgygnLVnPTffv+PKytRFnQ0+cowmj+3yfmNCqfRGEt24IcP6/Ztol3l+c8FDdA3WF2/0+N/YuzNDnCWh50WVs0ZPdZmmqk+IzLl7g3X8AJW9Ta2Bx75bB4t2zmqvx7Nu8w0BmZUB21crxlIYhfja50M3KapSkQ5KBGbrgzgyJc68SJsnxGm8XGXQlqEf8Ow3wgAMy0IeD5pFQN1EBgLt2Gguq9/rMnDa+kTIUAXH1g4/dpq8ao1zmKQP7NbWj0IcN7Eyo//Cy10vhLHHGAvk0INyGzKcZ9IRMtsCt/ol0jjhGffh0ybMgODZWZPL3RW1tfhgp783B/5QRtS+95P3PgdrJ8xs3kUjpWyIZ4bGRjj6moOYOAfvaOL56PBCjtCNiKKZ/zbzbSZhEQkI3RuVG4QR1p37Vds5YUb3KmaDlGax5glO/U3CI7Ktrhufmo/2Hej7FYozEIo8ABzFPfIUTtq2Uhvgbg5/tyIaAAVuQWSA+ZfBZ7Bx7WJHKnVIuoTlIWHM75nKDMEkR4ianWwgCnF6giUXyV4+TAu5CKzfiY7824KdrCJXoJPDDS3i1tkON2jUXNK/MXzZqCQQ694TjKZu/89Bed+p7ZMCtk1P86bfj0/AL9i4YuWHua8d1nLRZjIJk2f3VB7VdNvAmeTS9f2mQBefRSkm2rWolXu08RANrwnbHdW89/mM7FilGoXc213OCv1aqNwdJXyHrNBt7EL5hywURShSwKgShTrVpizVFeB39BW0MrhIv+477vVb5ine0qDxiMA/9EOPm30w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wvSoL+lXh7J99x5H9SHp5ugetJ/yAtT/mlaBleLdI2Ny0xSg9HK0dhDdb/U?=
 =?us-ascii?Q?Z1NGF91y+ovB/4QO2ksX4F+LONT4ir5Iq1vCcJtghSHCt6z1wX49lPqIKcwA?=
 =?us-ascii?Q?pz7Pyx8nFhxOiidmcDUCl71XQk3+BrxG2g4kSP+PVbzOSzI8MDQYuDK0iTGy?=
 =?us-ascii?Q?lolEeWHaTD4EeELqWeOws+BFzXpRWZL9IZ225NqzO6kHl5Q1o++zqxBK8xcN?=
 =?us-ascii?Q?pPigKFZj5verq9+za27VXH8M8JR0K5+iwtRGSXujNBtek43i8e+0E0iy7ump?=
 =?us-ascii?Q?dYUS4pZecdB9ucv2DdFAux+3QrJ78Ns48XK6pvFVhgfvSwC4KBJ5JFwHniFV?=
 =?us-ascii?Q?843y7fLi7OrHB9P6h9OwDYExR0VGBYpAS+Y6/7i4PGus4Vn52HsPn63YpIgo?=
 =?us-ascii?Q?8EITK5Tx3fCBT1m1nwg8MkkggiZ87Qq8XFByTYtzOsy9NMHow5yX+sfFREzu?=
 =?us-ascii?Q?CgIL/6YRQPZZV4a6x6k/9rU4FdWALrlQNuGQs269xxh4fVQDc0+32rL0wUih?=
 =?us-ascii?Q?yP3JLPWg7p625kIwX4WZ52XfQ4i9xRcE4mFXCGJ7GE9t8xgNtrblobpFkKcI?=
 =?us-ascii?Q?tfAbBGvpIqLIsRTWiNjvOvkm6bHaaJzGBV5++7vC8CtEFVZmCJRj/I6ThzqD?=
 =?us-ascii?Q?AePMqnXZHVSCuLwS1VMkwU4W2qtAeH6KFKGFwiv8uQuATCwUr5GdnJud5Ltj?=
 =?us-ascii?Q?9YawewJjxRANt8xl7wKEUC7li+VBGxoD9dWSCd0rrZzMCKCv0qlbJS5xZlHM?=
 =?us-ascii?Q?diaIj7s1ik/eUG0n29nH/5AEk4O74mYMvcocJNG9uL2ZUy1toa01L2piVllZ?=
 =?us-ascii?Q?mkIagBDX9Ywao2acCTgOKvWc9K4GOpym5OCQUlW0arUycufo5rn3VaI8ZSYm?=
 =?us-ascii?Q?gfggfRWIBaD5sr9luZ4KWyBsLGnZYFhfBowNSaEYc3A2Xn/EqPJWL+X2wCll?=
 =?us-ascii?Q?/JYugqiItf6s44pbeYAxSRiiWCF8iUbaeYn5NuFiDPKVXjBnpqp7ft6C1f2X?=
 =?us-ascii?Q?HkVbPKAybsCyd7ceurjeysR7HSuTJ1MeIugew8zHgkcdghWaBtXbg37pzN7g?=
 =?us-ascii?Q?k+txE3EA/wUrBF7ic7OMQ7fTNIGiU0xzyS7FfGtbguaTXQ+qFxD547SHv7Z3?=
 =?us-ascii?Q?zQwFPXci2S4p9ChWJQDiQHR3X4sdZ5d0zSlkrh5RatPM3VzU7KRWeAaPRCse?=
 =?us-ascii?Q?Vvj4dKE5CC8rb0afoTHQAM26qNp78ZO8SeBCKtGSSOn7hKtvT/2QB0laqjPc?=
 =?us-ascii?Q?9V/g9ZfFkUsr1tH4yx+C5oanao+goW49bw4Dfa/oIlLsmabppm39Ngrj2qBr?=
 =?us-ascii?Q?xRHA2D0yi4u+JyCz0F7igSPib/VfyPHiiJxSUn6vutzO8c3q10mTq7CQcI/a?=
 =?us-ascii?Q?bzElz7SJn5cknzK1rB302+JBlrja9qb2Skl3SgxDgEyy0E/oqHxB/OO/nU1o?=
 =?us-ascii?Q?lBqqonrPlOsnkRAqqveoBZIuuxLqdXGLwyXk17FRaf0ERHhmQ3BeNoNxqadR?=
 =?us-ascii?Q?nndTgJ6AkZz1CCGy5n0x8+2Cy1lT3tkNyNIYMBnaXphDKLz7PlJvD+Kvpfze?=
 =?us-ascii?Q?eT0A5Y4c5ggHcfDoXTvFI11zL4nlEWI11qQXMNRfwbyCfwZFZ4G/MlATVlzt?=
 =?us-ascii?Q?cGC89wpeV0B9GRR8Dloj00Q=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c85711-904d-4306-0bdf-08daa95e30d4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:03.9288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ze5kIzNT78IQRPJjnmyEn74GPcalnpRiUNUtfSfLh4m/flPvXeLiG5EhZoEFH5x65H9Ut8+5CU7zMZyRN9gQfYJXlxjYFnNy/vIjBAq5fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 - v4:
    * No changes since previous RFC

---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6f22aea08a64..bac0ee9126f8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -234,34 +234,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 967ba30ea636..55bbd5319128 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1145,6 +1145,11 @@ void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

