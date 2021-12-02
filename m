Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A529465C4A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354675AbhLBCvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhLBCu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:50:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8991DC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:47:37 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 133so7446587pgc.12
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8mApNYIlmyYDE92hmrIu9j0ZnkBUvjBpogxont+LFMc=;
        b=Qdr458L9RsO1m+v3aT9KMK6AVcb/NxGHnpXIEZPtjZnweSxrpCtCbL4oHWKaX1/5PV
         8MV24Tzq8ASgdYakCup1KgD0mPtOa0V8e8P49euciLTwymyzqkNhgKqN/ohRo5Y87Qtd
         5r4BsFv/xsM98Vb3b3mSxLqdOGOWl5SiSitmcw5JIe0xA4MNyOmm6oEm1j8loI9WLRTW
         u3OaDBlvv0aCaoliuKcnFHOP1ai+NBNo17HlNPJGIXHlUbBBF9veh8++FsLQpuTQoFkv
         gzI9JLrr03o0Hl/yWU8Qz+Dg8voaA9an1qcNe2ODKYxJrS1+WtrM6p0FmcyunOYEHKuV
         DY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8mApNYIlmyYDE92hmrIu9j0ZnkBUvjBpogxont+LFMc=;
        b=YfyJ6YD1iTntadvaUISVpLXNyw+Mfj/9vhiHQTtE6Xe24pL6YDTZnkkztbR1q87F0o
         20mAyHLvdrDDOGwz5CZLPajmAF+XXSbaeGxLfsc5D846WMgpCYtNZvkHNOJbjmK5wt3j
         /2EhCAAvD7BwfOdtg/LPbMMFFBDkABPZAmnE3gqZ9xe1Cf7u/30Xo7qGNTKEj/HG97dS
         481T9pRnKSoi0g8yyalxmfESTTWb+Ut5YrSLDs51Bc5yVhf3u/r3mAcrGZix42/mec6c
         AIJYcBXmbEdNgBtFFfepprOa1LBkp5Ql3Nh0YhV7IDHtCIY9yiyeCzY+2ERzoRQNiDWI
         gH+w==
X-Gm-Message-State: AOAM531Arie2Up8wSh//abvBU8i9sXDTXL5kl92wz1pvHEpA7mOZPI/g
        BJCyNM8I7RkX2bmruzEPus+ma1fSjQmY7A==
X-Google-Smtp-Source: ABdhPJzKDZ4SWggJ5/ICL4WugXxWxKwop4vPiWzyfk/B2ISYJ6wyH8Mgs+Ko9k4c/60GfKDP5LFVoQ==
X-Received: by 2002:a05:6a00:14cb:b0:49f:c028:aea6 with SMTP id w11-20020a056a0014cb00b0049fc028aea6mr9985890pfu.48.1638413256685;
        Wed, 01 Dec 2021 18:47:36 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id z10sm1183180pfh.188.2021.12.01.18.47.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Dec 2021 18:47:36 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net v4 1/3] net: core: set skb useful vars in __bpf_tx_skb
Date:   Thu,  2 Dec 2021 10:47:21 +0800
Message-Id: <20211202024723.76257-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We may use bpf_redirect to redirect the packets to other
netdevice (e.g. ifb) in ingress or egress path.

The target netdevice may check the *skb_iif, *redirected
and *from_ingress. For example, if skb_iif or redirected
is 0, ifb will drop the packets.

bpf_redirect may be invoked in ingress or egress path, so
we set the *skb_iif unconditionally.

Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/filter.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8271624a19aa..bcfdce9e99f4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 		return -ENETDOWN;
 	}
 
-	skb->dev = dev;
+	/* The target netdevice (e.g. ifb) may use the:
+	 * - skb_iif, bpf_redirect invoked in ingress or egress path.
+	 * - redirected
+	 * - from_ingress
+	 */
+	skb->skb_iif = skb->dev->ifindex;
+#ifdef CONFIG_NET_CLS_ACT
+	skb_set_redirected(skb, skb->tc_at_ingress);
+#else
 	skb->tstamp = 0;
+#endif
 
+	skb->dev = dev;
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
 	dev_xmit_recursion_dec();
-- 
2.27.0

