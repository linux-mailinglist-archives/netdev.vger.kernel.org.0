Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8307D39F7E
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfFHMF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52688 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfFHMFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so4437078wms.2;
        Sat, 08 Jun 2019 05:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6DqNJh4jJm03bOKgOkYs+6tY5+ZJVyuTKSv9adK700M=;
        b=RPla0KbBjbU4GjjjtzZOKUZFyrldgu9FTBvWFYuZprunoaDB46HPbzEtQT2chmIOXd
         iLgt2FnbNFL7WukoYMus1/HSaSuB6v3LWQR7W9okj0vqqbBtEoBgR9LAQuPdb3P1OWwl
         15u8Igm/C29ve23kAsGFbcJ4N0H35fGFk1q3ksUUO/G6sMOGsGtYaHGVYv3gN6aOS7pr
         A+HuqqV3a+UFC13mJ1wwlrgmAcu+b6+XCVl1ot6y0WdIf+x1ViN7DWnXI9JOxle0QseE
         0Ondwe0BlmuEMS+elCYq9q6q0WPidYAJCsBQGILYUClrsJ+7hoAfNfJsuhxmb6hmzivB
         tSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6DqNJh4jJm03bOKgOkYs+6tY5+ZJVyuTKSv9adK700M=;
        b=cNThWQ7zberdWjikFGlqz5OcyUxRChSgoyGgHK49Y6H5enz+fUcWmCLHluP0ScmUTp
         10bSyNUPlZvfHy1ya6YUIJ5C2fW9VNknqxsDMovZ/A9o7269TgG9GGZke3PHmSex6l3I
         Z7/uMaqWAGRTkb6I2ck6SoFc7LZxd0gx9vUT+xt1g2+0SBpnpLjJ2elEP4nk6gZ5QbYn
         tG9wjbxri9NeDyr5GJ5UlMovjPZ0s44c0ShvSp33bH62GOMcQd7ZSGdWooEJN3uzX+O3
         q88WWtLACsLduQTmHvXeGx57o/dJ9WOlfm3YuGUKhOPxNMpTlFF+QtOOQLTYhzKOQgpT
         4Aqg==
X-Gm-Message-State: APjAAAWCpxHBtLVL+GXn9HAhtjTN3qbQ/7z0eHeM3LLHAkTttdMjnT62
        Fxn+geUCHQgriR03S+OpyXU=
X-Google-Smtp-Source: APXvYqznJjdyxhWV4RvGus8Y7szy8XKGGmutHpOaYzeA+W3IWjQBtflNZv2SJWMjQF/11o77PRwqmw==
X-Received: by 2002:a1c:3d41:: with SMTP id k62mr6300976wma.61.1559995551682;
        Sat, 08 Jun 2019 05:05:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 15/17] net: dsa: sja1105: Increase priority of CPU-trapped frames
Date:   Sat,  8 Jun 2019 15:04:41 +0300
Message-Id: <20190608120443.21889-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
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
index 3c11142f1c67..2b804eeca390 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -389,7 +389,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.mirr_ptacu = 0,
 		.switchid = priv->ds->index,
 		/* Priority queue for link-local frames trapped to CPU */
-		.hostprio = 0,
+		.hostprio = 7,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
 		.incl_srcpt1 = false,
-- 
2.17.1

