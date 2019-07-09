Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3DF62E56
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGICxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41125 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfGICxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so18785554qtj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jPOiynAlD6Ifea2jP1tAEOf0lQvNlrt92+9HCD1k8dk=;
        b=nAaZYwVrS5w+KBDwfh5VzcpXgXD3ERUskRsQVuHBN9bro9af5DMRL57FZEz6TSlMva
         z6e246bexHqHd/K3z+lDnNspAMxc9fAN8sLZwsFzaIwzDb1dyWgq/3a1BZpmilDVMZF4
         sVd51jSyiAiAqUBQAMYuCvD3IjgiXjWpzeR04jc/iNuuXiqmTTRCSQ6DQkXFqAzYSNzX
         uIJjXsTikvKonGIxEYnZAwWZykgF/IAeRzPj2fW8MsTWGu0aRDJgQcFZUQ/Ah6kQd7Gt
         YOie5I69+L5ZtGKZkGoMyUJJekd87exYv6tBId8r9yiEn9I4f0AlNATc3Rv9PEw9aEjg
         dSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jPOiynAlD6Ifea2jP1tAEOf0lQvNlrt92+9HCD1k8dk=;
        b=H6gbcR2BgIX4dBjtYiOB52wPwti73lIzh4YqLldmD2/u6B4YSPlSZjmycbJ2NyzF3z
         wG8yCzS6JbZbEGcDFJNfMOlT1/7Yg8IOjNXGrZ86MMmqZbhjeGQxr9vOUBzrYaQY3usN
         9yk0NwR5lBxL6x+CDmlZl8ejqmmREuArHwCp30T2xHmGFgjQy73lqwMRcoZzzOa3Lp0I
         yHAL9Lhz5NoR4W7BKSLZAWJ1kibBephvevalR5lgjWm4XiqLy3dieaE+OpsQiGDCHSgI
         hHQ+rKCXDURQqPmbVh8PNFgXnfqQNvAPqlr1qKvv3Wsf2PyMq6Ti9+H6zuOyTc3yhbVo
         9cFQ==
X-Gm-Message-State: APjAAAWQnXAJbDB0DQQphTI0WV4bdmzZOenImXGFTsjOr0afrcVHhb9s
        I6Qr38xMM3gPLwBtna8RuS/cdjjDg1w=
X-Google-Smtp-Source: APXvYqyWC+8dNLfkWS1Iiykq5rlCukPpy1wDjYMx/TGWdZtMtA6fc/Amm2Ii4mhO5d9qNKswN7PAJA==
X-Received: by 2002:ac8:2af8:: with SMTP id c53mr17046207qta.387.1562640825917;
        Mon, 08 Jul 2019 19:53:45 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:45 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 01/11] nfp: tls: ignore queue limits for delete commands
Date:   Mon,  8 Jul 2019 19:53:08 -0700
Message-Id: <20190709025318.5534-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to do our best not to drop delete commands, otherwise
we will have stale entries in the connection table.  Ignore
the control message queue limits for delete commands.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm.h      |  4 +++
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 25 +++++++++++++------
 .../net/ethernet/netronome/nfp/crypto/tls.c   |  5 ++--
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index da1b1e20df51..a460c75522be 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -118,6 +118,10 @@ bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size);
 struct sk_buff *
 nfp_ccm_mbox_msg_alloc(struct nfp_net *nn, unsigned int req_size,
 		       unsigned int reply_size, gfp_t flags);
+int __nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
+			       enum nfp_ccm_type type,
+			       unsigned int reply_size,
+			       unsigned int max_reply_size, bool critical);
 int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 			     enum nfp_ccm_type type,
 			     unsigned int reply_size,
diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index 02fccd90961d..d160ac794d98 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -515,13 +515,13 @@ nfp_ccm_mbox_msg_prepare(struct nfp_net *nn, struct sk_buff *skb,
 
 static int
 nfp_ccm_mbox_msg_enqueue(struct nfp_net *nn, struct sk_buff *skb,
-			 enum nfp_ccm_type type)
+			 enum nfp_ccm_type type, bool critical)
 {
 	struct nfp_ccm_hdr *hdr;
 
 	assert_spin_locked(&nn->mbox_cmsg.queue.lock);
 
-	if (nn->mbox_cmsg.queue.qlen >= NFP_CCM_MAX_QLEN) {
+	if (!critical && nn->mbox_cmsg.queue.qlen >= NFP_CCM_MAX_QLEN) {
 		nn_dp_warn(&nn->dp, "mailbox request queue too long\n");
 		return -EBUSY;
 	}
@@ -536,10 +536,10 @@ nfp_ccm_mbox_msg_enqueue(struct nfp_net *nn, struct sk_buff *skb,
 	return 0;
 }
 
-int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
-			     enum nfp_ccm_type type,
-			     unsigned int reply_size,
-			     unsigned int max_reply_size)
+int __nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
+			       enum nfp_ccm_type type,
+			       unsigned int reply_size,
+			       unsigned int max_reply_size, bool critical)
 {
 	int err;
 
@@ -550,7 +550,7 @@ int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 
 	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
 
-	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type);
+	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type, critical);
 	if (err)
 		goto err_unlock;
 
@@ -594,6 +594,15 @@ int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 	return err;
 }
 
+int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
+			     enum nfp_ccm_type type,
+			     unsigned int reply_size,
+			     unsigned int max_reply_size)
+{
+	return __nfp_ccm_mbox_communicate(nn, skb, type, reply_size,
+					  max_reply_size, false);
+}
+
 static void nfp_ccm_mbox_post_runq_work(struct work_struct *work)
 {
 	struct sk_buff *skb;
@@ -650,7 +659,7 @@ int nfp_ccm_mbox_post(struct nfp_net *nn, struct sk_buff *skb,
 
 	spin_lock_bh(&nn->mbox_cmsg.queue.lock);
 
-	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type);
+	err = nfp_ccm_mbox_msg_enqueue(nn, skb, type, false);
 	if (err)
 		goto err_unlock;
 
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 9f7ccb7da417..086bea0a7f2d 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -112,8 +112,9 @@ nfp_net_tls_communicate_simple(struct nfp_net *nn, struct sk_buff *skb,
 	struct nfp_crypto_reply_simple *reply;
 	int err;
 
-	err = nfp_ccm_mbox_communicate(nn, skb, type,
-				       sizeof(*reply), sizeof(*reply));
+	err = __nfp_ccm_mbox_communicate(nn, skb, type,
+					 sizeof(*reply), sizeof(*reply),
+					 type == NFP_CCM_TYPE_CRYPTO_DEL);
 	if (err) {
 		nn_dp_warn(&nn->dp, "failed to %s TLS: %d\n", name, err);
 		return err;
-- 
2.21.0

