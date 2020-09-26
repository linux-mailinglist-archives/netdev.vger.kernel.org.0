Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C093C279C32
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgIZTdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:45 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730046AbgIZTdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cy8AN49tR8pgelNRJRJLz0ZjWFZJ9cJGeB3+1bz1Fj1NTj/IADhbuwkwdUE0qVlg98vjxZprl6EXHLB5QndXDzIDDkqK+UTJkKWMgmFGwTZ0aXMU2iDDbgvMv+P7Vy9KaKjdP8d5FOA10z9r1F7qoF1xIsYThOSO3al0HHvZT4FJpHX5FjEhH/wx384fxZCfa5d0c4SdN1Ummkaa6tP+ylvBdYaybYk2SqA+zYM+1+WsptFXuCUxllkGn+30TdRZhPL2l3v3Td4n0qqzIpgRFIo6fGx/9UdnWLEljCES7aaDHRbiTLy7vRnsV+E26iFsmtXub+xkCNBd0CmBu2VRRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC6tcZcVPIQukTy2t0/bkHp7zNU2maL8/441/uTEYis=;
 b=iTjoBOJPiqAiiEtubm/8h/V+ZRaEb9YKMzlxyWAoOXHulzz6nuZlOL39G9gp2DiOXcmmYOCblt5vZPk+eAY3KbbJCgZOcTTahml01DYNfSgcrU7qxxLXtsxeuNK2qnqoR5VaLRiPw6sq/J6iUalMQEJHhD2XpfymRKglThISkKEv4tUa96aY+5ZCBqgyLUhtDw4Re0O88zJVUHkhrJI5IWKsni9ord6U/R7NTlOSt6Hc/YksFET3mue7xUVQnmuCuxKn/Y1pIgoxtde0kNPVRN6q/Pn8X8NjeL9L15nBBpyGXVL2jJW3dEvwz7wk4E6IBq16WhKXlkl7W2EKzd0Duw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC6tcZcVPIQukTy2t0/bkHp7zNU2maL8/441/uTEYis=;
 b=GszxbshqzF1oaIwzrn8JXrYbLTtCAy5Sz7I7LJEgPyQNFgPBzibWttE1pXD439OrjJtmDC9e/VIDpO0G2OSHcRb3sYcavXm6h2fncZKnb1LfhZCmAN/YHp11TwXlLAHs4JQa8qcQ3OylrxhiMG+kXmo1c1LLM8m4M0rv2+vq1MM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 14/15] net: dsa: tag_sja1105: use a custom flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:14 +0300
Message-Id: <20200926193215.1405730-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:11 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a6b89e2-b322-4ed6-5ba4-08d8625301c2
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52959F84EE089914A0ABA118E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VE5G2OI6d3pDSbOdR1OHPN6BS/8XDn6TMZIwP4+9qU9rq3wxOV2QaNjdvCss1GHg480jjV63L4MOCPDLAIfW83hcgI55BTHOX5UPRAa7o8ZEW8JuxbjiF4h8xDOiAYiipaO44t+qg1WeqkS0hHm0jKSkvJ7Xg3gC4LFnKKKTCE3hzL62CNDskUuY2KRjKM8u4hMWoxdsrMH7OJN7OLSeZT9JXgnrYT8HpISppB406iiq5gYHdw7VSMsKWrCOrn+XJKk/5fQl3j6C/5cbee+TQxOa4Q28r9YLM8WtDtpMRXzyGwxH1KaPTNjyrQBZl6wnw4vbScs/UvKPE3yYJb4v1f2OY2qXRw1TMlIgJPxOjf17806IXCy0FWOKS5oy+dQzwr1SA/x2MN+izB/kQMGuGqgdhCtNHcixVe956zpXdqbflzaCJhMHwFRo6UBP32i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(4326008)(69590400008)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qaacjoo/hTeHpD1QM2+x/tATIc2paWFZj+ihPshoepkemZ5H61FmZ1bubnvKFuY66K4eBy87j+EwA/wkfVAdrTwtRWavtmYedT1KQXwhrddT3llGjJHkVpNH3ZyfFQL81HRNChrYKKaoK1xYO6y7NuK7VRuVNcbsm4adEMhHdNNT3P9VEbOK5usKxbjBC1re6hPh4aoZaqJLahT8F6rYxbju4uzcoVKA7/HqS6sgefvL4wXosGOpE5FoMknaen+t9iYKPZR1iUWr6d0qLp/AIyjoYPC+o6THG7EwFuJEItBhGDCB+vaQxpZk1TvtdBtthhW21DgvM3EsK3ubn2y6SNxhXepRaJ9353MKKPLceoq8cRKHIwHvFzgy8D4pQXkjByytjTE8HpdE50gy1NjRMMQoU5l1MqTbRkkHoJRDmW1GVKQ8WYKyy7vrkjaG2llQKA//1aNLlej7vTlrLGC3fb/K54tJ+SkbJyKBIx66SlyoJImYyxD0SVlYrNEXnsOGICZNUx/HYgm3myVL1cibe/nkvwrIYPPbKs7t5bdNl1vahRQVSckIdHEpM3hYqQKIhUlRy5qOvYJIg0u+f3qvDXA1FhSdGtCMXK3Q1zl3G/lFR7E4S/X0+qRUa7GFS0DdDoDVrNIIZQLmVXN9B/XH0A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a6b89e2-b322-4ed6-5ba4-08d8625301c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:12.5986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4Tpo49UXo2088ztKZZyvOF4eLzKvyUIXZOrjoYCrssh6ThSCKg9+jQsOdaSWm87YRus2ZqQd5SEkjleChqSIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 is a bit of a special snowflake, in that not all frames are
transmitted/received in the same way. L2 link-local frames are received
with the source port/switch ID information put in the destination MAC
address. For the rest, a tag_8021q header is used. So only the latter
frames displace the rest of the headers and need to use the generic flow
dissector procedure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

 net/dsa/tag_sja1105.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 36ebd5878061..50496013cdb7 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -346,6 +346,16 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 					      is_meta);
 }
 
+static void sja1105_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	/* No tag added for management frames, all ok */
+	if (unlikely(sja1105_is_link_local(skb)))
+		return;
+
+	dsa_tag_generic_flow_dissect(skb, proto, offset);
+}
+
 static const struct dsa_device_ops sja1105_netdev_ops = {
 	.name = "sja1105",
 	.proto = DSA_TAG_PROTO_SJA1105,
@@ -353,6 +363,7 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
 	.overhead = VLAN_HLEN,
+	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
 };
 
-- 
2.25.1

