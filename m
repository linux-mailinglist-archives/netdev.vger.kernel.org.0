Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98864D1A16
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347354AbiCHOMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347348AbiCHOMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:12:19 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2110.outbound.protection.outlook.com [40.107.113.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9846D4AE0C;
        Tue,  8 Mar 2022 06:11:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mkx/xCsndadZFBAEp9GUzRLTiLErZgZMC6cmcWj7/TBYY/oX0vwIEZlOc0fHCdrpGjMroq1EIi6QVJU6ogMh0R34rfc5dY8501k6WfAfBZP3yQBy3HcM32C+KKEju0BwDn7a013UlXv3PQLiVw01o50xT8pKvPOTCqX4+GO88oGaVDyaWqd3vMlzt9Gl/nk5BjoKkFtt1BFFzQUlYIQ/n816SHQWJ3y68mFA8ZaSQIThUmwLZ2nd2qdxbk2G42g3V+3REPq6GXr/GLItswF33HAEsqZy7SJ51HNGLm3v2D3hkUAV9kMjt9MCsQKeN+IS+GbYQtmcjKI127Y9d5h19Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtpk3ooz2Yx7pfMcooSd/QDSvt/TRBhARH9NT+zNoNY=;
 b=fkzMZulTi202La+jEu8aTt3jFWljCCwSwXVHPKDTmghW3nCAoW59lCBjTvFXEgq58aQFVL/njcb0E8tPawVrddxJmrrL+FNmLAm3zyZXlm2Jj++UN4bzYinjiLBPZTlQrmikZDeY95lyZXGHMW0NxkFRcVzk63ZRJgy+Y+YRKvP/workFtjEaox05YJ5p2/oo7rFTLITb25olXPHlQvNc7zq6o0hMeZNqLuCWUNIHaoBGZrGmV4x8sBWPoJOyB9k3FvO3lC5xjL0Vdf2ooHR+tOz6R2Zs8Ez6GltiosjjpHxsU/CFQMnMZkq30JCIStgfmep0ZzKVz5pxxIzm3eftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtpk3ooz2Yx7pfMcooSd/QDSvt/TRBhARH9NT+zNoNY=;
 b=Dkv505ppt0E43wmALMdD1MJfM8tM+bmnTP+5ou/DJ2fLg4cz+5HLYKEytqvZXpKfJvMC+4m56yWCxCffCO1sw75DINOXeYXkofq2nHAB16kpGoejkqsiJQ1FAE4P5khkplpxcxzrFNOzVq1AaEDb3BXtzGobihIF6SX8aULjKVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com (2603:1096:400:ae::14)
 by OS0PR01MB6484.jpnprd01.prod.outlook.com (2603:1096:604:105::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 14:11:17 +0000
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::b075:82de:46a:5318]) by TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::b075:82de:46a:5318%8]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 14:11:17 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net] ptp: idt82p33: use rsmu driver to access i2c/spi bus
Date:   Tue,  8 Mar 2022 09:10:51 -0500
Message-Id: <1646748651-16811-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:408:fb::31) To TYCPR01MB6608.jpnprd01.prod.outlook.com
 (2603:1096:400:ae::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e297aa9d-177c-4187-91b0-08da010d812a
X-MS-TrafficTypeDiagnostic: OS0PR01MB6484:EE_
X-Microsoft-Antispam-PRVS: <OS0PR01MB64847CC60C22189D0605F463BA099@OS0PR01MB6484.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgKPltVfYNvtMMaeQPfPNBwbahw+ojNNFIakFKaMOivu66lPZSmE5xnr1t0UYtrXp1wGczNsIPtVYt54YaHfpvlAlb9SdtgMA3wlqO1EFQEAr5HSbOh/jhSMNiJ6ImCcyaVjYLYWnFisGdaeEah7kuQ+4iDh9mW2OhIC7y5ceMCbufDZUzqHEdA59s5wpeHkrhiKEPL0jGn7zcd1ZocXbEfM21Muy8QdyBaJdUyf24d5TD9loTAWpPnFCaDS0mCe/FZx+D0csunIN3qrDhgQyx9UgYpHKGBE9efCN0a0RFZFI1qd5XowpwNduJoDAaGE+a39ukMmAkEsymtKn+iGc1al6QL+zJDTMmZ3kc9dmk8O6+GsjfzF8jpNSrFv8H1McOOnkXce0dcQGdKYMgw0s40CBuNz2p1WL8rJzxaZd9yDAxUlRotuEZRGvWuO6441t1IFVqUDe4a7hTEaYWkxZfu3qdCC9ehGGLqWdicR8T59RmTGZ0WTgcwPuRUMs+iSSsZfWbEFxN5xSTNWzSxZy0e86FLULofk86A2Pu7Tco8VPNZMjMljvNZ8lIfy9E7X3dCzdg98ch7gofbA8y4TbsuU10jdrB7Jp6W0UMu3one1PahJSbV0lFb7qD9bFo+kXL6ChoNJZszGeYqAsUKAEwFN9RpGrsmEZbS4GLy+jgJhFOAJRQSDrrIwIgulTMqAqyioOIODILbjD/PyEiMuqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6608.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66946007)(19627235002)(52116002)(6506007)(6666004)(6512007)(4326008)(66556008)(66476007)(316002)(508600001)(6486002)(26005)(38350700002)(38100700002)(186003)(2616005)(83380400001)(107886003)(2906002)(8936002)(30864003)(36756003)(5660300002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uu2zGAnkZd8CSJBEqvLJP4iJWoVX5p2jabq1lDxQJBqYZ3UCrVkuR2ac6JAg?=
 =?us-ascii?Q?oV6M8U7QBybm/U1GF8BheRbGPpRekeNGQsWUcYV1a9/VjTtgrhjWbfspwvAU?=
 =?us-ascii?Q?B5JZJlbIdb9tpT8wI2hPH0KLYUIDn0EfDL14ulH7KgY/NLjXzoci4rBknwSk?=
 =?us-ascii?Q?QY8CtVKfSN2P6qEQQO3ebVtqnS7QR19IdwB4fp+nY50LnDChiiZ+rNoMAmAL?=
 =?us-ascii?Q?SbpJ2n8MiHrVMTXPVIWjVtBBjy2n3ptGJ/OvAVeWPzFMWAdBA+r7NkMiAW4a?=
 =?us-ascii?Q?xGb1AjM/5w8RtT872K/yijBW2Uk6U5mQIesBKM+w094pP33RmtQLmpExMAU2?=
 =?us-ascii?Q?k51xpK5DB0TS/QaM0tEZa5ivNqZfa626sBvHezn18Cp92OwpwInGvU0b93Cu?=
 =?us-ascii?Q?/kETOXuHjaN9+Rmshg2eyvX+UUoJV9Z4Cl/r1PSWwL/1Y9HiNzqiq7GRVMRU?=
 =?us-ascii?Q?TObcq1GOpWQKrhRDevvYqRcuku1En3K8vfM+ni/VeJ+Yrb6RecNuXX0BTleQ?=
 =?us-ascii?Q?zJmzaEpk8XCJIhDPVOFdqY/gSCNbsZMYSYUTJOG5a+5ay6B1zPGCT85jw94n?=
 =?us-ascii?Q?Z3IoZ5fes7wX+ddUakbzdJYixvFgK5kvQl2zRGzFa2r7u8xwiX2BTvWAj3Bg?=
 =?us-ascii?Q?eKqI747gNNyd1S63yip1VDHiqitL1+UKAOMIDeaLRK0nrWe4L1+3X+ZyuG4N?=
 =?us-ascii?Q?bdoNK+GFU7iY00mSKVzRqbwJaxrI1X2t515ZRrhTIZaw0Yz8T+IB0sCZ4vVx?=
 =?us-ascii?Q?YLim4myTCmTszWyfCFdLOLobQoSane0By7ahtxM/WYQuZ67JUIrkYOV7Ue7U?=
 =?us-ascii?Q?brBohfqu+xdT2j7crrDHGblqpAKWdCm8AE5v5jWK2S9eJ7pWb7tFvqWTLjBZ?=
 =?us-ascii?Q?DbHm7EgYwwjeZHQHxJDb7YGa9EoNB8qN0tKOCsxafQOueRWT5rwssVpD/yb3?=
 =?us-ascii?Q?+h14Sljz2ECE2aQD8NvTfbVYetfsOCqCIpQWrthVWdYdyuQndtUtudTd8pnA?=
 =?us-ascii?Q?NjAwseQbTno9R9MpVmeurw40Oc7fkH/DXxM/3bgJPubcjpROGZHj7VtBVDHk?=
 =?us-ascii?Q?bzOY6Tj7zPIM6nXxU6kWVatndO1gGxQdHLzuwKwqUY+JdwwQy92HAy+Nwym9?=
 =?us-ascii?Q?/kIK6kZZnyq5VTZ6uolYUJwv6VemN/XWTPTigjHXiF+GVGNLnPOnhbHR0YXo?=
 =?us-ascii?Q?fal7ji7XolEGPZBr1mqwR2bXFoBSCdekEjjDCzunMPLg8Y2WZkYVqWCHsNFu?=
 =?us-ascii?Q?rDU/DXmK/jjegFZRLE5loza1CSQij/XwcDodUpiPk27O3BtwmE17xfT8A0js?=
 =?us-ascii?Q?Vl5US27gXJb8+ivvZBY/2U+dBvUWZvxhUd6Zd2csrUTqyiA4v2VtaJFX/fz3?=
 =?us-ascii?Q?fhERS53O0YnH07mysShOlsdNUgCpyNSCBfhDNYbPxWDOUPC+0Mq+g0YlnByz?=
 =?us-ascii?Q?HyL/isJFe+7s6pcNMdnx9aLQ/y0zh4YWsfRKaoKZzvkk24T5LdQY9lwlUOzK?=
 =?us-ascii?Q?HSL+3+AZUBkUpxyll/fWNoCfaAmkLCu+q5+vgPRPJtAnN30wmsUg5WG6/5Sh?=
 =?us-ascii?Q?tpXYbbqlUSPvdGd4V3gv8qBtN8ngNQKk/JnJnkjf+iLHtZ2UbJpw2kOcuWXP?=
 =?us-ascii?Q?bmdt3lXoTN9+Wq1SdIFA2BQ=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e297aa9d-177c-4187-91b0-08da010d812a
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6608.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 14:11:17.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lca7PuIOEvnfgrIgjrzn7fVad7uubohVWdgVlOjX+XURApJd7yjw4njw+stH6ng9idZ6Up1FdWA5BEXD37g4vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6484
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rsmu (Renesas Synchronization Management Unit ) driver is located in
drivers/mfd and responsible for creating multiple devices including
idt82p33 phc, which will then use the exposed regmap and mutex
handle to access i2c/spi bus.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c       | 344 ++++++++++-----------------------------
 drivers/ptp/ptp_idt82p33.h       | 151 +++++------------
 include/linux/mfd/idt82p33_reg.h |   3 +
 3 files changed, 129 insertions(+), 369 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index c1c959f..97c1be4 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -6,13 +6,17 @@
 #define pr_fmt(fmt) "IDT_82p33xxx: " fmt
 
 #include <linux/firmware.h>
-#include <linux/i2c.h>
+#include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/timekeeping.h>
 #include <linux/bitops.h>
+#include <linux/of.h>
+#include <linux/mfd/rsmu.h>
+#include <linux/mfd/idt82p33_reg.h>
 
 #include "ptp_private.h"
 #include "ptp_idt82p33.h"
@@ -24,15 +28,25 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILENAME);
 
 /* Module Parameters */
-static u32 sync_tod_timeout = SYNC_TOD_TIMEOUT_SEC;
-module_param(sync_tod_timeout, uint, 0);
-MODULE_PARM_DESC(sync_tod_timeout,
-"duration in second to keep SYNC_TOD on (set to 0 to keep it always on)");
-
 static u32 phase_snap_threshold = SNAP_THRESHOLD_NS;
 module_param(phase_snap_threshold, uint, 0);
 MODULE_PARM_DESC(phase_snap_threshold,
-"threshold (150000ns by default) below which adjtime would ignore");
+"threshold (10000ns by default) below which adjtime would use double dco");
+
+static char *firmware;
+module_param(firmware, charp, 0);
+
+static inline int idt82p33_read(struct idt82p33 *idt82p33, u16 regaddr,
+				u8 *buf, u16 count)
+{
+	return regmap_bulk_read(idt82p33->regmap, regaddr, buf, count);
+}
+
+static inline int idt82p33_write(struct idt82p33 *idt82p33, u16 regaddr,
+				 u8 *buf, u16 count)
+{
+	return regmap_bulk_write(idt82p33->regmap, regaddr, buf, count);
+}
 
 static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
 					    u8 buf[TOD_BYTE_COUNT])
@@ -78,110 +92,6 @@ static void idt82p33_timespec_to_byte_array(struct timespec64 const *ts,
 	}
 }
 
-static int idt82p33_xfer_read(struct idt82p33 *idt82p33,
-			      unsigned char regaddr,
-			      unsigned char *buf,
-			      unsigned int count)
-{
-	struct i2c_client *client = idt82p33->client;
-	struct i2c_msg msg[2];
-	int cnt;
-
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = &regaddr;
-
-	msg[1].addr = client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = count;
-	msg[1].buf = buf;
-
-	cnt = i2c_transfer(client->adapter, msg, 2);
-	if (cnt < 0) {
-		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
-		return cnt;
-	} else if (cnt != 2) {
-		dev_err(&client->dev,
-			"i2c_transfer sent only %d of %d messages\n", cnt, 2);
-		return -EIO;
-	}
-	return 0;
-}
-
-static int idt82p33_xfer_write(struct idt82p33 *idt82p33,
-			       u8 regaddr,
-			       u8 *buf,
-			       u16 count)
-{
-	struct i2c_client *client = idt82p33->client;
-	/* we add 1 byte for device register */
-	u8 msg[IDT82P33_MAX_WRITE_COUNT + 1];
-	int err;
-
-	if (count > IDT82P33_MAX_WRITE_COUNT)
-		return -EINVAL;
-
-	msg[0] = regaddr;
-	memcpy(&msg[1], buf, count);
-
-	err = i2c_master_send(client, msg, count + 1);
-	if (err < 0) {
-		dev_err(&client->dev, "i2c_master_send returned %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
-static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
-{
-	int err;
-
-	if (idt82p33->page_offset == val)
-		return 0;
-
-	err = idt82p33_xfer_write(idt82p33, PAGE_ADDR, &val, sizeof(val));
-	if (err)
-		dev_err(&idt82p33->client->dev,
-			"failed to set page offset %d\n", val);
-	else
-		idt82p33->page_offset = val;
-
-	return err;
-}
-
-static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
-			 unsigned char *buf, unsigned int count, bool write)
-{
-	u8 offset, page;
-	int err;
-
-	page = _PAGE(regaddr);
-	offset = _OFFSET(regaddr);
-
-	err = idt82p33_page_offset(idt82p33, page);
-	if (err)
-		return err;
-
-	if (write)
-		return idt82p33_xfer_write(idt82p33, offset, buf, count);
-
-	return idt82p33_xfer_read(idt82p33, offset, buf, count);
-}
-
-static int idt82p33_read(struct idt82p33 *idt82p33, unsigned int regaddr,
-			unsigned char *buf, unsigned int count)
-{
-	return idt82p33_rdwr(idt82p33, regaddr, buf, count, false);
-}
-
-static int idt82p33_write(struct idt82p33 *idt82p33, unsigned int regaddr,
-			unsigned char *buf, unsigned int count)
-{
-	return idt82p33_rdwr(idt82p33, regaddr, buf, count, true);
-}
-
 static int idt82p33_dpll_set_mode(struct idt82p33_channel *channel,
 				  enum pll_mode mode)
 {
@@ -206,7 +116,7 @@ static int idt82p33_dpll_set_mode(struct idt82p33_channel *channel,
 	if (err)
 		return err;
 
-	channel->pll_mode = dpll_mode;
+	channel->pll_mode = mode;
 
 	return 0;
 }
@@ -467,7 +377,7 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 	err = idt82p33_measure_settime_gettime_gap_overhead(channel, &gap_ns);
 
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
 		return err;
 	}
@@ -499,8 +409,8 @@ static int idt82p33_check_and_set_masks(struct idt82p33 *idt82p33,
 
 	if (page == PLLMASK_ADDR_HI && offset == PLLMASK_ADDR_LO) {
 		if ((val & 0xfc) || !(val & 0x3)) {
-			dev_err(&idt82p33->client->dev,
-				"Invalid PLL mask 0x%hhx\n", val);
+			dev_err(idt82p33->dev,
+				"Invalid PLL mask 0x%x\n", val);
 			err = -EINVAL;
 		} else {
 			idt82p33->pll_mask = val;
@@ -520,14 +430,14 @@ static void idt82p33_display_masks(struct idt82p33 *idt82p33)
 {
 	u8 mask, i;
 
-	dev_info(&idt82p33->client->dev,
+	dev_info(idt82p33->dev,
 		 "pllmask = 0x%02x\n", idt82p33->pll_mask);
 
 	for (i = 0; i < MAX_PHC_PLL; i++) {
 		mask = 1 << i;
 
 		if (mask & idt82p33->pll_mask)
-			dev_info(&idt82p33->client->dev,
+			dev_info(idt82p33->dev,
 				 "PLL%d output_mask = 0x%04x\n",
 				 i, idt82p33->channel[i].output_mask);
 	}
@@ -539,11 +449,6 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	u8 sync_cnfg;
 	int err;
 
-	/* Turn it off after sync_tod_timeout seconds */
-	if (enable && sync_tod_timeout)
-		ptp_schedule_worker(channel->ptp_clock,
-				    sync_tod_timeout * HZ);
-
 	err = idt82p33_read(idt82p33, channel->dpll_sync_cnfg,
 			    &sync_cnfg, sizeof(sync_cnfg));
 	if (err)
@@ -557,22 +462,6 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 			      &sync_cnfg, sizeof(sync_cnfg));
 }
 
-static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
-{
-	struct idt82p33_channel *channel =
-			container_of(ptp, struct idt82p33_channel, caps);
-	struct idt82p33 *idt82p33 = channel->idt82p33;
-
-	mutex_lock(&idt82p33->reg_lock);
-
-	(void)idt82p33_sync_tod(channel, false);
-
-	mutex_unlock(&idt82p33->reg_lock);
-
-	/* Return a negative value here to not reschedule */
-	return -1;
-}
-
 static int idt82p33_output_enable(struct idt82p33_channel *channel,
 				  bool enable, unsigned int outn)
 {
@@ -634,18 +523,11 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	struct timespec64 ts = {0, 0};
 	int err;
-	u8 val;
-
-	val = 0;
-	err = idt82p33_write(idt82p33, channel->dpll_input_mode_cnfg,
-			     &val, sizeof(val));
-	if (err)
-		return err;
 
 	err = idt82p33_measure_tod_write_overhead(channel);
 
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
 		return err;
 	}
@@ -673,16 +555,14 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 }
 
 static int idt82p33_enable(struct ptp_clock_info *ptp,
-			 struct ptp_clock_request *rq, int on)
+			   struct ptp_clock_request *rq, int on)
 {
 	struct idt82p33_channel *channel =
 			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	int err;
-
-	err = -EOPNOTSUPP;
+	int err = -EOPNOTSUPP;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 
 	if (rq->type == PTP_CLK_REQ_PEROUT) {
 		if (!on)
@@ -690,15 +570,18 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 						     &rq->perout);
 		/* Only accept a 1-PPS aligned to the second. */
 		else if (rq->perout.start.nsec || rq->perout.period.sec != 1 ||
-		    rq->perout.period.nsec) {
+			 rq->perout.period.nsec)
 			err = -ERANGE;
-		} else
+		else
 			err = idt82p33_perout_enable(channel, true,
 						     &rq->perout);
 	}
 
-	mutex_unlock(&idt82p33->reg_lock);
+	mutex_unlock(idt82p33->lock);
 
+	if (err)
+		dev_err(idt82p33->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	return err;
 }
 
@@ -727,11 +610,11 @@ static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offset_ns)
 	val[3] = (offset_regval >> 24) & 0x1F;
 	val[3] |= PH_OFFSET_EN;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 
 	err = idt82p33_dpll_set_mode(channel, PLL_MODE_WPH);
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
 		goto out;
 	}
@@ -740,7 +623,7 @@ static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offset_ns)
 			     sizeof(val));
 
 out:
-	mutex_unlock(&idt82p33->reg_lock);
+	mutex_unlock(idt82p33->lock);
 	return err;
 }
 
@@ -751,12 +634,12 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	mutex_unlock(idt82p33->lock);
 	if (err)
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
 }
@@ -768,29 +651,20 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 
 	if (abs(delta_ns) < phase_snap_threshold) {
-		mutex_unlock(&idt82p33->reg_lock);
+		mutex_unlock(idt82p33->lock);
 		return 0;
 	}
 
 	err = _idt82p33_adjtime(channel, delta_ns);
 
-	if (err) {
-		mutex_unlock(&idt82p33->reg_lock);
-		dev_err(&idt82p33->client->dev,
-			"Adjtime failed in %s with err %d!\n", __func__, err);
-		return err;
-	}
+	mutex_unlock(idt82p33->lock);
 
-	err = idt82p33_sync_tod(channel, true);
 	if (err)
-		dev_err(&idt82p33->client->dev,
-			"Sync_tod failed in %s with err %d!\n", __func__, err);
-
-	mutex_unlock(&idt82p33->reg_lock);
-
+		dev_err(idt82p33->dev,
+			"Failed in %s with err %d!\n", __func__, err);
 	return err;
 }
 
@@ -801,31 +675,31 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 	err = _idt82p33_gettime(channel, ts);
+	mutex_unlock(idt82p33->lock);
+
 	if (err)
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
-
 	return err;
 }
 
 static int idt82p33_settime(struct ptp_clock_info *ptp,
-			const struct timespec64 *ts)
+			    const struct timespec64 *ts)
 {
 	struct idt82p33_channel *channel =
 			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 	err = _idt82p33_settime(channel, ts);
+	mutex_unlock(idt82p33->lock);
+
 	if (err)
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-	mutex_unlock(&idt82p33->reg_lock);
-
 	return err;
 }
 
@@ -864,7 +738,7 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 static void idt82p33_caps_init(struct ptp_clock_info *caps)
 {
 	caps->owner = THIS_MODULE;
-	caps->max_adj = 92000;
+	caps->max_adj = DCO_MAX_PPB;
 	caps->n_per_out = 11;
 	caps->adjphase = idt82p33_adjwritephase;
 	caps->adjfine = idt82p33_adjfine;
@@ -872,7 +746,6 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
-	caps->do_aux_work = idt82p33_sync_tod_work_handler;
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
@@ -887,7 +760,7 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 	err = idt82p33_channel_init(channel, index);
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Channel_init failed in %s with err %d!\n",
 			__func__, err);
 		return err;
@@ -912,7 +785,7 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Dpll_set_mode failed in %s with err %d!\n",
 			__func__, err);
 		return err;
@@ -920,13 +793,13 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 	err = idt82p33_enable_tod(channel);
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Enable_tod failed in %s with err %d!\n",
 			__func__, err);
 		return err;
 	}
 
-	dev_info(&idt82p33->client->dev, "PLL%d registered as ptp%d\n",
+	dev_info(idt82p33->dev, "PLL%d registered as ptp%d\n",
 		 index, channel->ptp_clock->index);
 
 	return 0;
@@ -940,25 +813,24 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 	int err;
 	s32 len;
 
-	dev_dbg(&idt82p33->client->dev,
-		"requesting firmware '%s'\n", FW_FILENAME);
+	dev_dbg(idt82p33->dev, "requesting firmware '%s'\n", FW_FILENAME);
 
-	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
+	err = request_firmware(&fw, FW_FILENAME, idt82p33->dev);
 
 	if (err) {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
 		return err;
 	}
 
-	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
+	dev_dbg(idt82p33->dev, "firmware size %zu bytes\n", fw->size);
 
 	rec = (struct idt82p33_fwrc *) fw->data;
 
 	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
 
 		if (rec->reserved) {
-			dev_err(&idt82p33->client->dev,
+			dev_err(idt82p33->dev,
 				"bad firmware, reserved field non-zero\n");
 			err = -EINVAL;
 		} else {
@@ -973,16 +845,11 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 		}
 
 		if (err == 0) {
-			/* maximum 8 pages  */
-			if (page >= PAGE_NUM)
-				continue;
-
 			/* Page size 128, last 4 bytes of page skipped */
-			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
-			     || loaddr > 0xfb)
+			if (loaddr > 0x7b)
 				continue;
 
-			err = idt82p33_write(idt82p33, _ADDR(page, loaddr),
+			err = idt82p33_write(idt82p33, REG_ADDR(page, loaddr),
 					     &val, sizeof(val));
 		}
 
@@ -997,36 +864,34 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 }
 
 
-static int idt82p33_probe(struct i2c_client *client,
-			  const struct i2c_device_id *id)
+static int idt82p33_probe(struct platform_device *pdev)
 {
+	struct rsmu_ddata *ddata = dev_get_drvdata(pdev->dev.parent);
 	struct idt82p33 *idt82p33;
 	int err;
 	u8 i;
 
-	(void)id;
-
-	idt82p33 = devm_kzalloc(&client->dev,
+	idt82p33 = devm_kzalloc(&pdev->dev,
 				sizeof(struct idt82p33), GFP_KERNEL);
 	if (!idt82p33)
 		return -ENOMEM;
 
-	mutex_init(&idt82p33->reg_lock);
-
-	idt82p33->client = client;
-	idt82p33->page_offset = 0xff;
+	idt82p33->dev = &pdev->dev;
+	idt82p33->mfd = pdev->dev.parent;
+	idt82p33->lock = &ddata->lock;
+	idt82p33->regmap = ddata->regmap;
 	idt82p33->tod_write_overhead_ns = 0;
 	idt82p33->calculate_overhead_flag = 0;
 	idt82p33->pll_mask = DEFAULT_PLL_MASK;
 	idt82p33->channel[0].output_mask = DEFAULT_OUTPUT_MASK_PLL0;
 	idt82p33->channel[1].output_mask = DEFAULT_OUTPUT_MASK_PLL1;
 
-	mutex_lock(&idt82p33->reg_lock);
+	mutex_lock(idt82p33->lock);
 
 	err = idt82p33_load_firmware(idt82p33);
 
 	if (err)
-		dev_warn(&idt82p33->client->dev,
+		dev_warn(idt82p33->dev,
 			 "loading firmware failed with %d\n", err);
 
 	if (idt82p33->pll_mask) {
@@ -1034,7 +899,7 @@ static int idt82p33_probe(struct i2c_client *client,
 			if (idt82p33->pll_mask & (1 << i)) {
 				err = idt82p33_enable_channel(idt82p33, i);
 				if (err) {
-					dev_err(&idt82p33->client->dev,
+					dev_err(idt82p33->dev,
 						"Failed in %s with err %d!\n",
 						__func__, err);
 					break;
@@ -1042,69 +907,38 @@ static int idt82p33_probe(struct i2c_client *client,
 			}
 		}
 	} else {
-		dev_err(&idt82p33->client->dev,
+		dev_err(idt82p33->dev,
 			"no PLLs flagged as PHCs, nothing to do\n");
 		err = -ENODEV;
 	}
 
-	mutex_unlock(&idt82p33->reg_lock);
+	mutex_unlock(idt82p33->lock);
 
 	if (err) {
 		idt82p33_ptp_clock_unregister_all(idt82p33);
 		return err;
 	}
 
-	i2c_set_clientdata(client, idt82p33);
+	platform_set_drvdata(pdev, idt82p33);
 
 	return 0;
 }
 
-static int idt82p33_remove(struct i2c_client *client)
+static int idt82p33_remove(struct platform_device *pdev)
 {
-	struct idt82p33 *idt82p33 = i2c_get_clientdata(client);
+	struct idt82p33 *idt82p33 = platform_get_drvdata(pdev);
 
 	idt82p33_ptp_clock_unregister_all(idt82p33);
-	mutex_destroy(&idt82p33->reg_lock);
 
 	return 0;
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id idt82p33_dt_id[] = {
-	{ .compatible = "idt,82p33810" },
-	{ .compatible = "idt,82p33813" },
-	{ .compatible = "idt,82p33814" },
-	{ .compatible = "idt,82p33831" },
-	{ .compatible = "idt,82p33910" },
-	{ .compatible = "idt,82p33913" },
-	{ .compatible = "idt,82p33914" },
-	{ .compatible = "idt,82p33931" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, idt82p33_dt_id);
-#endif
-
-static const struct i2c_device_id idt82p33_i2c_id[] = {
-	{ "idt82p33810", },
-	{ "idt82p33813", },
-	{ "idt82p33814", },
-	{ "idt82p33831", },
-	{ "idt82p33910", },
-	{ "idt82p33913", },
-	{ "idt82p33914", },
-	{ "idt82p33931", },
-	{},
-};
-MODULE_DEVICE_TABLE(i2c, idt82p33_i2c_id);
-
-static struct i2c_driver idt82p33_driver = {
+static struct platform_driver idt82p33_driver = {
 	.driver = {
-		.of_match_table	= of_match_ptr(idt82p33_dt_id),
-		.name		= "idt82p33",
+		.name = "82p33x1x-phc",
 	},
-	.probe		= idt82p33_probe,
-	.remove		= idt82p33_remove,
-	.id_table	= idt82p33_i2c_id,
+	.probe = idt82p33_probe,
+	.remove	= idt82p33_remove,
 };
 
-module_i2c_driver(idt82p33_driver);
+module_platform_driver(idt82p33_driver);
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 1c7a0f0..0ea1c35 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -8,94 +8,19 @@
 #define PTP_IDT82P33_H
 
 #include <linux/ktime.h>
-#include <linux/workqueue.h>
+#include <linux/mfd/idt82p33_reg.h>
+#include <linux/regmap.h>
 
-
-/* Register Map - AN888_SMUforIEEE_SynchEther_82P33xxx_RevH.pdf */
-#define PAGE_NUM (8)
-#define _ADDR(page, offset) (((page) << 0x7) | ((offset) & 0x7f))
-#define _PAGE(addr) (((addr) >> 0x7) & 0x7)
-#define _OFFSET(addr)  ((addr) & 0x7f)
-
-#define DPLL1_TOD_CNFG 0x134
-#define DPLL2_TOD_CNFG 0x1B4
-
-#define DPLL1_TOD_STS 0x10B
-#define DPLL2_TOD_STS 0x18B
-
-#define DPLL1_TOD_TRIGGER 0x115
-#define DPLL2_TOD_TRIGGER 0x195
-
-#define DPLL1_OPERATING_MODE_CNFG 0x120
-#define DPLL2_OPERATING_MODE_CNFG 0x1A0
-
-#define DPLL1_HOLDOVER_FREQ_CNFG 0x12C
-#define DPLL2_HOLDOVER_FREQ_CNFG 0x1AC
-
-#define DPLL1_PHASE_OFFSET_CNFG 0x143
-#define DPLL2_PHASE_OFFSET_CNFG 0x1C3
-
-#define DPLL1_SYNC_EDGE_CNFG 0X140
-#define DPLL2_SYNC_EDGE_CNFG 0X1C0
-
-#define DPLL1_INPUT_MODE_CNFG 0X116
-#define DPLL2_INPUT_MODE_CNFG 0X196
-
-#define OUT_MUX_CNFG(outn) _ADDR(0x6, (0xC * (outn)))
-
-#define PAGE_ADDR 0x7F
-/* Register Map end */
-
-/* Register definitions - AN888_SMUforIEEE_SynchEther_82P33xxx_RevH.pdf*/
-#define TOD_TRIGGER(wr_trig, rd_trig) ((wr_trig & 0xf) << 4 | (rd_trig & 0xf))
-#define SYNC_TOD BIT(1)
-#define PH_OFFSET_EN BIT(7)
-#define SQUELCH_ENABLE BIT(5)
-
-/* Bit definitions for the DPLL_MODE register */
-#define PLL_MODE_SHIFT                    (0)
-#define PLL_MODE_MASK                     (0x1F)
-
-#define PEROUT_ENABLE_OUTPUT_MASK         (0xdeadbeef)
-
-enum pll_mode {
-	PLL_MODE_MIN = 0,
-	PLL_MODE_AUTOMATIC = PLL_MODE_MIN,
-	PLL_MODE_FORCE_FREERUN = 1,
-	PLL_MODE_FORCE_HOLDOVER = 2,
-	PLL_MODE_FORCE_LOCKED = 4,
-	PLL_MODE_FORCE_PRE_LOCKED2 = 5,
-	PLL_MODE_FORCE_PRE_LOCKED = 6,
-	PLL_MODE_FORCE_LOST_PHASE = 7,
-	PLL_MODE_DCO = 10,
-	PLL_MODE_WPH = 18,
-	PLL_MODE_MAX = PLL_MODE_WPH,
-};
-
-enum hw_tod_trig_sel {
-	HW_TOD_TRIG_SEL_MIN = 0,
-	HW_TOD_TRIG_SEL_NO_WRITE = HW_TOD_TRIG_SEL_MIN,
-	HW_TOD_TRIG_SEL_SYNC_SEL = 1,
-	HW_TOD_TRIG_SEL_IN12 = 2,
-	HW_TOD_TRIG_SEL_IN13 = 3,
-	HW_TOD_TRIG_SEL_IN14 = 4,
-	HW_TOD_TRIG_SEL_TOD_PPS = 5,
-	HW_TOD_TRIG_SEL_TIMER_INTERVAL = 6,
-	HW_TOD_TRIG_SEL_MSB_PHASE_OFFSET_CNFG = 7,
-	HW_TOD_TRIG_SEL_MSB_HOLDOVER_FREQ_CNFG = 8,
-	HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG = 9,
-	HW_TOD_RD_TRIG_SEL_LSB_TOD_STS = HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-	WR_TRIG_SEL_MAX = HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-};
-
-/* Register bit definitions end */
 #define FW_FILENAME	"idt82p33xxx.bin"
-#define MAX_PHC_PLL (2)
-#define TOD_BYTE_COUNT (10)
-#define MAX_MEASURMENT_COUNT (5)
-#define SNAP_THRESHOLD_NS (150000)
-#define SYNC_TOD_TIMEOUT_SEC (5)
-#define IDT82P33_MAX_WRITE_COUNT (512)
+#define MAX_PHC_PLL	(2)
+#define TOD_BYTE_COUNT	(10)
+#define DCO_MAX_PPB     (92000)
+#define MAX_MEASURMENT_COUNT	(5)
+#define SNAP_THRESHOLD_NS	(10000)
+#define IMMEDIATE_SNAP_THRESHOLD_NS (50000)
+#define DDCO_THRESHOLD_NS	(5)
+#define IDT82P33_MAX_WRITE_COUNT	(512)
+#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
 #define PLLMASK_ADDR_HI	0xFF
 #define PLLMASK_ADDR_LO	0xA5
@@ -116,15 +41,25 @@ enum hw_tod_trig_sel {
 #define DEFAULT_OUTPUT_MASK_PLL0	(0xc0)
 #define DEFAULT_OUTPUT_MASK_PLL1	DEFAULT_OUTPUT_MASK_PLL0
 
+/**
+ * @brief Maximum absolute value for write phase offset in femtoseconds
+ */
+#define WRITE_PHASE_OFFSET_LIMIT (20000052084ll)
+
+/** @brief Phase offset resolution
+ *
+ *  DPLL phase offset = 10^15 fs / ( System Clock  * 2^13)
+ *                    = 10^15 fs / ( 1638400000 * 2^23)
+ *                    = 74.5058059692382 fs
+ */
+#define IDT_T0DPLL_PHASE_RESOL 74506
+
 /* PTP Hardware Clock interface */
 struct idt82p33_channel {
 	struct ptp_clock_info	caps;
 	struct ptp_clock	*ptp_clock;
-	struct idt82p33	*idt82p33;
-	enum pll_mode	pll_mode;
-	/* task to turn off SYNC_TOD bit after pps sync */
-	struct delayed_work	sync_tod_work;
-	bool			sync_tod_on;
+	struct idt82p33		*idt82p33;
+	enum pll_mode		pll_mode;
 	s32			current_freq_ppb;
 	u8			output_mask;
 	u16			dpll_tod_cnfg;
@@ -138,15 +73,17 @@ struct idt82p33_channel {
 };
 
 struct idt82p33 {
-	struct idt82p33_channel channel[MAX_PHC_PLL];
-	struct i2c_client	*client;
-	u8	page_offset;
-	u8	pll_mask;
-	ktime_t start_time;
-	int calculate_overhead_flag;
-	s64 tod_write_overhead_ns;
-	/* Protects I2C read/modify/write registers from concurrent access */
-	struct mutex	reg_lock;
+	struct idt82p33_channel	channel[MAX_PHC_PLL];
+	struct device		*dev;
+	u8			pll_mask;
+	/* Mutex to protect operations from being interrupted */
+	struct mutex		*lock;
+	struct regmap		*regmap;
+	struct device		*mfd;
+	/* Overhead calculation for adjtime */
+	ktime_t			start_time;
+	int			calculate_overhead_flag;
+	s64			tod_write_overhead_ns;
 };
 
 /* firmware interface */
@@ -157,18 +94,4 @@ struct idt82p33_fwrc {
 	u8 reserved;
 } __packed;
 
-/**
- * @brief Maximum absolute value for write phase offset in femtoseconds
- */
-#define WRITE_PHASE_OFFSET_LIMIT (20000052084ll)
-
-/** @brief Phase offset resolution
- *
- *  DPLL phase offset = 10^15 fs / ( System Clock  * 2^13)
- *                    = 10^15 fs / ( 1638400000 * 2^23)
- *                    = 74.5058059692382 fs
- */
-#define IDT_T0DPLL_PHASE_RESOL 74506
-
-
 #endif /* PTP_IDT82P33_H */
diff --git a/include/linux/mfd/idt82p33_reg.h b/include/linux/mfd/idt82p33_reg.h
index 129a6c0..1db532f 100644
--- a/include/linux/mfd/idt82p33_reg.h
+++ b/include/linux/mfd/idt82p33_reg.h
@@ -7,6 +7,8 @@
 #ifndef HAVE_IDT82P33_REG
 #define HAVE_IDT82P33_REG
 
+#define REG_ADDR(page, offset) (((page) << 0x7) | ((offset) & 0x7f))
+
 /* Register address */
 #define DPLL1_TOD_CNFG 0x134
 #define DPLL2_TOD_CNFG 0x1B4
@@ -41,6 +43,7 @@
 #define REG_SOFT_RESET 0X381
 
 #define OUT_MUX_CNFG(outn) REG_ADDR(0x6, (0xC * (outn)))
+#define TOD_TRIGGER(wr_trig, rd_trig) ((wr_trig & 0xf) << 4 | (rd_trig & 0xf))
 
 /* Register bit definitions */
 #define SYNC_TOD BIT(1)
-- 
2.7.4

