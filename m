Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0022E1609
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbgLWC4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbgLWCUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF347225AC;
        Wed, 23 Dec 2020 02:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690036;
        bh=zktbvyeBRJW9xPFIDbQduVFW7ampvIQ6IY6hQF+Inwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHnJ6tJdbOICIKOaz4b/P2gQYlRLZVq4TTpKXQQ9gHOn0RqiqhOf/mZQuP8tnsPEH
         1WlauuFVN+bcU1Z17ktK4hgKGucoXUy5Et7pSZTLTRkXxaLFcIA61IvEX+Q1sOixvF
         4o7WUBQT1QLsV9gBzbYUDLambI5sgDPZlF2eu2sqTOy4wCZD4PyFiFp7cX4gTSYxpA
         7D1pvjjXbjFGly26gWeee2bi81XYL0BeQQWPLOhEe+8O853Rc6cC+66H+aRyWqJqAd
         02XWmHuXdaEeVI8W7lh9z2fJrDMsJd2gaCrJ336pG9lY1OqmXIgCdFyXoNS/3f7zvd
         uep3Ws/80LGpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 111/130] iwlwifi: mvm: validate firmware sync response size
Date:   Tue, 22 Dec 2020 21:17:54 -0500
Message-Id: <20201223021813.2791612-111-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b570e5b0592a56c5990ae3aa0fdb93dd9b545d43 ]

We send some data to the firmware and expect to get it back,
but we shouldn't really trust the firmware on this. Check the
size of all the data we send down to avoid using bad or just
uninitialized data when the firmware doesn't respond right.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.a5a8173f16c7.I4fa68bb2b1c7dcc52ddd381c4042722d27c4a34d@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d0bfcee59a3a7..545a84e08816e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -763,10 +763,18 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rxq_sync_notification *notif;
 	struct iwl_mvm_internal_rxq_notif *internal_notif;
+	u32 len = iwl_rx_packet_payload_len(pkt);
 
 	notif = (void *)pkt->data;
 	internal_notif = (void *)notif->payload;
 
+	if (WARN_ONCE(len < sizeof(*notif) + sizeof(*internal_notif),
+		      "invalid notification size %d (%d)",
+		      len, (int)(sizeof(*notif) + sizeof(*internal_notif))))
+		return;
+	/* remove only the firmware header, we want all of our payload below */
+	len -= sizeof(*notif);
+
 	if (internal_notif->sync &&
 	    mvm->queue_sync_cookie != internal_notif->cookie) {
 		WARN_ONCE(1, "Received expired RX queue sync message\n");
@@ -775,11 +783,22 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	switch (internal_notif->type) {
 	case IWL_MVM_RXQ_EMPTY:
+		WARN_ONCE(len != sizeof(*internal_notif),
+			  "invalid empty notification size %d (%d)",
+			  len, (int)sizeof(*internal_notif));
 		break;
 	case IWL_MVM_RXQ_NOTIF_DEL_BA:
+		if (WARN_ONCE(len != sizeof(struct iwl_mvm_rss_sync_notif),
+			      "invalid delba notification size %d (%d)",
+			      len, (int)sizeof(struct iwl_mvm_rss_sync_notif)))
+			break;
 		iwl_mvm_del_ba(mvm, queue, (void *)internal_notif->data);
 		break;
 	case IWL_MVM_RXQ_NSSN_SYNC:
+		if (WARN_ONCE(len != sizeof(struct iwl_mvm_rss_sync_notif),
+			      "invalid nssn sync notification size %d (%d)",
+			      len, (int)sizeof(struct iwl_mvm_rss_sync_notif)))
+			break;
 		iwl_mvm_nssn_sync(mvm, napi, queue,
 				  (void *)internal_notif->data);
 		break;
-- 
2.27.0

