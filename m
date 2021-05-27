Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D8B3928A7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 09:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhE0Hih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhE0Hif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 03:38:35 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A243C061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 00:37:01 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 27so3063945pgy.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 00:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xCvrAmiCLz1uMfi+mi9IcnAJlINxbAz15gIGFNGNZrw=;
        b=C2hJSV4S7/+Rk1JKTCgxheZX0Gpt2KUVZzFVclHFKMSZRN8BfoQcFM7GogSiGUtk2C
         rLWsVJpIA+/DhUNx+G9yVnD58QEP+nLBxJmXWw7zRZ4agkl1TZJ0klLgM3Dx3z3z3U5K
         FidlBHHU+l5maw+0WYxOLZltQ62818G2W55geWnoRZ+gNkR/jGRVHgazX6Pbw7vDw9Qg
         Wx8lxD4NFRT8DiejbVQm/QJ/u57vFn5KpDqlaq8JdSWSDZsqICG71HTQrg6IQqGDR3J3
         SAcDUH9GTluD8hG5h0vrlb6SX4KbxHd1R5VhApBckw5sDsm96ikXbNKCSMew/EWZQtU6
         UlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xCvrAmiCLz1uMfi+mi9IcnAJlINxbAz15gIGFNGNZrw=;
        b=cPnkD2hTghayPJ/Oc7aUTZHk4fyXVzWIyGTya4PBhLDuKJWSJEg6suhnHJQngYDFld
         ZghTLppmG/KHY68kRDKoU4BKlk8NI27m7GBX2MT3RPrd8MROsRcte440M+2fplsN6Lt2
         S5AdzGppuBOwMzA6kNpyEF7KQwhqVsKfseigo/JVFBcvhlxb8IY54dZtNJ+b/WhOsz+I
         9MB4inwdqGxlorypTAmz2In8D/4HwNtpkK981bvDaRcsiJfb4sorIn/iEhE7CIaQG/q1
         /SUYGX2S2mj6aiOf50MdZjAffNoWYpZU+C6N1KmaXOCyzel7EkaDkYUH8V5W8dCEGjdz
         TF7A==
X-Gm-Message-State: AOAM530vfiX2KXnS0jl3C6iaYP1p7MQOrvjveazPvbxUXsGNjeXwe08L
        U0Pq80JddO0VeYM3q3scrN/0
X-Google-Smtp-Source: ABdhPJyaMzbyimGdOvpLzUf5PLLz5C4DWVOUQgxOigRa2fpuu/fsZDONOWrcq07gYwYXN48QFxR+/Q==
X-Received: by 2002:a63:aa48:: with SMTP id x8mr2428006pgo.359.1622101020770;
        Thu, 27 May 2021 00:37:00 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id u22sm1197547pfl.118.2021.05.27.00.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 00:37:00 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] virtio-net: Add validation for used length
Date:   Thu, 27 May 2021 15:36:43 +0800
Message-Id: <20210527073643.123-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/net/virtio_net.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c4711e23af88..01f10049f686 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -661,6 +661,17 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		if (xdp_prog)
+			goto err_xdp;
+
+		rcu_read_unlock();
+		put_page(page);
+		return NULL;
+	}
 	if (xdp_prog) {
 		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
 		struct xdp_frame *xdpf;
@@ -815,6 +826,16 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		if (xdp_prog)
+			goto err_xdp;
+
+		rcu_read_unlock();
+		goto err_skb;
+	}
 	if (xdp_prog) {
 		struct xdp_frame *xdpf;
 		struct page *xdp_page;
@@ -937,13 +958,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	if (unlikely(len > truesize)) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)ctx);
-		dev->stats.rx_length_errors++;
-		goto err_skb;
-	}
-
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize);
 	curr_skb = head_skb;
-- 
2.11.0

