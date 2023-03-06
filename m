Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470D76ABEE2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCFL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjCFL6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:58:03 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0739C4C13;
        Mon,  6 Mar 2023 03:58:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p20so9948386plw.13;
        Mon, 06 Mar 2023 03:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678103881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hft+w/AWTpA/oHx8mE1wI0oZbuc9lfki3TKKzp/NdNA=;
        b=N7/Sujkh6ufAR+6H+b161RlDaaLu9dDxRmwjQEJX1my8jcJLYEIr4xPSpSBEhpMovw
         FdsO0MXBpWWIBj+5AUOo41QTeh/Wi860oHBnqIJvBkYHc6uaqVPpKiSl07yJZkFDYHcQ
         n1QIDC/SMxXE4/b1ee4zPgdoby+dBU/9/uVKSH81RGRLRx1/0Yn7F2GR8lzQwx2TJGxZ
         6UapA8IaXxQvtSUxtmCbxNv6BmWVjxrdUP8G9Wx2sPskf78cHbcozxQAdlSHPGMSZmib
         MRxs9gF+e4g2ZZz/vA8byA425ih75kwgoGp8jdb0mgXlkU+1kUbV4xPsP0lEgEFvPUhQ
         TUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678103881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hft+w/AWTpA/oHx8mE1wI0oZbuc9lfki3TKKzp/NdNA=;
        b=CGlEUbkovdgt/IisV0YHHlhCPh0Smlv1NjVuD7ogzMtM3nMGI+86+vF/dXcf0ZDu4h
         vp9lke8mzgKgKy5hELR22nWDC7yF4HGrCiNJg6iUXdIPNgmnkFBoADkoiU/j2qo2h1oN
         zRRAy+J0FH2e4xo65xXXpFSF0rH/Yg6y+Dl2iFxreBQX6YEEyL7ufwSciNEcaSt/l3/U
         E88FlF/d1g/vU0lTr2b+TOdwkElCfVsP69SWlkWknZw7F3YmUVEm77cSVMY0We24qbeE
         7IpMUCaGspew2t+modaH3+8zQV8iXhNLhX7GZyK2W2893QnlcqaV6kU8dlBP7idxrmco
         ALUQ==
X-Gm-Message-State: AO0yUKU8Ycn5sq97RSNSG6TLUS+SmUuOID1dKVyDHp8JqduBygb3gwRD
        CAtFQesHWudcD7qnpWonX/M=
X-Google-Smtp-Source: AK7set/AFZkOnRb5aCA1x9R88r1/NeFmclcksVUWCpHqot6Nff6CildQ66ij5zK3slqZaSGojYn9+A==
X-Received: by 2002:a17:90b:1b05:b0:237:aa9f:968c with SMTP id nu5-20020a17090b1b0500b00237aa9f968cmr10973012pjb.34.1678103881440;
        Mon, 06 Mar 2023 03:58:01 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090add8300b0022335f1dae2sm5887361pjv.22.2023.03.06.03.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 03:58:01 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net-next] udp: introduce __sk_mem_schedule() usage
Date:   Mon,  6 Mar 2023 19:57:45 +0800
Message-Id: <20230306115745.87401-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Keep the accounting schema consistent across different protocols
with __sk_mem_schedule(). Besides, it adjusts a little bit on how
to calculate forward allocated memory compared to before. After
applied this patch, we could avoid receive path scheduling extra
amount of memory.

Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxing@gmail.com/
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
V2:
1) change the title and body message
2) use __sk_mem_schedule() instead suggested by Paolo Abeni
---
 net/ipv4/udp.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9592fe3e444a..21c99087110d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1531,10 +1531,23 @@ static void busylock_release(spinlock_t *busy)
 		spin_unlock(busy);
 }
 
+static inline int udp_rmem_schedule(struct sock *sk, int size)
+{
+	int delta;
+
+	delta = size - sk->sk_forward_alloc;
+	if (delta > 0 && !__sk_mem_schedule(sk, delta, SK_MEM_RECV))
+		return -ENOBUFS;
+
+	sk->sk_forward_alloc -= size;
+
+	return 0;
+}
+
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff_head *list = &sk->sk_receive_queue;
-	int rmem, delta, amt, err = -ENOMEM;
+	int rmem, err = -ENOMEM;
 	spinlock_t *busy = NULL;
 	int size;
 
@@ -1567,20 +1580,12 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		goto uncharge_drop;
 
 	spin_lock(&list->lock);
-	if (size >= sk->sk_forward_alloc) {
-		amt = sk_mem_pages(size);
-		delta = amt << PAGE_SHIFT;
-		if (!__sk_mem_raise_allocated(sk, delta, amt, SK_MEM_RECV)) {
-			err = -ENOBUFS;
-			spin_unlock(&list->lock);
-			goto uncharge_drop;
-		}
-
-		sk->sk_forward_alloc += delta;
+	err = udp_rmem_schedule(sk, size);
+	if (err) {
+		spin_unlock(&list->lock);
+		goto uncharge_drop;
 	}
 
-	sk->sk_forward_alloc -= size;
-
 	/* no need to setup a destructor, we will explicitly release the
 	 * forward allocated memory on dequeue
 	 */
-- 
2.37.3

