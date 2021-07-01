Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CAD3B8DAF
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 08:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhGAGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 02:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhGAGTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 02:19:44 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38DC061756;
        Wed, 30 Jun 2021 23:17:13 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id x6so2434897qvx.4;
        Wed, 30 Jun 2021 23:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQmdEh20TzOPTN5vRc3RTXpDGJW2JVfPqZfqDo6hNC8=;
        b=FmiIHUPRQ1Lcwzm3vtLI/LKQoPIaliVn7nEp5gR9GH8oZOjorH4b/NHLfDT+eGExbq
         MYyk6s9/ieatOcxHK3U2Ekm7gr7PHGh+cH+A+WuLRG9vojGtDCx4g2qoYDjJ0rDsm8sv
         WjhItpKUPmozyybcNhfY3UdjueFp7kkJZQRBu4niqb5ixpZ90+0B9++dcuN8zDWNCdK+
         MYN7iQefNejCxVCCbBBDdFOPFYpFWoeEpkObccZzLANpip3tcKBh6i+wxiU9ZWHpol6Q
         4lZE5WBzD0an9+zOzPYWxogqmKP0UCjNinyUrJQhdaP2vTa8dJ4UWQ1YmJI2rI/elMF/
         xWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQmdEh20TzOPTN5vRc3RTXpDGJW2JVfPqZfqDo6hNC8=;
        b=lPG4LO9yfGBj7DcY7CLDjimGNwKdw5/iCLmSdV4r+fOucG1FBiJOvLoOeLUQxAWkdP
         nlzIXoTSMojaNgpyNx9qnj9NIDSM2l5QYWcyNGrHc+LDrMb1nplMl8GuoOIy2Z4aCyG1
         flfy1VAn2bIFHd8pNzkNmydw99OK4jnpRi/8/9CMsd3+yp/IGBorbFYgFlHcagE+wZ6W
         w+fWM0hkpfZp9UfCiDTLXKEdGjA1XF3tPrxSC3enF3uH1dYNhBzub2w61mtU5xP0VgLN
         oc2zDIfqOaTcyDpUqY/NUjEcpCf9+FIHMiN49GrinIbZv8ELyuoHcWJaTPWN9R1ae+46
         gI3g==
X-Gm-Message-State: AOAM533qUFSvRD/kwxRhlZRRe4v3UTXCLQ9otCcRfK1LPnxCBY6X0i95
        s5GlatWSSNijQjwqRcqN+kQeoBIS1I6oCw==
X-Google-Smtp-Source: ABdhPJzqXh1wsVH46pv+j9y8magyspFKSnYFv3NUcSqNnvoCaX11NyTddzX0zsCHHx30It3p17855Q==
X-Received: by 2002:a05:6214:c26:: with SMTP id a6mr40931996qvd.55.1625120232667;
        Wed, 30 Jun 2021 23:17:12 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:2bdf:cf98:b2c0:7257])
        by smtp.gmail.com with ESMTPSA id g5sm6292830qtj.7.2021.06.30.23.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 23:17:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
Date:   Wed, 30 Jun 2021 23:16:56 -0700
Message-Id: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
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
index 9b6160a191f8..a5185c781332 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
-	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
+	    atomic_read(&sk_other->sk_rmem_alloc) > READ_ONCE(sk_other->sk_rcvbuf)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
 		sock_drop(from->sk, skb);
@@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
-			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
+			    atomic_read(&sk_other->sk_rmem_alloc) <= READ_ONCE(sk_other->sk_rcvbuf)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
 				err = 0;
-- 
2.27.0

