Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB16718EB57
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgCVSEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:04:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55860 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgCVSEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:04:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so12009817wmi.5
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8nPJmzAJFqc5LOFavwbEgUQfthab6zugyR6ppS8FLI=;
        b=A7yDVldS0jqBLr5xO481oA7XB2ubM4XlMLNpLEoDeHHVKVBjbL38XgStPm7uwF5zYX
         GMgfAuHPVThLW3PxPBH8PPQ8CJHx+XYQjEhsbckGhCiIo3wgr/YFmIpESJDBy102tvgl
         y2e3sAPxnoO/1yT6OTZJrdjcOkLTnVuYhSMQ277NzD7JgPXSo+gyv58gcpRku86hSljd
         6n6hxAvrS1TFWmsxUlzV7Leq3SA90A1V9n51NcyoU8Ajx51hmUIRjddYvukFUQc0/xc4
         WvVQ+L5+7kiyop2W6ZMYuYWirvuXdSm8OnIFU+Na+HiWxlO5OoOPSnCGdBAmHiiP/K7j
         6EZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8nPJmzAJFqc5LOFavwbEgUQfthab6zugyR6ppS8FLI=;
        b=TQsqIFOkbrd1oYmCZdLsSj8o3Vz3ekqINX3vDzRnzxZFp1ydeBA1BLbxjZEt+n57lv
         4f0dgpKog964f+a8V1Ou/gf1BHhBydceF+KOBagi8XQsbuK/6JUJAdRvO0XTglufzWuM
         MwtMTwdV0nrWmtOpJ2prufesRZ+FHGTCuAGci4w5p8t48cJAsGdIz5jG6ZU3Z9qHtKyn
         tzWXiBpcPtH9dT3ZRgK1RygIBwDPAAnYEQbzS9cGQg3Q87/aBX/cMKCrA8mJOX7cXXj0
         XYFTt1fPUDhz8dAJE+IzjN0gcTxDGVgEC4rx8vNd+814lAJUavUcRid+V5in2EZuXxwa
         r6kg==
X-Gm-Message-State: ANhLgQ39+CLcKmX2BkKDJ0TmVy/7bDPBt3dyT0/tNq/Cmtqy0w98eECb
        A00IS6mqnJHVyZjZSKyS/+pZM03h
X-Google-Smtp-Source: ADFU+vuUrMc9VHBp0Ezf4lg3m/Z+ux7o+/1DCLWAbCrkt2+TMGKquvyyTq30mKDbTwbNqdfxSW2BuQ==
X-Received: by 2002:a1c:2842:: with SMTP id o63mr4628536wmo.73.1584900246714;
        Sun, 22 Mar 2020 11:04:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id a64sm10282213wmh.39.2020.03.22.11.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:04:06 -0700 (PDT)
Subject: [PATCH net-next 3/3] r8169: improve RTL8168b FIFO overflow workaround
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
Message-ID: <e03d28ce-6542-835f-8d96-4f94c1137be9@gmail.com>
Date:   Sun, 22 Mar 2020 19:03:56 +0100
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

So far only the reset bit it set, but the handler executing the reset
is not scheduled. Therefore nothing will happen until some other action
schedules the handler. Improve this by ensuring that the handler is
scheduled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e9ced0360..b7dc1c112 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4575,8 +4575,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	if (unlikely(status & RxFIFOOver &&
 	    tp->mac_version == RTL_GIGA_MAC_VER_11)) {
 		netif_stop_queue(tp->dev);
-		/* XXX - Hack alert. See rtl_task(). */
-		set_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags);
+		rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 	}
 
 	rtl_irq_disable(tp);
-- 
2.25.2


