Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC95F66AB
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfKJDOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfKJCmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C604221655;
        Sun, 10 Nov 2019 02:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353737;
        bh=G8lJ2j3/oBPS6i/yoR6pbKyVq2pXSDmOnUhlWt+bOgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1THzImqux36XCiZ5y+6ee3GpN17P44ywfq1wk9SvO0K2fS9sYqd2RmCsr7L1794A
         zT+HguKMVMzZbWgKymaW5N+BZlHFu2WpYUPE2bYuDh/eQEj8DEsm6xbsxxxszvZZco
         ONc+R8Ix+Yfo3E0zFQ6gLv1WJQ/BchlZBdcs5/6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 059/191] brcmsmac: Use kvmalloc() for ucode allocations
Date:   Sat,  9 Nov 2019 21:38:01 -0500
Message-Id: <20191110024013.29782-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6c3efbe77bc78bf49db851aec7f385be475afca6 ]

The ucode chunk might be relatively large and the allocation with
kmalloc() may fail occasionally.  Since the data isn't DMA-transferred
but by manual loops, we can use vmalloc instead of kmalloc.
For a better performance, though, kvmalloc() would be the best choice
in such a case, so let's replace with it.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1103431
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ecc89e718b9c1..6255fb6d97a70 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1578,10 +1578,10 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 			if (le32_to_cpu(hdr->idx) == idx) {
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
-				*pbuf = kmemdup(pdata, len, GFP_KERNEL);
+				*pbuf = kvmalloc(len, GFP_KERNEL);
 				if (*pbuf == NULL)
 					goto fail;
-
+				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
 		}
@@ -1629,7 +1629,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
  */
 void brcms_ucode_free_buf(void *p)
 {
-	kfree(p);
+	kvfree(p);
 }
 
 /*
-- 
2.20.1

