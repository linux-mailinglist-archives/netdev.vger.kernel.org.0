Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3443B1947
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhFWLwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:52:10 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:55218 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230291AbhFWLwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:52:08 -0400
X-UUID: 64b6003317444b0bac0b4a68d87a33a5-20210623
X-UUID: 64b6003317444b0bac0b4a68d87a33a5-20210623
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1990726428; Wed, 23 Jun 2021 19:49:49 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 19:49:47 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 19:49:46 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
CC:     <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <zhuoliang.zhang@mediatek.com>, <kuohong.wang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH 2/4] net: ipv6: don't generate link local address on PUREIP device
Date:   Wed, 23 Jun 2021 19:34:50 +0800
Message-ID: <20210623113452.5671-2-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210623113452.5671-1-rocco.yue@mediatek.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PUREIP device such as ccmni does not need kernel to generate
ipv6 link-local address in any addr_gen_mode, generally, it
shall use the IPv6 Interface Identifier, as provided by the
GGSN, to create its IPv6 link-ocal Unicast Address.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 net/ipv6/addrconf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 701eb82acd1c..1bfa7eca1314 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3339,7 +3339,8 @@ static void addrconf_dev_config(struct net_device *dev)
 	    (dev->type != ARPHRD_IPGRE) &&
 	    (dev->type != ARPHRD_TUNNEL) &&
 	    (dev->type != ARPHRD_NONE) &&
-	    (dev->type != ARPHRD_RAWIP)) {
+	    (dev->type != ARPHRD_RAWIP) &&
+	    (dev->type != ARPHRD_PUREIP)) {
 		/* Alas, we support only Ethernet autoconfiguration. */
 		idev = __in6_dev_get(dev);
 		if (!IS_ERR_OR_NULL(idev) && dev->flags & IFF_UP &&
@@ -3352,6 +3353,12 @@ static void addrconf_dev_config(struct net_device *dev)
 	if (IS_ERR(idev))
 		return;
 
+	/* this device type doesn't need to generate
+	 * link-local address in any addr_gen_mode
+	 */
+	if (dev->type == ARPHRD_PUREIP)
+		return;
+
 	/* this device type has no EUI support */
 	if (dev->type == ARPHRD_NONE &&
 	    idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_EUI64)
-- 
2.18.0

