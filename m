Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3261ECB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbfGHMvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:51:05 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:41495 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfGHMvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:51:05 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M3UIe-1hjv8o3PBC-000YS6; Mon, 08 Jul 2019 14:50:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] ath10k: work around uninitialized vht_pfr variable
Date:   Mon,  8 Jul 2019 14:50:06 +0200
Message-Id: <20190708125050.3689133-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0ZEH7BLXky2hsEkFHE941e4QDy+Q0DeLq46hitjd9gIhiQjjcX3
 +rAvYpf6ObAijkvutVOtvfqk9eYOtLienzGiIpbTDGnsqZCSITBIvrTu4jxz+YdUu9QRHv3
 QxLpMOZsqLWoMbZNFdcxIW5SWLT43shXwIKV5kDoF+g5+atQdjJ2NFU8SP3cT2qvXakgjww
 UX0MmUnxTukQk/l0l/CAQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3Ejh7jG9+JE=:u6LjctvG2zwbsJ6T/k0FHq
 dgqfAC28oMIrAdI3ri95sJPS96jeTdpTsFSyNNrt79K6b7RXwdm+hovOFSNbRPvheL0RpUFUr
 j33VnbNkyz58HRB+debVGYYWUqw/JneG8hlo5nRkC6g0ckC5rYr/7ktSnqJobABl9N4vywlX7
 WPFNf6J2MZxb2LYhIe0/MJU4gacUZwBgHQ6kW9d7KTlOARuEAPgoGkGTdXQemvGlmEs0VvDXL
 luJHOTs2LjvmZ/gkHlLLTLEY5Az7G+BGPlYV7rcQMSxo+0Uy+Gv61HjOnH3CqmLcLdZPu8g/t
 13EK9BIyqmBZzHDXg/eLkt5mGLnF79mG0PnsM12rdaFZGwv1jv28lPeshJnX7myAhWbnXCXed
 6beGwDbuM1XZijsv6AkwOvMFGDoYm+5s2j52yBEkuQAeaX3gpTF55v84GlktgJba9jnAdovC1
 cEssA0JM4U0bIW9oFZfiKkTollfb1O4ZME96c8eUJ6p6F0fMu95ciNyExKgWuDiGSDlS406+K
 FiLLyENPaGPB1+EB0f4ma33zXTdn9guc0/w8GBiFS2OOmSwxUEKvfxiLVFd73Dk/b3PnQg38V
 N5dBlWtqXW+VT3xvWgmL1Lr5ZxuEqzZ0yIF/vjUq0j61xk0qqlHJhld0w5bcrJAXH2+w0XLeC
 PRGctYgwnh6YOqY2YZse3yQvX4Zx0i8eeAyEJBtbhKrhJgUkWpnsRbt4XSXH5ZB+IJKITvJnC
 ftlKEzqC3l2XxINHW4aGdJRHqZSfRuy37pFKrg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As clang points out, the vht_pfr is assigned to a struct member
without being initialized in one case:

drivers/net/wireless/ath/ath10k/mac.c:7528:7: error: variable 'vht_pfr' is used uninitialized whenever 'if' condition
      is false [-Werror,-Wsometimes-uninitialized]
                if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath10k/mac.c:7551:20: note: uninitialized use occurs here
                arvif->vht_pfr = vht_pfr;
                                 ^~~~~~~
drivers/net/wireless/ath/ath10k/mac.c:7528:3: note: remove the 'if' if its condition is always true
                if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask,
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath10k/mac.c:7483:12: note: initialize the variable 'vht_pfr' to silence this warning
        u8 vht_pfr;

Add an explicit but probably incorrect initialization here.
I suspect we want a better fix here, but chose this approach to
illustrate the issue.

Fixes: 8b97b055dc9d ("ath10k: fix failure to set multiple fixed rate")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e43a566eef77..0606416dc971 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7541,6 +7541,8 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 								&vht_nss,
 								true);
 			update_bitrate_mask = false;
+		} else {
+			vht_pfr = 0;
 		}
 
 		mutex_lock(&ar->conf_mutex);
-- 
2.20.0

