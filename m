Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045E92D9AF7
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgLNP3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437287AbgLNP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:29:03 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7AC061794;
        Mon, 14 Dec 2020 07:28:23 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y8so8794370plp.8;
        Mon, 14 Dec 2020 07:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FsgDhaY8pDmVAcsUZgp8PKiEoehT8Ak4C21MYcX8O14=;
        b=C3FaFlNVAcRNVy8lPYZXYQkgxB0Gyo8LLPWb02hJcNDJtdQTXhp9UCRfz4GtOncXLN
         x3NH1BFBssKEfN0JisGoDEKqn9phlGsRbF7eelVOR3Bwan9bO0Vm1NZLDznbgCtIHNF0
         SiVTq/VfmwNytZ8RDLG8oh+LT4DdpSoWu9e+KqsZF858aaHq2SJ1/IHHhtR77pU70o3D
         Z9HrDyiiH4vWAgAC7JyGAK/guCVC0c7uQ/IqvEyYvocUuD4x36ddIlbm6Zu6KU8YOTE4
         0GFiPCNtLq33gY5EBlcVdc18KNsnnuXWiy83yuJ1xfPr23A3bOY8183326NAbgx7Hexz
         rfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FsgDhaY8pDmVAcsUZgp8PKiEoehT8Ak4C21MYcX8O14=;
        b=KHo80mLgV6Z7AUF9hXmeCkaw/4rzNEDSqLdlXPgV6xHkUctn/E3yQJwgminazcC6lJ
         cyMPHTO+4Qxv00i/yBlM2u3YqSQyl6enlnBVrYuF2v+9aCcfhqSXZyslzmtiCOVzcNSj
         8e8alITJAhLyfmYVyLUgz7t38kL1UduoOqbRoIy5FvLugDSSP9h2h8B488Fv7un39VzM
         dbF6ZraojFKRFnrfWy6VjvVrpUU4TLOJZ/tjsKUL7sqVYJCptwoKiEvTOZkeDxZOpJf0
         a8bZEMHO2yP1vX5iLydxGdSUUD8BGQLEUuVyyDQs9FdcQrHczFFrMbBVJXGpkGDmiV6J
         UErw==
X-Gm-Message-State: AOAM530yXi3iBoAbZsFeCrAvMGa/QZL78fYkwK8LJMtSFYLsyhtkT/Qo
        /JLIiZ2n5DOXwpCvEc05FKM=
X-Google-Smtp-Source: ABdhPJwfI42KSZKR37/CxrSwwH4p1PVHcM7M2A/USHj3aXA+EeMfq85HIKl/kmcgyUFL7VGioUxN3g==
X-Received: by 2002:a17:90a:de95:: with SMTP id n21mr25526103pjv.62.1607959702828;
        Mon, 14 Dec 2020 07:28:22 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id 5sm20036027pgm.57.2020.12.14.07.28.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:28:22 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, A.Zema@falconvsystems.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf 2/2] xsk: rollback reservation at NETDEV_TX_BUSY
Date:   Mon, 14 Dec 2020 16:27:57 +0100
Message-Id: <20201214152757.7632-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201214152757.7632-1-magnus.karlsson@gmail.com>
References: <20201214152757.7632-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Rollback the reservation in the completion ring when we get a
NETDEV_TX_BUSY. When this error is received from the driver, we are
supposed to let the user application retry the transmit again. And in
order to do this, we need to roll back the failed send so it can be
retried. Unfortunately, we did not cancel the reservation we had made
in the completion ring. By not doing this, we actually make the
completion ring one entry smaller per NETDEV_TX_BUSY error we get, and
after enough of these errors the completion ring will be of size zero
and transmit will stop working.

Fix this by cancelling the reservation when we get a NETDEV_TX_BUSY
error.

Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 net/xdp/xsk.c       | 3 +++
 net/xdp/xsk_queue.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 42cb5f94d49e..2587583a6be9 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -428,6 +428,9 @@ static int xsk_generic_xmit(struct sock *sk)
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
 			skb->destructor = sock_wfree;
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			/* Free skb without triggering the perf drop trace */
 			consume_skb(skb);
 			err = -EAGAIN;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9e71b9f27679..ef6de0fb4e31 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -286,6 +286,11 @@ static inline bool xskq_prod_is_full(struct xsk_queue *q)
 	return !free_entries;
 }
 
+static inline void xskq_prod_cancel(struct xsk_queue *q)
+{
+	q->cached_prod--;
+}
+
 static inline int xskq_prod_reserve(struct xsk_queue *q)
 {
 	if (xskq_prod_is_full(q))
-- 
2.29.0

