Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BD2A80D9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgKEO2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKEO2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:28:51 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D53BC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 06:28:51 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h62so1805069wme.3
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 06:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OW/+lX09YizACTS6icuE/7YpsLFFjdwuqBw/nslXytM=;
        b=sR8Fw/HFyNv/8eMwyXa4N4HVPLVuBbuoY1B10CqP2JZ1WUhQiHatt0reT4dEbWYqAT
         qoPIeS0890xHiroLXOCQGKzPiE4vugIkBImVod6Kjcy6Y1fkMWTD6opSGDBKS7HTmaBs
         bLC5qOqZnjXG7mJi8/k51uIfWI8SBDUs87Ad0DFJd4QAlenIkpBetDJsL2ctOgVOVIT1
         SNJE7hBdRPxsYvi5rvy22yaRNhG5JdvwUG41wwxe54l4HOLwJnJ/p1qFziZoF0ELmEla
         F50FLyfXudumBGlwRmMYhnyIhZZ7t/UoAaSplhVdRZVRGB6/zhuHUD3SzgePzhsM0FeC
         sNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OW/+lX09YizACTS6icuE/7YpsLFFjdwuqBw/nslXytM=;
        b=FLxz5hI8uMwQKnZEm0WXwgJTT/T3m0iAuHs1sfzed4qDS2LXn0ahZXR4f1/XFSRkje
         eyKljru19Ff8JKCyukTlAaNSxUI/y26/OmXh/SFPUDvQeWHTanV+kCrqyIMUZdJKa5gL
         eJ0Vgrx3w6Mp/iwmHhtJppNJhaAFXhW2reu/cSCiFqPTxMMc1+qduxxS8hNmqA94okC6
         RPXrPgg0+ve57ATlvAMGiEAaD8zJ69uDops6dp9DPMDsJWHY31YihtJpHWWtlTT4VkU/
         0++YHkpviMYWAgbFEQN842ySIlW4Xtp09vPyRIUY1VgWZrJGoznewoCrd2RstTRXwLHx
         TVWw==
X-Gm-Message-State: AOAM531fQlA0iTIPQjqf5frfX3Bycwd5D+xmqauZj7TWJYWgY4Ctyy37
        Vw8v2Ww5v1Vh0bwp/LJViQEmWBgwxej8mg==
X-Google-Smtp-Source: ABdhPJxI79kl20PVCKSay7nJl9UI1ZyNAzjmCw8Md7xJOq4cnJGYnVp03y4Dwx7YZcmASPs1RKk4Ow==
X-Received: by 2002:a1c:f209:: with SMTP id s9mr2933571wmc.115.1604586530084;
        Thu, 05 Nov 2020 06:28:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id x7sm2698034wrt.78.2020.11.05.06.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:28:49 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] r8169: fix potential skb double free in an error path
Message-ID: <f7e68191-acff-9ded-4263-c016428a8762@gmail.com>
Date:   Thu, 5 Nov 2020 15:28:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller of rtl8169_tso_csum_v2() frees the skb if false is returned.
eth_skb_pad() internally frees the skb on error what would result in a
double free. Therefore use __skb_put_padto() directly and instruct it
to not free the skb on error.

Fixes: 	25e992a4603c ("r8169: rename r8169.c to r8169_main.c")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
The Fixes tag refers to the change from which on the patch applies.
However it will apply with a little fuzz only on versions up to 5.9.
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 07d197141..c5d5c1cfc 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4134,7 +4134,8 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
 		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
-			return !eth_skb_pad(skb);
+			/* eth_skb_pad would free the skb on error */
+			return !__skb_put_padto(skb, ETH_ZLEN, false);
 	}
 
 	return true;
-- 
2.29.2

