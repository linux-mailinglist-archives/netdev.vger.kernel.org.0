Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C647B18EB56
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCVSEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:04:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33923 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCVSEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:04:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id 26so7281484wmk.1
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tj5BOBwt+tZgzN78lpjbaZZ1K15kqel8mJEF1GGMT20=;
        b=CUr5zKbtkzXG8hzZ+nd7n7lqtoeOPInBGAjoMeaVqkz7RPbCQPZYWEpeXKKtRvUb9A
         GWSWSNK0kSxklVvE8zckmQwJTNW+ACvGzgjd+p94EgD9KdoPkkFvURcP6eKWttggJ6/U
         i0hrFfsDETaku51yDq/uRsvFPGmLOMgLQG05yZcevggtb1434YHRwhRNjOscRaQUB4Hm
         LBUx6N36R0UktXnrCzQvOX2m71LERDuGvgTHiAebmsalXYAfdTYusI0MuaXD1bnGjtQA
         rmiRyTdOIB9Lj/y6cU63suGlNaizN5sdiZ/6i2FINf3IvMaOR4GAZNIpdrI1dtD40k2E
         9g+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tj5BOBwt+tZgzN78lpjbaZZ1K15kqel8mJEF1GGMT20=;
        b=flHIrhRw9NzPtTuKOafbt9coPCfxGLDOMBljNqLpb33FXfcyQcd6eb5PdIcdg0eIcI
         1QLWdw+Eqw0p5qqcsy/UOXhzbqialfTQLCGJwIcku1RwAupFM4WEXmtp28AOuq+ZxtXW
         fcAZOltmmbAmO7fZUWX1vjkvItCB4Ks/nU07up9Cp+HVrPgKBRv7F7GeGmsTIOLIP7iF
         oM4DZmeK6h3o1uCXUcCXpAv849YT+w8M1JQdQ8REB5Sj4mQuggReDFJ3VMpZPn0CnlK3
         esCi7P2c/gKDj0idcn43ODCbGOsKsKBF50sH3m+ZD6C6KTMqT0WA4kfBv/FQ58iZkXuL
         p3fg==
X-Gm-Message-State: ANhLgQ3Rm6W42dBHh4Kii7DM7RqXw9IFdH/WBuwl7JpcfY4/50W0yT2N
        hLyt2zFGd2yW52E8vzkOobtW8YWF
X-Google-Smtp-Source: ADFU+vu6LjmR0HpbXD0t5LCzjPtu/MsKbTbv52dP1aTTIHMTb+ECVIiU0rJtaLUzaDHHWibhqH00TQ==
X-Received: by 2002:a7b:c391:: with SMTP id s17mr22648539wmj.55.1584900245756;
        Sun, 22 Mar 2020 11:04:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id t126sm19028557wmb.27.2020.03.22.11.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:04:05 -0700 (PDT)
Subject: [PATCH net-next 2/3] r8169: improve rtl_schedule_task
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
Message-ID: <5ea504dd-caf4-066d-a35d-a5b4846861f3@gmail.com>
Date:   Sun, 22 Mar 2020 19:03:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation makes the implicit assumption that if a bit
is set, then the work is scheduled already. Remove the need for this
implicit assumption and call schedule_work() always. It will check
internally whether the work is scheduled already.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 242b14cc7..e9ced0360 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2228,8 +2228,8 @@ u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
 
 static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
 {
-	if (!test_and_set_bit(flag, tp->wk.flags))
-		schedule_work(&tp->wk.work);
+	set_bit(flag, tp->wk.flags);
+	schedule_work(&tp->wk.work);
 }
 
 static void rtl8169_init_phy(struct rtl8169_private *tp)
-- 
2.25.2


