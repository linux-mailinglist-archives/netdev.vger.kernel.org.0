Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6C325C3B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 04:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBZD6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 22:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBZD6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 22:58:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C8C061574;
        Thu, 25 Feb 2021 19:57:34 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k22so4595520pll.6;
        Thu, 25 Feb 2021 19:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E9uT3F5a+Hilx7GeVN55UELvpzXvN2z1hUQ2uEJGCFU=;
        b=X2OrJSnrjeIUZW27A1DiaoI6Gm3ofJtmqNJrDEjVsRV++pkR4S6pcYcwxDyoy7pbz2
         58Flgdd8a5+VgAuEQXrxPYgaJrO9wMHhl1vPCpeKJLuSjQVGgBmPOA6pQDrFKmlgIct3
         hIe7TlIzDR8eIx22FjRGjunzbl3HMZxcG6w2B4e1ciW9rBq6DSc/m2c5GK5LBcsQHNjK
         eAoqYL3Sw9ElIxN9WoiNJOgVupAsOTawavC6gskmD/YrA6QG8Zo88bF/4lal/wZA+iKi
         nWdPQo9XWt0xqmBbIEUwAeKChDtRWIJsRqm2IhR28fqHDKmb9gew0hGC6iGshBeQ21Mi
         ujNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E9uT3F5a+Hilx7GeVN55UELvpzXvN2z1hUQ2uEJGCFU=;
        b=Hxn7LL9YawdGBmI7axlsG7pLWmtG2qZUjkslI2A6KllUhpWjVadbRI5tmSRiVFKOZv
         TjimxcL8r1iwWX8j4l1JgvJWPVgr5DIApTYVJtWXX3kLrmrz2PShvtnLIjzYlMM0cVN1
         B557YHeeu/WR/hoEBVezk+qaxRWLD2+/SVoXOqU/VDfxP5cL5aQHWK5GI0sd8p5FwOoZ
         1bxsP7cGhCbl1Up38Lv20WAsQHc/RjRnTTtk/kNSSBNJEDlTuzDGkQC3abLRGisBmUGE
         shQaDZ8mLzM98x2pcz5vCQCOjQ5QgYIHRYKgsO48r8vuJmr8AU4dODwpCNiOsU9xuzOh
         JxKg==
X-Gm-Message-State: AOAM533bGuv86H/AkWs4nW3roD8guYqoI6/CdDV37GQwjJMsRDsd414Z
        lhnhqOrqkQ3MKs8hYxv5o6A=
X-Google-Smtp-Source: ABdhPJyCUfNoAEjO97SXjz7tTVaxyDh8nEBM7i1wbf6/BcXGz6uYkFFyEki3gTQYywmBeAe+fXZeew==
X-Received: by 2002:a17:90b:4acc:: with SMTP id mh12mr1340433pjb.10.1614311853709;
        Thu, 25 Feb 2021 19:57:33 -0800 (PST)
Received: from localhost.localdomain ([154.48.252.65])
        by smtp.gmail.com with ESMTPSA id mp17sm6992917pjb.48.2021.02.25.19.57.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Feb 2021 19:57:33 -0800 (PST)
From:   Xuesen Huang <hxseverything@gmail.com>
To:     daniel@iogearbox.net
Cc:     davem@davemloft.net, bpf@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Subject: [PATCH/v3] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
Date:   Fri, 26 Feb 2021 11:57:21 +0800
Message-Id: <20210226035721.40054-1-hxseverything@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuesen Huang <huangxuesen@kuaishou.com>

bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
encapsulation. But that is not appropriate when pushing Ethernet header.

Add an option to further specify encap L2 type and set the inner_protocol
as ETH_P_TEB.

v3:
- Fix the code format.

v2:
Suggested-by: Willem de Bruijn <willemb@google.com>
- Add a new flag to specify the type of the inner packet.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
Signed-off-by: Li Wang <wangli09@kuaishou.com>
---
 include/uapi/linux/bpf.h       |  5 +++++
 net/core/filter.c              | 11 ++++++++++-
 tools/include/uapi/linux/bpf.h |  5 +++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77d7c1b..d791596 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
  *		  type; *len* is the length of the inner MAC header.
  *
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
+ *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
+ *		  L2 type as Ethernet.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -4088,6 +4092,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
+	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee..8d1fb61 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3412,6 +3412,7 @@ static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
 					 BPF_F_ADJ_ROOM_ENCAP_L3_MASK | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
+					 BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
 					 BPF_F_ADJ_ROOM_ENCAP_L2( \
 					  BPF_ADJ_ROOM_ENCAP_L2_MASK))
 
@@ -3448,6 +3449,10 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		    flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP)
 			return -EINVAL;
 
+		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH &&
+		    inner_mac_len < ETH_HLEN)
+			return -EINVAL;
+
 		if (skb->encapsulation)
 			return -EALREADY;
 
@@ -3466,7 +3471,11 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		skb->inner_mac_header = inner_net - inner_mac_len;
 		skb->inner_network_header = inner_net;
 		skb->inner_transport_header = inner_trans;
-		skb_set_inner_protocol(skb, skb->protocol);
+
+		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH)
+			skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+		else
+			skb_set_inner_protocol(skb, skb->protocol);
 
 		skb->encapsulation = 1;
 		skb_set_network_header(skb, mac_len);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77d7c1b..d791596 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
  *		  type; *len* is the length of the inner MAC header.
  *
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
+ *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
+ *		  L2 type as Ethernet.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -4088,6 +4092,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
+	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
 };
 
 enum {
-- 
1.8.3.1

