Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E216410EF7B
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfLBSp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:45:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38051 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfLBSp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:45:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so564339wmi.3
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=sH4e9NHKZzkTmn7ltOUix78Vm87DAjbV//WRgMOs1NKw6kcDyI7yQNOp+T0NimePoE
         vX8HipYFrBHYtulcOZHYZoObyXGKkxLzqNRxlNoZo+tWevneBo6KI4O3loDkaQK6kenA
         Q9BYpIXnV6fALBpVQ1Shhez2cjoq6f5a1tlCt6XlJb+FS7JjXNysNH3VQOPOzryUC6Li
         zwStcM+TH52em8Lzx6UO++k+s4MLPGGnImCWgzpwOcXl9WBxgq39niUvIW78T2g3JX4j
         MqHywiLyIHeMzTYbaHyKcSmM1K7R1PnfW6yDEm7rMc7W1zYmqJ+ESfH4EuOwO0BTjlSb
         H6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=Ig+WKbOBA//ypL0fV7KAPH9vYZhEYjsmEy26NaRlz70qL6vyaWGg4l3qPuPScUFi9n
         XYYvjMUW6GpkPoLO2vH9OwVbiZBc13IZjKWlizvn3WHCDnveE5/uYzS0wHBi3ScZvdin
         GArJ3/EMiHdUAwVI5r/uaYfCPy4nbq9lcwEiPB+VvxevLPCNh/kFXP6lcYTdZytGP//m
         0m2s659sT6Lyx3ZQrjCBPPvfFDXNEkTA9E3OWiJOxjOSR9ca/CDPueVu9wOEn93N8byx
         xyxJNUJhiooAP9goRH9jwnfVCxrQiPUQ9gtaWV230QSTuXPRTTeK+6ZyVfruF781Qm6w
         Sopw==
X-Gm-Message-State: APjAAAUKeq0qg5o7krLo1Tt4F9JhHWL4G73l9z6PvCKvVzecQDMnqQCP
        updWuNhAKVYe12Xn0luBhRQ67A==
X-Google-Smtp-Source: APXvYqysRVaX5YC5uLnT4dw+a5HbChrr/ywLcja6qV0HwtbAVsYLK0rWSxKpT5RCSCj1RcQSBO8+kA==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr6744043wma.121.1575312325902;
        Mon, 02 Dec 2019 10:45:25 -0800 (PST)
Received: from localhost.localdomain ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id k8sm361585wrl.3.2019.12.02.10.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:45:25 -0800 (PST)
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     marco.oliverio@tanaza.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, rocco.folino@tanaza.com
Subject: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Mon,  2 Dec 2019 19:45:16 +0100
Message-Id: <20191202184516.30861-1-marco.oliverio@tanaza.com>
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

