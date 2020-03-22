Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5099718EB55
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgCVSEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 14:04:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39987 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVSEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 14:04:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id f3so13929137wrw.7
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 11:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OZbUlCgfdsQNSZsqjsYnFy6cu+94ZFfvIX6eD+CY5h0=;
        b=T7rnzZtaghhhByu6rXJR29nslKDkAN+pkr1AMaxQv+qahDyarJ20khhMqccwRzE/V4
         cI8zYtEGr6vnYhWxqzXwQIebEfJH3HKB5G9J5EZWD0/3CIBG7eVe7uqBBqRPtty80Gv5
         4/KF6YWbnR/hnEGL2tmwCqRa51REDUCLTi43sJJbkS2XDr4y9yDzYWbfQzaGugvo2OCt
         AJmUoilHM4noEasSQjlRc/S2mpacarAk638zIQGqlWgR7CrdCuTcFuY3lS1Jq9mAVMUa
         06m2Lk/EqbA5LdIXrdzYLyYZa9BVbuMonReZjnbFFeM+0sIZZxV8FczwjGEjaZIYM/9B
         2Htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OZbUlCgfdsQNSZsqjsYnFy6cu+94ZFfvIX6eD+CY5h0=;
        b=HfUkDl68IsV29gcnr+4PSVuhJDL9wVRWa++CtR9gDrgzpFq2AdE8x8osdYBRk7qLfR
         33rXFDAONnmg1mczKoh5gMdXDXp07wpKxtMLKb6mgnSemRqnI7l6ktXy4uUNNX66I1vT
         H3FfaAWeKe//CoMA7Ok8Xv4nZ5AOYrOxLZG59j2y0wnUS3054zCCbl0nCXxiOaIfxGSX
         DFp/FWFVEjukEapN86JYLS2k+lu4z1tYN0J7H15byaPkfgkX6r7ZX/rzybXpvFzSnzI8
         oiSfS8FQuYF9N1rfY5FkrTsg0vttCcwEIS1XOJgkVmoMb92ITEAKaMa/TP/Qp1ILIfc9
         xW2Q==
X-Gm-Message-State: ANhLgQ0fpwi3NFoepVGvdyd6JMwUN4Dcg5jefujdirILKcSAjoUvD1yD
        SRNGgd3fOpHQBIslbQx5GJAUgEXR
X-Google-Smtp-Source: ADFU+vsxl76xDksg8eb4RIYZS5KddmXcSIEfeVczTu53khmR/CZgoIwy/R+3ZSM3898MGF+C4x0A8A==
X-Received: by 2002:adf:9ccb:: with SMTP id h11mr5078665wre.22.1584900244728;
        Sun, 22 Mar 2020 11:04:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id a8sm9709828wmb.39.2020.03.22.11.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:04:04 -0700 (PDT)
Subject: [PATCH net-next 1/3] r8169: simplify rtl_task
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <984b0d19-07f4-fa9c-2ac8-4d7986ca61ee@gmail.com>
Message-ID: <37a2ab7b-c2b2-5858-51b9-162469d33d51@gmail.com>
Date:   Sun, 22 Mar 2020 19:02:32 +0100
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

Currently rtl_task() is designed to handle a large number of tasks.
However we have just one, so we can remove some overhead.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d2eef3754..242b14cc7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4589,31 +4589,17 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 
 static void rtl_task(struct work_struct *work)
 {
-	static const struct {
-		int bitnr;
-		void (*action)(struct rtl8169_private *);
-	} rtl_work[] = {
-		{ RTL_FLAG_TASK_RESET_PENDING,	rtl_reset_work },
-	};
 	struct rtl8169_private *tp =
 		container_of(work, struct rtl8169_private, wk.work);
-	struct net_device *dev = tp->dev;
-	int i;
 
 	rtl_lock_work(tp);
 
-	if (!netif_running(dev) ||
+	if (!netif_running(tp->dev) ||
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
 		goto out_unlock;
 
-	for (i = 0; i < ARRAY_SIZE(rtl_work); i++) {
-		bool pending;
-
-		pending = test_and_clear_bit(rtl_work[i].bitnr, tp->wk.flags);
-		if (pending)
-			rtl_work[i].action(tp);
-	}
-
+	if (test_and_clear_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags))
+		rtl_reset_work(tp);
 out_unlock:
 	rtl_unlock_work(tp);
 }
-- 
2.25.2


