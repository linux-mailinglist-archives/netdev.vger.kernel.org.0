Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8149699641
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387810AbfHVOUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:20:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45620 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387766AbfHVOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:20:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so3749826pgp.12
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 07:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lrEJglD9iLPN5tQjvlqR1XP1nUOxVdW/sZ6TST8l3pE=;
        b=AdRxK9Df3/CQ1foP/LGaawZiMlJOAk82XDIqqTjZZVkkCh0cDosFPHv/kRabSMKIKw
         naffhYLGxArV1CBgSOpm90Y8gjZxMHs1D8I06hg7+viQX1lG1E5g683jgpYREYkr0jtQ
         G58lAsxIv+F3XlyANQXgwuVAK42S7H9dLtd3gzdQ6k/8F1vutJnzcFgtxl04cYBkPdW6
         KSQpNsAkoe5Y/LdhsUyti57pxjn1x3edzRLXuFlZidL9z/6Pa9h0oUw7CN8fKw3BKCbB
         Uu9ZMkdHf9HGFsRrmuh3ofZpRU7FTWqI2h2U3jWt7IL6KxoTtmpqa5DtdyrpAK5/UyvW
         31Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lrEJglD9iLPN5tQjvlqR1XP1nUOxVdW/sZ6TST8l3pE=;
        b=KRLQ8RYV4x6gJO4EAg7UH8eduowrOUDlE7gssJi6QMK8J3xgOI/vn/yalepM71Z5gb
         oiIHflmN1Rqo3QKrNN/rQbi0UEgJl16np7WA+W8cybJsnKhrS0R/2Xw023JJ8lgbHfVo
         n0gEtJfr/VANkZrwgZH0HG1Uz4VCQMrNNBVFZkcO/rqZVMELYNw8Gx+yYIFc4qJBuIT0
         khnK7UjHGf0CeaiLLbkWhNHqdqfSO1nU2jyYsmCvSxuHEq08feamjIGvEMFaxyDY+WIJ
         YRjJtp0nbQUEgPQ54KSJGKon+gn2uyQa5LS88lleNJNZK9Z43PwiS3EEyKZItndW153s
         2NwA==
X-Gm-Message-State: APjAAAU+OvBtli4y/BRYz8l2BGUJkJCH7s51t4RrvMSiE6xh99AXMpO7
        1AiLKy0htiBe5V5UI4id8S8jPYfn9y3Xhw==
X-Google-Smtp-Source: APXvYqzsQzWUg8T5OvveuRPpl71yKQ8rePAmDLc9jJG/ZEOKQbRG1DcFPprYjXx+E+qus3OYPIfmqw==
X-Received: by 2002:a63:c03:: with SMTP id b3mr34715701pgl.23.1566483610757;
        Thu, 22 Aug 2019 07:20:10 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11sm3076747pju.2.2019.08.22.07.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 07:20:10 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 1/2] ipv4/icmp: fix rt dst dev null pointer dereference
Date:   Thu, 22 Aug 2019 22:19:48 +0800
Message-Id: <20190822141949.29561-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190822141949.29561-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190822141949.29561-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __icmp_send() there is a possibility that the rt->dst.dev is NULL,
e,g, with tunnel collect_md mode, which will cause kernel crash.
Here is what the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv4
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmp_send
      - net = dev_net(rt->dst.dev); <-- here

The reason is __metadata_dst_init() init dst->dev to NULL by default.
We could not fix it in __metadata_dst_init() as there is no dev supplied.
On the other hand, the reason we need rt->dst.dev is to get the net.
So we can just try get it from skb->dev when rt->dst.dev is NULL.

v4: Julian Anastasov remind skb->dev also could be NULL. We'd better
still use dst.dev and do a check to avoid crash.

v3: No changes.

v2: fix the issue in __icmp_send() instead of updating shared dst dev
in {ip_md, ip6}_tunnel_xmit.

Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/icmp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1510e951f451..001f03f76bc4 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -582,7 +582,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 	if (!rt)
 		goto out;
-	net = dev_net(rt->dst.dev);
+
+	if (rt->dst.dev)
+		net = dev_net(rt->dst.dev);
+	else if (skb_in->dev)
+		net = dev_net(skb_in->dev);
+	else
+		goto out;
 
 	/*
 	 *	Find the original header. It is expected to be valid, of course.
-- 
2.19.2

