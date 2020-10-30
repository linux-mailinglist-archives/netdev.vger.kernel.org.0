Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C829FABE
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgJ3Btp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:45 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbgJ3Btn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPYduQyh/JtZJ9wSaJBIz/ok38Sh8c6HGE+m7fZSRlrK1WH/Ve7Z/6/T8vSOfg2Z1N1DegzzqWrPvYVkNVW73Vz0A2kcNtECCGi2bnMqSvLfuWGuFs5uY/meCZgBS6SNsIl3PPaBUTceAxijTB7xdx6J3NXHum7tOp+MmfrORPTQzsiIUoWzlyl7Qqzo5HSui9sKFz61IGQJ5/+PK88fq09mU+GJN47tW0Pi2NcGJmnuTsixB3c0Pf15lkqQj0Wn9Joctg6Qy0cO7G0n3Yd8IouzpuOatncXtfPY4Ck7SDWU6suoTflXlBTK7f0x8BdqeUjuNQA/ArcPLGYHXP9Q1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/V2xbcFfO3V9sh2m93gUqyr/97y4+HABLtIc9qKbqg=;
 b=Atk1s+Pn86jq2gZoCHBLNlaAR1V05En99toJu5+2T79jxfI6a9VVmYxfNPV+/v6ezqpJ57FRS6krtv4yoi2YzACZ7Qz7n2uObKZY/ncajR8klHMjnbh3wCA2Lhv5RjGz6+AwEGRApTGB20jXvDKUSYZl16e/mPhnetWsKYGMeD8kNEBKlGm0njhWrQORVNo/dUNfWFBNlLImHWd+xgv2oITCecLM1jO0Bdp/MDjONhZ5BODmMYpDqP6Am7uXpf2uKlwH3/BKC0qX8KTslNmuCCpj+/K1GFaSbJhtAruqjnCeCumG0hlyG/wx7Nx4izm2uefosFBofBYHNyfwo8xM0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/V2xbcFfO3V9sh2m93gUqyr/97y4+HABLtIc9qKbqg=;
 b=sq9hMUluwW81Jqd+87mImoAu3jqKLQ3baX6WwiG3NJNplTaiMYs4GpfwSyD/KIzhedi5SFyIgwTaLZTOuoGBPLP9jRw4ARvqOZF4NjF9Q/JvbXt9sCIJXjtePLQiJKzrZAkBhbHcacmcJZjoVp6j41I7pRtZ6DTod4Pgb9crKTk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 07/12] net: dsa: tag_lan9303: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:05 +0200
Message-Id: <20201030014910.2738809-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d034e956-fbff-4b1c-49ed-08d87c760d57
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509A11A385BBCB17925A3CBE0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Su4/9Qj5GIwenTCHtRpvUNwNZarjRR+i9jbIsU8tdY4MGbSzA++CPTqIBMTteKO8Mh/UOPONapwlNs+vI9JMvXom73brikDKzWjVcVz5tu2Cftl8YaSPxMpeZhAr36WV7p7xOMKm1pMjsQihRXRr1QAyv5FwTzqNex+YiVqYy6O9H8U3WHbblauCrjPFJlUxO7/iXtYTzy3M0RaRlkqN93GJ6E0LTMl25qvaFFC+A0Zq6loBhpSEw6Sxs0JeOB8M5XJOspVz4Yrp02brP8JehvmiIzABEnpwKtfLodUmmjKRbfT3ThpfNXGxc1k2PBoqqK+z6GzMzyFwOycb+++78phRpbTzhrjj6mKu7Sr/KNwKSWJznDsywL+Vd0mZjtOT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4ZytYzDNdv9EszQJKrWG3FV9IkDPxennVxi/OpPENTujF8UxzvH82hV4AWq94f+4QVpcP5fhkvyqMt74bD55F66P0QaPVCBPBLDx0lYDCFTE+KgA5482A/PxvAViQc2su8Te29Ep/8p5HgHYbVVyqNn8ToLBxk9nvLX/iQ37t7BHrw8cfwzT7Vy7i+//rpDcm/7fDKrMwJ3WfE7lrVygfaXfA06h47oih2WBShsxQxPkmR/NwX7spR+4ellCG1SaL/4pMcMo0DA7JLHQvNJP/NdagVBC9osdzLtNulZIAbCYN6RopzgwboZZTeh0Nyz7M9DVEa9SRhPB2qBpvrmya/il0EMCLfY/8UgM6SXaZrUyi2TMzJJh+MMxrE/v4P4W0Ybw/0MJ/5YjN12amOG1z7/SOZa4dNacsfGaCw+AqB6OCwqx5V2jOl/jvnsaHB/h37NrDMvOKvkkdx7l8BvoP8gNZtWqyiBWTARvWp/Iw1KtGIS+K5pxdcxzYN+lIZkyMTZJ3JVnRonFG17MNsUqxYbm15uz/QGcUQPb6zx0xeva0lQPfxloUCp8gmc7vAejQT6DqaKPXpxVASC4fgopA7Hfu8TaNcD/wY59D7m8qSAp7sbQ5DjDWxil+ThLOp5z11hBQlT88tUAT6rqzQnNuA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d034e956-fbff-4b1c-49ed-08d87c760d57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:34.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14I5+5zkI9qW6qQePh1fmssYyPzlQglVWQAj3op/1pcBLkLKgubLRPdLhL+073NvactilVkM8QY84gfdhI3XZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_lan9303.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index ccfb6f641bbf..aa1318dccaf0 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -58,15 +58,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *lan9303_tag;
 	u16 tag;
 
-	/* insert a special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	if (skb_cow_head(skb, LAN9303_TAG_LEN) < 0) {
-		dev_dbg(&dev->dev,
-			"Cannot make room for the special tag. Dropping packet\n");
-		return NULL;
-	}
-
 	/* provide 'LAN9303_TAG_LEN' bytes additional space */
 	skb_push(skb, LAN9303_TAG_LEN);
 
-- 
2.25.1

