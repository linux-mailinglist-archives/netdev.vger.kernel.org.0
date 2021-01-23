Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D7130182A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbhAWUFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbhAWUBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:01:09 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6ACC061221
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id p21so7220647lfu.11
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uKKJeqaXIO+5os8l/V0Znssmjq/yk2JjBfnzf1a4R7Q=;
        b=1Jy9raR49TfNioC81iTuWWXiqL9J53/BooMuFA8iZy6Duam9g1zpIZCmYj3eEOfWwQ
         RXbqh/mcftLp9jBOMNTG/0WoyAqvxxnjGqMgvLvviVMrmOyk8ihDcpL4xXkzj1fAayE1
         HimN4WvHTHzh+WdLk0hVdfoqrtV/gReDZNyu3x6BBrG1RN/fE9hTtxmqAR2R2/1oJdTt
         qUsGJrtlkuhCdAO4/YIxsGgjmfq8nS/fPxPOVXI2wQI8YzGH8FaTC/FjNkcIWMaeuOCq
         nE13NNsEZMwHWhptlJQQo+K4Bb0vaVywa/P6Eue0V1VIOxYSoau/55biUMrHpH28QXik
         vtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uKKJeqaXIO+5os8l/V0Znssmjq/yk2JjBfnzf1a4R7Q=;
        b=gShNc2tZ6l2rjOo5eVvruE3zTS3cqd8mTILVH8mV4z6yojtQ19X9O2/FuXYMjrI2B3
         QDy3mk8zqTEhdrlIBITLklDJnkLP6/Q1CTgqkrg5bhhf0FTIbKYKjtzad7xOzOMqu1ED
         suCia1WN9ZlCqafhsPKjJ5R2S/rH9JjbGQbqO7DDdqnYT5XRoPDdMLmjaGgjm3TEoTdM
         PUJvBaElsSI1tLkzIM7dr54v0q/XglODDVJYp27AIIE7nqyJh5QQiEZw/k95TyS3M5tz
         mTJ6vPboNNuusWN6kEOUuwYn3i9ioC5fnTScwQ+KM6EdgS776LwhltWdfiyr4N+gkID2
         921Q==
X-Gm-Message-State: AOAM531r1sdNu/ckLTsAe4j4mdGIeLY8dyHP5xWh24y2SNnhiEm8X1HW
        UGyc7IFog86eE0fgV15kfECAug==
X-Google-Smtp-Source: ABdhPJyOEDegoL2JmO11AVhLcmFnAykortVOCpt/OwXZz/Er+dSWC/3k+gWOXl2eF5YAqfz0FKGZxA==
X-Received: by 2002:a19:84:: with SMTP id 126mr15172lfa.120.1611431982581;
        Sat, 23 Jan 2021 11:59:42 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:42 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
Date:   Sat, 23 Jan 2021 20:59:15 +0100
Message-Id: <20210123195916.2765481-16-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pravin B Shelar <pbshelar@fb.com>

Please explain how this patch actually works... creation of the control
header makes sense, but I don't understand how sending of a
control header is actually triggered.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 668ed8a4836e..bbce2671de2d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -683,6 +683,38 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
 	}
 }
 
+static inline int gtp1_push_control_header(struct sk_buff *skb,
+					   struct pdp_ctx *pctx,
+					   struct gtpu_metadata *opts,
+					   struct net_device *dev)
+{
+	struct gtp1_header *gtp1c;
+	int payload_len;
+
+	if (opts->ver != GTP_METADATA_V1)
+		return -ENOENT;
+
+	if (opts->type == 0xFE) {
+		/* for end marker ignore skb data. */
+		netdev_dbg(dev, "xmit pkt with null data");
+		pskb_trim(skb, 0);
+	}
+	if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
+		return -ENOMEM;
+
+	payload_len = skb->len;
+
+	gtp1c = skb_push(skb, sizeof(*gtp1c));
+
+	gtp1c->flags	= opts->flags;
+	gtp1c->type	= opts->type;
+	gtp1c->length	= htons(payload_len);
+	gtp1c->tid	= htonl(pctx->u.v1.o_tei);
+	netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
+		   opts->ver, opts->flags, opts->type, skb->len, pctx->u.v1.o_tei);
+	return 0;
+}
+
 static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
@@ -807,7 +839,16 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 
 	skb_set_inner_protocol(skb, skb->protocol);
 
-	gtp_push_header(skb, pctx, &port);
+	if (unlikely(opts)) {
+		port = htons(GTP1U_PORT);
+		r = gtp1_push_control_header(skb, pctx, opts, dev);
+		if (r) {
+			netdev_info(dev, "cntr pkt error %d", r);
+			goto err_rt;
+		}
+	} else {
+		gtp_push_header(skb, pctx, &port);
+	}
 
 	iph = ip_hdr(skb);
 	netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
-- 
2.27.0

