Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA461A443A
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDJJIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:08:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37451 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:08:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id u65so823918pfb.4
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hXJ0uJ3nr0jmaP2DH0n4+T7XWmlC4tRLr+n2Pudmjc4=;
        b=ffDlJ/nR2SmHXtDrENr7WMwdQkR0YPg2D0iPIXyr+XUi9h66mtQmKgKfwCaP94oX3T
         slko8rMvbzQ0/493o+lCAO9Y/wVxWGiEzAbpOItJjuUNyKn8HWKLfwJIbhVxpsr6MYe0
         fwIk4HFcx48xHzhK+SSwSNijKD7Ryj8kYO1fA57n3oyAjsAKpcu1jIVYNbgvb5gC8gCk
         HQOARqwWsTl+MyQ9X3Z66VXCFGBKevcNzfeN5Hwtdt7Lm1Y7CnS7Mwf8AkgprW2S0+Uo
         jspORAqlZm6lMogaCPYNaZZI5WbQAusOHfzW6oclkGF4w5HO2nTYSrAxWLh3nl+cUEct
         yGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hXJ0uJ3nr0jmaP2DH0n4+T7XWmlC4tRLr+n2Pudmjc4=;
        b=fZEzW2YfJn+8IG6GpSJz84fJ3fVwKkoCjxpxQkgRBH5R6j0qcINK8X5Tbjlc+JpM++
         yvsR46HXG6eQIn4mqnJZ8oxFh8lNEOjDrqCVgzm1qCsApS6YPC5M+UhnBuiQ8YUAxwJi
         vKrhJ9r9TMnWsYKu/SLwmlxpCFLFoV6tTws2zjmn/ot3zXvYYPFlZ9prS5OzvKjxQi9f
         JcSYe3cByPIxmRWG4LPD/c8OqKNsdkYy8cRIGsacAO2eVjZgOde0Yml6cqgNgjnfwRM5
         1sj2dheNcneUaJFgH0u9gJZBx7QSlgM/0ZuZBcwnrA/bEcIUA9497lUR4ySqePzJDCLE
         fPPQ==
X-Gm-Message-State: AGi0PuZZdS99pddThXgwuexjJXCcB/BIhFwDICjrgowU7lTbfY2JXnDq
        PLaNwCXGxTUGwccVWdXnDF31XaJk
X-Google-Smtp-Source: APiQypJKrrswFh9QzIOhgFl82on5wDPMcgihjGbnfBFzzTx1/M7n/e+r1ql2qNWycvphud7FBni6CA==
X-Received: by 2002:a63:a351:: with SMTP id v17mr3428909pgn.351.1586509707883;
        Fri, 10 Apr 2020 02:08:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l7sm1261843pfl.171.2020.04.10.02.08.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:08:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: remove the xfrm_state_put call becofe going to out_reset
Date:   Fri, 10 Apr 2020 17:08:24 +0800
Message-Id: <f0609f4a5b90fa6cdfffc5b3b68b9f9014770ea0.1586509704.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This xfrm_state_put call in esp4/6_gro_receive() will cause
double put for state, as in out_reset path secpath_reset()
will put all states set in skb sec_path.

So fix it by simply remove the xfrm_state_put call.

Fixes: 6ed69184ed9c ("xfrm: Reset secpath in xfrm failure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 4 +---
 net/ipv6/esp6_offload.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 9dde4e3..785baf2 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -63,10 +63,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 021f58c..4c4f7a0 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -85,10 +85,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;
-- 
2.1.0

