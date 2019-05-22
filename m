Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B526F4D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbfEVTYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbfEVTYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:24:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD4A217D9;
        Wed, 22 May 2019 19:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553077;
        bh=YzezW2Fba2Qpg5me27N4CVgznmETrqoWlEbAAN6ufFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPatB5nXOrE38Kq+rro743gElhOcd5qzdSzXzELRTL7A3FWKTn+OhqHVbJDTa2lt2
         FRsjLN+6svzlFr9WUm2Q64z8vuOck8Gorhh43bdYtUpuBkTH0sKsW5GTsLSl5Zb7Vn
         6obg1XEHX+ir11/i6FnNm7/Fc28EbUv/gRW5sCKw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 035/317] brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()
Date:   Wed, 22 May 2019 15:18:56 -0400
Message-Id: <20190522192338.23715-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e025da3d7aa4770bb1d1b3b0aa7cc4da1744852d ]

If "ret_len" is negative then it could lead to a NULL dereference.

The "ret_len" value comes from nl80211_vendor_cmd(), if it's negative
then we don't allocate the "dcmd_buf" buffer.  Then we pass "ret_len" to
brcmf_fil_cmd_data_set() where it is cast to a very high u32 value.
Most of the functions in that call tree check whether the buffer we pass
is NULL but there are at least a couple places which don't such as
brcmf_dbg_hex_dump() and brcmf_msgbuf_query_dcmd().  We memcpy() to and
from the buffer so it would result in a NULL dereference.

The fix is to change the types so that "ret_len" can't be negative.  (If
we memcpy() zero bytes to NULL, that's a no-op and doesn't cause an
issue).

Fixes: 1bacb0487d0e ("brcmfmac: replace cfg80211 testmode with vendor command")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 8eff2753abade..d493021f60318 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -35,9 +35,10 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	struct brcmf_if *ifp;
 	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
 	struct sk_buff *reply;
-	int ret, payload, ret_len;
+	unsigned int payload, ret_len;
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
+	int ret;
 
 	if (len < sizeof(*cmdhdr)) {
 		brcmf_err("vendor command too short: %d\n", len);
@@ -65,7 +66,7 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 			brcmf_err("oversize return buffer %d\n", ret_len);
 			ret_len = BRCMF_DCMD_MAXLEN;
 		}
-		payload = max(ret_len, len) + 1;
+		payload = max_t(unsigned int, ret_len, len) + 1;
 		dcmd_buf = vzalloc(payload);
 		if (NULL == dcmd_buf)
 			return -ENOMEM;
-- 
2.20.1

