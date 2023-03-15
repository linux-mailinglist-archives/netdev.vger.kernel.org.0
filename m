Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA36BBDEB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjCOUWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjCOUWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:22:34 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0B9A21AE;
        Wed, 15 Mar 2023 13:22:24 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id 000B144C101F;
        Wed, 15 Mar 2023 20:22:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 000B144C101F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678911743;
        bh=KHlEKAhpUGzm2mZCMucQ8WbZWdQoP58ONPTTGbeX3MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF8+mLdy40gtvvg8OB9D1OQDILvPJaHvvHMnT7RNekOc6QhJSM3bhgNu+no7WBUPh
         iEbbhudO8Dzq8G8WsxsNaChuyN0EA2dyfCCBcJVUnq7sj5jBuHY/bny1AQS0INSVZj
         5t3iTEBkUd36YwJFAhhKN1TBuroFwJAK3VXphddo=
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
        lvc-project@linuxtesting.org
Subject: [PATCH 3/3] wifi: ath9k: fix ath9k_wmi_cmd return value when device is unplugged
Date:   Wed, 15 Mar 2023 23:21:12 +0300
Message-Id: <20230315202112.163012-4-pchelkin@ispras.ru>
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

Return with an error code in case the USB device has been already
unplugged. Otherwise the callers of ath9k_wmi_cmd() are unaware of the
fact that cmd_buf and rsp_buf are not initialized or handled properly
inside this function.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: a3be14b76da1 ("ath9k_htc: Handle device unplug properly")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 99a91bbaace9..3e0ad4f8f0a0 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -320,8 +320,11 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	unsigned long time_left;
 	int ret = 0;
 
-	if (ah->ah_flags & AH_UNPLUGGED)
-		return 0;
+	if (ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(common, WMI, "Device unplugged for WMI command: %s\n",
+			wmi_cmd_to_name(cmd_id));
+		return -ENODEV;
+	}
 
 	skb = alloc_skb(headroom + cmd_len, GFP_ATOMIC);
 	if (!skb)
-- 
2.34.1

