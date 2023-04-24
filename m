Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645496ED480
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjDXSek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjDXSeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:34:37 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A84FA;
        Mon, 24 Apr 2023 11:34:35 -0700 (PDT)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id E9104407626E;
        Mon, 24 Apr 2023 18:34:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru E9104407626E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682361274;
        bh=PRIdr5ITnjkysoIatNA0p/ZUHeBN+gItyLquEJcHG7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arVHo42+Ms6WNHPJyjNBUnplzA0d9vVLl2ngnRfDxQfxKyEhT8O+CQ4Xcg4WqSC5t
         B/0auEjXE9IJtc7O+G6E9hGnvM/WO2hxv5WJct1uGgLGzaNqga2ju7YEVOMWzM15zI
         cDJQqWtZFJZ76UqDBc9ooPjDwclyUJ5zctUpgbq4=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Vallo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
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
Subject: [PATCH v2] wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx
Date:   Mon, 24 Apr 2023 21:33:48 +0300
Message-Id: <20230424183348.111355-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424182300.sw5ogmcst5suf2ab@fpc>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the reasons also described in commit b383e8abed41 ("wifi: ath9k: avoid
uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
validate pkt_len before accessing the SKB.

For example, the obtained SKB may have been badly constructed with
pkt_len = 8. In this case, the SKB can only contain a valid htc_frame_hdr
but after being processed in ath9k_htc_rx_msg() and passed to
ath9k_wmi_ctrl_rx() endpoint RX handler, it is expected to have a WMI
command header which should be located inside its data payload. 

Implement sanity checking inside ath9k_wmi_ctrl_rx(). Otherwise, uninit
memory can be referenced.

Tested on Qualcomm Atheros Communications AR9271 802.11n .

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: remove incorrect checks and rephrase commit info

 drivers/net/wireless/ath/ath9k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 19345b8f7bfd..d652c647d56b 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -221,6 +221,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
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

