Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5443E2CFFDD
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgLFABp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLFABo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:01:44 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455E9C0613D1
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 16:01:04 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a6so8422144wmc.2
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 16:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xtDjSEBnDzgEG2Ay8lke047Uz/3kwjxeikZsv3A5YPE=;
        b=tR1AIUXOe7tDi7vfIgIHYisONxh17V9sh6c/6Y69SBeNcQjZtQKclLvBnW2y+MU0r4
         XUo8h49Knq5BM/NUwJh72HYQC5gO3lVoKBwBoV4ocdX88i3ss4ZwVxV1llcXkCpzcq9b
         qzMkSqN6tbICx5XvBWj2MGTifT14o29rlGqslfZTgEtOebQCipI8WuG46CAOUTxirn/L
         x+apb20UvxJil4Iqn0is7xa49cOA6N0mCfem4V8gcJQL55Tz8gWNUVpdCWEJ1zhgce4x
         ST+vZoAQOzrcxagGbzsYLrkzj/RWiq0qUkd44aRVQhCqeVEAJDeSVgiJOdPgfXPmbLFM
         fSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xtDjSEBnDzgEG2Ay8lke047Uz/3kwjxeikZsv3A5YPE=;
        b=IAHf5A+Itt6w/db4zsrWxN8WGn0Lxq2IuL3ly3QeAZV7MfJeIvPHHBiQx5tIAmD7Ue
         sQNPKEraWByN47SYAZcq3aqnBwP21qXl0sIRTHlWLzJUhP+YB+ssoKgyW8UQTwH8yzOU
         kc+fbgTTI7Ba2EhP9uRJDQcYyuW05t/Q1A6/qBBj5InwuB6nJGoL0p7IoPuSs2B5kvp2
         KkmAfcwg9lUreWFkb+y+2brhZkqCq/z2c4NBols8nm0iO6yeQkEtFfw+qHSjRj5bkFn5
         wSKeDBKmH2GwE1dSWhea/1kur0hTEU5MxzY03bmqOu/FKmp7iLXaSnVywMVMuKINFl1B
         +XyQ==
X-Gm-Message-State: AOAM530A9aWRZURyu3YRUeT8LXXOMKhMBQfVOf11fAplWUQoaxi1tBHC
        HAg4kszzgTuavaosPysP1srivqsRFu0=
X-Google-Smtp-Source: ABdhPJy90qcwvGl64iq3XxVfcR7mxzjw5m5gT7/tEtMcKDb1bwOuH3fQnUd46Cah2LDDuxx4UbYM+w==
X-Received: by 2002:a1c:730c:: with SMTP id d12mr11161992wmb.3.1607212862772;
        Sat, 05 Dec 2020 16:01:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2e:e00:6845:f25a:bfd1:6598? (p200300ea8f2e0e006845f25abfd16598.dip0.t-ipconnect.de. [2003:ea:8f2e:e00:6845:f25a:bfd1:6598])
        by smtp.googlemail.com with ESMTPSA id h98sm9753973wrh.69.2020.12.05.16.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 16:01:02 -0800 (PST)
Subject: [PATCH net-next 1/2] r8169: improve rtl_rx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
Message-ID: <1ede7930-0018-49dc-b63a-7c77dd4b367b@gmail.com>
Date:   Sun, 6 Dec 2020 01:00:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to check min(budget, NUM_RX_DESC). At first budget
(NAPI_POLL_WEIGHT = 64) is less then NUM_RX_DESC (256).
And more important: Even in case of budget > NUM_RX_DESC we could
safely continue processing descriptors as long as they are owned by
the CPU. In addition replace rx_left with a normal counter variable,
this allows to simplify the code. Last but not least there's no need
any longer to pass the budget as an u32.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3ef1b31c9..3ea27a657 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4415,15 +4415,13 @@ static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 		skb_checksum_none_assert(skb);
 }
 
-static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget)
+static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget)
 {
-	unsigned int cur_rx, rx_left, count;
 	struct device *d = tp_to_dev(tp);
+	int count;
 
-	cur_rx = tp->cur_rx;
-
-	for (rx_left = min(budget, NUM_RX_DESC); rx_left > 0; rx_left--, cur_rx++) {
-		unsigned int pkt_size, entry = cur_rx % NUM_RX_DESC;
+	for (count = 0; count < budget; count++, tp->cur_rx++) {
+		unsigned int pkt_size, entry = tp->cur_rx % NUM_RX_DESC;
 		struct RxDesc *desc = tp->RxDescArray + entry;
 		struct sk_buff *skb;
 		const void *rx_buf;
@@ -4500,9 +4498,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		rtl8169_mark_to_asic(desc);
 	}
 
-	count = cur_rx - tp->cur_rx;
-	tp->cur_rx = cur_rx;
-
 	return count;
 }
 
@@ -4561,7 +4556,7 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = tp->dev;
 	int work_done;
 
-	work_done = rtl_rx(dev, tp, (u32) budget);
+	work_done = rtl_rx(dev, tp, budget);
 
 	rtl_tx(dev, tp, budget);
 
-- 
2.29.2


