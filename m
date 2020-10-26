Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284262998DE
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389350AbgJZVdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389315AbgJZVdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:33:33 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43B4207C4;
        Mon, 26 Oct 2020 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748013;
        bh=zsdFRK78KKmwrwcAyPUjk92vDNhs3wUrIe6GE9ax80s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWK1ZZkcBliOfExdtIIuqKluve8nkz/DPJXW4xzjRoChOLErpR8rQH6rxJ5PJVIuG
         vSH5mn0VSEhGh6+K3j3ST/BKuIWLUSgPSmmvncubE96aJsXIXHOD9lpvHo+xHJZtmB
         bTwhjriX3fGW5g+GeS5U45FB1GknPc/RLR2epKyo=
From:   Arnd Bergmann <arnd@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/11] ath9k: work around false-positive gcc warning
Date:   Mon, 26 Oct 2020 22:29:55 +0100
Message-Id: <20201026213040.3889546-8-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-10 shows a false-positive warning with CONFIG_KASAN:

drivers/net/wireless/ath/ath9k/dynack.c: In function 'ath_dynack_sample_tx_ts':
include/linux/etherdevice.h:290:14: warning: writing 4 bytes into a region of size 0 [-Wstringop-overflow=]
  290 |  *(u32 *)dst = *(const u32 *)src;
      |  ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~

Until gcc is fixed, work around this by using memcpy() in place
of ether_addr_copy(). Hopefully gcc-11 will not have this problem.

Link: https://godbolt.org/z/sab1MK
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index fbeb4a739d32..e4eb96b26ca4 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -247,8 +247,14 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	ridx = ts->ts_rateindex;
 
 	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
+#if defined(CONFIG_KASAN) && (CONFIG_GCC_VERSION >= 100000) && (CONFIG_GCC_VERSION < 110000)
+	/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97490 */
+	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1, ETH_ALEN);
+	memcpy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2, ETH_ALEN);
+#else
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
+#endif
 
 	if (!(info->status.rates[ridx].flags & IEEE80211_TX_RC_MCS)) {
 		const struct ieee80211_rate *rate;
-- 
2.27.0

