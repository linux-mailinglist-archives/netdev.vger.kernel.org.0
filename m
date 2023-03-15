Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740156BBDE4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjCOUWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjCOUWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:22:20 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D9DA0F00;
        Wed, 15 Mar 2023 13:22:19 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4B84E44C1010;
        Wed, 15 Mar 2023 20:22:17 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4B84E44C1010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678911737;
        bh=sNJDCRIt59eJ1lrh220dzpHP4PwNZfpMpr1y7yJ9szY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOW4/2FS9/ve654NMTfeFUxqHd7YR2DaT9Jk5FvnsEEYwYlMvK9nMUB5n98mSM+x1
         v8PKGwldQkizuAzdHp//w98dlhiLxeIkXxLjnZpP56tYyZ/sYo5e9SfGQ2t1oAt/+q
         qzF12IXIcS4E4sVyRVHV6VXkaeXZLKSghIfSPNBw=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Subject: [PATCH 1/3] wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx
Date:   Wed, 15 Mar 2023 23:21:10 +0300
Message-Id: <20230315202112.163012-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315202112.163012-1-pchelkin@ispras.ru>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the reasons described in commit b383e8abed41 ("wifi: ath9k: avoid
uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
validate pkt_len before accessing the SKB. For example, the obtained SKB
may have uninitialized memory in the case of
ioctl(USB_RAW_IOCTL_EP_WRITE).

Implement sanity checking inside the corresponding endpoint RX handlers:
ath9k_wmi_ctrl_rx() and ath9k_htc_rxep(). Otherwise, uninit memory can
be referenced.

Add comments briefly describing the issue.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/htc_hst.c      | 4 ++++
 drivers/net/wireless/ath/ath9k/wmi.c          | 8 ++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 672789e3c55d..957efb26019d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1147,6 +1147,12 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	if (!data_race(priv->rx.initialized))
 		goto err;
 
+	/* Validate the obtained SKB so that it is handled without error
+	 * inside rx_tasklet handler.
+	 */
+	if (unlikely(skb->len < sizeof(struct ieee80211_hdr)))
+		goto err;
+
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index fe62ff668f75..9d0d9d0e1aa8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -475,6 +475,10 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		skb_pull(skb, sizeof(struct htc_frame_hdr));
 
 		endpoint = &htc_handle->endpoint[epid];
+
+		/* The endpoint RX handlers should implement their own
+		 * additional SKB sanity checking
+		 */
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 19345b8f7bfd..2e7c361b62f5 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -204,6 +204,10 @@ static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
 
+	/* Once again validate the SKB. */
+	if (unlikely(skb->len < wmi->cmd_rsp_len))
+		return;
+
 	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
 		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
 
@@ -221,6 +225,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	if (unlikely(wmi->stopped))
 		goto free_skb;
 
+	/* Validate the obtained SKB. */
+	if (unlikely(skb->len < sizeof(struct wmi_cmd_hdr)))
+		goto free_skb;
+
 	hdr = (struct wmi_cmd_hdr *) skb->data;
 	cmd_id = be16_to_cpu(hdr->command_id);
 
-- 
2.34.1

