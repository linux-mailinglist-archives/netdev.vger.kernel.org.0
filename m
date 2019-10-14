Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9621ED5D05
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfJNICD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:02:03 -0400
Received: from fd.dlink.ru ([178.170.168.18]:60580 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfJNICD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 04:02:03 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 3D6051B20A35; Mon, 14 Oct 2019 11:01:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3D6051B20A35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1571040119; bh=gdm2EEbYYtK0LBeSCJG8+CJkJpdqV/u9GSpbaHJHXVk=;
        h=From:To:Cc:Subject:Date;
        b=CrCPART2dsE7/fDiOhL8iGBGyfp1e8msUlVn45j7mWrcDNzdgVTSPlO25RKFpwdtB
         YQ22QeZoaLctDSwmRJjdG1ng730uqlN9gseD3/9mysbHTt4ISUXAe/Cha+yDqYJYW7
         CcMTdndFm60ZkVXL1RmCEPgprtc/UOTdcJK/Fc74=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 0A4B91B202B0;
        Mon, 14 Oct 2019 11:01:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0A4B91B202B0
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 492221B217C5;
        Mon, 14 Oct 2019 11:01:50 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 14 Oct 2019 11:01:50 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
Date:   Mon, 14 Oct 2019 11:00:33 +0300
Message-Id: <20191014080033.12407-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
skbs") made use of listified skb processing for the users of
napi_gro_frags().
The same technique can be used in a way more common napi_gro_receive()
to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
including gro_cells and mac80211 users.
This slightly changes the return value in cases where skb is being
dropped by the core stack, but it seems to have no impact on related
drivers' functionality.
gro_normal_batch is left untouched as it's very individual for every
single system configuration and might be tuned in manual order to
achieve an optimal performance.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Acked-by: Edward Cree <ecree@solarflare.com>
---
 net/core/dev.c | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8bc3dce71fc0..74f593986524 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5884,6 +5884,26 @@ struct packet_offload *gro_find_complete_by_type(__be16 type)
 }
 EXPORT_SYMBOL(gro_find_complete_by_type);
 
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
+ * pass the whole batch up to the stack.
+ */
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	if (++napi->rx_count >= gro_normal_batch)
+		gro_normal_list(napi);
+}
+
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
 	skb_dst_drop(skb);
@@ -5891,12 +5911,13 @@ static void napi_skb_free_stolen_head(struct sk_buff *skb)
 	kmem_cache_free(skbuff_head_cache, skb);
 }
 
-static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
+static gro_result_t napi_skb_finish(struct napi_struct *napi,
+				    struct sk_buff *skb,
+				    gro_result_t ret)
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		if (netif_receive_skb_internal(skb))
-			ret = GRO_DROP;
+		gro_normal_one(napi, skb);
 		break;
 
 	case GRO_DROP:
@@ -5928,7 +5949,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb_gro_reset_offset(skb);
 
-	ret = napi_skb_finish(dev_gro_receive(napi, skb), skb);
+	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 	trace_napi_gro_receive_exit(ret);
 
 	return ret;
@@ -5974,26 +5995,6 @@ struct sk_buff *napi_get_frags(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(napi_get_frags);
 
-/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static void gro_normal_list(struct napi_struct *napi)
-{
-	if (!napi->rx_count)
-		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
-}
-
-/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
- * pass the whole batch up to the stack.
- */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
-{
-	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >= gro_normal_batch)
-		gro_normal_list(napi);
-}
-
 static gro_result_t napi_frags_finish(struct napi_struct *napi,
 				      struct sk_buff *skb,
 				      gro_result_t ret)
-- 
2.23.0

