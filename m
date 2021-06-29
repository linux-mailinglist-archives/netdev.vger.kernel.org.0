Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4113B6E36
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 08:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhF2GXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 02:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhF2GXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 02:23:15 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AC2C061574;
        Mon, 28 Jun 2021 23:20:48 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so21592184otl.3;
        Mon, 28 Jun 2021 23:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Se16ZA++CTrolvG6Cq5GPO+HX4VPHxQ2O5qkzFvgqqI=;
        b=oIOtYWFM4ZqIOWIAvPSscLwsoBcbJ/y0/+W7wVU1BDF0rg/sip/bs36SxqdjswZAkX
         xuZO40mDaF+OchtlbRzi+1py83xEySxUJ1SvnK0FZcHiVPt8u6VtK9zbp2Qbr/L01jmo
         /5WzZ8Z5em8Qaw80wPzeBGNFxK2/ibmu8SaOQTNHipSHVZHhnbSunGoXV5Zc5RxPoOW3
         2VP5MmZnrxTZJtoGbbf0CGHK5w2yITkgltFL9DnS4mcD0Znm/PbiLWalboeCPtFNJbN/
         8XTE6d4qNiM3/YLAqzCxtGWRA2P/FyoaPweXpDQAcrMycSAKmY487vlEQK4+qS095uav
         UNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Se16ZA++CTrolvG6Cq5GPO+HX4VPHxQ2O5qkzFvgqqI=;
        b=pc0lcMUGnBAOyfTF2yxCgJYqDRU/a+Nm8DsGBCJSu2fdrIFcr1RpPVpGqAr+b4SZJH
         Vp8KbZlQULw6KWpdXaxrdFSsbj/q9GSWk8aF4MJS40si9JA3ZWCEWnD7Vj856Y3t4mZL
         HDWmOcYf3yofurW+khUePaTe5iiQ5Izyzi3v0fzPsmFxdr9yt0c0KbwdbSt+Ke9aAHoT
         w7oc0TCMKH7dCBoxQJIOWmrI3Ey8zV3LL4gm/Bh7hkwGTaXYp4FxZVhyVls2pN6fiSAW
         zRotVMjbSHgzTOqwhXIgSDdaUsfoa/yEySxgmf15Ql6DMpjyz3i7FUBa+BsAoZ+F+wNZ
         fu+A==
X-Gm-Message-State: AOAM5300ovLU43PCeB8SGkj+cWuW3vHsltk6DyoITPm+5rKw0DK56YRp
        yn2NGQvFKCRf6vlXQKrWzpJLLTF+oXO/Kw==
X-Google-Smtp-Source: ABdhPJwjPf4OYT1Ckf0LOgVzFp8nDoYm06OErmAwWe9P/+VeWVUXPQCgYfy+LIMFONIWu5cs8xH/MQ==
X-Received: by 2002:a05:6830:1b6b:: with SMTP id d11mr2996194ote.86.1624947647696;
        Mon, 28 Jun 2021 23:20:47 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:7de:9afc:ae20:4d84])
        by smtp.gmail.com with ESMTPSA id s28sm3687900oij.12.2021.06.28.23.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 23:20:47 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
Date:   Mon, 28 Jun 2021 23:20:29 -0700
Message-Id: <20210629062029.13684-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Jiang observed OOM frequently when testing our AF_UNIX/UDP
proxy. This is due to the fact that we do not actually limit
the socket memory before queueing skb to ingress_skb. We
charge the skb memory later when handling the psock backlog,
but it is not limited either.

This patch adds checks for sk->sk_rcvbuf right before queuing
to ingress_skb and drops packets if this limit exceeds. This
is very similar to UDP receive path. Ideally we should set the
skb owner before this check too, but it is hard to make TCP
happy about sk_forward_alloc.

Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9b6160a191f8..83b581d8023d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
-	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
+	    atomic_read(&sk_other->sk_rmem_alloc) > sk_other->sk_rcvbuf) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
 		sock_drop(from->sk, skb);
@@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
-			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
+			    atomic_read(&sk_other->sk_rmem_alloc) <= sk_other->sk_rcvbuf) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
 				err = 0;
-- 
2.27.0

