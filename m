Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAE565D233
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbjADMQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjADMQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:16:17 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A719F016;
        Wed,  4 Jan 2023 04:16:16 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4DF7D419E9CB;
        Wed,  4 Jan 2023 12:16:10 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4DF7D419E9CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672834570;
        bh=Z6aS5qwzvrT0EpnS1M75E2ZCaAMxUHd9r+HBXrqbyEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGRgfg+jgxe1kSHwci/iiw6fMSJJpkpM1F9rNjloL3XOiDp9BcJ1WsRyqJsIadf/r
         4koYwwmC1SkBuRFq7fxtghx588QHzzzkJl6muwt/7OYdkWrVesYIScCQizYx+Cyueo
         cevtkGepSizm2VSYlYfHjKaGQHCbnA14P2TJn5J4=
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
        lvc-project@linuxtesting.org,
        syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Subject: [PATCH v3] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
Date:   Wed,  4 Jan 2023 15:15:58 +0300
Message-Id: <20230104121558.38969-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103224815.304147-1-pchelkin@ispras.ru>
References: 
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
Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v1->v2: added Reported-by tag
v2->v3: use 'goto invalid' instead of freeing skb in place

 drivers/net/wireless/ath/ath9k/htc_hst.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index ca05b07a45e6..0c95f6b145ff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -478,6 +478,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			goto invalid;
 	}
 }
 
-- 
2.34.1

