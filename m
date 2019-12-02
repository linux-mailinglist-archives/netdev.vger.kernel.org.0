Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514C010EF71
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfLBSny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:43:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39844 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfLBSnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:43:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so431453wrt.6
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=J4zSDOSwnfPSKPGR2qKeyhIBo15cNR8KCao+qo+kbTu8vDiFyZHCZBNzNg1f5/XoVn
         /Zvt4hxFEy81Hpmc6wK7RB3nwIlwgHW2B1ef0EHaNBTKu3Q8h0T3KaA0wWrDaQkp3UqL
         RgO1u0OV4wjhoI6OgTd2LxgoCLNfhcHt9p8z38r+FgJneTHGD8sBaw+jXR6BXJZG+nic
         Yj+4GolcsBPeUGJLE7/VDYT6WNG73lEPJA+fvGaTV8w0gFb4+6/HsXSQOy+hni68A2YI
         8xYYVzrnDjusDshjplUE696/FT08ntnLN5MdwQnsGfILSJM5SVwwrVoXw5kVr6Cc2PjA
         KoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPd+QRgs7ePapql6POhB+1aBTSVvo7+m0B0hFM2W+V8=;
        b=ZbpFkE8mr9BYXtzuLiPVgf6qF1leXDRJrk4lqxhSLIhqK3ZWMgAz60hewjJDs2r72S
         fHTfJ3+aXjhxjJ3HtHGKoxifTlzvvJarYel2HNhGREExyLC/EKCFDyu44MXyPNtNgU0t
         g4ZQXHahiWj1eS0cotcXhf0jkMiQL+75JwUIb9PaaWGGrnHgboVC0FFsypuesinEzNNN
         0Yusl+nM7pSZscP7n7VLLYOqXM5mee5K/oQ1RhPok43rqRGxwLDhMF+dmpawWM8n5ZGY
         qxgIJlvAQRT+z5WN6dgaZYQbYqUQb2VbegEiSyO0STgNCsPgNefmMkZlK8gn1uzNa/c2
         oYpg==
X-Gm-Message-State: APjAAAWGPVYUYKRNBCXkh4XI+DDbsIx4Mof7JT4xyiNCzveh/v1RZl13
        QWBm/eX5xfYZQyqoJAlEh/vdOQ==
X-Google-Smtp-Source: APXvYqw3Tl6vVuLZkZpg2L8yke229s5WeD8viXd0QK9pMEuc1/yMCUSLcTn99Xk79oW/+MsehxQe7w==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr393310wrs.113.1575312231765;
        Mon, 02 Dec 2019 10:43:51 -0800 (PST)
Received: from localhost.localdomain ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id v14sm342380wrm.28.2019.12.02.10.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 10:43:51 -0800 (PST)
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     rocco.folino@tanaza.com
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        Marco Oliverio <marco.oliverio@tanaza.com>
Subject: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Mon,  2 Dec 2019 19:43:45 +0100
Message-Id: <20191202184345.30755-1-marco.oliverio@tanaza.com>
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

