Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18F34CE65
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhC2LAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbhC2LAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:00:39 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B287BC061574;
        Mon, 29 Mar 2021 04:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=6WGqTp8LlJ
        59ua+GVPvEnMczMwTS+/11WKeKOjgGhoM=; b=Shxtg7AXlGvy+aTBuQuhlIRvat
        EmNogThRBfqgGDUw848aj+v8AtTHJJ58E88tQrIV7DF/Wy4nEU2yCYNJlH4czxse
        2kiMDZqbP5EX/uZSMDWCg7rpKQGr/J1GKEkvHsdP2J6jvcArWSZvCehi1flnBkgz
        nEYtfV+lt7azcc+mc=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygD3_39Hs2Fgv+xmAA--.569S4;
        Mon, 29 Mar 2021 19:00:23 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     j@w1.fi, kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] wireless: hostap: Fix a use after free in hostap_80211_rx
Date:   Mon, 29 Mar 2021 04:00:21 -0700
Message-Id: <20210329110021.7497-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygD3_39Hs2Fgv+xmAA--.569S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur17Ww4UZry5ZrWDWrWrAFb_yoW8XFyfpF
        Z5Cay3Krn8JF1UA34xXF1xCFyrXa1UJas3WFyUC3WF9Fn8XFn5K3sY9FyUKF15W39Yk3Wf
        JFs8tw47AasxG37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4kMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbU5r5UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function hostap_80211_rx() calls prism2_rx_80211(..,skb,..). In
prism2_rx_80211, i found that the skb could be freed by dev_kfree_skb_any(skb)
and return 0. Also could be freed by netif_rx(skb) when netif_rx return
NET_RX_DROP.

But after called the prism2_rx_80211(..,skb,..), the skb is used by skb->len.

As the new skb->len is returned by prism2_rx_80211(), my patch uses a variable
len to repalce skb->len. According to another useage of prism2_rx_80211 in
monitor_rx().

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/net/wireless/intersil/hostap/hostap_80211_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c b/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
index 61be822f90b5..a45ee7b35533 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
@@ -1016,10 +1016,10 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 			if (local->hostapd && local->apdev) {
 				/* Send IEEE 802.1X frames to the user
 				 * space daemon for processing */
-				prism2_rx_80211(local->apdev, skb, rx_stats,
+				int len = prism2_rx_80211(local->apdev, skb, rx_stats,
 						PRISM2_RX_MGMT);
 				local->apdevstats.rx_packets++;
-				local->apdevstats.rx_bytes += skb->len;
+				local->apdevstats.rx_bytes += len;
 				goto rx_exit;
 			}
 		} else if (!frame_authorized) {
-- 
2.25.1


