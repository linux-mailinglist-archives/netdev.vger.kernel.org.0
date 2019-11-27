Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A82A10ACC7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfK0JnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:43:22 -0500
Received: from fd.dlink.ru ([178.170.168.18]:44698 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfK0JnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:43:21 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 1C6AF1B2130C; Wed, 27 Nov 2019 12:43:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 1C6AF1B2130C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574847799; bh=f9ywakjd6DOZRN8wGbpkHEur4i2IZ2IEiXwypzRgpnc=;
        h=From:To:Cc:Subject:Date;
        b=r5KR6a7KIsKaZV74ppiKTWqepDXWKqopiyWIK+GruJsZB+zpTGG4t8sc+iTdRa8zd
         oMkzFBIWdeXkUz9ZLNNNFxikmktzAVH5GQvy4UaRm3ReWCWbMUhl0H01x7rSl2X580
         npAASEG+sIUXrXAnRbmPwLHUVU9/xQdXHM1eKiYM=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 418B71B2128B;
        Wed, 27 Nov 2019 12:43:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 418B71B2128B
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id B93291B22678;
        Wed, 27 Nov 2019 12:43:05 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 12:43:05 +0300 (MSK)
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
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "Kenneth R. Crudup" <kenny@panix.com>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling
Date:   Wed, 27 Nov 2019 12:41:23 +0300
Message-Id: <20191127094123.18161-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()") has applied batched GRO_NORMAL packets processing
to all napi_gro_receive() users, including mac80211-based drivers.

However, this change has led to a regression in iwlwifi driver [1][2] as
it is required for NAPI users to call napi_complete_done() or
napi_complete() and the end of every polling iteration, whilst iwlwifi
doesn't use NAPI scheduling at all and just calls napi_gro_flush().
In that particular case, packets which have not been already flushed
from napi->rx_list stall in it until at least next Rx cycle.

Fix this by adding a manual flushing of the list to iwlwifi driver right
before napi_gro_flush() call to mimic napi_complete() logics.

I prefer to open-code gro_normal_list() rather than exporting it for 2
reasons:
* to prevent from using it and napi_gro_flush() in any new drivers,
  as it is the *really* bad way to use NAPI that should be avoided;
* to keep gro_normal_list() static and don't lose any CC optimizations.

I also don't add the "Fixes:" tag as the mentioned commit was only a
trigger that only exposed an improper usage of NAPI in this particular
driver.

[1] https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
[2] https://bugzilla.kernel.org/show_bug.cgi?id=205647

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a4d325fcf94a..452da44a21e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1421,6 +1421,7 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct napi_struct *napi;
 	struct iwl_rxq *rxq;
 	u32 r, i, count = 0;
 	bool emergency = false;
@@ -1526,8 +1527,16 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 	if (unlikely(emergency && count))
 		iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
 
-	if (rxq->napi.poll)
-		napi_gro_flush(&rxq->napi, false);
+	napi = &rxq->napi;
+	if (napi->poll) {
+		if (napi->rx_count) {
+			netif_receive_skb_list(&napi->rx_list);
+			INIT_LIST_HEAD(&napi->rx_list);
+			napi->rx_count = 0;
+		}
+
+		napi_gro_flush(napi, false);
+	}
 
 	iwl_pcie_rxq_restock(trans, rxq);
 }
-- 
2.24.0

