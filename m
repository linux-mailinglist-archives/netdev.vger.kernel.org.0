Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10651EE8B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiEHPbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiEHPba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:30 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0591AB87
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjfe/8xdutg4m6xfGW8+oJyXseljMXP7FwXUv+lj/3CzBPMRZbM3TlUjHD3csjVV0FP1MHzlKXvfFWNIHk+NccpHXnKCuS0U3yyChypuHSwbn+ihKT0HXOCco9EXcYQc+phHOC42zDulPaZ8uaWTVxoA8snB3TtaVIvHFB1LTbHk8IXrARoyaLrGG7INAgSphOMxHdk3KHflWrmx255+ldqK9dEyJrq4MnQ3POdHEeW6QWqURyZRgYlva0+ynBBoRapeQGncakFY5iIa2/Rnvo1SktzenPAGpMzo0MdMAr+gMNL1z/mZzQlTwBJqzxTulXBO8dCZBLGDbyFCier9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noRfRsxLXnzZUJwo9CwwBSheuh5tvQdEdOsGH6ZVm6I=;
 b=T1HfJ3jxTmiJ43mq8lJwWd+NroE0Dg0NeDt3CW3koB+NmzCwE25bCA7/wbq41BxIW6+EMZ4IB1j80e1mfLW/IgxN3prugCb8FV4T12XXJkd7KOsfTL/q0jjXjB5MFE7v+KpzLm8X+VMUVREUT+lhktd4OchVoYi9BANekAL2FaYCk5LdeI/dszZeomgLZTXzVn1uy3XgJi56Osfe3VZvGVvSa38wOjvP6xudRB4H77BlzlG997Gvh815lHnIePfLTFLdIQXfITOtNHR8dNkMB96iaSlI7Ty6ChEX3hXs+mba+/x1MWtOtPPhJf5+ffqgOsaiITMCXgbAHEdwA03/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noRfRsxLXnzZUJwo9CwwBSheuh5tvQdEdOsGH6ZVm6I=;
 b=eeAptx1SO4Z2yziok3dSZc4LKo1PakjngqIe2KoMTdysV3pdcDCCTNB/zXLSPhRqxxxuGNMal8NL3hKl0L8XWYo10pog2UJm38THTOg6arhhdD6J/z4fHQJzSUogf06qWhAiE449+l4V34jjCPDyQKjnLdYLvS5pewznj2+RFRU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:36 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 6/8] net: dsa: remove port argument from ->change_tag_protocol()
Date:   Sun,  8 May 2022 18:27:11 +0300
Message-Id: <20220508152713.2704662-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9156ccf-3636-4828-ad7d-08da3107477b
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB28068527789CC0F6FC197FCCE0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvzrNRSkrp80cIofYkKF8eMRoiC/0snkB3qfd/Wpk0+0h4/iHAw10TSRPOktWEv6hOrbqjjh6QJSxyuJRyJK0LSkceyfmTEcZLTNEaybL8PFr30K/A19u9jfJmSMkQ7a+eBKZ+3iKRb0zXGJ5UiJX9vIGzCxTZf+9CJUZ1uBEAjN8Wo7QvHhiiOprSOFjPVak5mXsBIp8NxJfoeklBov6FvjABjPn5hun3C1XEtS73FiH7g++O40c5zkJPzXjiq37DDGWgmt1zTt6uxk4dSXwQmEr1w4NYb/DaTnYVQXgxhDkOE6/dQJwf474iZs/isMigFvK2sGO33Tnxwd7QO4S+Wabo62UUkYc/C0slMnQtWbk4/zmU1GqhXGK66en8wcc+OyY2PPFwYdY79wmtvL+EEAiIGCvetGsK0yZ2Sn3yNTd9uOQ76bVqVw2uJ18TKeOw23DKAhKBgaVfnDPxd/59gt+bBFrpLtBehu9eCrFnvIo/FpsDfaiosMIcS8GsmYK/W3TZbsoDXClVZA0HSt4C+3IH33CvlxtgO337SB5tzqUtcaDL+80busv91o6Afa/C3FEUwJ0q9TMaFM0fBleY88ojJfzQzN1h+NLGHF33EvfUeG9+z2OrXGk/R9udthDU4AJpNJh6sRd6Hzk91CSU95yqDF/eIRETVnhHHTISOOg4QmZPR0aCSXLs7iZGKu9Wcgq//QrQCEDzfAs5kUoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mY+fNRpvwH9WqaA9SJrGsDGSxz87KkGTvsTfKds4QPhL3fZ19di2CZZHKTxC?=
 =?us-ascii?Q?HOFZyRBHwPZDZlL31CrRFguDxhZgy4XezLuraRjXstLp1OmEs9xkXaYpkc1M?=
 =?us-ascii?Q?DJyKyknR0yATmLWMCEDWSM608msoMkhqqsAUGUOL5xbudXCXlC43M7pkVjVU?=
 =?us-ascii?Q?4Soh6LSQRb/iRPWz8EgJeKSA2dAVFKhVwNCE6TYnIbEcsn0PnDou6G+Bv5Gm?=
 =?us-ascii?Q?2lltlA6j/7znXaohccT411aK/rAcjZpfB7XBT7jOIEnX4YEFdGUfn/aNp7mS?=
 =?us-ascii?Q?PciYQr7dQ1O1idFBlz0pRhB+3ZM6gWJJzIAa/vyjUGWBqPqkNMAIuYfA4fk5?=
 =?us-ascii?Q?8DGMNN+A0G6iVK8UdGqoH0jrYJHLv7dTfL/eTMAqhiVPc/BFtcHM7CqTGX/F?=
 =?us-ascii?Q?c3Q802yZiC8BD6C7ilmSIoWgxFYu0hIfP5G/r8/hJhZPnHSKo6ffkKflSKxW?=
 =?us-ascii?Q?Pwh7Ld3IHmZN2an7MVbOE0BhBAeBADhKyOKOPuL90eiWXST4TIfgZuAbZgZd?=
 =?us-ascii?Q?FrfyXiHXCWOHG9pnB+cmgPuqu+qjyfgd7NfLJ3o9ZNzn4l4ASWmIdJbYL6SY?=
 =?us-ascii?Q?HqLgyLdeAhBXMjKcWIO9PFkz7F6t/gZjL0JaqVNCItL4toyhTa2vbtzP8Meh?=
 =?us-ascii?Q?3yJnguMz3Tpqk/l6Wxf2RB9E3lyzZ34vDGN8vfaZHKn7ZSRY4RGOxjcRUE9g?=
 =?us-ascii?Q?fNnsWk9ZEt9rqdqGl4zUx9SwkfMtV9qjuIHB/4Ng0mFpd1O89hD595NnTzq4?=
 =?us-ascii?Q?ASPH0PmkMuUM5JdHfRUD1ZMpAODlA1od8c6z95S7/k5fjFKb9Pk49D6xXLB+?=
 =?us-ascii?Q?OHraMyoy1lU477vjI4h6jkDwY5zQ4xbHMYjrSBOCiKcuMdhiNaTIuQ1Mzl6D?=
 =?us-ascii?Q?/lHxtPZJ4C1gswxaYZFxNHDt51x0tAT4cvC25nBvks+foM7fbOSwQlH0f6f1?=
 =?us-ascii?Q?FiHVRREjXYNalN0QdO+DwAERGNivwQ+5ntl7wPSzfHn3B8wlbrnzXU9UhAnJ?=
 =?us-ascii?Q?Zxp/vipHiIKyh121jVRnlFN2dgUNM6ItShZudjRiJ/q7bpPcpZzsL2M+uLO/?=
 =?us-ascii?Q?tK34ErxFlStWzZMd+2kLxcASfwCC+ZFz6oryunjuZGpm1prva3R04zbeengN?=
 =?us-ascii?Q?M6Yg+H4RShtUOBjCBQcTTTWjnRZ4jeb6/ILAdrB7g7UDaLWuEMyPClLyS94a?=
 =?us-ascii?Q?HJmZZITMsS8+QcceKffEgtSdLjI4LEfzqa/3zg6sDi3DFzBHB50a0Eo9JrSL?=
 =?us-ascii?Q?GsxBs+ce7dqaZa4hco1+nD4DOEhOyIcLDT3JarNgyv8LTH8vRN3UckbSI2Ym?=
 =?us-ascii?Q?TF5zI8BqtjFBwZMME/gGfQNZJO/zYuh+c47Nb4iUBJYX6pTge88G/dxY2idt?=
 =?us-ascii?Q?+fTXsXM9Olj/BL0UuBa17Qrz+RWgBwA4wHYcXHKPwdCXEXSuP4LAGisY2gCE?=
 =?us-ascii?Q?6sMzSnyDXtwDbfF/kNkee7zRaDM2JIG3cBbv/gz+7+WOt29w515Z7JzmPMs2?=
 =?us-ascii?Q?DRUFv6xMSlgaMt0FX+snSmGeCwu9mTtApVT1uQywbcdc292Ii7VZSVIgX6Ic?=
 =?us-ascii?Q?2FogGx7FRjrd3BQe4f/fY6EXuTGcpP+uuzOSo+ciIOVjwQ8GdVxV3ChXLaTj?=
 =?us-ascii?Q?EfR94Jtt4SQxkXCflEBNQpxQfVMBXMQzSZpBUegpRZkCKol7LmDEQ7eoougT?=
 =?us-ascii?Q?B0nu7c+sEBg4nLpiETdD8lDiMM9ZnI26b83VpeC8RRHlt+QL/ihActNE9HdE?=
 =?us-ascii?Q?sAjnNn7PGYEXs1BaEuKBek3YD0+C/qo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9156ccf-3636-4828-ad7d-08da3107477b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:36.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLPsTWWHE9uuNb1h03jJs9XpM0+9l7bTJPQPxKK8kkFB0rOeNmr3nSeXkYzIQiOOycirxNvjJKmevbN66VJ1zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA has not supported (and probably will not support in the future
either) independent tagging protocols per CPU port.

Different switch drivers have different requirements, some may need to
replicate some settings for each CPU port, some may need to apply some
settings on a single CPU port, while some may have to configure some
global settings and then some per-CPU-port settings.

In any case, the current model where DSA calls ->change_tag_protocol for
each CPU port turns out to be impractical for drivers where there are
global things to be done. For example, felix calls dsa_tag_8021q_register(),
which makes no sense per CPU port, so it suppresses the second call.

Let drivers deal with replication towards all CPU ports, and remove the
CPU port argument from the function prototype.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 22 +++++++++++++---
 drivers/net/dsa/ocelot/felix.c      | 39 ++++++++---------------------
 drivers/net/dsa/realtek/rtl8365mb.c |  2 +-
 include/net/dsa.h                   |  6 ++++-
 net/dsa/dsa2.c                      | 18 ++++++-------
 net/dsa/switch.c                    | 10 +++-----
 6 files changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 53fd12e7a21c..5d2c57a7c708 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6329,11 +6329,12 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->tag_protocol;
 }
 
-static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
+static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds,
 					 enum dsa_tag_protocol proto)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	enum dsa_tag_protocol old_protocol;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	switch (proto) {
@@ -6358,11 +6359,24 @@ static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
 	chip->tag_protocol = proto;
 
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_setup_port_mode(chip, port);
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = mv88e6xxx_setup_port_mode(chip, cpu_dp->index);
+		if (err) {
+			mv88e6xxx_reg_unlock(chip);
+			goto unwind;
+		}
+	}
 	mv88e6xxx_reg_unlock(chip);
 
-	if (err)
-		chip->tag_protocol = old_protocol;
+	return 0;
+
+unwind:
+	chip->tag_protocol = old_protocol;
+
+	mv88e6xxx_reg_lock(chip);
+	dsa_switch_for_each_cpu_port_continue_reverse(cpu_dp, ds)
+		mv88e6xxx_setup_port_mode(chip, cpu_dp->index);
+	mv88e6xxx_reg_unlock(chip);
 
 	return err;
 }
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4ab4f3d16c20..4430495a4d21 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -575,14 +575,13 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
  * tag_8021q setup can fail, the NPI setup can't. So either the change is made,
  * or the restoration is guaranteed to work.
  */
-static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
+static int felix_change_tag_protocol(struct dsa_switch *ds,
 				     enum dsa_tag_protocol proto)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
-	bool cpu_port_active = false;
-	struct dsa_port *dp;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	if (proto != DSA_TAG_PROTO_SEVILLE &&
@@ -590,33 +589,17 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
-	/* We don't support multiple CPU ports, yet the DT blob may have
-	 * multiple CPU ports defined. The first CPU port is the active one,
-	 * the others are inactive. In this case, DSA will call
-	 * ->change_tag_protocol() multiple times, once per CPU port.
-	 * Since we implement the tagging protocol change towards "ocelot" or
-	 * "seville" as effectively initializing the NPI port, what we are
-	 * doing is effectively changing who the NPI port is to the last @cpu
-	 * argument passed, which is an unused DSA CPU port and not the one
-	 * that should actively pass traffic.
-	 * Suppress DSA's calls on CPU ports that are inactive.
-	 */
-	dsa_switch_for_each_user_port(dp, ds) {
-		if (dp->cpu_dp->index == cpu) {
-			cpu_port_active = true;
-			break;
-		}
-	}
-
-	if (!cpu_port_active)
-		return 0;
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		felix_del_tag_protocol(ds, cpu_dp->index, old_proto);
 
-	felix_del_tag_protocol(ds, cpu, old_proto);
+		err = felix_set_tag_protocol(ds, cpu_dp->index, proto);
+		if (err) {
+			felix_set_tag_protocol(ds, cpu_dp->index, old_proto);
+			return err;
+		}
 
-	err = felix_set_tag_protocol(ds, cpu, proto);
-	if (err) {
-		felix_set_tag_protocol(ds, cpu, old_proto);
-		return err;
+		/* Stop at first CPU port */
+		break;
 	}
 
 	felix->tag_proto = proto;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3d70e8a77ecf..3bb42a9f236d 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1778,7 +1778,7 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv)
 	return 0;
 }
 
-static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds,
 					 enum dsa_tag_protocol proto)
 {
 	struct realtek_priv *priv = ds->priv;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index cfb287b0d311..14f07275852b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -579,6 +579,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	dsa_switch_for_each_port((_dp), (_ds)) \
 		if (dsa_port_is_cpu((_dp)))
 
+#define dsa_switch_for_each_cpu_port_continue_reverse(_dp, _ds) \
+	dsa_switch_for_each_port_continue_reverse((_dp), (_ds)) \
+		if (dsa_port_is_cpu((_dp)))
+
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
 	struct dsa_port *dp;
@@ -803,7 +807,7 @@ struct dsa_switch_ops {
 	enum dsa_tag_protocol (*get_tag_protocol)(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mprot);
-	int	(*change_tag_protocol)(struct dsa_switch *ds, int port,
+	int	(*change_tag_protocol)(struct dsa_switch *ds,
 				       enum dsa_tag_protocol proto);
 	/*
 	 * Method for switch drivers to connect to the tagging protocol driver
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cf933225df32..d0a2452a1e24 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -809,22 +809,18 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 {
 	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct dsa_port *cpu_dp;
 	int err;
 
 	if (tag_ops->proto == dst->default_proto)
 		goto connect;
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		rtnl_lock();
-		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
-						   tag_ops->proto);
-		rtnl_unlock();
-		if (err) {
-			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
-				tag_ops->name, ERR_PTR(err));
-			return err;
-		}
+	rtnl_lock();
+	err = ds->ops->change_tag_protocol(ds, tag_ops->proto);
+	rtnl_unlock();
+	if (err) {
+		dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
+			tag_ops->name, ERR_PTR(err));
+		return err;
 	}
 
 connect:
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 704975e5c1c2..2b56218fc57c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -809,14 +809,12 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 
 	ASSERT_RTNL();
 
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
-						   tag_ops->proto);
-		if (err)
-			return err;
+	err = ds->ops->change_tag_protocol(ds, tag_ops->proto);
+	if (err)
+		return err;
 
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
 		dsa_port_set_tag_protocol(cpu_dp, tag_ops);
-	}
 
 	/* Now that changing the tag protocol can no longer fail, let's update
 	 * the remaining bits which are "duplicated for faster access", and the
-- 
2.25.1

