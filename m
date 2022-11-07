Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C3F61EE47
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiKGJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiKGJJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:09:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C763EF;
        Mon,  7 Nov 2022 01:09:57 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso13910920pjg.5;
        Mon, 07 Nov 2022 01:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7s5/qb1nSXLZnJZGYNn4Wzlw1M+hVX8xrWCLqS93kyE=;
        b=jsZFj6rnuGvjrA0j9safRVQ5ub46rEH1AZfLSqW2ttOPIj5JHT/WdKQlIhtr2nVEJS
         nsSd+7WepQB+ugVUZrR8cMRMWVAadLJGsKUD7ZMEmHnnorqSXESEhIo5Vs1mo64JT9Gn
         EXN+KW+LZieQD50nvey2BtAtDAGfVSkRXtCnxgZ09na2YxBeKwn60+lx/DKjy9/h0e9u
         a/LlbxjMOUCjBcaaO1oYdcLOnb3uXZaoHIg0gLPfqklgoYL60KLY++/34/uecscDXpHH
         iyuhqr6ey99c7HW4fQ6LCJg1q6bKDyceQMGcopTLm/2geH7+8Dph0PbIimVSvA2YKfA9
         X0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7s5/qb1nSXLZnJZGYNn4Wzlw1M+hVX8xrWCLqS93kyE=;
        b=SVgEIR85I/gbehpP8P8yWjImXXfdvTr6AZFqc45oYCKCj8qqgIYyrRJXdfPYMWGGKS
         itWfRDHYFosKuJuO1jyfnJOjrJRUwym9J+wC3wRXHp3C8hHYVIjsP47L2lss7dKzgvY3
         Kl5zXPDCWeZSGxQNKhB/oMq3UUduVgeiulE23lgIRZy0ulntz/lpXjLlXqL2xeuuHZLS
         0cLVZUz9cbt8+35IKWfGzrlgJAn3AMFXSUEbQeFN3laPbgrKCzaCpakxB5Wud3uyB1Fd
         Obfc9b02yXPY2iZX64xNu83ixMvjyASXogU7kFZDNSMflmPfjkXUUZfTIUGnpJWNrwp7
         AUDg==
X-Gm-Message-State: ACrzQf0URqpgnXQI36W1B6eEg9n24m5muyPT6nRjWsbqI4ouBLkx1lPp
        EoMWB1/MUf9qk2vOrteDxrE=
X-Google-Smtp-Source: AMsMyM4gl/gScKEXAGRR2lnQ8YwqcbIK1OxMz9XJeChJTovFnpwVuWj5tN1PpbxaSJtL26M8yoNddQ==
X-Received: by 2002:a17:90a:a781:b0:214:2921:41ca with SMTP id f1-20020a17090aa78100b00214292141camr29126567pjq.118.1667812197190;
        Mon, 07 Nov 2022 01:09:57 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b001886863c6absm4493809plg.97.2022.11.07.01.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 01:09:56 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] net: tun: rebuild error handling in tun_get_user
Date:   Mon,  7 Nov 2022 17:09:40 +0800
Message-Id: <20221107090940.686229-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling in tun_get_user is very scattered.
This patch unifies error handling, reduces duplication of code, and
makes the logic clearer.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
v0 -> v1:
- rename tags

 drivers/net/tun.c | 68 ++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4bf2b268df4a..5ceec73baf98 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1742,11 +1742,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	int good_linear;
 	int copylen;
 	bool zerocopy = false;
-	int err;
+	int err = 0;
 	u32 rxhash = 0;
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
-	enum skb_drop_reason drop_reason;
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1808,11 +1808,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
 		if (IS_ERR(skb)) {
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			return PTR_ERR(skb);
+			err = PTR_ERR(skb);
+			goto drop;
 		}
 		if (!skb)
-			return total_len;
+			goto out;
 	} else {
 		if (!zerocopy) {
 			copylen = len;
@@ -1836,11 +1836,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		}
 
 		if (IS_ERR(skb)) {
-			if (PTR_ERR(skb) != -EAGAIN)
-				dev_core_stats_rx_dropped_inc(tun->dev);
-			if (frags)
-				mutex_unlock(&tfile->napi_mutex);
-			return PTR_ERR(skb);
+			err = PTR_ERR(skb);
+			goto drop;
 		}
 
 		if (zerocopy)
@@ -1851,27 +1848,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		if (err) {
 			err = -EFAULT;
 			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
-drop:
-			dev_core_stats_rx_dropped_inc(tun->dev);
-			kfree_skb_reason(skb, drop_reason);
-			if (frags) {
-				tfile->napi.skb = NULL;
-				mutex_unlock(&tfile->napi_mutex);
-			}
-
-			return err;
+			goto drop;
 		}
 	}
 
 	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
-		kfree_skb(skb);
-		if (frags) {
-			tfile->napi.skb = NULL;
-			mutex_unlock(&tfile->napi_mutex);
-		}
-
-		return -EINVAL;
+		err = -EINVAL;
+		goto drop;
 	}
 
 	switch (tun->flags & TUN_TYPE_MASK) {
@@ -1887,9 +1871,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				dev_core_stats_rx_dropped_inc(tun->dev);
-				kfree_skb(skb);
-				return -EINVAL;
+				err = -EINVAL;
+				drop_reason = SKB_DROP_REASON_INVALID_PROTO;
+				goto drop;
 			}
 		}
 
@@ -1931,11 +1915,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			if (ret != XDP_PASS) {
 				rcu_read_unlock();
 				local_bh_enable();
-				if (frags) {
-					tfile->napi.skb = NULL;
-					mutex_unlock(&tfile->napi_mutex);
-				}
-				return total_len;
+				goto unlock_frags;
 			}
 		}
 		rcu_read_unlock();
@@ -1952,8 +1932,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	rcu_read_lock();
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
-		err = -EIO;
 		rcu_read_unlock();
+		err = -EIO;
 		drop_reason = SKB_DROP_REASON_DEV_READY;
 		goto drop;
 	}
@@ -2007,7 +1987,23 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (rxhash)
 		tun_flow_update(tun, rxhash, tfile);
 
-	return total_len;
+	goto out;
+
+drop:
+	if (err != -EAGAIN)
+		dev_core_stats_rx_dropped_inc(tun->dev);
+
+	if (!IS_ERR_OR_NULL(skb))
+		kfree_skb_reason(skb, drop_reason);
+
+unlock_frags:
+	if (frags) {
+		tfile->napi.skb = NULL;
+		mutex_unlock(&tfile->napi_mutex);
+	}
+
+out:
+	return err ?: total_len;
 }
 
 static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
-- 
2.37.2

