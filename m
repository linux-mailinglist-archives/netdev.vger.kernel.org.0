Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA62565875A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 23:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiL1WlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 17:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiL1WlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 17:41:02 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82379258;
        Wed, 28 Dec 2022 14:41:01 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id EEA2940737D4;
        Wed, 28 Dec 2022 22:40:59 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru EEA2940737D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672267260;
        bh=yAe/xSvn4I4BDY4nXAoWtF0FbwyCZJFaP8UyARdW5hU=;
        h=From:To:Cc:Subject:Date:From;
        b=XaDnrIsUaEQAqsWu7EDbJqxAhW6D8aRfyNfPYxOn+01FDM2oLQeDNDuooar2h/ImU
         K+SLOZFcPjvPBBYc4OpKgcauRNnGQU9p7vQVlqUa1j7/suZJViRXY8GXbhtb4fhoKh
         lpOjywYp76syTpPKfwqjmIDcrYdSCtw7otTov0TI=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
Date:   Thu, 29 Dec 2022 01:40:47 +0300
Message-Id: <20221228224047.146399-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is stated that ath9k_htc_rx_msg() either frees the provided skb or
passes its management to another callback function. However, the skb is
not freed in case there is no another callback function, and Syzkaller was
able to cause a memory leak. Also minor comment fix.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index ca05b07a45e6..7d5041eb5f29 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -391,7 +391,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
  *
- * Service messages (Data, WMI) passed to the corresponding
+ * Service messages (Data, WMI) are passed to the corresponding
  * endpoint RX handlers, which have to free the SKB.
  */
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
@@ -478,6 +478,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			kfree_skb(skb);
 	}
 }
 
-- 
2.34.1

