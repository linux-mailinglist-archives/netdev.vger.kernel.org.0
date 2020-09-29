Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA727C217
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgI2KLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:48 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgI2KLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlaMrJ/swNkUy7ofasvrrtclO7qC0R/jE9OeSC8SJeZwu0Nni6qHqdCG0ZlKj4yxYQ6v37yMq9WXDIGLp3OGQdlap2Mz1V4S5X4t8qJuQku0AxHpHQXSfe6w2QJGSq0+ZUpcp7lTh3pIzdNsRvkmCfwWyFDdJkw6l9WuGqoKbmp3Ulcgr5QUG2zffoOX1nUAwObe7BGP2et82EPw5YfTtbgN/ugiLRUM9Uuv1F3N7IECNEv7L57EPcJ/wkO2/TF045nAi1FOKIlCJKtFiOSoFtW6FG4ZKhypmiMLs9/PnJLDLcrwswzUY5TiXbKfOFVE2JlOVUkQnumUqMz3lBiBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3JhjKKxCfKNRj9BIoGuDA4g56G9mrU5iagVRFzPOjI=;
 b=RC31OG3Ibbhq5SiF6+DS7uS3wh/olwElDkzLterBkXl72j6c8A4dmP2tUeHjCzSAKotbFfqN1rn9ZvpoZSxG8+/0hk3ZxIUjWhgR6NofmsMcUKNITk4nGFDBhparICiQuzMW7RD13MFm8xcoW179ZGgRQJn30xAJvuGpRH06BVEqo4z5t9WABPaSh3YyxAQRb6hufzXgCFnvWpw9javetgqy13JKXqU7469zK5CIQGK/u/PDvqUyLL05ysYNBL3m2kcuBQRYcTOpUEfNq1bMivbP2/oSQgGp+UJvwLJSYxad4wFSVzK7xUUI4bFJ//9u6FJGkk0DeoolRdGHR8Rk/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3JhjKKxCfKNRj9BIoGuDA4g56G9mrU5iagVRFzPOjI=;
 b=ZLftM6LWmj6tIRcoi6x2phIgsLvV1y2uZ0cwJ3Jj1p8xg4K2Rb0PF/LQfsPM1eRggxuSAK/OOzt9b02IbHGZkf17fvSPhSH+QoB4eaUqxb3z+UmrSf6jBHfpdyZF/BAqKJtEXF4WJeKakIYcO1hamXvAy5R19oeBe7DFuEMvNx0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:50 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 18/21] net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG
Date:   Tue, 29 Sep 2020 13:10:13 +0300
Message-Id: <20200929101016.3743530-19-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a31b4b6b-c57b-46d6-f5c9-08d8645ff0c9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB52958D3C41CAE754ED778A08E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8+x3Pl1aJmyFcOHp0Fftx1xyDC6Vf3XyFdC0obKkn4/j3QoC8iG8URB4ZRQu1sYoEJudaZlo41ur3wviBjretxAxwUxXcnh0F3kKi+YkUrMHr1dZ5ifpcWaUV853q6uB47fe0ErGtSvY37k1IQnb6zpXIYNrdyYM9b3LVOXd1dcKwB/IcGipnhVfZNHF/cuqe8aCWqPjfTAx82ajPutor1WRp7nODe+NhWgedRLlJczkEdL/MYC//JTlC+fQbcTcw9rM20HxdD38QOEYVeGPUQ9QKUkeEZBkzyQz+JeDl8G2xKwp/A+SKILPOvN139CaYgLe8+16wDqAGjRAMxaAnSB9kW+e2bPxXmj+bkK5JiAhvl77P/0FhyKVbP05MiY6E5LuDteHl6mBwLaExzJd/5XnMq0ddFML1vOGLzHbp2x6afdKbIV9W08XQwdcAA3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: baR3XbGjhnReofTEAXv3BlMWYQsSUko0U9kIjd6P7GaYuwBi09YGwVtstg5xESlFMt5j6bw5DZyyQ4z1tsC9SWwk9ntlw91BGS0WOgAAFQn9y7ylVkDY1OTOQyt55l/q7cCfzJTWe9yvxN66iGlfEwX9j/Z1C+DXbkkEwN/xQSr5GOqa8krq2PxW6PyPeg1SFcazQsZH6pQqarGtdywe0DETsWjuPZiiP7xPkmmmm3aKbWHYiXRt2rA2tI6iRP8QstgX4yevIrsSxVbdMIOZZq0zv5Gbt8EPr5znleVMndMZH85LpuM8+Z9GXRWVN6rgoXVi8Z2p48+VMyG81YAWCYLo/oXP3ZbmcCgM2Ul1djyB7nPrVLxjQM595X/Vzl0md+CIzURokZ2iqLAhMB+FUls56JQ4qYZOkTGD6Rwui66XKR1e0a1rzf9NwwNL3z6KbuwevHMEVd/mKOfFfyEqdd/rDxjASP0smsloFMIsLPZyND097ES2loBBN7hgqCD3H/ykIGid7QYg3KhNhO6MOGrcntEZUZOCt6PUBXSs6TsUssESjVnDTEjYabP/S0xnA/bsyttgK/zLGh5EaR6bFfsW+DsPnpSHdgygVVjnH/8n2S9M1SAjGoF8wP5tO0beq5CtxptAYBbpKk9AwzVzWw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a31b4b6b-c57b-46d6-f5c9-08d8645ff0c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:49.9102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: booLbaJ/Bty4kLMq63Kjco4akKnQl1A3uj/KW43oqjX0zdTWSOAzFQlerC5/hpSfMGuhHg9rm+medW8qQOiWvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were installing TCAM rules with the LOOKUP field as unmasked, meaning
that all entries were matching on all lookups. Now that lookups are
exposed as individual chains, let's make the LOOKUP explicit when
offloading TCAM entries.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 10 ++++++----
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  6 +++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 3808a0762919..ca7cb8f2496f 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -164,6 +164,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	}
 	if (filter->block_id == VCAP_IS1 || filter->block_id == VCAP_IS2)
 		filter->lookup = ocelot_chain_to_lookup(chain);
+	if (filter->block_id == VCAP_IS2)
+		filter->pag = ocelot_chain_to_pag(chain);
 
 	filter->goto_target = -1;
 	filter->type = OCELOT_VCAP_FILTER_DUMMY;
@@ -205,9 +207,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_POLICE:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Police action can only be offloaded to VCAP IS2");
+						   "Police action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
@@ -276,8 +279,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 		case FLOW_ACTION_GOTO:
 			filter->goto_target = a->chain_index;
 
-			if (filter->block_id == VCAP_IS1 &&
-			    ocelot_chain_to_lookup(chain) == 2) {
+			if (filter->block_id == VCAP_IS1 && filter->lookup == 2) {
 				int pag = ocelot_chain_to_pag(filter->goto_target);
 
 				filter->action.pag_override_mask = 0xff;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 59ed25b8b5a1..958d8263bcdb 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -350,7 +350,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
-	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, 0, 0);
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, filter->pag, 0xff);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST,
+			 (filter->lookup == 0) ? OCELOT_VCAP_BIT_1 :
+			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
@@ -671,6 +674,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	if (filter->prio != 0)
 		data.tg |= data.tg_value;
 
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_LOOKUP, filter->lookup, 0x3);
 	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, filter->dmac_mc);
-- 
2.25.1

