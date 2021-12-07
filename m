Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037D746B2AF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 06:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhLGF7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 00:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhLGF7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 00:59:36 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E01AC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 21:56:07 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g19so12406109pfb.8
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 21:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZA+NL37GyPQjL7oCpSdAjYngjOuaMcnsL8S7ue8D880=;
        b=N3HPvML/gPfT9irppJnPzkv+NW+OqxxljNeW/RwRAutErdScBEGXM5KdZFXgn/m9WO
         GGhY6PTsOtYBsMY7o40uGNqiqwH2U5bAuolXbIGRn8whS81ky6RX3oYdzJda5bmG/bG9
         VRIZ/JZrvLQMpcU45N4+QlvbATHbdvE0MSZqRJl+GfmfMPs9fjk5ENrRjCm+8XJv9hnH
         /isBGasnJWMsGrhLnZ9Mx0HfYP1NiWO75ba8hYksR0JVN/RcN4RieUotF+3PG60ccl0I
         0JrzKxsXpUShyrF1HaIrK3PwNqrbXg/N+7CccV3dObNzkbC4s7Tw33YdhcOv9ETB7kqC
         zQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZA+NL37GyPQjL7oCpSdAjYngjOuaMcnsL8S7ue8D880=;
        b=bVApgvwCTywSsWey65v0eBjoaEFMV7iRreFEBtjhzXvEOsFLixZ//ZtWLQwhlKGw2C
         fszca6z6jmcYWdA0if7TyVNQU+bBt4yNhwYQ75lZHlZuHtcolY2SHs5MoHIbZvdEjgi1
         ECi12gOoWw0JcFZPehTsfY1LUVTCEnn2c1SYACa22gIiBHSGN5fnmAnMYGp5l+5Sseyf
         PQyfp5e3nXPRSaJUlur3q/f0m+Lx8qRr7pEM9t2OJoEXbDIM8QzbqD6p4bTtJ3K4+uNm
         j4Y8CEs6GA4gi2u44O1qG9JLyi5E8spSJSSuojMU8H7kTpI5ErBLdiwDdlUiMPUI+3dM
         m3pQ==
X-Gm-Message-State: AOAM530qWE4itCij3kGN9kwWNjzOugcZVgREVsFfK8ytazmO9/0XSEag
        91lbX9EQROAvBjh1rjQLKsk=
X-Google-Smtp-Source: ABdhPJxzWQkYpBzV5zossfl5+XMHH67QDpjpcZY9z3xNmRoKhvjRWQ1/bV4P7FHvFr42ZGobny3nIw==
X-Received: by 2002:a63:f654:: with SMTP id u20mr22907365pgj.233.1638856566984;
        Mon, 06 Dec 2021 21:56:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id s14sm14453288pfk.73.2021.12.06.21.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 21:56:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] vrf: use dev_replace_track() for better tracking
Date:   Mon,  6 Dec 2021 21:56:03 -0800
Message-Id: <20211207055603.1926372-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

vrf_rt6_release() and vrf_rtable_release() changes dst->dev

Instead of

dev_hold(ndev);
dev_put(odev);

We should use

dev_replace_track(odev, ndev, &dst->dev_tracker, GFP_KERNEL);

If we do not transfer dst->dev_tracker to the new device,
we will get warnings from ref_tracker_dir_exit() when odev
is finally dismantled.

Fixes: 9038c320001d ("net: dst: add net device refcount tracking to dst_entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/vrf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 131c745dc7010b1653b937e87c7f7f5a67e3460d..dbfa124d1c1c03c768ddeae6f2fc7a06166a20d4 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -814,9 +814,9 @@ static void vrf_rt6_release(struct net_device *dev, struct net_vrf *vrf)
 	 */
 	if (rt6) {
 		dst = &rt6->dst;
-		dev_put(dst->dev);
+		dev_replace_track(dst->dev, net->loopback_dev,
+				  &dst->dev_tracker, GFP_KERNEL);
 		dst->dev = net->loopback_dev;
-		dev_hold(dst->dev);
 		dst_release(dst);
 	}
 }
@@ -1061,9 +1061,9 @@ static void vrf_rtable_release(struct net_device *dev, struct net_vrf *vrf)
 	 */
 	if (rth) {
 		dst = &rth->dst;
-		dev_put(dst->dev);
+		dev_replace_track(dst->dev, net->loopback_dev,
+				  &dst->dev_tracker, GFP_KERNEL);
 		dst->dev = net->loopback_dev;
-		dev_hold(dst->dev);
 		dst_release(dst);
 	}
 }
-- 
2.34.1.400.ga245620fadb-goog

