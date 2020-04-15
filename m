Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5AC1AA053
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409184AbgDOMZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:25:35 -0400
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:30848
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393973AbgDOMZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 08:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoBb4XmZi0TbPLAWWPlw9Yy3V/rzB92a1gSPcy/JceQsr07zO02nhaFmPM/1ejukhOkjSMAV1alGXqQzciqIdEnWhMYd739eplyS21j6MIHo/N/oTS85iBYGdgWDu5s8TUeawS7Gef5HokB3Aitrz1IRM7UQ/k62VBQj1zRujaEbKaN2ORj07hlqVQhVUDJEHG0QqtnTp7dawugC63rA4AMGY6MKV2Id0mnagISiUk0OLwdvWpSghuPvdwRijv6sUIWx15ZkX6fuiKYwXryLjtWMGYCqn1SpTb+jygLN6JHLG21IwIIcKkUfyVrWfG2MjWSCu1cIOijaAZ2V6+vPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u06ZugPLeMVc6oKOGCt2khLEwe9xYqJWqqTI37CHEQU=;
 b=DhC9q8ox+/UuHEBw+eFlR+3Y6Kqvu1gfFoiNXuGlHUf3zmSq6Do8Fa7RAeF8tqoqDQmopM8x6plw9tQ2Y/u9oHhX4hbjZLqbrfx2RvCSxcAk/KBN7m5QMSdRj8mzgMIY0wmJOm4xDMJQ6tp8beTGdjouJ8wvPX7x4V2cQjxvVQVKFmWD3mlxNxP6+D1y9++dpRS1+2lF2FQn4ZcSVEv3S5dwa3owg+Zz9cnvwB/PeDMJ1oZ76nN5PRV4QSe5ahBIlpVBsPcu1t83ZGU1R8oPzMEDSzRHQLeKqwcfJEzrz5ZSEhDXRK5obeOnLYaMkz4woLLbdwXhzl+S5dG/TEU4RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u06ZugPLeMVc6oKOGCt2khLEwe9xYqJWqqTI37CHEQU=;
 b=KE0defP0uIiH8QV7Yl9ruRC11QVJs1A4CMwOaM2csKk3OqRa99HETMXLo+7Wds7Mv4xJhIAljsG9ju84fWbSDEf/KBnQpyeRBZL4trjsAqzMKl4K17S0zrzvO5Se5qc1ygY/3jV10LI9UzX3rDkaLwMIkO8ZqI/Rl/8TShfQD1k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3153.eurprd06.prod.outlook.com (2603:10a6:206:6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 12:25:11 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 12:25:11 +0000
From:   Julien Beraud <julien.beraud@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Julien Beraud <julien.beraud@orolia.com>
Subject: [PATCH v2 2/2] net: stmmac: Fix sub-second increment
Date:   Wed, 15 Apr 2020 14:24:32 +0200
Message-Id: <20200415122432.70972-2-julien.beraud@orolia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415122432.70972-1-julien.beraud@orolia.com>
References: <20200415122432.70972-1-julien.beraud@orolia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0178.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::22) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from julien.spectracom.local (2a01:cb00:87a9:7d00:39f3:186e:89f3:a8d8) by LO2P265CA0178.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28 via Frontend Transport; Wed, 15 Apr 2020 12:25:10 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:cb00:87a9:7d00:39f3:186e:89f3:a8d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1292ac91-dbe9-426f-fb43-08d7e1380a8b
X-MS-TrafficTypeDiagnostic: AM5PR06MB3153:|AM5PR06MB3153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR06MB315375510257482EC99FC58399DB0@AM5PR06MB3153.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(39850400004)(346002)(6666004)(316002)(66476007)(86362001)(6512007)(2906002)(107886003)(1076003)(5660300002)(4326008)(6486002)(8936002)(66946007)(52116002)(81156014)(8676002)(6506007)(44832011)(478600001)(110136005)(36756003)(186003)(66556008)(16526019)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bCX4vE+rcNUGQVyHWjrSZcKBjMIt3vKZOJB17Ist5Ok4x+VfiG+FkQ2oi8e1xNxqpEiTgiBFDa3dI9EZhMbyg8cpe6JwN14o8G9m9wfCDub8/JgOQVQOe63QCFbOGKEmvv+zGua6uaQtkgatdYBscxAhIfuN2n2w2vT6oy2am1kQ3wtM/Tg1o+s6U8A1vN0aEV9LWLHIwm5A4PVgqqIiXggnR/wmkXXmcM3secuYEsNv9AcZgQxRLwGgmWTo/Tbm8X4X5rbs32a/W+PRAh/xwUnvH6T7yPBTU1lGW324iVo+EBjNqBH49BysSW8THsm4x1J0q90X/lpOe5kMixN/ZZ/L7VJ6BML0DMZ8e5uEigFWSG3JmvHPFRj4ED3S7d6NlhrdFvFxU8D+rmy2qBrO8cdRB5crLXYSVYzn89JgE41b9wZULJVYHkx4s5EKwFiq
X-MS-Exchange-AntiSpam-MessageData: f8w2ighkUu3odOMFvi3JabQPqGnQM2t7N05g1JPS1rA1P8hHGPxTW35B2bwd6phoLETVyWQwvzlH6c7FnRF2QlhC6x0pxPpT/RFSRImlwDa1H2koUNd5GdcLJpbP6nHoDR9RTltSp4Hy/+qYuULGNAuJ4aZ6LUUA5M4uuqxnKmlilI9XtpSADFbpHICHXLFWAReTGp8HjX2l932mxEsJfQ==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1292ac91-dbe9-426f-fb43-08d7e1380a8b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 12:25:11.0007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lUMG+d2tOu+azR5D4t3x2lArSVd/JyE5Fm6X9gGwrkBydokgKVQNxPII6VjLeFZzvUyhHeytQ38uUxi0FFhInNc1nW6b+yFge2eMYrBld9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    In fine adjustement mode, which is the current default, the sub-second
    increment register is the number of nanoseconds that will be added to
    the clock when the accumulator overflows. At each clock cycle, the
    value of the addend register is added to the accumulator.
    Currently, we use 20ns = 1e09ns / 50MHz as this value whatever the
    frequency of the ptp clock actually is.
    The adjustment is then done on the addend register, only incrementing
    every X clock cycles X being the ratio between 50MHz and ptp_clock_rate
    (addend = 2^32 * 50MHz/ptp_clock_rate).
    This causes the following issues :
    - In case the frequency of the ptp clock is inferior or equal to 50MHz,
      the addend value calculation will overflow and the default
      addend value will be set to 0, causing the clock to not work at
      all. (For instance, for ptp_clock_rate = 50MHz, addend = 2^32).
    - The resolution of the timestamping clock is limited to 20ns while it
      is not needed, thus limiting the accuracy of the timestamping to
      20ns.

    Fix this by setting sub-second increment to 2e09ns / ptp_clock_rate.
    It will allow to reach the minimum possible frequency for
    ptp_clk_ref, which is 5MHz for GMII 1000Mps Full-Duplex by setting the
    sub-second-increment to a higher value. For instance, for 25MHz, it
    gives ssinc = 80ns and default_addend = 2^31.
    It will also allow to use a lower value for sub-second-increment, thus
    improving the timestamping accuracy with frequencies higher than
    100MHz, for instance, for 200MHz, ssinc = 10ns and default_addend =
    2^31.

v1->v2:
 - Remove modifications to the calculation of default addend, which broke
 compatibility with clock frequencies for which 2000000000 / ptp_clk_freq
 is not an integer.
 - Modify description according to discussions.

Signed-off-by: Julien Beraud <julien.beraud@orolia.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c    | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index fcf080243a0f..d291612eeafb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -27,12 +27,16 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 	unsigned long data;
 	u32 reg_value;
 
-	/* For GMAC3.x, 4.x versions, convert the ptp_clock to nano second
-	 *	formula = (1/ptp_clock) * 1000000000
-	 * where ptp_clock is 50MHz if fine method is used to update system
+	/* For GMAC3.x, 4.x versions, in "fine adjustement mode" set sub-second
+	 * increment to twice the number of nanoseconds of a clock cycle.
+	 * The calculation of the default_addend value by the caller will set it
+	 * to mid-range = 2^31 when the remainder of this division is zero,
+	 * which will make the accumulator overflow once every 2 ptp_clock
+	 * cycles, adding twice the number of nanoseconds of a clock cycle :
+	 * 2000000000ULL / ptp_clock.
 	 */
 	if (value & PTP_TCR_TSCFUPDT)
-		data = (1000000000ULL / 50000000);
+		data = (2000000000ULL / ptp_clock);
 	else
 		data = (1000000000ULL / ptp_clock);
 
-- 
2.25.1

