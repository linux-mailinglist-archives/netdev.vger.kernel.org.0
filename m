Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77602D299
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfE1X6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:58:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40409 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfE1X6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:58:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id 15so276974wmg.5;
        Tue, 28 May 2019 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GZyffYfMPKchEX6Qggp4RmN0jCDvBMdBfEYe+t4NqOI=;
        b=klV+0RK4nucqfGR5SkClN8gc6IeW37MGz7hTGRPx+FjPQuxx+A04zkL7YhCEEKk0aq
         9ODqW+VYhuW+J2e0zDQ1cldPWagbdG8s0l5Qt4fclEN8TNS4hbt2T+WE2kfPRqBNIxsH
         X9Gq/BpOM52B4kjtuhph8L5iwk/VVY4sM0N51MISCReUgkeN8x4ADGwYeXORUcDd2c34
         pC4URtjRcV+sucBMA+3WDdkYWY37EX4nh304bSJZHkVGU/YQjrwIllV87U3NgX2K/wq8
         e7g2Fu90gR2+lqJLe1eolgRpGogvLOjispZXqYp8Ev7HAoJR9TYLZyLzVCZGHs2JxWn+
         qUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GZyffYfMPKchEX6Qggp4RmN0jCDvBMdBfEYe+t4NqOI=;
        b=i3B40czSDWSz/Tsxz9oZ+xQoaW3NYMyfAnA4EwiaspJEp5mXL6xUThMvLFDw1DTVZF
         ffkmoLNCXsYKQNJILgWo0gL6Gw6XVvCP8FiufDAvLccL/YfYwIlR9aACdVmTVFA2mHyO
         bnY2AGidHgTGDJtrGKy/maWLHxUPWxiPOaGlr54UY+xFfU1QLVse8Lzl/hQ4CIB3RMjx
         YsPWCSQ55WIk3auU1pHm1Z8tHLGydBwtMhI6/yOZsNLP38OTVE00PQV7ThCrqa+qK836
         cNDJO/VNKRG6NvKqyjCzuTCA4BMBHWoDZBI2xqGGG3jKLwjR5VGR8kFxthgB6ceJqej4
         IPlg==
X-Gm-Message-State: APjAAAVZhd1BhszRuUi7kvLlRiju2Pz6odSOV/MBZHxJsR9vTeOyQLJ0
        ZxeAfkeXym5vzYkuDBfKvK4=
X-Google-Smtp-Source: APXvYqx3YdxtxXesAGbrLO/pWGatsVocFLEqcvKamxWqcYKnHWWlO1ncmg76clzk4SnfvTlOQ5tlxw==
X-Received: by 2002:a05:600c:2187:: with SMTP id e7mr4723813wme.16.1559087913612;
        Tue, 28 May 2019 16:58:33 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f3sm1207505wre.93.2019.05.28.16.58.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 16:58:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/5] net: dsa: sja1105: Increase priority of CPU-trapped frames
Date:   Wed, 29 May 2019 02:56:27 +0300
Message-Id: <20190528235627.1315-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235627.1315-1-olteanv@gmail.com>
References: <20190528235627.1315-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without noticing any particular issue, this patch ensures that
management traffic is treated with the maximum priority on RX by the
switch.  This is generally desirable, as the driver keeps a state
machine that waits for metadata follow-up frames as soon as a management
frame is received.  Increasing the priority helps expedite the reception
(and further reconstruction) of the RX timestamp to the driver after the
MAC has generated it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ce516615536d..3bd250e4e070 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -380,7 +380,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.mirr_ptacu = 0,
 		.switchid = priv->ds->index,
 		/* Priority queue for link-local frames trapped to CPU */
-		.hostprio = 0,
+		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
 		.incl_srcpt1 = true,
-- 
2.17.1

