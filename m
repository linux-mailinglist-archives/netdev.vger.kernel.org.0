Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B442B90B3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 12:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgKSLJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 06:09:44 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:35266 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgKSLJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 06:09:44 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4CcH51163qzRp1J;
        Thu, 19 Nov 2020 12:09:41 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcH4V2sdZz2TTJR;
        Thu, 19 Nov 2020 12:09:14 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.113) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 12:09:14 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next v2] net: dsa: avoid potential use-after-free error
Date:   Thu, 19 Nov 2020 12:09:06 +0100
Message-ID: <20201119110906.25558-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.113]
X-RMX-ID: 20201119-120914-4CcH4V2sdZz2TTJR-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
immediately. Shouldn't store a pointer to freed memory.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
---
Changes since v1:
- Fixed "Fixes:" tag (and configured my GIT)
- Adjusted commit description

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

