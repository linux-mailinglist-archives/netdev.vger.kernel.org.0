Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7BF29FABC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgJ3Btm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:42 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgJ3Btj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clsR3CBYaNaFX+vteVtSC3wwLHDlSw+IK00zmoweVKOFaMjFLKbLBmbWW0O+jsbpT9HdpzoIko+79i4xMjVHjcvcB/rqBmRI8gCy5Bg22rnDZu4SDtgB4fKGACXc61/mWk+1MWB6sKg9asiTveSley6TWFkCgzN3f8NOxsr6qfRg4L7L5RMZWpxWKhVn3bl0O1MCubaAnYxZt0TOfPYMhUysAvquc0EkAxPAAYzVaJ7kBeW0pbIaD79iGTpRdd+DuXkWySKhYky7+jJnz5dRgks8tQrQvNiTLRhFJN5AC635DiZ6YW1a1TdEfu4THkCSitBC8b2gs/t4psPFhPgDkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5Inlop7MVTtw2qSaH4auIK1dW6ItrO8k2HBPppeiOA=;
 b=oV3e2KRd6LhlQ23An6HRgAVBOoHlMrqsV5fvj8S4UoYkK8/cetmb605HqB+gIzTQIj2b7Eqf0Mc9SdpQUAOQL0YzzHuUcKDz72t8ZD/oTyG2o5W/FjKK35rwoAxT5aM8HWTin1mg3JKA99yihV0jAfXKX65InMEv1fCMLvDM7ysc9u651g+nK+Y469a9YCrtzN4rllO2b8cGooHAuVMwZFh7LVnwKl3H/Euqf8Y2LZ4cbkTMYdtjLhnRNwtQ2JgTiNhD3//wNG3dDvKICYPrRCvwhV5NqHMhO3OFv+LPQvrlY9yNFEHlyBJcJ0mHgvz70QJw1BUryUd3SLTjDGsO5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5Inlop7MVTtw2qSaH4auIK1dW6ItrO8k2HBPppeiOA=;
 b=nSN4oUfYZElRjiqm9lxlC1oOpPP6srDAw3nRu37qVRHjh8kNmC/DTTneH4KIoSAu15mTCv2Ew4c6X6lD249GLL2nGKao0qtQfsyUUnS5GBrxbvchumpTbeW9c7UChuVhuniZqNfOSY7xYMtbYEBmvZDlbWkkKjOWbHfrSJFD1QI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 04/12] net: dsa: tag_qca: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:02 +0200
Message-Id: <20201030014910.2738809-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 201101a5-ca91-4f08-1b55-08d87c760b7c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509245527338340AA07C3D7E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jK9xpBTHTwWRmxaWZ0JnMiOhnruOvVgfCQxt2aoDD64FPOywqxoTvm54gXlkZU0wCl0jyEhpJf146fzEwz4yVsJu+Q7nA+3SEXN2oQ/+XJul+8BU8M9kWTA6IdQG2ICt26DLdNb4Asw/uWRdw97YZyvcm74M/w5EiurAv1hNnQPpu6C+Q6lDymaFzD0YB5MUxWAXTFQ1VQynbOLVDbKjuPngusza+Ig+d6/FK4w4gxUzLCVpsmJI3jPelVqoJzya0OpgkorEXl9zy0xTyubwqJiwuhG5YGBiABBrZ5MofR0dkfJlrWkCt/dQhe3Z5rj2FAOX1XJkBvZycV/JHeNvseFuv8hOM7alRaMJYKQLg/Yg7ofq5Aa0zoIWeF7EJ38
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zsAGRmg8k06RG6Vgx7gzZr5KU60+986KUpsFscrD3XT06TNC1XjerrpWFN6GofXVVfzGBxIwpPHfjRC32hgHmkjW8AOci2F5MlVLgWdhpk+twOvDmmp8UpZYjxZeGNHgzTRgMqq5swIJJXfHls3cOwz+OXl3LqzMEnG2TDD1VmfWILLg0OutuaWJPUiPLHUe/CdFA4Ed9jXJnZOaT6bzXFIAUJswF7xxFdxzdAseRWZO32dvylFnK2L621SIx9hJ8p3ZBN2mLB4wKLBRmkLIbZZS2MHJqEtWgrWapRwAWcsLZNYxtxc0RDEs/IugDq8m/IL3w8YTFoR+MK3LDp6CsVIm96MnWMS/R8DcCqKq2E4jFLs2PP7B4GyJ/Tih+u//esEziltjhT8cUrKJQHpWouXfhC5T42JqRITdrNbO6QWQXaRR3fE0QdhphBsMSYHydaCBH0XyADCzuEywEMZjasdreCuMo6dV/6qRqSudqOKdVWiUpc8/htQkxx5tEvNJV6UMbv4SHcRLkU60JyTYns8tDxA/LuZXibAkYbfArUA2pfNBKGNIp/WgDMRH8ULncOvfDHMUVufl/+JV7omxhZIaWs8PSlDrI4iruVNYEHlMMsP+2AAForCer+BsZOundz5Tys7Mt6/WHGm1gNIQwA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201101a5-ca91-4f08-1b55-08d87c760b7c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:31.5472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WcTdpLiE0UYvy1DzKQO1+C+lxNEAsUNwyPriGCFzw3sygrJLh0FKWmkzt5Q//4zsFr6C1N6B1OpqhJceAZThQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_qca.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1b9e8507112b..88181b52f480 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -34,9 +34,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
-		return NULL;
-
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-- 
2.25.1

