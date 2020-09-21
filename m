Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040C22736B6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgIUXgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:36:53 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:13019
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728728AbgIUXgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 19:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbD8gqCXMx1wgQlvVxkZ+Rc5JiWhEkOGoE06GuxsUFvxgU72JKyd0we2j51qlQlztYOO001eReLzJAZ7MyQ7vKEmsLrgisaMd3b6VZhgRSzhS6MCVNlhFhiMlOaXrcy1pLQEU7mg7nV6bcv+ed76EAYuwPERCtwODm25LM9HoacOJJS2N+vtgDWlZYcfG6Ki1kvI3omm5pfWUmeLZZ4yJ/GTvxTo7PgswJ/zotmD9+i20q1bLtEHb6ZjF5o3wwXQeuB+vlY+Sn1H5CTpaDIjxiG/oS6yrl0wAR7Otxe2AosWeSoEYDbK2Co+oRy5K8CRDdkNb1Y/UE1eDW78fjOdVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwJsH/JORQiNDwdmaJFH8aj6ncBkoHdK4H494xQEHLY=;
 b=cSvzuJgLFqRXovizirA677QYvnqBH5YTEuAv5cubh72yMwcJM+TbpWf3JWMg21c2c3b7DvB65mHQcVvTbZNneIrs6mHnCYmnRobZIJj/2jLTn1R2TiHyyyEjFkH0YVmuFY2khWh/UmlLLrz4X9jhcSkd6Rms7WeRqn0N7+/+KsFHybJ2OkgkgLVzOzF78RV7HM9F4JSCjJEjxqmD4rs0yvILKilxyBimbCbEzd+Q5tcW7e+T8DZ1KzzYy9w5YPtsTfKpnF5kORJbSMQ0K2pwy48gcwqeh9kmN2cp2sjH+jLyTICy44t9Irh69JzFpIi2wiEdVQgKQw5SNTAS+TVLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwJsH/JORQiNDwdmaJFH8aj6ncBkoHdK4H494xQEHLY=;
 b=MyAE9kKcJDfn8xDw8VPNhugXRCarA/8rZ0Tz9G67GWUvy0MM0gSU6Xja8S8afO71qsqceqMs2YRAr0guwXBUp5FXR6tcbS9Zpy57tD8pp4bjsVHH5DMGCEhBV6qpJk0y/tkS0ZmIPBNc5SH/JO3jcg4jVPLAhnnpJrItppdJMQw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6512.eurprd04.prod.outlook.com (2603:10a6:803:120::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 23:36:48 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 23:36:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net] net: mscc: ocelot: return error if VCAP filter is not found
Date:   Tue, 22 Sep 2020 02:36:37 +0300
Message-Id: <20200921233637.152646-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0277.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR07CA0277.eurprd07.prod.outlook.com (2603:10a6:803:b4::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.6 via Frontend Transport; Mon, 21 Sep 2020 23:36:47 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c8f9778-4988-40fb-6206-08d85e873517
X-MS-TrafficTypeDiagnostic: VE1PR04MB6512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB65124DA4D67E093892808E89E03A0@VE1PR04MB6512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KecWjQaZQFjBr+bIg+q/pTPkwizTMjAGFLiR7VaKly2s+6I4ZVZw5TxXpCyE5kzsi2Yxcb88GK8fBxS3C1Oxlv9XZKUrmKmi54OioPSUsu88IRi3Iv7G2H9SRVzILzIGlY1k1E1lkcY+BFMphjRPyBo3Y1nnihVWs/mKfYm46VeVi6itCbzicZDgkYsn4nUICcEt1bQDWe7GcV78bEj27dhHF32B1jkQHXMWQppbpchFRRUBUbRDmOhW6KC6UU77cdZv8DgwRe32jQo99uU+2Hc4NTVDD6kIty0vyBhHGxPbONCHp8pfkSe3miqrclBjRr1XUwzkmn4A783uU0DG0UiVl6GlSQ3kf1wCihzBUFNPENgpufJANGy+9oP+does
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39850400004)(136003)(376002)(366004)(36756003)(83380400001)(8676002)(316002)(8936002)(52116002)(2906002)(5660300002)(478600001)(1076003)(6512007)(66556008)(66476007)(2616005)(956004)(44832011)(6486002)(26005)(4326008)(86362001)(16526019)(186003)(6506007)(6666004)(66946007)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fKxznUSpk8ig1tEt+ES+xASvFdoNJvsqHrWAYYESKbGsU2Ad1+6++t7rYkpBV62qzBX3RBON/94V3AJVkfp2YMrNrTU6lfErGu+jYvCqVhSoI0TiUU8upgromEpeOJO7RRRALvcFqV6yZZg1K1bradSlbABmR8aXIlQSryLnE0DaYC2BfpjtyWV0IN81oxlHXcSV+sKOfE2u/ZhetYvfLXnekdrdvqYzX/hbCxDsFjcNmm03K+mBn6T2q3ZCoyQGClrFWBl/uV2zQ8zd1C6KPl8FChq8sJBDuKioBS0hnLE1ZMHaIBcs1EM32hTpr9pc+QcPS78L02yxSVUblV5MpoVUatfQdFpu41SWCTWLPIESvVVhKEE7lGT51ToVa0rI6Yfzs6wWMmVWJrdcl5+0D0fz3UMuDrHisxuOGsNhqoZRlz2cXa1BGA3QX6D+rGs84Jpqa7hK07H2La8/EDiBrNrh7MpDAHbNFAtbLltdcf/sgflYp259rRX0WRYgU80IfCUVI/JTBW8XqKUZusi0fMwo1yV+i5xcpwjVs3C2dwUiqsvZQPix31dxvCmjZyzMBOfOzPlAfR+uhmMCd3XpKRZZJwC9F/YkvRw2pjyLVr+hE0K68Ib/ZRP0IhFB1EZXHFXi/bsgiXV8lW9cI6R7WA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8f9778-4988-40fb-6206-08d85e873517
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 23:36:47.9384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGcyVs1Qnyqq+AopktoJ/OidU5sjivPMLF0eqvWA4FmVmRnwxjy4U+2VslPM6UjLSjb1iXApC/xHv3BxPBlrGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6512
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

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

