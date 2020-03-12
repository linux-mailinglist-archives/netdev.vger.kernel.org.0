Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8D183D65
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCLXgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:36:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35864 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLXgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:36:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id i13so4060001pfe.3;
        Thu, 12 Mar 2020 16:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CUtuZs6tB3eihlQ8+JOvCdfQc7WtxhqeROTUx2HPazc=;
        b=PxmCqY3gn4tIQDZMdRIwT/8HdYfsYUBMnkUmS3AGNOFr8F6c0vQoHFzFq8H7pgppDT
         EjjQCKgyJ2nyTENPdgMVM2mHuV09DCo/GLFOc6SK+YUnrky7FbeKWOpGA9q4O4Ygtf8C
         qYCRQUPlzxiumnKZoiLXINtYxrMOkUjAJTwm1YfzVYWywWE46fWOJmgBBN0tlqnqATRr
         mifaOf/ckdDHO0OhfhENbSTLTQHKszhk9z1lIVRaqhFkFkutP9uCq8OsGQqkCn/oFX5f
         rSF1X8OEgW7Mk7WY6AGun3jFIJl5oe4iBunW0RH3LC2nqqv8mUwWri2SS3uykIdtWxVd
         qfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CUtuZs6tB3eihlQ8+JOvCdfQc7WtxhqeROTUx2HPazc=;
        b=lmt6PFbR2+wc3bb6Dh5kUwdsVr7XqI+U/sWbwjiiNNe2B7yPt11p836gH9kRZRLAqE
         QcCwHCJYn2wDOrBKx3NtsK1iKA/Q2a+R33KD5xcQ4J51av2ZMxUK2ByHqaGXpIme2NZt
         HzaRWh6NvINEaiGSUvNlQbztIsLyQIUS7ocELkeMNXRN4/2drWKeqWT1kjMy2L4+5w5O
         cOiQPqzl71EFHEYspFXRyqQ9QDNZSYq8ZGUu97lxNCf9JamzK15nccJDuDsgiIw3JVhN
         2NSDhjR34Piaf8XchcfKGe+XW/K9udNDAnpqXXFGboXac+NOcW3h9qVvLcjW1CVWiOIL
         avHw==
X-Gm-Message-State: ANhLgQ2Kdl1Fri7IqJ+HBk2mIxWXazwloqCbfCX+payJvjeUY34XOblH
        VYC9HUfjr4Fo2T6VI0FesmY47Elz
X-Google-Smtp-Source: ADFU+vvtkEz/5mFLktFi4PSowE5zFRes9Kvn7UkruCvUOapp4PcyObEFTP3eBWKCGZjaK00ZP2B3qA==
X-Received: by 2002:a62:1b51:: with SMTP id b78mr10442084pfb.23.1584056212203;
        Thu, 12 Mar 2020 16:36:52 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:51 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 1/7] dst: Move skb_dst_drop to skbuff.c
Date:   Thu, 12 Mar 2020 16:36:42 -0700
Message-Id: <20200312233648.1767-2-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for extending this function to handle dst_sk_prefetch by moving
it away from the generic dst header and into the skbuff code.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 include/linux/skbuff.h |  1 +
 include/net/dst.h      | 14 --------------
 net/core/skbuff.c      | 15 +++++++++++++++
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 21749b2cdc9b..860cee22c49b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1047,6 +1047,7 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
+void skb_dst_drop(struct sk_buff *skb);
 void skb_release_head_state(struct sk_buff *skb);
 void kfree_skb(struct sk_buff *skb);
 void kfree_skb_list(struct sk_buff *segs);
diff --git a/include/net/dst.h b/include/net/dst.h
index 3448cf865ede..b6a2ecab53ce 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -259,20 +259,6 @@ static inline void refdst_drop(unsigned long refdst)
 		dst_release((struct dst_entry *)(refdst & SKB_DST_PTRMASK));
 }
 
-/**
- * skb_dst_drop - drops skb dst
- * @skb: buffer
- *
- * Drops dst reference count if a reference was taken.
- */
-static inline void skb_dst_drop(struct sk_buff *skb)
-{
-	if (skb->_skb_refdst) {
-		refdst_drop(skb->_skb_refdst);
-		skb->_skb_refdst = 0UL;
-	}
-}
-
 static inline void __skb_dst_copy(struct sk_buff *nskb, unsigned long refdst)
 {
 	nskb->_skb_refdst = refdst;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e1101a4f90a6..6b2798450fd4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1034,6 +1034,21 @@ struct sk_buff *alloc_skb_for_msg(struct sk_buff *first)
 }
 EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
 
+/**
+ * skb_dst_drop - drops skb dst
+ * @skb: buffer
+ *
+ * Drops dst reference count if a reference was taken.
+ */
+void skb_dst_drop(struct sk_buff *skb)
+{
+	if (skb->_skb_refdst) {
+		refdst_drop(skb->_skb_refdst);
+		skb->_skb_refdst = 0UL;
+	}
+}
+EXPORT_SYMBOL_GPL(skb_dst_drop);
+
 /**
  *	skb_morph	-	morph one skb into another
  *	@dst: the skb to receive the contents
-- 
2.20.1

