Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9C21CC126
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgEIMHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:07:42 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:40871 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgEIMHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:07:41 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N7RDn-1j3u291OAv-017q80; Sat, 09 May 2020 14:07:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] ath10k: fix ath10k_pci struct layout
Date:   Sat,  9 May 2020 14:06:33 +0200
Message-Id: <20200509120707.188595-2-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200509120707.188595-1-arnd@arndb.de>
References: <20200509120707.188595-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PwCZxgyuJPTotwKY546enVLNSjcEZwvUHNxW+ZeWlIbFQWRywio
 zufRY0iO7HkMQ8lpmHRn7fJ7AYqhTdmqsbL4v/355PdA91ANvQzywOGv32/DXJRqAzoINys
 YI1hF8rtOMGIYhcGlOLQvSRJB+NxU1YCGGTFGdB1h3UOqf1PfcOw8D2VVKjSHwdNXuWUWqx
 wS8L4ildOaTnVsG7hvJ4g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pQykyiEsgvc=:5PhDczXHDy7IquzkJB7qTx
 /TzHKhDP4SwR+IAaOr6xcVgCWBKtTo4cZXwMyTyZSPvlnPeIDkbsJWDsJnhBuEHtt9e+HzHF4
 eRR3/J1QXBWDNRKTUKdxDCOkvg4bbkDqABbaMM0agEkDoLrnGj/f3NepIcaKGW228mgtbtu8C
 s4Kc8sFNIu4AdyYrfEStC7jccU2QsSyq2lQDMhf1wJaKrYxtwaeyfYYgbFY9OaOxBKxcUGV1w
 EkrQgy+lkZrZY8WJ0kWCZDlGYIUJB9HrAhwxVyW6dO92OemvzlrOjRAu4ZImR8V69bCoWGJJ0
 4I+wcFjVecW2davHhm4mN3QQmmCgx30e1gTSUlRTAu93V6+2vudc5QgwBUedYCI86kN+x9Beo
 r+okGwG/0QqR0UyHnC+xJ6NdK71oo4zSghPiHYtLOTPsRqNRCttYs6s7ZAndqMJfxG+uJa7uD
 NESEzJTIYhpBW+d9wbt+QRl9m0vXj8lrAHf9vExbOSGyl6br9wuyfoPpDWUhgz1zlAv7q+PcO
 /9cpPmMeDMYjKNnKDLmfAWPsUM2g5kG7B6Wl682HScUYZDjmwts9cTvjD6Wp/DiRJ2Z8plHaD
 Q7/+e5gfUd7VDBrSw4XQvm6tQFxxrkIAtoFCzZCJoyEcAZbfJ2Z5kByMuT37zVb7lzNg5EOnU
 rs2QXjHQh6HSbSnEYrSNaAAcWVYx8XStXWaz9gyzr5Rx4cJLEavX0SJPLK+nd/wCq95+XWAvi
 rUl2iiomWXVzH3yr75qsmE5QZjWp1mMkgUMPGBDDgJyh9wIi4oK/+WWnIbuMmLoUE+GSK722i
 +mzFCSq72AE9Nwq49GRlcizgTFDuZhr+DSP8QmUvBVXYM77A8Q=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 correctly points out a bug with a zero-length array in
struct ath10k_pci:

drivers/net/wireless/ath/ath10k/ahb.c: In function 'ath10k_ahb_remove':
drivers/net/wireless/ath/ath10k/ahb.c:30:9: error: array subscript 0 is outside the bounds of an interior zero-length array 'struct ath10k_ahb[0]' [-Werror=zero-length-bounds]
   30 |  return &((struct ath10k_pci *)ar->drv_priv)->ahb[0];
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/wireless/ath/ath10k/ahb.c:13:
drivers/net/wireless/ath/ath10k/pci.h:185:20: note: while referencing 'ahb'
  185 |  struct ath10k_ahb ahb[0];
      |                    ^~~

The last addition to the struct ignored the comments and added
new members behind the array that must remain last.

Change it to a flexible-array member and move it last again to
make it work correctly, prevent the same thing from happening
again (all compilers warn about flexible-array members in the
middle of a struct) and get it to build without warnings.

Fixes: 521fc37be3d8 ("ath10k: Avoid override CE5 configuration for QCA99X0 chipsets")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/pci.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index e3cbd259a2dc..862d0901c5b8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -178,15 +178,16 @@ struct ath10k_pci {
 	 */
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
 
+	struct ce_attr *attr;
+	struct ce_pipe_config *pipe_config;
+	struct ce_service_to_pipe *serv_to_pipe;
+
 	/* Keep this entry in the last, memory for struct ath10k_ahb is
 	 * allocated (ahb support enabled case) in the continuation of
 	 * this struct.
 	 */
-	struct ath10k_ahb ahb[0];
+	struct ath10k_ahb ahb[];
 
-	struct ce_attr *attr;
-	struct ce_pipe_config *pipe_config;
-	struct ce_service_to_pipe *serv_to_pipe;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
-- 
2.26.0

