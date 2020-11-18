Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8112B8111
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbgKRPo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:44:29 -0500
Received: from mailout02.rmx.de ([62.245.148.41]:45927 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgKRPo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 10:44:29 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4CbnDT1h6wzNmql;
        Wed, 18 Nov 2020 16:44:25 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CbnCy3Xp7z2TTN0;
        Wed, 18 Nov 2020 16:43:58 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.25) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 18 Nov
 2020 16:43:58 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next] net: dsa: avoid potential use-after-free error
Date:   Wed, 18 Nov 2020 16:43:35 +0100
Message-ID: <20201118154335.1189-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.25]
X-RMX-ID: 20201118-164358-4CbnCy3Xp7z2TTN0-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
immediately. Storing the pointer in DSA_SKB_CB(skb)->clone anyway,
supports annoying use-after-free bugs.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
---
 net/dsa/slave.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ff2266d2b998..7efc753e4d9d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -522,10 +522,10 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	if (!clone)
 		return;
 
-	DSA_SKB_CB(skb)->clone = clone;
-
-	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
+	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type)) {
+		DSA_SKB_CB(skb)->clone = clone;
 		return;
+	}
 
 	kfree_skb(clone);
 }
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

