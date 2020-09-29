Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822F27DBFD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgI2W2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:15 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkY5wKqGahfXCztazYd1nwNA+b3lQZkxkVmP4dW8i5L3xt+qAcg2Kmp8YlZaTDJ6ute2cvxC+1tVwI4aH8nX7kiBn5MWbcfFbmhiYl3qXiig5gAacU7YE1QqVZThggX/M29ZuK4UHkY0vfRePE+rQf8K3AM9RS6Nk5jcp91kys7lmsf+FUqVFgPs6AfBsXqIaGkwSnKp6gC3mB78SliJriaO9brq0AxalJgRM0e82cC5n4Cv7yg8belRqzKY7r+wHMtyZEt9ZrYoQ+9Qfsx/Fyn5zVszRT3lfLnZ7Hzrsfz/STGIy4daLt+Ki9k95ersUn7Y+xkSjJNbGtwFKsfq3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/sFgtfq5zz0iGO57VMVFGARHkuxvY8ZVdz+u9rspJM=;
 b=Dh37ZB16Wq0OeQN91TTjgCP6a5i8BOfKaV/neKv8wcHGSLsvAO9JIlkgKU008V/Wz29uBPEPh1sIyAjGvTerILUmQwqppL4+FqRkd+oFPjC1cUEnVxM5w2AN7udkAKWScZ4PBOVYILTaGMoAVh4cO+Hq4GeHhcHU4l8s/ZCOthyUgWN4ytOLoxcT3yS9XR6zVLfBZH3LnOKvnacADSvMycNYjl06vLNikZXXWSwWiKgZmqe5a1/iSL+jVY+7Nzcz4fsGuqqN+yfvEPLW9vjxlnQeY7Anb4OxfdZglFRBrL1kEs6uKRknxwyxoIIh90zTOTTgNOWwZ+Q0BtynX1s9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/sFgtfq5zz0iGO57VMVFGARHkuxvY8ZVdz+u9rspJM=;
 b=ZkEuTwZCmU2/zItgJ5N4UYiSQnLLN035hQPlVdpP0X2cEeMoLMX6sJ0QuyTX0URIYVF0JotVlesJlXWjGvmHig9kEOnrmZVlWQ/rff6uLBwFRAXLPpbdQaUgfQjA82djM/qSS63EQDlYo5LKOvXzvDwu/09m0O05QdpvZTXwSgo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:27:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:27:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 02/13] net: mscc: ocelot: return error if VCAP filter is not found
Date:   Wed, 30 Sep 2020 01:27:22 +0300
Message-Id: <20200929222733.770926-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:27:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19318951-df80-434d-bbc3-08d864c6eac4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797AC97F06D5980FA7E0769E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9V62nb2q2e/suNcu3aeKVMaK0jpB9a0isYNbKh21ZX/Kt569miE5935jDfUlL3Y1H7kwHFy+Nd4Ijg5Kx1ycJcR+q9f46JHayTtc3dwMVAbs4GEB1epTXw4omdfG7cskD6M8cDHLryMlYqcZaQs4RtcnWdmXSZnWQxSYSMAuiQF3PQOv/6MHo2SJgpj/qtHdDz97tUHE1zmeUhMLA3e8jryLO/Hro6FVwfICrahwfZ8e0o5NLy8NV2SG0RiHKM4ZHj/qR4JL43EM3f30HYnIcx8xyeT+VtcHZyhg7piaGXPtPdNHgXYPWZAP0fSyGHYp3WZsdLUBnCENiLYwEOLRLkRGk6SGYVDso+u4Tio0oRkCUWnEiCQBYx4YeCZrt3C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(6916009)(86362001)(66476007)(6486002)(66574015)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GJLNEYNdSloZoxx3wg2T0BG3ABGFdaPpxpD0i1TzcILn5rli1zvdwwie7xqk8sHFsy1+J4Ne6QjgmPNnYB+MXTeh/ivT+HUZWrDzEWyErF52uc5XRTQg6rQjqLUiifl0vbFt4QWgIPOllo0DrlMBV6x4x5MUeVRSPm2TBY9fz+lg7Q6LTAVgefrY5yxqQjhzVOEw1+BNf37ydbG3VLO/cCeIoU/CYpkhfyahqKELrF7Axk/67ewOdY7FpARxE6uVzKIrtg84IKO7NpLCMXLkkB++swBJn4+02EIeGi+KTOG10XxYv+I8lwhQFIawImC6shyNwViUOn7pt/pC2rfflqNqlPLV4kbtYfJtLjGopv86DsmmXZ5ZUDtORZKGfND+jCJtku8EuPO8i/O6bXm5QZ/luNo3OXBisEvgqUgp4C0KrUrY4Im+hZkVc1LwoCIMEuD+m9YF3Iovx79UH+ARG597Sz6A2NjduPiPJ/+QU9FobmghgfPVA3cwqFtz2qhM1ovWLPUBKnYvg17QuT3yAN5SCbJB+jRi9NHa7xLH3SzdwrC8LprBasDSW1RBgY7d22Lc6fMPEuY7tXtA8m2kJ57mwpdO5uNBhNGON6bWaKpwzTObIqX7XcvtWfTnmDCIqv/38Bqh9vdi3Ln5pGKf0w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19318951-df80-434d-bbc3-08d864c6eac4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:27:58.0097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmLAOsQNHalJpo/AEKh8ATswwYY6DjBMauEnnit7eSfLOYxwjjAczJi2foZAjwdzFoGEhXdvDL4nujew9xf7HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Although it doesn't look like it is possible to hit these conditions
from user space, there are 2 separate, but related, issues.

First, the ocelot_vcap_block_get_filter_index function, née
ocelot_ace_rule_get_index_id prior to the aae4e500e106 ("net: mscc:
ocelot: generalize the "ACE/ACL" names") rename, does not do what the
author probably intended. If the desired filter entry is not present in
the ACL block, this function returns an index equal to the total number
of filters, instead of -1, which is maybe what was intended, judging
from the curious initialization with -1, and the "++index" idioms.
Either way, none of the callers seems to expect this behavior.

Second issue, the callers don't actually check the return value at all.
So in case the filter is not found in the rule list, propagate the
return code.

So update the callers and also take the opportunity to get rid of the
odd coding idioms that appear to work but don't.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
None.

Changes since RFC v1:
Took this patch which was previously targeted to "net" and re-targeted
it to "net-next", because it doesn't appear that this bug can be
triggered, and in plus, when in "net", it conflicts with the work done
here.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 3ef620faf995..51d442ca5cb3 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -726,14 +726,15 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 					      struct ocelot_vcap_filter *filter)
 {
 	struct ocelot_vcap_filter *tmp;
-	int index = -1;
+	int index = 0;
 
 	list_for_each_entry(tmp, &block->rules, list) {
-		++index;
 		if (filter->id == tmp->id)
-			break;
+			return index;
+		index++;
 	}
-	return index;
+
+	return -ENOENT;
 }
 
 static struct ocelot_vcap_filter*
@@ -877,6 +878,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 
 	/* Get the index of the inserted filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
+	if (index < 0)
+		return index;
 
 	/* Move down the rules to make place for the new filter */
 	for (i = block->count - 1; i > index; i--) {
@@ -924,6 +927,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 
 	/* Gets index of the filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
+	if (index < 0)
+		return index;
 
 	/* Delete filter */
 	ocelot_vcap_block_remove_filter(ocelot, block, filter);
@@ -950,6 +955,9 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	int index;
 
 	index = ocelot_vcap_block_get_filter_index(block, filter);
+	if (index < 0)
+		return index;
+
 	is2_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-- 
2.25.1

