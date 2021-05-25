Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9054038FF7F
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhEYKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:47:53 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44398 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229968AbhEYKrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:47:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ua4PKOY_1621939578;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ua4PKOY_1621939578)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 18:46:20 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, kvalo@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] ath10k: Fix an error code in ath10k_add_interface()
Date:   Tue, 25 May 2021 18:46:17 +0800
Message-Id: <1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the code execute this if statement, the value of ret is 0. 
However, we can see from the ath10k_warn() log that the value of 
ret should be -EINVAL.

Clean up smatch warning:

drivers/net/wireless/ath/ath10k/mac.c:5596 ath10k_add_interface() warn:
missing error code 'ret'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 'commit ccec9038c721 ("ath10k: enable raw encap mode and software
crypto engine")'
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5ce4f8d..c272b29 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5592,6 +5592,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->nohwcrypt &&
 	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ret = -EINVAL;
 		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
 		goto err;
 	}
-- 
1.8.3.1

