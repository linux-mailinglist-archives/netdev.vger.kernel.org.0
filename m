Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15DC5E732F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIWE7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiIWE7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:59:39 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B69262FD;
        Thu, 22 Sep 2022 21:59:35 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id ml1so8354010qvb.1;
        Thu, 22 Sep 2022 21:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=E3uwB8CqWVlPJdmYFGu1eVYpx1JpXqpegdhCF2Dn9pA=;
        b=nZsnGlCKEzHd5dkQ0Y+CcZkE37s49utJ7EJjcXq+k9Xew12sdEX8ZXxoP6MT11iATd
         lVSFZjKCwWKTp77T6e35BiSz8cY2UJX++jtcHdDYwSiKi2CF2p3ZirJtNqoZRCo81+qn
         nbWX+HLIfTNp/1lBNasq9K9qgtuvM8qpjh+S6af5Pq02ap0uCnuCQxAxOW8xASajLw3i
         QEWtdD692EUISxJ91DrP/Z/n8Xu/FYDgY8WmZkqi/FwPOVKKANdd6LWK71JIjYoRJLcY
         Gga/YwSnTM5lBPvmjPS7Rr1d0oiHmgABjvrRH467LPt2f/Vm4pPLbbpgu4OVP8qcu0QJ
         A4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=E3uwB8CqWVlPJdmYFGu1eVYpx1JpXqpegdhCF2Dn9pA=;
        b=YyTy/7PhCu1Nl4g6sJPZ4EXJd3KZglaXe2ZcJHDkFg7nt8RK9qMFr4CliuJAC2yya0
         CRmY4jmfyf9HiNNV6ey/RVj5RPPLE36doyVYQ30tOBHJ6iSO9L/rW/K9vJmDOANI9VBl
         WNIII+Tx6oosNBz6PX5iDJ/2c0tilJyfQTqMGPdjLpfTw+Bei2G1K8dsIvVbE9rXQtCc
         CWuMG6kwg16fLssNSMMBGTNDFYT+bc4JbksjtYuxozUfyd+YfCeZLhzkj1FNKdXagjOa
         46Ez5EwMdEA+i7s31x5bNOZzXrW3EbMn8xNtBzNJdbF1a0ejkNW5qSfH3Bu36eD0CLw/
         CYSg==
X-Gm-Message-State: ACrzQf3XejoZzL4oF49GUr4ixAQZPiD9uMM/xSrmRz4FOSzIw5N2nc3w
        G2UxX7VMsSwcQ6GnjV65yQ==
X-Google-Smtp-Source: AMsMyM7daWXjghU4BJEGxdJKD7rszzAz0+XrbF8n/FxFUIKac8PUSEcwk3rImT8JwBHpJCRZAkrBKQ==
X-Received: by 2002:a05:6214:29e3:b0:4ad:5de4:accd with SMTP id jv3-20020a05621429e300b004ad5de4accdmr5377972qvb.60.1663909174781;
        Thu, 22 Sep 2022 21:59:34 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id x17-20020a05620a449100b006b9264191b5sm5263168qkp.32.2022.09.22.21.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 21:59:34 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next RESEND 2/2] af_unix: Refactor unix_read_skb()
Date:   Thu, 22 Sep 2022 21:59:26 -0700
Message-Id: <7009141683ad6cd3785daced3e4a80ba0eb773b5.1663909008.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <343b5d8090a3eb764068e9f1d392939e2b423747.1663909008.git.peilin.ye@bytedance.com>
References: <343b5d8090a3eb764068e9f1d392939e2b423747.1663909008.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Similar to udp_read_skb(), delete the unnecessary while loop in
unix_read_skb() for readability.  Since recv_actor() cannot return a
value greater than skb->len (see sk_psock_verdict_recv()), remove the
redundant check.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/unix/af_unix.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dea2972c8178..c955c7253d4b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2536,32 +2536,18 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 
 static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	int copied = 0;
-
-	while (1) {
-		struct unix_sock *u = unix_sk(sk);
-		struct sk_buff *skb;
-		int used, err;
-
-		mutex_lock(&u->iolock);
-		skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
-		mutex_unlock(&u->iolock);
-		if (!skb)
-			return err;
+	struct unix_sock *u = unix_sk(sk);
+	struct sk_buff *skb;
+	int err, copied;
 
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			kfree_skb(skb);
-			break;
-		} else if (used <= skb->len) {
-			copied += used;
-		}
+	mutex_lock(&u->iolock);
+	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
+	mutex_unlock(&u->iolock);
+	if (!skb)
+		return err;
 
-		kfree_skb(skb);
-		break;
-	}
+	copied = recv_actor(sk, skb);
+	kfree_skb(skb);
 
 	return copied;
 }
-- 
2.20.1

