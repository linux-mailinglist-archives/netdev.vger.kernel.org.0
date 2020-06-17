Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECC91FD685
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgFQU4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgFQU4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDC8C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d128so3478685wmc.1
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l1LC2Irfpc6BGnyAnq4AXVKzvohW3OyajQTmgEYFLIY=;
        b=SasygcGZV8rJpkGxZYVMIgyUlBRU3ierWc3nFP8BVbGjCyMJabXqhu9WMH3Wm2Nx8J
         jz1FCdzVWcEqRx+ITkCc16awPdvpo4Fr3N7bk6G71J8vOpd8aE35Smrd8+10qQiU34v7
         uXxrZb8Qf0qr+pLVduXTjfrg5kkNDct7KIymodV1NuIRSrpEPYiElmhIG8vq8JStlPJp
         9DQH7hCLGxo/tKVtRoJVnYEkrDNvDOC35exEQgWIunpV2tD9z91fVICeylc0jlPPriAp
         9yCK0dgLakl6qVTaVhy4pxnp2Z49vR+G0e+cmackrpBLQDHcAtaj+Bd/yjYy841mwFVQ
         8/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l1LC2Irfpc6BGnyAnq4AXVKzvohW3OyajQTmgEYFLIY=;
        b=pyN43BUc9tXqSxKDJGnPJQMkd2ozPEL5XH+xtLOw5C/ySID19rdBUCj4WMlvktRB5j
         hQk01JvYfqOSdz5u16RRTDqjJMJ2JBvKlHg2toYBPLzkbFX6TVTYooX7JzY8q+43dzND
         H6l/1+0g4h8IMnw8fId9Tdc/HYfkUVg7MvNTol7oa3kgdXwhOyHV+bpWSPokgM+7B1dG
         CufgzAOjJ/L1Rrg54T4YD2zBmvB/4BQhJOKYKcWW8L4G1NWCgZPyriNN6VGt0w6uIcdW
         ShL+oHfmxYQf7kSPXRetg0oCUsbhRIKfZQyy0IcJHYuSthVu7/JpCuldMi8I7x75w0SS
         vh6g==
X-Gm-Message-State: AOAM533NdIAsD+i2giX9WWp2ZD/ClxU/05g/+iLTB6Fycy7MwDY6uN0R
        PgLU+P+y/iaD+DjvIDhnk9vgzgDX
X-Google-Smtp-Source: ABdhPJwDv5Bcq++FPdpzpLcKZFpw1+myt3POfhcTIeAF5scYpsf59vmD/gQa+elcl0aLEF69cNRgJQ==
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr560822wmh.38.1592427406186;
        Wed, 17 Jun 2020 13:56:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id q13sm828776wrn.84.2020.06.17.13.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:45 -0700 (PDT)
Subject: [PATCH net-next 4/8] r8169: replace synchronize_rcu with
 synchronize_net
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <8924ccae-fac3-aae5-dd9a-711a1ef861d1@gmail.com>
Date:   Wed, 17 Jun 2020 22:53:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8169_hw_reset() may be called under RTNL lock, therefore switch to
synchronize_net().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bd95c0ae6..0d3e58ae1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3929,7 +3929,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 static void rtl8169_hw_reset(struct rtl8169_private *tp, bool going_down)
 {
 	/* Give a racing hard_start_xmit a few cycles to complete. */
-	synchronize_rcu();
+	synchronize_net();
 
 	/* Disable interrupts */
 	rtl8169_irq_mask_and_ack(tp);
-- 
2.27.0


