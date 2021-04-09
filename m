Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E86E35A534
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhDISHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:03 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:33370 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhDISHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:03 -0400
Received: by mail-ed1-f49.google.com with SMTP id w18so7637093edc.0;
        Fri, 09 Apr 2021 11:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z4sgDBLXwxEY87QxPLWCqsAiKmh0VfdIxRXwqQ8C9+k=;
        b=b3fVo17tF5IL4ho5V2g40OnMsRLnc8hiQYNfqryBdXvsE20oPSAbkAKc/T5KrK6MR/
         OLB+ey+anMxqMLWbmDVpJ53Ttl+P5uwgPFJc6hfkhtLFqJlTpX64j5Y0Bx17gKP9B1CC
         Do9wAR6RXIawJ9V0DCn7mf1+RWe3G2dBDaJ7GYu5YxStRm5HJUm4zvrrgQn+R7crCsno
         RKYNOrt6gK+ZpAQBEktdxuPgyW598842ep1zk1mgvfzWeogwK/7fZkK0PGU5GXgWvB8X
         y9Ny1om6MR3507wO2Ndol1h1WRLEbNc6nY7DjCwuFvKKiVVcfy0s+ZeOBXeq3yt0u4/Q
         A9Pg==
X-Gm-Message-State: AOAM530lcBAwxcORNxIpnOpInO2vPAMwiIvmzJYAkcRiXaowwKvQflE1
        gkoNWS0Qr71VlpxehIV1xOOocz7pcBg=
X-Google-Smtp-Source: ABdhPJwEUk+2l0biYLbYUC+4wXkKlCAPMzP9tXwpwn021PMMZk3NGjqhyGk3d+wmGFNJLZJnp9jJZQ==
X-Received: by 2002:a05:6402:4405:: with SMTP id y5mr19075811eda.32.1617991607832;
        Fri, 09 Apr 2021 11:06:47 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id k26sm1571383ejc.23.2021.04.09.11.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:06:47 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next 3/3] net: use skb_for_each_frag() in illegal_highdma()
Date:   Fri,  9 Apr 2021 20:06:05 +0200
Message-Id: <20210409180605.78599-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409180605.78599-1-mcroce@linux.microsoft.com>
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Coccinelle failed with the following error:

 EXN: Failure("no position information") in net/core/dev.c

Apply it by hand as it's trivial.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 33ff4a944109..98deb4852151 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3505,7 +3505,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 	int i;
 
 	if (!(dev->features & NETIF_F_HIGHDMA)) {
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_for_each_frag(skb, i) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			if (PageHighMem(skb_frag_page(frag)))
-- 
2.30.2

