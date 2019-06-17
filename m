Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2914841A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfFQNee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:34:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42955 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfFQNee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:34:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so5700204pff.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Ym+Kgrqwf/hk9Fs8QYXFX64f8kKSwJZyVRGMNWQXJho=;
        b=gTEOO9d8uUlEjbzTdVHQS7PMVskfyVmO3z9kNBqSvTKYDsE1w2Zpli0hB0yrRAShj/
         vycRiw2gTVWKtLXr0a9qyWvqS0JwfQYTQMbwmn50nTJccK6cmtppE3aAuf2rKoyXc1Lu
         sKcCv9uANX9VVjwOwEGJRSAizkDvGRUre4TfwMw5dQzY6rS4PvALWT3IZUIrtdZv6ijE
         o0TxtOAGPq4WfOYX2RarJvGowC99YuhmTF0TjUNVXvnj8olT8R04LqUfG5ia4dKt4ivi
         ERjVdZnhj+LjZLlyCkWaGABN9qyCGD1mO8s0sAnpZUFoXZzVh51AiIlQv9UJ1ociNNrk
         tApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Ym+Kgrqwf/hk9Fs8QYXFX64f8kKSwJZyVRGMNWQXJho=;
        b=EuUHj1oaJ9IobjaPWitvuAmrC6R9ep66uAe1D5PfnVwrELAWuUqMqzl1+VVY12hbvC
         Vqs0xoHS/iPBshslosehXMVu/s/w3uUtxRCCSyNzmjuxb8yfg57HOMjrbb/TeoebCu55
         UjmpURj3/ub9YRgNtFFpF+mkjv6+wPuxlshr9ZcW2QdtiQNA6A5k/y5b9o9icTeEs++j
         maaQC8BLFksRNF0LqIwEHumFM4SlpRIgciihwGKZF/h1y7BzUnXwEqcuTMBn3zUs94sQ
         VkFIbsKbnz40feXwHL/FZRv4HsaI87k1xPbjBvSIwvslDz26v366z2qFiTvG9yGXw2rW
         uBmw==
X-Gm-Message-State: APjAAAUNXE55O+tvHSANFpiQzQllHozPpaANRa6kEJLKuGnYmXtqWrCq
        ifodCEnLYnesLCLQOgGt80s+1Xvl
X-Google-Smtp-Source: APXvYqzA4nJhZo7G/6u9p1h0x6Yzmmtj29eGMMWyg1ByTJHwN7l86AuO4t8t36vDru6z//22f8wsdA==
X-Received: by 2002:a62:d143:: with SMTP id t3mr14556933pfl.66.1560778473485;
        Mon, 17 Jun 2019 06:34:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g17sm15171958pfb.56.2019.06.17.06.34.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:34:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH net 1/3] ip_tunnel: allow not to count pkts on tstats by setting skb's dev to NULL
Date:   Mon, 17 Jun 2019 21:34:13 +0800
Message-Id: <89113721df2e1ea6f2ea9ecffe4024588f224dc3.1560778340.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iptunnel_xmit() works as a common function, also used by a udp tunnel
which doesn't have to have a tunnel device, like how TIPC works with
udp media.

In these cases, we should allow not to count pkts on dev's tstats, so
that udp tunnel can work with no tunnel device safely.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 30c1c26..5073e3c 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -89,9 +89,12 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out(net, sk, skb);
-	if (unlikely(net_xmit_eval(err)))
-		pkt_len = 0;
-	iptunnel_xmit_stats(dev, pkt_len);
+
+	if (dev) {
+		if (unlikely(net_xmit_eval(err)))
+			pkt_len = 0;
+		iptunnel_xmit_stats(dev, pkt_len);
+	}
 }
 EXPORT_SYMBOL_GPL(iptunnel_xmit);
 
-- 
2.1.0

