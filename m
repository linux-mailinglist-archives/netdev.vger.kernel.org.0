Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D597FE2363
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfJWTmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:42:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39537 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbfJWTmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:42:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id r141so166446wme.4
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 12:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XHVSXBTTDPSRigWI86ZsKOXVFmCz3BVdzZsozZDTsUk=;
        b=NMeU0BLvjXAUH5We8wFOo2qpcxHU75571gcSrUq8/z+mciP8LYuzbG/WWF1jYniq77
         +7sgVM9gps1FrFLr/ooin9BjNOQdrP4OgaCatVTjjHLf9gMdgwNuDBB3B6RSnz9bhHNx
         f+5OgEKCDO4cYDIRKhu4Qg+ncX/UYgZYthyPahurcr0kiAY8GwFjUQVaeN/kPF/x6/1G
         e9E+To599iATJiFWonxCAerU59gtO7Y0bU21aqlAzSkyKIOByTVuvvRDJDErmdRZKcWA
         swpIix9vzoAo2ir2A7aQFRC97YGdotTBaSXG7FUunNWWuSMBHcmuMW6+i4vZrE+Fsuf6
         2bFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XHVSXBTTDPSRigWI86ZsKOXVFmCz3BVdzZsozZDTsUk=;
        b=JXCIBfTYqXDFTV5bj00rh2oElMMxxa+ZojpoH1b6uAskkaXUo1I3cmnkfhhk1uphBL
         YwJDQyhkPt0ylKv2ncfztPPiYbiDa87QXerkDZfNjl54GLWqxPq8qwwwYXRGY/QFXB+n
         8/v+gzbwGxV1Na51Npz8p0/UI0LVCQ4l1et3DWho6WOHov7fPO7jO4nxc3dctiZOQbe4
         Dq9hYUJsT7BoWLJQE8EyNh16cfl4MGFOJusGw+EI2RT0P06Sy+YrbkMd5jCY59BGVuDM
         PgUgdcZkaomm6/9Aaa2C9r05QIeKouyx1AelJU6AmBH987iEtzG7tTRVZP/SHpGXNkOS
         jYog==
X-Gm-Message-State: APjAAAVz3uB8H6aNeIo53IcTm+78XIdnt/Pt+vVoEu+SzGNa0bR46Llo
        JpYzaVGmcJ5dW/uDaQC3nbmPTEX2
X-Google-Smtp-Source: APXvYqwEZyY1QdklV3JsNeruLs+j4GvGGcmQsViLkCN798KMNR1MfxuCBEekUQmu0HRuACl8Nbo1Mg==
X-Received: by 2002:a1c:7e57:: with SMTP id z84mr1463236wmc.84.1571859383361;
        Wed, 23 Oct 2019 12:36:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:2dc9:419b:b5f1:8890? (p200300EA8F2664002DC9419BB5F18890.dip0.t-ipconnect.de. [2003:ea:8f26:6400:2dc9:419b:b5f1:8890])
        by smtp.googlemail.com with ESMTPSA id a186sm207139wmd.3.2019.10.23.12.36.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 12:36:21 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl8169_rx_fill
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <fb0f8c51-6ef4-ed93-254e-871f482f8f6e@gmail.com>
Date:   Wed, 23 Oct 2019 21:36:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have only one user of the error path, so we can inline it.
In addition the call to rtl8169_make_unusable_by_asic() can be removed
because rtl8169_alloc_rx_data() didn't call rtl8169_mark_to_asic() yet
for the respective index if returning NULL.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 43ffd4f49..91978ce92 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5493,18 +5493,15 @@ static int rtl8169_rx_fill(struct rtl8169_private *tp)
 
 		data = rtl8169_alloc_rx_data(tp, tp->RxDescArray + i);
 		if (!data) {
-			rtl8169_make_unusable_by_asic(tp->RxDescArray + i);
-			goto err_out;
+			rtl8169_rx_clear(tp);
+			return -ENOMEM;
 		}
 		tp->Rx_databuff[i] = data;
 	}
 
 	rtl8169_mark_as_last_descriptor(tp->RxDescArray + NUM_RX_DESC - 1);
-	return 0;
 
-err_out:
-	rtl8169_rx_clear(tp);
-	return -ENOMEM;
+	return 0;
 }
 
 static int rtl8169_init_ring(struct rtl8169_private *tp)
-- 
2.23.0

