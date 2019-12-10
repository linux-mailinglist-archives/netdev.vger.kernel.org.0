Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25015119439
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfLJVOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbfLJVN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98428208C3;
        Tue, 10 Dec 2019 21:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012437;
        bh=IuYOpPvSdHmvCmlPfdxsAUVModI75wSqdZHZvJ1mZGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWJOgr2oWaOQE+/kCxf9tm87GMUUGBi8Eb/YgLul1IYduDLUs7FWyhZLDUD9guVoG
         GawsH8HPNYUbyOaK99uAwy3twleBXXjTL6LAyzc0YKt5SXPCTymA+NCvqN7lxEwpAF
         dgjczuEApEw490qFFAXt7vIUV/NCO3Y0co4AIfLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@dlink.ru>,
        Luca Coelho <luciano.coelho@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Edward Cree <ecree@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 349/350] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling
Date:   Tue, 10 Dec 2019 16:07:34 -0500
Message-Id: <20191210210735.9077-310-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit b167191e2a851cb2e4c6ef8b91c83ff73ef41872 ]

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
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Reported-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Tested-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Reviewed-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 19dd075f2f636..041dd75ac72bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1429,6 +1429,7 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct napi_struct *napi;
 	struct iwl_rxq *rxq;
 	u32 r, i, count = 0;
 	bool emergency = false;
@@ -1534,8 +1535,16 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
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
2.20.1

