Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC2E396262
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhEaOzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhEaOxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:53:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971CAC01F000
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:59:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m8-20020a17090a4148b029015fc5d36343so32185pjg.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ElXRDuCmw0SEZf7krYsHM0+lPZEqdIG1NofDQ2gJtK8=;
        b=eLtfYCTPZ+gy7IXFcEKe+h4uBfDBgNRv/Tl4pByit8rXqDIi/XXukZHCJZYLGnLYvG
         1bFZ1qCpyIZ8sfyykN1Zyvxq1gVojP5wMkBXxFhylevHbmIL1lXTLjG1H2YbQGoh2+gX
         0KN2t3AhyErvU4dlzzqkWSdzih5nY54K24CpWzG8awKrUnwzvJsLeqrmFh0/KwszTR0s
         DL4BfWpqB/1BH7fwsHut0NTiL0m54R09yqJxlRRCaKd4nLlBT+WOScg6qGK/yMFwnRbE
         aplkaVOPtIpAzyPmqTGofDzMlTdq/T5m9DNNymkVhuQygsFnmIsYW1xPU+SLi4eVkkXZ
         I3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ElXRDuCmw0SEZf7krYsHM0+lPZEqdIG1NofDQ2gJtK8=;
        b=WyGAgE9g6EhWlxAhOKg2Ho5/eoz0lhnaIzO92CL/zgPpXi8Usoasjmf9ifkr2eUkag
         ZnbpKz6HFxHPoUGtXiNz8PvaFOVvWt4kgpLC79v3TWWihsknqbG7f9gpvHXt0rJ5ojSM
         9l2vADYww9cZs4CQyHuciahDlZ1bfgkMEndfWGgeTmbysHBFnuavOKTSCC2khIahYGBn
         P44v3utZ9XaTIgbshr7+E5yEkM6LCaw7uPXaf6AsjhW1Ug59TMZe0KrSl/VdebP7xzIm
         vIVJy7dmg8QMKV3TDIQAej0Mduhk9r+r3YiiIn/SYjWbzJnDkoWYpfs96H7oLkdF7VYi
         jCHA==
X-Gm-Message-State: AOAM530M91zZ4Ff2GyKO/ygfrB2R4WH/UCI563N28fsWFffsQKGLsURE
        LLbBASk0ApGEUZxKDCOr1d5C
X-Google-Smtp-Source: ABdhPJzbq32IEkUykPGhPRHegPvNO+SK7zrkq9BiknlxPVrEYOMiqQyv/a2g1V45EXL7j3YrYkE4Lg==
X-Received: by 2002:a17:90a:950c:: with SMTP id t12mr18877822pjo.135.1622469554187;
        Mon, 31 May 2021 06:59:14 -0700 (PDT)
Received: from localhost ([139.177.225.235])
        by smtp.gmail.com with ESMTPSA id t12sm4352602pfc.133.2021.05.31.06.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 06:59:11 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] virtio-net: Add validation for used length
Date:   Mon, 31 May 2021 21:58:52 +0800
Message-Id: <20210531135852.113-1-xieyongji@bytedance.com>
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
 drivers/net/virtio_net.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 073fec4c0df1..ed969b65126e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -730,6 +730,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	len -= vi->hdr_len;
 	stats->bytes += len;
 
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		goto err_len;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -833,6 +839,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
+err_len:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
@@ -886,6 +893,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
 
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		goto err_skb;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -1012,13 +1025,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
 			       metasize, !!headroom);
 	curr_skb = head_skb;
-- 
2.11.0

