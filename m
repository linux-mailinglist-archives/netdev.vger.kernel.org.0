Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28522A20FF
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgKATRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:24 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727009AbgKATRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0WquFRY/DtLFFu5zGFGJQUjjmamapg3RJJ2Dh1mjN+lWmQPIIsA0m+DAr8HXiuu/ahRKhb/wc2dT+cmnYkfvokgQXwCEOw/ggRPYJxIPG2mfpCVCHTgpir9eNCSoYeWqIXZ6eVA7MZGPKIc2aqH8wsbYqirGrf2s8z3T4cScC1mm+RuD9sr2MhDzWcajwnWEiSpT+ZmPI2LscQxy+jABdFRuBsqJpAqHi9yFlBDcCRE+4HtFuNx91Nvbk4D9CnrPO27PpwEjP0OQmEncDsa8r5zdEaM5s/61x4NxlGfYiUvPbO0HPqkVQU2VT7O2Omb1t3c9Unf6i+eUEJkmnQ74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CkLLcr1IE0AEyDhYiBHH5b18feuGU0ovuoU9ApuDSI=;
 b=AqzxwEMIOr3TAcT+qGXfsfuUGxlSLUJDiYUGOslxeyDcfgo3SqAUoSVo6NtpzcdInlEb++lYIFjvN/cm54feYD69BSH43FtHBYF3c+BOv1xTRPscHQEDWRCFNA0NtJpI5/bhLXm6zBpA7GLN6S9nka2vqdAYhNn/4i+JTlciKmBEL9so6M1tcgRfFCtcygKcl61nbz9cqALpl8e+U/GWNZQY+KucRO8sK5sgZTQUglXCeHaRDscP93bhOPGtEYfdgro1hIuquPzkC4n67Rxl6GzJo2FjibuiSBmEnouqQ8wgPkrHuph9VPGouBx/VrWJF+yhelYvkrxFGiwvz6X91g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CkLLcr1IE0AEyDhYiBHH5b18feuGU0ovuoU9ApuDSI=;
 b=ZYuxfBtJ9C62FOFNNb8KT+YGywOQoFPM0Fai8rDKAPljvOOH1iZnk6/lT5n5oOPXfRok4U4mxdFWiA3sGWJSs9u2eIX4wQkW5j1RKgSDZr23jaYXmM2wBDLoOXN8rnylt09Zv71TPrVnOceB03reTB5hiXgpKWT2UkvlQPjd3XM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 net-next 11/12] net: dsa: tag_gswip: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:19 +0200
Message-Id: <20201101191620.589272-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3f7eb0f-15a4-4347-e5ae-08d87e9ab479
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286182D80D4CE0D284864872E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+ghVOCQQr+68WNwD0HCakoMPxp0hI+EBBkQz7lM49qGB8zoodvRAYmfkCHnwEPLRJQCNRxoTUMXr3SPegvW7KOLRcNoDwggLK33UhPR35itZpXalBOLBIowG//CD8DW/wiwqpOoHNEfjwmGdYagPPO3yXDrQe+xJJkmcV7rI4rJwE9fb1HjOZTsvTXDGkCVK9AlpOwyh7fjf5kKdcT+f/b8IoEmmdajUe75VlcRnp5bhZJMiH+yp2kDv8JrzEveryFe9p7F3Q76O+qgTx1dpb9XBRsovrUaKwtujD1wHmzKnxtnQPj4PEuHFodAMrxYWYFvpyBaSNNMMFSJWqC2XhZcnMrr3mbLjliT6MSyBlJe7QL2pUlDN3wXGgobP35O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: H4589yJcJZSVCm4UY3FQyQlmlrELbCpWbGgGIRfQZrK1pAVFrEmsEP/NoYfqbnaaRlp/vJoEyB6kgbEk/blDqdtj3py2Ml+9xyI8vi3hSFeVailvs798bZnju5W23PywLjeGPbnPowNHqUBYVJMNRgLPYYKJaD8KtWP6LuaURbuWKXB8Z4EOLu3VuXjC+iGfsd3elj1Bz/vGtRDnQG4kuz328+YR+7n7ePnzv7wo7CQaJzJV65bRKYbfuPn1DhIvVtIlbL/dvV0X7EyPTIi/03tstH1f+XR2y1mIfJ9SiKTahJ+dWRzvZ1hZCnAvMHs1tqYwSYQUXU/hS9kMVd7Zree95Nb1EcjB8kjEO/urnK3Gas+e1I7BRxs5TMxHke7ITFU0Tz2bbLNrkzmOFb+5XglQkT69+J+XbnzHvYL3qPyjS5b7fqjM5w90uHiA8rQ/M8ycVL5189/UuSkPYrLokThdO3Q48aQOlvGjkVcaoKtbdUBydhmVTR4Ks3T/6+Bo/WJRtqy3o3dMb4cx1Ze3qIv1JG3lD5D1c7mAbzXLtwlHI6QE8I88S0WtKbPoTdxY8/BYYGeftLxEhUVg6B2ZE0Y5U6e/rPhzQsDYdx4noyRKqmaOGzMRu8rNR9xk23WL0j38u/anO/Aw6yc06us4gg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f7eb0f-15a4-4347-e5ae-08d87e9ab479
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:59.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfxf14n7tRKRdhXClvYRVFMMdiIXl04adwf3DiqVZj8Ht3RDLsgPTf5Dsagaob6swrmVAbHCh3MenVa3MYtQPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

This one is interesting, the DSA tag is 8 bytes on RX and 4 bytes on TX.
Because DSA is unaware of asymmetrical tag lengths, the overhead/needed
headroom is declared as 8 bytes and therefore 4 bytes larger than it
needs to be. If this becomes a problem, and the GSWIP driver can't be
converted to a uniform header length, we might need to make DSA aware of
separate RX/TX overhead values.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_gswip.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 408d4af390a0..2f5bd5e338ab 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -60,13 +60,8 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	int err;
 	u8 *gswip_tag;
 
-	err = skb_cow_head(skb, GSWIP_TX_HEADER_LEN);
-	if (err)
-		return NULL;
-
 	skb_push(skb, GSWIP_TX_HEADER_LEN);
 
 	gswip_tag = skb->data;
-- 
2.25.1

