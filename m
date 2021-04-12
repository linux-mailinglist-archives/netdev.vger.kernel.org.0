Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE7535B7CC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhDLAin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:38:43 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:41660 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbhDLAii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:38:38 -0400
Received: by mail-ej1-f41.google.com with SMTP id g17so14637762ejp.8;
        Sun, 11 Apr 2021 17:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ai1fYsMXAfcw2GEL2Uwlzy50KG4+X4VPIXten5NjSnc=;
        b=qAtBXWPI1JWksBAxYwD13QdudA7dKmtFQGnuBNFoPjwpmJmch8VDVmBzyE+JniljHY
         qF9HE9I8nw+RIUISCd7d1fYnRkg7PrdEdABjXcUbFF0+YSTEQiOStNhjtblMNNaQhiNd
         N2ej5r7SnNNF43tiqZtM16pnEDvq+UfWyVM9wtc3L9+r//gX8RO+p8VSKOerD1rXJWxM
         PwrwOQucLNQDiJV9v/Mf+VBT7HOD8t+/LsGf16SkAGK3uOXpjFySjCd2bbShsA+d1+EO
         smEUS3DDMIRzCeTw4U8jBDjgfZJSmpfex/UuKqtQyjf47O5tO87xs/m6UXXY0j2MoZyV
         BDAg==
X-Gm-Message-State: AOAM533CiL159vpPULteTRwWVG+//EeCu82/JLy9Xf9A/sWVw9C1CjLM
        eJWF78DY4x8s6BVQInhF4Txz6mihiEI=
X-Google-Smtp-Source: ABdhPJxR5fkR4YjboaWoyqCu2w7eHdGD6PnEtlrtq+Kcpc6qa2/AKL3eCeJYwAemiNDcs1ftAm/Hng==
X-Received: by 2002:a17:906:c82c:: with SMTP id dd12mr1776884ejb.132.1618187898391;
        Sun, 11 Apr 2021 17:38:18 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id a9sm5477837eds.33.2021.04.11.17.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 17:38:18 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next v2 3/3] net: use skb_for_each_frag() in illegal_highdma()
Date:   Mon, 12 Apr 2021 02:38:02 +0200
Message-Id: <20210412003802.51613-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412003802.51613-1-mcroce@linux.microsoft.com>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
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
index cc5df273f766..605103582aac 100644
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

