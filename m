Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222683D3C77
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhGWOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbhGWOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:51:27 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC27C061575;
        Fri, 23 Jul 2021 08:31:59 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d18so2718705lfb.6;
        Fri, 23 Jul 2021 08:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OaMQFsec0NzLLpOf7NP5EVhh2TGUHi54KtoO+USyjiE=;
        b=j+RE9f9M4jLFONDoyX5Okg929LQmJ3Kox7FDvip52TSOScBMfinmkWh38BHT7an6VR
         DuhsvVZ6715Jky8eWdQ/9vD7p9GQqtiReNOJcpPLQMBNe6cgm2nZTIohPrYdzdmZwzuu
         mtDyvkoAlIRwQIELBm0h0ITVFaEf30vDtNSDpJeQqehmlAZWZ790f8dd03QGDrEdBBGT
         474uHCAcZkb9+sXV85pIZvc5SSxuNTD5gy+s4MK8aoZoYS74LucutTIMYAbtQvRpDOVD
         N+MwoH1DH7OGHzzqoUqNbUhymO7aXg7OIlGYAh4hH3XM3VIVLU0KBEbcgP1WQvYHO6tT
         WnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaMQFsec0NzLLpOf7NP5EVhh2TGUHi54KtoO+USyjiE=;
        b=Ao92k+yM2r7mLtcB59EpIyB3wT5K2+Ct3gm5QaLkzwiKJSymcmZOeymm9/CiUbW1cs
         bPhqvvuaFicr8+ERIpZKMkne7XO2NvPT4wfchMZuLunwjwa5mJhGM/m7Q6mfY0NDwVQM
         fzyrHMaOC+U0GXpRtZ4mhXjBCyQ5d8+T7XXbsMUt64SRuewpg5MEzIO+uBHrSuRZnZ8r
         RdVVDqY+YMM+q536o2/wi95+gdVFQw/bfdCWVIC2AC50XJCa0GnKA8ufpSBabGrOVDKE
         TNNKJo1bOS/G2+Na9oNtLJJHodQzbulMw7OA4nOQwz3QxiTNOOEd49vLLlmWEZlJ6kM4
         L2vA==
X-Gm-Message-State: AOAM532dX4mbS74pQd4fGbIK6i6mfbSZu+N56HKxo9dZhZeq4OVfMea7
        4Jba4DCJEZ9PYhCX3OCYejA=
X-Google-Smtp-Source: ABdhPJy2M5tILOLFh5iRpgWoc7jZAgwABTrFi8rY5WhoFNtBIcWZw5W57Ajp0eoS9a6H/u79RC4IIA==
X-Received: by 2002:ac2:4c13:: with SMTP id t19mr3551237lfq.394.1627054317862;
        Fri, 23 Jul 2021 08:31:57 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id j26sm1630849lfh.71.2021.07.23.08.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 08:31:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        xiyou.wangcong@gmail.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: [PATCH v2] net: qrtr: fix memory leaks
Date:   Fri, 23 Jul 2021 18:31:32 +0300
Message-Id: <20210723153132.6159-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210723122753.GA3739@thinkpad>
References: <20210723122753.GA3739@thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in qrtr. The problem was in unputted
struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
which takes sock reference if port was found. Then there is the following
check:

if (!ipc || &ipc->sk == skb->sk) {
	...
	return -ENODEV;
}

Since we should drop the reference before returning from this function and
ipc can be non-NULL inside this if, we should add qrtr_port_put() inside
this if.

The similar corner case is in qrtr_endpoint_post() as Manivannan
reported. In case of sock_queue_rcv_skb() failure we need to put
port reference to avoid leaking struct sock pointer.

Fixes: e04df98adf7d ("net: qrtr: Remove receive worker")
Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-and-tested-by: syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Added missing qrtr_port_put() in qrtr_endpoint_post() as Manivannan
	reported.

---
 net/qrtr/qrtr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b34358282f37..a8b2c9b21a8d 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -514,8 +514,10 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		if (!ipc)
 			goto err;
 
-		if (sock_queue_rcv_skb(&ipc->sk, skb))
+		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+			qrtr_port_put(ipc);
 			goto err;
+		}
 
 		qrtr_port_put(ipc);
 	}
@@ -850,6 +852,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	ipc = qrtr_port_lookup(to->sq_port);
 	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
+		if (ipc)
+			qrtr_port_put(ipc);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
-- 
2.32.0

