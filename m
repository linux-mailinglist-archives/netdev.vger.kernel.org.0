Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4E5119DCE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbfLJWk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbfLJWcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:32:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C49D21D7D;
        Tue, 10 Dec 2019 22:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017126;
        bh=+A2phvID+gqjmzb3uCb5NALuzM4a0PEWBErOw+JcLQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK+ErQLAUb4Z7XeXRxdEIzL6ALkCDAwGX9M4qdI3XGIp9aZVGN1BuyhB+s2Szb/TE
         nveBSkl1jwPi41wCbx093IJ8n2T+hh+imVhzw6wpP1nsK0KgmciwHcQc7BhIvukt7o
         I80vzMVLFoMKhlvgF0tp56eKRB+4V+2m24G6hLAI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xuerui <wangxuerui@qiniu.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 76/91] iwlwifi: mvm: fix unaligned read of rx_pkt_status
Date:   Tue, 10 Dec 2019 17:30:20 -0500
Message-Id: <20191210223035.14270-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Xuerui <wangxuerui@qiniu.com>

[ Upstream commit c5aaa8be29b25dfe1731e9a8b19fd91b7b789ee3 ]

This is present since the introduction of iwlmvm.
Example stack trace on MIPS:

[<ffffffffc0789328>] iwl_mvm_rx_rx_mpdu+0xa8/0xb88 [iwlmvm]
[<ffffffffc0632b40>] iwl_pcie_rx_handle+0x420/0xc48 [iwlwifi]

Tested with a Wireless AC 7265 for ~6 months, confirmed to fix the
problem. No other unaligned accesses are spotted yet.

Signed-off-by: Wang Xuerui <wangxuerui@qiniu.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index b78e60eb600f1..d0aa4d0a5537e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -62,6 +62,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <asm/unaligned.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
@@ -289,7 +290,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
-	rx_pkt_status = le32_to_cpup((__le32 *)
+	rx_pkt_status = get_unaligned_le32((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
-- 
2.20.1

