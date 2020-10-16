Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE828FF39
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404705AbgJPHgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:36:24 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:43981 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404600AbgJPHgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 03:36:24 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CCHyX0PknzN0wd;
        Fri, 16 Oct 2020 09:36:20 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCHxl2DmGz2xpY;
        Fri, 16 Oct 2020 09:35:39 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.49) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 09:35:38 +0200
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
Subject: [PATCH net] net: dsa: ksz: don't pad a cloned sk_buff
Date:   Fri, 16 Oct 2020 09:35:27 +0200
Message-ID: <20201016073527.5087-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.49]
X-RMX-ID: 20201016-093539-4CCHxl2DmGz2xpY-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the supplied sk_buff is cloned (e.g. in dsa_skb_tx_timestamp()),
__skb_put_padto() will allocate a new sk_buff with size = skb->len +
padlen. So the condition just tested for (skb_tailroom(skb) >= padlen +
len) is not fulfilled anymore. Although the real size will usually be
larger than skb->len + padlen (due to alignment), there is no guarantee
that the required memory for the tail tag will be available

Instead of letting __skb_put_padto allocate a new (too small) sk_buff,
lets take the already existing path and allocate a new sk_buff ourself
(with sufficient size).

Fixes: 8b8010fb7876 ("dsa: add support for Microchip KSZ tail tagging")
Signed-off-by: Christian Eggers <ceggers@arri.de>
---
I am not sure whether this is a problem for current kernels (it depends
whether cloned sk_buffs can happen on any paths). But when adding time
stamping (will be submitted soon), this will become an issue.

This patch supersedes "net: dsa: ksz: fix padding size of skb" from
yesterday.

 net/dsa/tag_ksz.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 945a9bd5ba35..cb1f27e15201 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -22,7 +22,7 @@ static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
 
 	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
 
-	if (skb_tailroom(skb) >= padlen + len) {
+	if (skb_tailroom(skb) >= padlen + len && !skb_cloned(skb)) {
 		/* Let dsa_slave_xmit() free skb */
 		if (__skb_put_padto(skb, skb->len + padlen, false))
 			return NULL;
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

