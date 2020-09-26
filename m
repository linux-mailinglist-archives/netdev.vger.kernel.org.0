Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3883A279C2A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgIZTdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:19 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:63047
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730218AbgIZTdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+DQDiH+JWKRR/KOBM5qnW8VHh/l8M02EV6qed56GVLle46Gv27y7BFjbEgrnKpznZnfUhTLdGZdefzYHxpkv6paIkWLCF7D8YKewn/IpN9PeUk2YQcHKCTKqgYOmymvsVdv1LypzUb3tjHGr846XvrxLBJO2946XXed/PZyB7yGWCFinkZz6FuSHXhpTvxoWcNhzvjzQJfCdiVaEiO6vzFf9sVh5qyFgQt3XtXzpBq4qX0cT1WiA4gIsELnstmT3uOzglG51NqsA6ZYTRqb1/FSptZixnlVtdQiJWGpRzJU1VQc0tHs3Hj2MwDuYA0zu4dmFYdkXhhaVhuyxRtstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9iFRvn8q+IWnAyQgXvFfh8d12siKDC1nTZsItq4fDo=;
 b=RC4eeC4dXanKHs1QO6MtJ0xV1CAeDAQhN75ab3nF3jdSZvRC1grawr/wH4xMTPglwJ+oaBEMbpDMIOf1a/AciCbaM045alG4Md4/eHmtnhjo+uo5vscxaTMtCYrZz4ZYa99uifUd9oBeKhprO1yChcYRRp+glKnVjnCeQGHiIaJdA2xKHBOJB3lhgeOEz015C6WD4HU0fB2pJvA+jNmd8DqAdn7/IU6Ya+LqGxOwMWQ3Hm/G6X3tbJbarwfTs/dzd95EInsB1EQwDo95J9LexTP6Qj8f+4Kow87sPvCy4/UtkRZKSkt+/6yOSMrnBEyOyRKUzmmkTkpPR9H74D32QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9iFRvn8q+IWnAyQgXvFfh8d12siKDC1nTZsItq4fDo=;
 b=dfWKCK7yobMv/IwOQvIPd5ztV447dRAoUX0/k4FQcACSI+hZGG286PqAgJ8K8KiTRCJ2GmvYJn0ZUG46bAkG98RGHiqlmwUTo241Nk6b0fbUQHuRCF0Gnlogbzee1Ds/gVJVadjm+40SFCUEy6IPxhgVBS8eLo+sVbtIq/6Y2oI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 06/15] net: dsa: add a generic procedure for the flow dissector
Date:   Sat, 26 Sep 2020 22:32:06 +0300
Message-Id: <20200926193215.1405730-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:03 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0dffe0e1-ab6b-40f9-e1e8-08d86252fcc0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52957AA1DFE04AFFDE724A70E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /a23u/m8EOuV5Um9uyT9lhBOfr1vpbwuiXz+1zkjqWJ4ZhugzKhcCbrKEqo9LMcqw2d60J9PYS7piG3+Yc9Q+TyWrgswuuJ8oiFMJ6q4PlL+z6J9Ncm16AFjKP+EgtbiM9i0CgnO27f21VNkaztuMwsnNIGu07oqfj4juGIYNMO7dH2WpV7PuilJvYO7fYHf0RBaA/xwUziHgRO3VvSst78ejHBJdj5qTHXqL6UQB9q6hxqVTXMyiPny06qZZiy5NyFARk9rdoNSv/J1KajfxS9K2pKokwVAmfZ8SpwgtNwref/qZ8UONKeKB2xhG5OK+IIfu0U/pecC9TmD8+WPu/QkqKj4zrVXYL+CO3PY2RzkXVHPUKYUWL4CunJRsjjYg28tHiOIyztCcly1gsRxC9ZdydpKecCTCqr7LnVIm+es/aYdVGywrVfEw2Tk8miUOZ4WsiNEO2Y4rV8ua3oAJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BHn6muedHJN9apHAkEUblGO99YesX8HWR+dnGgcIeb6259rQ/mb3U8K7IE26n25C6scJs0AAXOpOtIHQG6tN2xrF6p+3VhUzqjygB0DKieANorFqDtaOmJhXJlM/ECrGuWSzhn63oLMImeqVWin6xobIgYK6Nh4O8d1u8COH1JsvD61EaAz8j4PTcOZ9X+UdrFejXjVe0SWdOEQAvOumMR8MYY7g5F50ZEy2xG4FgEft5RLg8xYdfXhaIt2pw1eqpTRruNis6Mwqq+1pgFM2DjTfw8dYpRI3hh4kfBDc1jkBpIm4v3Lx8ioImcz8vV7fGq/vfAgT1J+99euR6xJDmO4gEhk+Y9TDw+7jDAWaN2PGEF5UwGEIU9p4qCXKN+9OK1CinEUOBIN9MHi8fonQ6qQ+csLpFgMutawSWQYSVPlUYRqrN4vVl6UMWaKG/i7mdu0zDWArSJbu4O+uvJ0Iq24gMzcn8XfwiPemrNJnNsK/k4l0ZqI4hSYf4ckzbuVx8Gb6HhGaiyCicHi6UexckikTYd9ZJHMFkydIFX3RX/jGjOYsLnYELB1TOums0OTlVGvxnHeW666PRykYNvnaDVRtJ0uzzXH1NekOm2cuUVwaiWYkt0zNym7gLsqJ2ea1CWR4rRFN1rOn8PNUegxXbA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dffe0e1-ab6b-40f9-e1e8-08d86252fcc0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:04.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +tc1qTAkuGYewhb+J7RViKNqxvGokHhAyadCcXAdMp9mKU5ubFqO1k6gT/kI/gTZNuXT/r2iSB//BzahwItmKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For all DSA formats that don't use tail tags, it looks like behind the
obscure number crunching they're all doing the same thing: locating the
real EtherType behind the DSA tag. Nonetheless, this is not immediately
obvious, so create a generic helper for those DSA taggers that put the
header before the EtherType.

Another assumption for the generic function is that the DSA tags are of
equal length on RX and on TX. Prior to the previous patch, this was not
true for ocelot and for gswip. The problem was resolved for ocelot, but
for gswip it still remains, so that can't use this helper yet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Made this a static inline function callable from the outside world.

 include/net/dsa.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 98d339311898..817fab5e2c21 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -711,6 +711,32 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 	return false;
 }
 
+/* All DSA tags that push the EtherType to the right (basically all except tail
+ * tags, which don't break dissection) can be treated the same from the
+ * perspective of the flow dissector.
+ *
+ * We need to return:
+ *  - offset: the (B - A) difference between:
+ *    A. the position of the real EtherType and
+ *    B. the current skb->data (aka ETH_HLEN bytes into the frame, aka 2 bytes
+ *       after the normal EtherType was supposed to be)
+ *    The offset in bytes is exactly equal to the tagger overhead (and half of
+ *    that, in __be16 shorts).
+ *
+ *  - proto: the value of the real EtherType.
+ */
+static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
+						__be16 *proto, int *offset)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	const struct dsa_device_ops *ops = skb->dev->dsa_ptr->tag_ops;
+	int tag_len = ops->overhead;
+
+	*offset = tag_len;
+	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
+#endif
+}
+
 #if IS_ENABLED(CONFIG_NET_DSA)
 static inline int __dsa_netdevice_ops_check(struct net_device *dev)
 {
-- 
2.25.1

