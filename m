Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B323B5280
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 09:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhF0IAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 04:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhF0IAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 04:00:11 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735FAC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 00:57:48 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c19-20020a9d6c930000b0290464c2cdfe2bso3606339otr.9
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 00:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMsX/JmWmDl5DkYGWepvSQmkHVeO1LqZDKLWlaY4m5g=;
        b=jTJEvSnZFmrO0DEryJpSFK5jqf1V5cq6k42rcJEIWRa9l1YXAEZ5bjL4eWaG1sRUs+
         sXFlyyP8+AVR9MYsEYYL5WgXEQ3LEDbGqk2tQazaIyjllx0hnMwczV2FlrZkMUwEF0sd
         UXRqL26NWjiGeIoKrRIwUE3gwjpqNHoHziFLrIUGyOJANvvny0vSSfnQTM4GSDEfydX4
         TW64bM1miXcFABdNT+r3nzVB0r/8ywuAOoJrJGk0qWJk14ONCCizln5BolYEZU/S1n4/
         pVskSij9q1rOH4ZSUt8gREGPrNaRKeRgnN/RNuiFZP3HXCRfzXw2WxloRF3rmkgSLQsM
         XXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMsX/JmWmDl5DkYGWepvSQmkHVeO1LqZDKLWlaY4m5g=;
        b=h64MWA9Q8/QUddeQkSrhr3eudHCq/WpEwPr+OWxY4OEFc+Z90Ishj8ppxK3DaF5U3j
         95RWR8b6QnTplr+uX6QWd7HK6mRbGiShxQfuhta0uxTJStTxZcbcH5+jxSxrUjPgb2eF
         PVmiNNpK1JF/7R8gJVYRVIncrE99BX0+1fiJKQAfXF3meBhn53hBRLgQfFKI85BFwcba
         nJpmMbJdG/uT/ecqZfcesZotP1Wd9E3HJ3s+C/TEX0QZ9CF0Nq2Xc/eBC8mHbyBIjT1k
         5bDxXgOV1+VYlrHePhqujwQF/6bk0y8rLVa8HFMjrMUdMb/0G/x3yqTM3FcbVfMaBWED
         B14w==
X-Gm-Message-State: AOAM531+JFiAyX8YlO9H/XuFUk6tF9YA+6taIMTlbVTg+SroKHdUd2wc
        eDg/JSltSJpaSlOwCRr3F8PjqBt4Ntk=
X-Google-Smtp-Source: ABdhPJyw9QmUHFfvRPr08OLJZ15CCycODz07DIJ/0tUi+Q1G7rAESMtlXpEz4m59/LNy5xx9IDX+jg==
X-Received: by 2002:a9d:7acc:: with SMTP id m12mr17017438otn.27.1624780667616;
        Sun, 27 Jun 2021 00:57:47 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id z5sm2554042oth.6.2021.06.27.00.57.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jun 2021 00:57:46 -0700 (PDT)
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] udp: allow changing mapping of a socket to queue
Date:   Sun, 27 Jun 2021 15:57:40 +0800
Message-Id: <20210627075740.68554-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many containers running on host. These containers
share the host resources(e.g. netdev rx/tx queue). For isolating
tx/rx queue, when the process migrated to other cpu, we hope
this process will use tx/rx queue mapped to this cpu.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/ipv4/udp.c         | 2 ++
 net/ipv4/udp_offload.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..72104c45e6b4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -950,6 +950,8 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 		uh->check = CSUM_MANGLED_0;
 
 send:
+	/* pick tx queue for this skb list. */
+	skb->ooo_okay = true;
 	err = ip_send_skb(sock_net(sk), skb);
 	if (err) {
 		if (err == -ENOBUFS && !inet->recverr) {
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 54e06b88af69..62683efca647 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -269,6 +269,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	struct udphdr *uh;
 	unsigned int mss;
 	bool copy_dtor;
+	bool ooo_okay;
 	__sum16 check;
 	__be16 newlen;
 
@@ -286,6 +287,8 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	if (copy_dtor)
 		gso_skb->destructor = NULL;
 
+	ooo_okay = gso_skb->ooo_okay;
+	gso_skb->ooo_okay = 0;
 	segs = skb_segment(gso_skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		if (copy_dtor)
@@ -293,6 +296,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		return segs;
 	}
 
+	segs->ooo_okay = ooo_okay;
 	/* GSO partial and frag_list segmentation only requires splitting
 	 * the frame into an MSS multiple and possibly a remainder, both
 	 * cases return a GSO skb. So update the mss now.
-- 
2.27.0

