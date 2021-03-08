Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB34A331B05
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 00:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhCHXjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 18:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCHXjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 18:39:00 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D4EC06174A;
        Mon,  8 Mar 2021 15:39:00 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id v192so5346193oia.5;
        Mon, 08 Mar 2021 15:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2u78htuCTna7EY9F4ZLyNc7j57MyX9k6GdRgfX2JGE0=;
        b=AAd1fUrXNtpyONki+nL+TsZxT01ap0WhF9rIy/7QDuJew5lvQ0Jf5Y5MvckLHCXdCm
         bjOlND0RhNJrrMmvcyLNHEP7OZV62ptbQMj6lg/WWsTEtP1BVIkDrJuzAQaCT/EAQMrL
         xnUNAKFht7/+HTTlOKQDp8ah2Du8GEUXcVXiBs4whwEbPrOwcnCcHhglZ7tbHaNTBbOZ
         Zsh0xC6JIWpVsiXWt9+jnL+WpnhmjVEIwlffsMO1vNbcK5Yo1P/IdVVu8d5ylYouph3q
         ROf0ta03Uqvlm07ShyAiLODgK35mPXd80mlLiGuKukBiDrvZyW5eWn0aF8Jt4qIvcLe0
         4AXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2u78htuCTna7EY9F4ZLyNc7j57MyX9k6GdRgfX2JGE0=;
        b=DHB/SqlNBpJsGsKArerpTfIWklCljc1gNuQR6n6CJ1Gb4iZp6VHj1uKoIiejrt7M/h
         QLA0rMzgNP/ApNNMLfj8FWzgl0hKx/44OeFIAL75ZAbUjksJTKRVqlxRYwslHfykhWtk
         2KHGS0N9NOmnIqB9wzSLcX2ooP1Sfq2PgOVOH+vcDHjCMiA5oyk+m6Mi4qZLKssGm2Oq
         XVULRiiPIZ7eRlzoS08F+M71CToPzMQWTyHz6elh4O6WnBlRNWnn6ixm+/EejkOO6bjt
         mBZVEfxlDhW4P+L+Zbi8kqJ2F77dHKmUrHBZT250HofOYiuNpT8syU5VYQbq8pmuSDlN
         balg==
X-Gm-Message-State: AOAM532KEZ356e/nYDKEYSdy7rnEQxTEkZ5lrzXKw7el34iWyxlLa+Sn
        tQyaJrTYhyCkJONJEkTqaXYhY3LUEkE8
X-Google-Smtp-Source: ABdhPJxnNQkDkHHyS9QQZuN3s2I9aVx8520jA3FVFwA9Mjo+k+oze5cf6oDS/h1smOFQMzrPDHlPIQ==
X-Received: by 2002:aca:1818:: with SMTP id h24mr1004650oih.16.1615246739059;
        Mon, 08 Mar 2021 15:38:59 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id a49sm2963846otc.37.2021.03.08.15.38.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Mar 2021 15:38:58 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net] net: dsa: xrs700x: check if partner is same as port in hsr join
Date:   Mon,  8 Mar 2021 17:38:22 -0600
Message-Id: <20210308233822.59729-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't assign dp to partner if it's the same port that xrs700x_hsr_join
was called with. The partner port is supposed to be the other port in
the HSR/PRP redundant pair not the same port. This fixes an issue
observed in testing where forwarding between redundant HSR ports on this
switch didn't work depending on the order the ports were added to the
hsr device.

Fixes: bd62e6f5e6a9 ("net: dsa: xrs700x: add HSR offloading support")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index f025f968f96d..fde6e99274b6 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -528,7 +528,10 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 
 	dsa_hsr_foreach_port(dp, ds, hsr) {
-		partner = dp;
+		if (dp->index != port) {
+			partner = dp;
+			break;
+		}
 	}
 
 	/* We can't enable redundancy on the switch until both
@@ -582,7 +585,10 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 	unsigned int val;
 
 	dsa_hsr_foreach_port(dp, ds, hsr) {
-		partner = dp;
+		if (dp->index != port) {
+			partner = dp;
+			break;
+		}
 	}
 
 	if (!partner)
-- 
2.11.0

