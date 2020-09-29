Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04D327DC04
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgI2W2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:52 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpbzZI2Tan34mQ3g4w4aIAzKCM1/cWo5YRBZEvprLNNr+UFekJr2cc6FMMG7fO9ZY33bWIKZnJl8waMryDQaSG9Ham15USLp7vmO2sciVjnx5Aa3cLHaQBXU1TiLmcuFUL3v3+GgQYTdTKuGWTVtOEMBjrgr/8nYOXO/Bx2tgNxEdHHDdan8wR8cm6qxm0veMzA2/EpJd8ChqUoDpHh0U0OH0+Yk1UVwDee1/8es9kmfg2jNV66ulo8NIDDEQ2sb9l3/M5JI41OM5INNnJzZdRz6GYDwWlcOzrS6k3G5agPkf+YMZrsNiCXKbAEizdqgKPo92VHuKxhCDyXNg18VEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHptCFTyhgjbQwp448YaXz8r3CESC/SHyEf0nqzbjpA=;
 b=EkWvDUUxsllCongbQ4gcuvIKJEaDZPkOxS6pbcOzkefvfSYz4nXNKCJhNpK/D4WpLkEPcZT3Dp1FEWKxa9c6bdjlz8P0FGZQ2jLv7Bwc3t6NtKhoyrOEFx/70i+D63iIhZyWbhbKMT7ev8fxTWYxb/KRuxQmHkKYL31IFO8t1CsmTlnG0mb4x41ohLMm9fzfppIFqQfMcUUedfxwm15BLdzRcKkWl0VnErovhy/U/2GMgWiTOL1nzfgWgL6JIP/qavk0O08M101g3pdsAwtE1ZNJmmLWV0zAR8ar5seKR5Vdw1yqci+d5S8WQenxqRxjeC1fa2vB+7uB3lOMycpwcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHptCFTyhgjbQwp448YaXz8r3CESC/SHyEf0nqzbjpA=;
 b=IUiwVsgVMhZFh2ccV+ec9zz9zlLQKRrQP+Zir21CeZccjJWEFZytq5zsK4RxmcexpVxm2m8h1R8TqpTsewyc9BcXsfU23X8OLWQnT7GqUc9q6qyxw4QKdnZzzZAY0vRAWP/dAGGnHXMHbzfKxS0V11HqO4GUCM8X2hIsqCjXTJE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:10 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 09/13] net: mscc: ocelot: calculate vcap offsets correctly for full and quarter entries
Date:   Wed, 30 Sep 2020 01:27:29 +0300
Message-Id: <20200929222733.770926-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0677676d-d25e-43ba-c066-08d864c6f1f8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797BFB239C0E2D944B8BEE5E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1qj6AV95/3Uoeg7U5mDYQw3aqIsdGVGi0i1qZx7C3qZa/WJGm621qtR3LN1pnD7tje8XCW+DdGS59GguJhmCRt8JpL4BkpyYxaGMKScjw543rnxPUYG5BFUOtQKSmE7EHzbrUCJEi7MO0boO0r+cVFB8JYJaksud4vsufiwxxCjdO9hkE2EnmAgZowY6DUeJhhFebhn7rtTcBUqDZBuxfy5fRQjTvIxBMY26/x05aDwV8FWQbpWFHKt3NLn9ZKy+5LlcpADe5slorOCyOdM7eGNx6yL99xGNx3InGPCx3RBNqG1N5YUqErYNx3vWrGTxn2AdhjUQXYRRapsNVkZSaVIyZHAGM1yYb5BIkKOgulVMP1pVAOZoxdc7j90/So4pxmeHn/1LJ4991bHliztDqTNm6cXflWse3OK400FZThnRNlUl4SRUV23+8GOT9EK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fhqLCIsrPEU3hsQb5Zz8NV0h4lwsABAUEsoMRUCpkToo0NtUZB3+DFE0+b0UNk1oeFtOgknJHxMklNovXh1ogC1GyS5JcmABD9etw6cQZyiHE+lxxUY2Me1iQMk/gfH766pil8rBs3w6jXYHxm9FNwXrb4Uw6n6x61tNSJapegIzKIFRq07TAfjs7OCjYY/8kqz0m3Ei+yxkD7dK/bVJMaHegIhMQB6TxA/5+f7q/lquhm3Xn7Nx1zR6dVamimmSyFViUGIJvuTljxXBXwd0fddzNAK+Kx7f4BI0WvAZxGvkHAQcCQ3gOx3mFYO2wCXzF3ljKTXFQbS3EDPBp/k9hmH4SpeFVU9W2MXfW31SLudY42bZ7FYkA3AHT3YpHmyzkrdfSTyoky6f3qzrgQL9D20M7oGrN5QhYljUlyoqbLIrBbOcuaLBr9B9krkhBHhqJfdFUZU20aHDSL8t7Zv6eosqAJWrlEy3x7GOnOta+6KUp/jwDRQbw01GiLx/iRdF9cA+8PQvhr64ynJPNkcWOCFxQxBn4StRpuNrNd635Dw3K2dOsxUVljRJvXp0nZRenSM1zLRsbPdBIetGVMN5RIzAFlbqhzc3Y663NWbG6CE0Z6zdz3ph74W7jxQdZMtlHp3hreMThEoA2gbJ67+gQw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0677676d-d25e-43ba-c066-08d864c6f1f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:10.1167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dLtq1RULQ50KJA3dgbcB7GAE/7CkI3R+CnV9PF5JoD+VnLPIofqVT/OHhVOUHkYr/GSf0qAiL3WAVV+JolYGUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

When calculating the offsets for the current entry within the row and
placing them inside struct vcap_data, the function assumes half key
entry (2 keys per row).

This patch modifies the vcap_data_offset_get() function to calculate a
correct data offset when the setting VCAP Type-Group of a key to
VCAP_TG_FULL or VCAP_TG_QUARTER.

This is needed because, for example, VCAP ES0 only supports full keys.

Also rename the 'count' variable to 'num_entries_per_row' to make the
function just one tiny bit easier to follow.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
Replaced the obscure 2 ^ n formula with something that is more obviously
correct.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index b736c3d3df2f..3f7d3fbaa1fc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -177,8 +177,21 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	int i, col, offset, count, cnt, base;
 	u32 width = vcap->tg_width;
 
-	count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
-	col = (ix % 2);
+	switch (data->tg_sw) {
+	case VCAP_TG_FULL:
+		count = 1;
+		break;
+	case VCAP_TG_HALF:
+		count = 2;
+		break;
+	case VCAP_TG_QUARTER:
+		count = 4;
+		break;
+	default:
+		return;
+	}
+
+	col = (ix % count);
 	cnt = (vcap->sw_count / count);
 	base = (vcap->sw_count - col * cnt - cnt);
 	data->tg_value = 0;
-- 
2.25.1

