Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86E92737A7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgIVArN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:47:13 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:54965
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbgIVArN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:47:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4ApzgsmpmvfhSP0WM9/F7Kwkq6wU104b1P723QwOMQFJt5yX6DdZKthC46qBMEb/UI5MPUgr5wWzkwBoioA8tq07g0ASMSiOdWgkf+7tip2WFTSf46Gv+s7ozhbPILKXlRMExa7sOaQmraHlaQAPfCFWHnPFhjjyfvwf+fXTep5+5STNaWQcWKtzhhz46VtbyNtONA4muc9uUw5CeV1ljn9AVEbruF+LOiHQR5Sg1oK+NjtmeNWx05BjcfL/XvGt0vH0YJYfGsEgqbFxFDYYy8eZ6fRauHPNtfQcrnhqq2gVL57tmKEOFqgv5nNpbB3Vgri9NIdlX3kk4Vuez0vIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuDkL4o4TG78Uttv6aJosp/yQu1t18uFw5Qb7b1X7Tw=;
 b=W9NSV31m1qNq/YnHuQLMWgVNpHCKy4niEk2ZlANpVtclMx6j1VbrP9Jwgx9/c0OaVsx08WsdCKHxO/CoumRQeuC2hp5K0A8IEeESy9RBiRRfFGa6froBoX6TMQVBcFMuLcKk7D1VYAdjqJEYDLuRYaGR2zZJpENJ2rR8sc23uJW4iyECQvzhY2dCXDG3oi9/iBkoI1vbCSXlF89Q7vGOeUW2812ZIXCecpoVqstB9UcXqlFRS6SCpidhXTf9F3tzNUOF9QA9uWQ6Ez86X9dY4/+pcxuG93hDVRpduXKJQWtzhBeI3wVfe2kGuRHmQ0JfGXtZcY7Rox68FqOYEmzPvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuDkL4o4TG78Uttv6aJosp/yQu1t18uFw5Qb7b1X7Tw=;
 b=OUKKZ41qRy+TnGJhD6wp58Ngtn6ffcE1c5jmtEkztM4RNb19RvbA48I+YDwim5MIDVxr8qY0c5X5nfCk7uJDvePQ0lJw2tnaJc6Eykyl05eizVi12VGd5oTaPKxqKp9jIMsFszyUnuw5xP5BMVfXBKK1sS98Mkv1fu4yt9rPewo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 22 Sep
 2020 00:47:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 00:47:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH v2 net] net: mscc: ocelot: return error if VCAP filter is not found
Date:   Tue, 22 Sep 2020 03:46:57 +0300
Message-Id: <20200922004657.181282-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0902CA0034.eurprd09.prod.outlook.com
 (2603:10a6:802:1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR0902CA0034.eurprd09.prod.outlook.com (2603:10a6:802:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Tue, 22 Sep 2020 00:47:07 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 103ee2f4-04e5-46df-c8fb-08d85e9108b8
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB422451017EF8C454A731E499E03B0@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZZQ3qdEaRcHVbg/6h/VZKVh0Dsp+hym8z085yqIJ7qcbMe50Z/ynVqiLyQz/3KOnX8a4Taqn6XY3VB9tBk184gFgeWVS+iCsQfFnK4GFFPHCgMsbMNPKVu1BMNsJ3zV+1gucaQSmYnVwCOj+FsOrwfci4UX92ofpZkpvVXXVCNVDz/MYls4Mg1anXG4TVoEhEYpGY9pkUZ6wPZVvLZmbTKBMYafOmdNLgwegSGU1CkbSyH5qen3LoU8H659ACo79UfQA/TyCzk44V+gUJ5lK4dD5TsJPKiqbr31Jsy6DXHtQvq76jgXn2en8EwLt6TmEUcXrym90CzRxqAxgBne/gZcRP+GE7p1rtLgiN/gnIydZ8n9jXxUrbtp2UhR3ql0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(86362001)(44832011)(2616005)(956004)(6512007)(4326008)(6486002)(316002)(36756003)(2906002)(5660300002)(6506007)(16526019)(26005)(186003)(478600001)(52116002)(1076003)(83380400001)(66476007)(6666004)(66946007)(66574015)(66556008)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KmJclMw4dWFoIYkBKv9+BuGDzw0qFVch4/5RzyiYT620AAxOuefVLOX+B6UafBcRkr0ah/9JLBsYXasYJ0EkLWV8o9YDpnEvkZBNfVv7nR5FBKLJftCg+fDtSrCzFfQpTvROLpT+rFVDwOcx+bp7xbsSuC+ISCSg7lwCYbQe9HLoZo+i1kE9oQEx6VnOx3BRhiLeCBPGAxwsxytGKWoVZuSpX2Sjp6p/KaU4PKFvZ3tnExWxjtV7ZavMOvbTBpq/GgIqx0BE1HxLBU7aTMQu5Xw0rYK+AO3H4ZlmmDBAsy7KkGImbObHGY5uVzjT4zrt5lzISOYy3rhLNnIjvkQr0+q9/n7i6t5inQ90CpcOztfwNeOyFEFwHFrfiyWUnSO4ZnAyLnDEHg0vjTd5qekZP++AXO/JfHy74fR3Qbidm4L4h/PRTrvQFT0bB0/0SJGKUkwXBCRfFyPMbk+czzgesEZSNQG8f9MWX+kxCyhGuG5vL0DV3YGsTHMN7Dg4s/7bgHL/KcWOuo3yDDNmF//BjBUROi2p1IdiRaroHOZbXEOxSizcEnb6Ix8O8LC7yE4fkHyVKVGhFziaxzh3q2gTDKrrfUAIi4ibIwaGG37y8jRaZL9LtBbIIbazcI2tCrpuR+wo+CqVLqAn0f2jubMwBg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103ee2f4-04e5-46df-c8fb-08d85e9108b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 00:47:08.5510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cbxwYDO31MRp7ODMrmp1/MX4Tx5YW9t8AutXxXExKzDpunvE3Y3y3uy96SMZMBqteY6g2MnucRpIoYdrp0CGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

There are 2 separate, but related, issues.

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
return code to avoid kernel panics.

So update the callers and also take the opportunity to get rid of the
odd coding idioms that appear to work but don't.

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Add Fixes tag.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 3ef620faf995..39edaaca836e 100644
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
 			break;
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

