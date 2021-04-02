Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0556F352EFB
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhDBSKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:10:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CC2C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 11:10:42 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id v10so4053675pfn.5
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 11:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCs/1DxmnCLzdgKQXYTKN2FMf+ljSRyMiYJVXUPthhk=;
        b=CmyltERB99U+7vUcf0Bvkp0YJ16KpyqQ+0KT7QmCUgIR2V0Pueqwk07EH/sGiu8fIm
         EsfaVvs1TxFPx7EJR/wyfnXj4Eo+gJD5mxQcpkSXZquFWXBox+OwtJkW34n0f7QYi6Yv
         6/PuzOMUxyUeRgXxrLNTe7BHhQ/jGrhGCv5KPfTGtG2zvX/SvP5XtIdK71fQoIFCYOiX
         3u57dIglRK6oe+wIbugcTBi6QgANqcWkWClUol/bJufGvCDZreBWrbpV/ehqDvvj4CFp
         4ZfCWfoyc9GWY0SeRk16/Obv2RDkrzosySn1OcALLr/vY+GgjXptyhEcJm061XIliVz+
         Pv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCs/1DxmnCLzdgKQXYTKN2FMf+ljSRyMiYJVXUPthhk=;
        b=TkZcNIKgzmuHQR7XEBY5sxEfAlyDpdUZBeIENqMcYR7ncjf3OuZl6ef7Ip2FgTSypu
         i5eqX3vkCjn/UjFBq9pf1oIfE4RR55SHqGZbqAiX9+jqC1xPe7V5EaN65zieqY0DySt0
         2/MxWRyhJZPQJtVxMssNirHDR4iPN2aGWllrowMAIHGGr6PH4gKbzpk+TmvN6rOa7+Wi
         gn/VKS2UBUE/Fs56uhR4hmwZUmwZYv5VJgeBugpMNqNRg34slNaRbVrj3MnckIOnGykq
         9NiTfNNcDx3AKA/yQVPtAs8puOcbPqPKR5uNauOchhX3CurrPOkOYmcVeMIa2jx0KR6e
         qXQA==
X-Gm-Message-State: AOAM531BrVdDuemQ4IhFbWUk3qDH3TNJKg4oaGxeu58fo3besgUU+Xvc
        HmH6svKpIaeUSUzkVExdpVDvaY1oKH4=
X-Google-Smtp-Source: ABdhPJzpoeywbLJwsV+vpzL4iVOkZEp/AUjhj7TbVqgfg2SWzMj6BQk/R0p/ynBFa4pJIvch1FY2rA==
X-Received: by 2002:a63:4c4:: with SMTP id 187mr12889065pge.187.1617387041723;
        Fri, 02 Apr 2021 11:10:41 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a57a:ec96:644b:4d80])
        by smtp.gmail.com with ESMTPSA id j3sm8713879pfi.74.2021.04.02.11.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:10:41 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: reorder tcp_congestion_ops for better cache locality
Date:   Fri,  2 Apr 2021 11:10:37 -0700
Message-Id: <20210402181037.19736-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Group all the often used fields in the first cache line,
to reduce cache line misses.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 075de26f449d27093ec6eeb114d7f53c328b2136..b34b2daf98d90930a7456f147d04e5b936185cbc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1035,44 +1035,56 @@ struct rate_sample {
 };
 
 struct tcp_congestion_ops {
-	struct list_head	list;
-	u32 key;
-	u32 flags;
-
-	/* initialize private data (optional) */
-	void (*init)(struct sock *sk);
-	/* cleanup private data  (optional) */
-	void (*release)(struct sock *sk);
+/* fast path fields are put first to fill one cache line */
 
 	/* return slow start threshold (required) */
 	u32 (*ssthresh)(struct sock *sk);
+
 	/* do new cwnd calculation (required) */
 	void (*cong_avoid)(struct sock *sk, u32 ack, u32 acked);
+
 	/* call before changing ca_state (optional) */
 	void (*set_state)(struct sock *sk, u8 new_state);
+
 	/* call when cwnd event occurs (optional) */
 	void (*cwnd_event)(struct sock *sk, enum tcp_ca_event ev);
+
 	/* call when ack arrives (optional) */
 	void (*in_ack_event)(struct sock *sk, u32 flags);
-	/* new value of cwnd after loss (required) */
-	u32  (*undo_cwnd)(struct sock *sk);
+
 	/* hook for packet ack accounting (optional) */
 	void (*pkts_acked)(struct sock *sk, const struct ack_sample *sample);
+
 	/* override sysctl_tcp_min_tso_segs */
 	u32 (*min_tso_segs)(struct sock *sk);
-	/* returns the multiplier used in tcp_sndbuf_expand (optional) */
-	u32 (*sndbuf_expand)(struct sock *sk);
+
 	/* call when packets are delivered to update cwnd and pacing rate,
 	 * after all the ca_state processing. (optional)
 	 */
 	void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
+
+
+	/* new value of cwnd after loss (required) */
+	u32  (*undo_cwnd)(struct sock *sk);
+	/* returns the multiplier used in tcp_sndbuf_expand (optional) */
+	u32 (*sndbuf_expand)(struct sock *sk);
+
+/* control/slow paths put last */
 	/* get info for inet_diag (optional) */
 	size_t (*get_info)(struct sock *sk, u32 ext, int *attr,
 			   union tcp_cc_info *info);
 
-	char 		name[TCP_CA_NAME_MAX];
-	struct module 	*owner;
-};
+	char 			name[TCP_CA_NAME_MAX];
+	struct module		*owner;
+	struct list_head	list;
+	u32			key;
+	u32			flags;
+
+	/* initialize private data (optional) */
+	void (*init)(struct sock *sk);
+	/* cleanup private data  (optional) */
+	void (*release)(struct sock *sk);
+} ____cacheline_aligned_in_smp;
 
 int tcp_register_congestion_control(struct tcp_congestion_ops *type);
 void tcp_unregister_congestion_control(struct tcp_congestion_ops *type);
-- 
2.31.0.208.g409f899ff0-goog

