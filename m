Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3325627C1FE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgI2KKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:10:50 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728215AbgI2KKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:10:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M93tWaScWV5yk547Mq4tttZfd7IyeoMKwbxQStlSFW6dXuIzx0a1XpNes9t3tt7rfOryKsdkXyMLSDN22oXfor8zT+Q6BnmQLIZGeRU532e6Az6t+XOCKuTn9Y84U/okMOeU/DbGE1llrHTjbB2uZDg/asEP87ebPxJkxBjub2Nq/5+OzE8tPqsOR2ZY5/gH3dsz9/QKY5FIqB9gYTXgxwwWYMDL0WqOH2RI9HV5uuqPMFikaA6L23vqrWmsdM5rY4CMcLPFZiWzzil9dclv7QD78MZecQpXaqF6AoXW/u34fT9C6ECUOEs/W1TaWANmttfgYopvzyCbOdGbs5/IVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ar9sfrRXLD//Rs1zlfv4jfE21qLI3+Tp5ogqV7rVTo=;
 b=Qv7gyPxF353cjFOQ4G9xmLas5V34DzFKnB8hKLnfvcuNidjafCRXX86OHIuRgPkfM1PCHaNoSxxhjQcyxXs4UG+jwAxOkykSstnIjy5Jmo5cTCuA3Px24H22OvR/C2jw1k6xMyvl+/Qil0YdpwmSzWx1Zi52fRYaFMSdkxHarIk0ArfWuYgtawRwRye+HZL1nWuxZwXBErZY9zZRE1UeSPfJWE7q6Ml2B/il+2h/isf8I+RrGMPcY+tqfkX1ix/D3bqL5T2cRQYzvMB3ASmb+j2VunyXoIvog+pHufbRB+guJywTSZZcms12Zi6KaCvP3xut/iXouWDmZMfamA/3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ar9sfrRXLD//Rs1zlfv4jfE21qLI3+Tp5ogqV7rVTo=;
 b=li2Tl38yMWE/OIHyAvcUeyuayZKUKdKuw3iGss+M7E4L7yF2R9RDT+4JnTidPhv4gb2TNZuW9wKSrtC80sQfWpcdiubONau4sdSi9++FCRBDhxdrUpc+pDH88VfFjqcwBs6GwFlCgIvnMiLSbYji6mX7rNIjBwZjeigNk6/8m2g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 02/21] net: mscc: ocelot: return error if VCAP filter is not found
Date:   Tue, 29 Sep 2020 13:09:57 +0300
Message-Id: <20200929101016.3743530-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae6c1130-e1c1-4ced-5e8a-08d8645fe865
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D5FF64ADE764405FEEA6E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQiIkpvzbGmwH6yJnujIigzmhchSK5/3Ni5dyhSjZNSkq9znXVk5LM9IINdvDzZmY5VarQsbO27awrWp3JM22l9CqcoaItJO52YLjS2q2F8qrxyihMPsKsIGHjb7ZLKiXfRV8Nm7IR1FveNj7CyPMW3EeLuoo18uu98LFXw4UvQbDLdYUP5AfS8GuWAPYyfutzoxLCBqauLkHuZeZavLmmN8CgYdfK6y7BT8Jq3nYoH0jQ4NmcuaVEbwd2Bqd4uISekUJeEHbxwvjsxkA861JjCuNEyp7QFoUy7S+xpvXZMl7Pv4ipI110owgA/Lqx8XUV1fY5hC2nPAK7j+5J57ekiJFMCC0nLxKS99q7kJ2mBjtGMOwnY8K6i2y78Vacyg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(66574015)(83380400001)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dbeONRXuvfWO5Gu5Uktewak8lcKLIOXFMLbtX3OpicY20wFniRTvm2vaiZaFps8DAWlX15ztrmx0Jo3+k6by/xR6qF6VaT4fBcQY8dbGnQnaliLS42AkiDENEG/45IugzOpcpi5KtWAP4s2sbauup7xlhqzYdaep+pTadugac31d8t4LvqXnGXSeoSdFBuh47Tx5zL4PO4q70Omwe+DwnAsT8WmI9iJsGLa0yTfwtLbVGQiP4ciLwgRzJ72P0lDl4VcXPltMQEdw6/pf7FOeMZ3BaVGpQBfedEZd6jWA8QGibCWDj7X1kVBzds93j5XUuP0bajZiWagIU8tuUdWZwnqoj9uzZnkFqDyQ4ZwFpbhOMvao3KsAQorCgME7lDrzc+bxDmu5RxCSa+9/gSQBQ8irORlKJYRplFAFs5kHPVnu2hSFdbWmtJMxBAT9lJabxVPKMphxJuRGFfiOw8FOEKILx33UY1RDEj00S3AFxlZoIgZ0ZDemO8EAZppAZCF6QWDvv0uXqZkwHnuBO4kCQKZEOrtEVweZhXLThbpWMLbmRGnUUuzI7/DteJwg8WH9n1av5RHgQip7nubQ8qLjUJdK3P+Rns9WSgs01jsIKQJi/TcOUf1sYHCY6GtutGcZAu7IMnoIe5t+G5v8Ek8NyQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6c1130-e1c1-4ced-5e8a-08d8645fe865
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:35.8952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0caDW5g/f+gJzt2KVvTKcYoHfGaIe7i84v/NvWJfFUaunoRtAPJrfdqsMamJvoiqiNsaZNMj+odNa2h+yP13Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
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

