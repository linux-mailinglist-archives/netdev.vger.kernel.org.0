Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69823D3BAC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhGWNba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:31:30 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59372
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233610AbhGWNb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:31:28 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9187F3F342;
        Fri, 23 Jul 2021 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627049520;
        bh=Pf6GOuDvvaJLJao9XPYpFcu0rFFPTS4bkI7s3Jx97zc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=QuCL3vpKLW9Ua1fqV7k3O0uq9xNnis2E+cQ7ddTG2SOJaT25jQOfn66VbBnNjumjS
         Vkp7wPmV5eRdvJvwoGq/ROc7VJIanZsRpfzgsOrdJa1LgZhzRAFyJn63qXqMHQBjxU
         m3KUfnRUdmsGPRmuc0wL3oN/TDX3knw7CA55CA9Kzfzk6DyrvYdXQRMZtbHKIErMGf
         WmlXvrN2A1DjJjlu0pBgBqNejtI0D3b0HO7mXSgMpcSBw9J7P1TicCtfHKrK81p2IM
         NPDbaBqw+bpFZr77ni0mCsck6hprinrsQcgPbPG4heSZyUtb/ww67fta7YqmrmY2SH
         hPleQldG7Vy9Q==
From:   Colin King <colin.king@canonical.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Fix memory leak on reduce_power_data buffer
Date:   Fri, 23 Jul 2021 15:11:52 +0100
Message-Id: <20210723141152.134340-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the error case where the TLV length is invalid the allocated
reduce_power_data buffer pointer is set to ERR_PTR(-EINVAL) without
first kfree'ing any previous allocated memory. Fix this memory
leak by kfree'ing it before taking the error return path.

Addresses-Coverity: ("Resource leak")
Fixes: 9dad325f9d57 ("iwlwifi: support loading the reduced power table from UEFI")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index a7c79d814aa4..413bfb2ae54d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -86,6 +86,7 @@ static void *iwl_uefi_reduce_power_section(struct iwl_trans *trans,
 		if (len < tlv_len) {
 			IWL_ERR(trans, "invalid TLV len: %zd/%u\n",
 				len, tlv_len);
+			kfree(reduce_power_data);
 			reduce_power_data = ERR_PTR(-EINVAL);
 			goto out;
 		}
-- 
2.31.1

