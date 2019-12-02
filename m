Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E1A10EF6F
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfLBSnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:43:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37043 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbfLBSnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:43:09 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so568126wmf.2
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=e0cE6g1sF+tY483HN62l54+lh8EkwXvT9uFIWhgvdS+QGVUESAEZi3RBcMnW+R94w5
         9OtLdqfTeE+evMBddiM4xZbi2zeTOrS//ywnTXUTQnfq5ni85hVxXXF3zxxpQghfviK7
         Yjj6F8XalTSvWQ/r2WY34AkYONeSyRVOIk8nEX8MVjZ7S2xo+QMC4iEP5sHCRwgZRSAR
         QWdf2ekujy/KYR9Fl0RAnObzFZjqysXbn11QPVaWzlNh2zxBshLbnZH2zug6tdFS5GzK
         /XHovPUETBslUW9Pm0gaALdEMjU+DRFYVRwbnGJTR6t8QBTp3qe4ERlHEHpYZQhbHUfa
         mWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=HFh58siyMapC5sbOjt+klmo5SeXZFQxgdJ8QU3hDBo+Eif/ZiPWa5u4l2po36DHJpR
         vWjHCAwI4A/bPwJEeqnFqcvqIK0/DH30EEWBbokIXgWMkmvsZQxOVr8LIiosy+BZpXWb
         LLpiwEH9ZFWp2Z4n6eqcUlgIAffOPyEknBPnNw7bzZBsqUVmlEOZRu3e0xmr6LOCjlIb
         5cAY4uMuKmvBnWFqL051jwVxXqhPT91pFgLwUtSEKVsn9DBigJxjCdO+bhRhhTsycqAA
         1NurtT6OmjkmfAEXHfy5GNepzxTr5MKieUhtXr2zmnVU+fBKQ3wc+MVHyCz8TvEAluDN
         Fgwg==
X-Gm-Message-State: APjAAAVaT9gJkuTYcSuEd7hCnDTazLGfQC4hs/9liToFZ4Yzvb258v6J
        WCM5TIJP67gAe1Qbqpb5SdyDog==
X-Google-Smtp-Source: APXvYqyZdO58+nWBztCHuIY/KbFCFXrStCRvUDDx0IfLD8lquGZ7s11a6zJhR7UoGLDqayc/CrF7tA==
X-Received: by 2002:a1c:2245:: with SMTP id i66mr31381227wmi.86.1575312186906;
        Mon, 02 Dec 2019 10:43:06 -0800 (PST)
Received: from localhost.localdomain ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id t1sm304557wma.43.2019.12.02.10.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:43:06 -0800 (PST)
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     rocco.folino@tanaza.com
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        Marco Oliverio <marco.oliverio@tanaza.com>
Subject: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Mon,  2 Dec 2019 19:42:59 +0100
Message-Id: <20191202184259.30416-1-marco.oliverio@tanaza.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bridge packets that are forwarded have skb->dst == NULL and get
dropped by the check introduced by
b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
return true when dst is refcounted).

To fix this we check skb_dst() before skb_dst_force(), so we don't
drop skb packet with dst == NULL. This holds also for skb at the
PRE_ROUTING hook so we remove the second check.

Fixes: b60a773 ("net: make skb_dst_forcereturn true when dst is refcounted")

Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
Signed-off-by: Rocco Folino <rocco.folino@tanaza.com>
---
 net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a2b58de82600..f8f52ff99cfb 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -189,7 +189,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
+	if (skb_dst(skb) && !skb_dst_force(skb)) {
 		status = -ENETDOWN;
 		goto err;
 	}
-- 
2.24.0

