Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD4F30F7E1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhBDQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237087AbhBDQ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E24A664F53;
        Thu,  4 Feb 2021 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612456098;
        bh=ytHJevR+zzgmOSRx6kpqUi3lL5tHgTyXFrb/w6GcbzM=;
        h=From:To:Cc:Subject:Date:From;
        b=XhN5ISGWyafpPs2enUgZVpXm4zoHkJUl3m57WK4TQXlYDlXQakC/EE45ItKpGRoI0
         8jkXw0LehmGi2vqhtkiOKG/t9ZZb/0hk/ymjcKz6vwZ6OsCxlRfbzyrJQFPZIISCCk
         +Ktuk2PtXZLRDBnOkXp3gOpekw0U18MVL3NhndpAMu/Uc4GvtJjpS+FggRjHG4nc0y
         yRCHtbJ3hU4xz7+QH0MKPKlx4oFrjD4H4jggYp6DxQW3mX/Pb9/kFMNHER+HAuOMid
         HMaBg4AuIPf8IpT9XQRRo8+i/VAjoZ1PeCRO8lCBpDLSuONnnpCkrC2Uo0UIdjfnGB
         QjhhXrKfgbJXQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Romain Perier <romain.perier@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Allen Pais <allen.lkml@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cwmwl8k: fix alignment constraints
Date:   Thu,  4 Feb 2021 17:28:04 +0100
Message-Id: <20210204162813.3159319-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

sturct mwl8k_dma_data contains a ieee80211_hdr structure, which is required to
have at least two byte alignment, and this conflicts with the __packed
attribute:

vers/net/wireless/marvell/mwl8k.c:811:1: warning: alignment 1 of 'struct mwl8k_dma_data' is less than 2 [-Wpacked-not-aligned]

Mark mwl8k_dma_data itself as having two-byte alignment to ensure the
inner structure is properly aligned.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index abf3b0233ccc..38eeab6369f7 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -808,7 +808,7 @@ struct mwl8k_dma_data {
 	__le16 fwlen;
 	struct ieee80211_hdr wh;
 	char data[];
-} __packed;
+} __packed __aligned(2);
 
 /* Routines to add/remove DMA header from skb.  */
 static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
-- 
2.29.2

