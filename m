Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087DD2DE36E
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 14:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgLRNqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLRNqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:46:33 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E6BC06138C;
        Fri, 18 Dec 2020 05:45:52 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id s21so1549847pfu.13;
        Fri, 18 Dec 2020 05:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=puW3DbJ+oWMyv153IUMmlQ4G7FVM7E3yY+4xe0UfzkA=;
        b=FCJ8Yw15ZeymnEvZv6tabs1xv8nR/E4Nn9pAqHXavlPiofDnnrrMeO6QeDW5S+S0nn
         NpbWrcIa/QtJA989zng4CDLJgGYc+K5kn/t/nkPaYJl/phfTt89vv7OoyjXYbqmyR6Z6
         hYGq89/p3/3SBZF9tD23EeI/Q3/tnePky6QjDrWLBiLg3o8YRzYSMahtdUOGVvFW3ATu
         17+W5sd1/2rQxXq+tG+tfyyrWQqFQhWeRPUUSLaO7I4aE7XYkyAV7s9MAfCJo4gCebrp
         K8/ChM2vAA7T8jrSMpgmYe0f/uGYFc+3IHYAYEPOysCmUiQvP1gHtxanxBLT3CtFkkb+
         K4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=puW3DbJ+oWMyv153IUMmlQ4G7FVM7E3yY+4xe0UfzkA=;
        b=jTjQhHgjSvLgIOc8CBFJDkv8fIjjCwqkBYHB8SckfPLxjlSzIteAZYZjeAp7XaeIjs
         iwnvuc/U30XIIvyUT/sFd42Rxv373/aQl3t67jCTP6pEETjAQP2E4YKH2DRlJJc0FFuJ
         u0+cCLfe8255xxDZ55ieFeXFIfixw10fBw3vfJ7ZhQ9d170i7LOEa5fDMJJ5lVEcueSJ
         /Y45bva+XYFVA82qAEJ4J2U4hZBRPmVfUQLSLTQh7aH+oSesFNGTUxyvnZic6Dpa8ez6
         +ZkpgZCXUWJL6zUSMsO3leTMbtWliI/kQwjueQdhqctb7bS4n0sC5bcpweJlLvClGthA
         aKbA==
X-Gm-Message-State: AOAM532vtA1yzN1DTs7suE3vz7Ug/Ji6sA4DtBfBj15iUIpiRBLAERcx
        3IXsPo4e4tShEKMkoYQ6Jn8=
X-Google-Smtp-Source: ABdhPJz0tU/9pyS2OnRIpSGN2I6ROVPelmMlTbNo3XMMNncgzYMcCwm7WkPPNN3mct/m5pLZHd/8Fw==
X-Received: by 2002:aa7:84d5:0:b029:19d:da20:73fe with SMTP id x21-20020aa784d50000b029019dda2073femr4364071pfn.16.1608299152520;
        Fri, 18 Dec 2020 05:45:52 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id r185sm9075906pfc.53.2020.12.18.05.45.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Dec 2020 05:45:52 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, A.Zema@falconvsystems.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH bpf v2 2/2] xsk: rollback reservation at NETDEV_TX_BUSY
Date:   Fri, 18 Dec 2020 14:45:25 +0100
Message-Id: <20201218134525.13119-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201218134525.13119-1-magnus.karlsson@gmail.com>
References: <20201218134525.13119-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c       | 3 +++
 net/xdp/xsk_queue.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d531f9cd0de6..8037b04a9edd 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -487,6 +487,9 @@ static int xsk_generic_xmit(struct sock *sk)
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
index 4a9663aa7afe..2823b7c3302d 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -334,6 +334,11 @@ static inline bool xskq_prod_is_full(struct xsk_queue *q)
 	return xskq_prod_nb_free(q, 1) ? false : true;
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

