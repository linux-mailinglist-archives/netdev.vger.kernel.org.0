Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C801920D3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCYF6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:58:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36649 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCYF6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:58:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id g2so396380plo.3;
        Tue, 24 Mar 2020 22:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TypTL5yCN9CsZjegVJUdyviRc16jWnLtS6ORX973s/8=;
        b=DZCcD5CujLldUJNTJ/DVpt0GwQ8QoEW+do+HAN9434TWWO7I8gG6wGv3ZmeeQZkUyA
         oeKD9Y5sGboEbRUusSuxWEHZM8LYllwvbJIylfAMRrozzrcgANC96div7dEiYSk29QX3
         C8EHKfp6yBAK9ekEAVX7b7JHsLXO8uLC+juy5+qXYA13l8Ee4qcaFzCwpRWnjqGESCam
         jqj6EikIJd0TP8kUnpImEOK83BZg6F1Wcdd7DEbbUqW7d/bqsd8Zs4zRMGx7EPr6OCip
         GPLku/2iYbr/VKqN2h5J3uqFZf/Vv9rAOZdmAcoVvqc4H1g6/G1+s0tOgHf+2ALs2Ak6
         nqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TypTL5yCN9CsZjegVJUdyviRc16jWnLtS6ORX973s/8=;
        b=rLq9S11ZK+8J9PN7Rt3IrO94C/IuYQZa45KXitpPaGO9nZtH0VUXyOc91jPzaNl7rq
         8NwV8+CP2qDchHcxfj0u6Iof/LajnkVXMN/z/tGBcMUaVgAj8IkJLlBt1tZ8HtWKIFij
         iGXqU87TVGIGI8HSK4FhrMAL8ZLeBLfXppFMgjbPOjcFM/B0TgiEaY/4fBWRikUfSd09
         KtvD4rJnZPQ+VZS+r/Zo4CTF/oY7aOn0vxOUA1S8vHzThNhlC3YLHXZnosyupuKGSp03
         8ujRJyEcjeAMAibKCyBiPpMkTrU6b+zdBHjG4A3yjlDgxMOkpi3NXnBpcOI64X0smBRL
         Khbw==
X-Gm-Message-State: ANhLgQ38i528pGbPU4/PBMMK1SUJhBDaN5xIEfWZ/u2trWA5z+Un+Xpd
        J+SD56IZ4cwNQcVClAo3ILFwcSXq
X-Google-Smtp-Source: ADFU+vs2ZcaUROavzDvUx+ynczMyUxe2NiGvTtB+bFkAdVoeU8Kl4nY3Bibh0ivxDOqRDatuq5bXMA==
X-Received: by 2002:a17:90a:2042:: with SMTP id n60mr1855783pjc.0.1585115879281;
        Tue, 24 Mar 2020 22:57:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id e10sm17605716pfm.121.2020.03.24.22.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:57:58 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv2 bpf-next 2/5] bpf: Prefetch established socket destinations
Date:   Tue, 24 Mar 2020 22:57:42 -0700
Message-Id: <20200325055745.10710-3-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325055745.10710-1-joe@wand.net.nz>
References: <20200325055745.10710-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enhance the sk_assign logic to temporarily store the socket
receive destination, to save the route lookup later on. The dst
reference is kept alive by the caller's socket reference.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
v2: Provide cookie to dst_check() for IPv6 case
v1: Initial version
---
 net/core/filter.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index f7f9b6631f75..0fada7fe9b75 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5876,6 +5876,21 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 	skb_orphan(skb);
 	skb->sk = sk;
 	skb->destructor = sock_pfree;
+	if (sk_fullsock(sk)) {
+		struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+		u32 cookie = 0;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sk->sk_family == AF_INET6)
+			cookie = inet6_sk(sk)->rx_dst_cookie;
+#endif
+		if (dst)
+			dst = dst_check(dst, cookie);
+		if (dst) {
+			skb_dst_drop(skb);
+			skb_dst_set_noref(skb, dst);
+		}
+	}
 
 	return 0;
 }
-- 
2.20.1

