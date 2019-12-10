Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDCA11950B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbfLJVSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfLJVMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA30214AF;
        Tue, 10 Dec 2019 21:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012364;
        bh=fm/+zOAPvpV2Lo3ggKjbrQ+9kbQpuyNZSNduvAMvOz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AV4ei9l4Y9tS4LZkjK7rfnJjfaQVpak1WiB/KoNeEF6wkpA+YWTJasTfGFrUm8jOn
         O085g47/xmKI4VqANS/Gb0142j1hvGZuTgs1RMkwFYMWOfNNcdzI5x4rAEUBUx3Xei
         Sp5Ntm0WEz/iYUvzykaWB2bxmjQ340ZkiAwiu1Wk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xuerui <wangxuerui@qiniu.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 291/350] iwlwifi: mvm: fix unaligned read of rx_pkt_status
Date:   Tue, 10 Dec 2019 16:06:36 -0500
Message-Id: <20191210210735.9077-252-sashal@kernel.org>
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
index 0ad8ed23a4558..5ee33c8ae9d24 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -60,6 +60,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <asm/unaligned.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
@@ -357,7 +358,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
-	rx_pkt_status = le32_to_cpup((__le32 *)
+	rx_pkt_status = get_unaligned_le32((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
-- 
2.20.1

