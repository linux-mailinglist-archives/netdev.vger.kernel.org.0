Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5248C425CA3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhJGTxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbhJGTxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:53:46 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DFAC061570;
        Thu,  7 Oct 2021 12:51:52 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so8901005otx.3;
        Thu, 07 Oct 2021 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0/6HCugUMN0F654upmT8E3BC8E0KlkaMuLVFLmed0w=;
        b=kpYzDIHQ8hqzKKZj5IVoqIa4/Y0cTKN2yDVeHbls9V9GTXBM5ElVvRNGWPCSGppv7g
         VkoWvUDN+juoR/xbjMTVd0RWX+TSV3sxG1SgYBb58VL5opkboPn7jx8ltbQGVMkNyXSj
         gTAgpJ+iQvkdmtN0QrUPODgOhBHf2Sp944DjUZPADvwB73NeMjmWmtpIkZiITmzXti8/
         5x1UNKUqy4Mn/gHZBIehejTQ3552exuKiXuHfU/10GRQQZW/XXqexvi7cfJ2hZRfPPiz
         ocHjA4pzb/TnlyUtW0vOMi7rMIFoG1A+h88GFlYCLytI/TH4yI5d0Eghe79S6nCRgPcO
         TYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0/6HCugUMN0F654upmT8E3BC8E0KlkaMuLVFLmed0w=;
        b=Ox8fyWlOfIp4E/GStqr3xYPEmQDwqcxfcMyStSk45HksRVONfbBqSz2FFM9w8kHIGx
         Wu4l8vIiwta/RNGQVANQdnnVFedFnYjPlRIRN/VrQBVkBM28KaKxBtEcXafOjlKEnLo9
         Spe0ZW+1WeewKdPWZFI7xJ9VqyferAHXLfd1KySx9QzkhM6Nn6gXKTyisWlWFYira6lU
         LeahM0YMwunQukjhp6OlJJ3kBQLDuYG4nfu5spsJlD1XCme30w/VvBFJE+KcYbRt4Ncs
         8f8jcAKcFwyOts2ieXoCBXkJVUpf8OZSWmSLAw9hOncVrsEkrUHN8zusTNOt7b36nof9
         xiIw==
X-Gm-Message-State: AOAM533eOpLIZIS+/IyDE2RbCMaVVoYuFl0L1DbN13eHQKu3LnBLTwmI
        z0v6HaNvZH8k3j6DRTR2NLFRH4wHQiQ=
X-Google-Smtp-Source: ABdhPJzIvUe3fMiVX/W5xfVi1zORiSe5YE8qxDAuN4+cVJ00zdWrKB74TBmicUWfk03AXXZvfJDPCA==
X-Received: by 2002:a9d:357:: with SMTP id 81mr5134026otv.381.1633636311857;
        Thu, 07 Oct 2021 12:51:51 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:85ae:a51:4d98:71a3])
        by smtp.gmail.com with ESMTPSA id s206sm94774oia.33.2021.10.07.12.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:51:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf v3] skmsg: check sk_rcvbuf limit before queuing to ingress_skb
Date:   Thu,  7 Oct 2021 12:51:47 -0700
Message-Id: <20211007195147.28462-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
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
and it is not limited either.

This patch adds checks for sk->sk_rcvbuf right before queuing
to ingress_skb and drops or retries the packets if this limit
exceeds. This is very similar to UDP receive path. Ideally we
should set the skb owner before this check too, but it is hard
to make TCP happy with sk_forward_alloc.

For TCP, we can not just drop the packets on errors. TCP ACKs
are already sent for those packet before reaching
->sk_data_ready(). Instead, we use best effort to retry, this
works because TCP does not remove the skb from receive queue
at that point and exceeding sk_rcvbuf limit is a temporary
situation.

Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
v3: add retry logic for TCP
v2: add READ_ONCE()

 net/core/skmsg.c | 15 +++++++++------
 net/ipv4/tcp.c   |  2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..356c314cd60c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -877,11 +877,12 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
-	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
+	    atomic_read(&sk_other->sk_rmem_alloc) > READ_ONCE(sk_other->sk_rcvbuf)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
 		sock_drop(from->sk, skb);
-		return -EIO;
+		return -EAGAIN;
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
@@ -941,7 +942,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 
 		skb_bpf_set_ingress(skb);
-
+		err = -EAGAIN;
 		/* If the queue is empty then we can submit directly
 		 * into the msg queue. If its not empty we have to
 		 * queue work otherwise we may get OOO data. Otherwise,
@@ -953,7 +954,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
-			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
+			    atomic_read(&sk_other->sk_rmem_alloc) <= READ_ONCE(sk_other->sk_rcvbuf)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
 				err = 0;
@@ -1141,8 +1143,9 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
-		len = 0;
+	ret = sk_psock_verdict_apply(psock, skb, ret);
+	if (ret < 0)
+		len = ret;
 out:
 	rcu_read_unlock();
 	return len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..8b243fcdbb8f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1665,6 +1665,8 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			if (used <= 0) {
 				if (!copied)
 					copied = used;
+				if (used == -EAGAIN)
+					continue;
 				break;
 			} else if (used <= len) {
 				seq += used;
-- 
2.30.2

