Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9080428E440
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgJNQSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:18:14 -0400
Received: from mailout04.rmx.de ([94.199.90.94]:37669 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbgJNQSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 12:18:14 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CBHdZ2sXGz3qtkv;
        Wed, 14 Oct 2020 18:18:10 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CBHcn4nwJz2TTL4;
        Wed, 14 Oct 2020 18:17:29 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.83) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 14 Oct
 2020 18:17:29 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net] net: dsa: ksz: fix padding size of skb
Date:   Wed, 14 Oct 2020 18:17:19 +0200
Message-ID: <20201014161719.30289-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.83]
X-RMX-ID: 20201014-181729-4CBHcn4nwJz2TTL4-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__skb_put_padto() is called in order to ensure a minimal size of the
sk_buff. The required minimal size is ETH_ZLEN + the size required for
the tail tag.

The current argument misses the size for the tail tag. The expression
"skb->len + padlen" can be simplified to ETH_ZLEN.

Too small sk_buffs typically result from cloning in
dsa_skb_tx_timestamp(). The cloned sk_buff may not meet the minimum size
requirements.

Fixes: e71cb9e00922 ("net: dsa: ksz: fix skb freeing")
Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 net/dsa/tag_ksz.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 945a9bd5ba35..8ef2085349e7 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -24,7 +24,7 @@ static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
 
 	if (skb_tailroom(skb) >= padlen + len) {
 		/* Let dsa_slave_xmit() free skb */
-		if (__skb_put_padto(skb, skb->len + padlen, false))
+		if (__skb_put_padto(skb, ETH_ZLEN + len, false))
 			return NULL;
 
 		nskb = skb;
@@ -45,7 +45,7 @@ static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
 		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
 		 * skb
 		 */
-		if (skb_put_padto(nskb, nskb->len + padlen))
+		if (skb_put_padto(nskb, ETH_ZLEN + len))
 			return NULL;
 
 		consume_skb(skb);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

