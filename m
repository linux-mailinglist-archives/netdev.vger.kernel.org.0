Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F36090CD
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 04:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJWCbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 22:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJWCbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 22:31:00 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CD57D798
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:30:59 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w196so7517955oiw.8
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tdQkUlrSmov1XrjFnl9UgkC+Tyxyg/IT9ERVW2khmA0=;
        b=i3aGR6OYAhZdDxKH1S4Qs02E5JIdPSdqjCX7YXvjsVwK666103Bkljw5ywUi8p77tV
         i9de3pP1+1hRz3pTTyQb5fopzvppyFQRHUzTvORhXxhnnOrpewx4NhLNctLD3LnDDjpJ
         CK8ZsNz2bJ4EE3nQ8EuNK8Kvkol/GEOASz/SyAhDVpk/CUbSGPXfk1dNSOURVDkbAjJj
         LX+R/3T1PxTUcOKCRu1SBIJG8mmQ8b+X3QqAAqxizWDHRO5JjTRrTMCafrqNRiURloE2
         iZ6xNb6HUxpKUg6iAo99KLXZTpOvGYJo92hmk8HU+4enmJ9XiDZwNR3PBmqztMk8VqI9
         kUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tdQkUlrSmov1XrjFnl9UgkC+Tyxyg/IT9ERVW2khmA0=;
        b=LxZTSz2AjFXtvvg9KyYy5rL2xABkdspAcbOJGy/lGTa4eHiPvPNuODtteI1m/0UJPt
         9IBxOO7OZdIFyaLk50QdXQ1uKQJxJUURrUL7sa0Hd6AII3AMZxjoyZqV+bW+3TG00dDD
         aY1qSnnigpEJiSqhnlvgB66sTnL985IySPzUMOuYk4BIIo2HDSnLmt4zU/kpg7Xrma0/
         Dmk9WB1IO//08JQfzqVPM3XqDlA8TF+yhCWQOyBiGjGqgV34Ap0lsQ4B9ewn7FaOj/Ql
         d6s3DfbkDzIkuB6LIIFCs7e40fbQViVXCuB50k9r+oou1ZSLB597en5HTeZhx6WS83Tj
         oK8w==
X-Gm-Message-State: ACrzQf1mg6pkbiSYxKgTtzTMQNs8sCmOpZms4vKidr502mbrk6wXj7/F
        0Q1T1B1PMHBqbJPKTXu2N+m1SVrj1ds=
X-Google-Smtp-Source: AMsMyM4hlumR726Hl1Z7KtWUfTFaGLr2vuCl0JbKKqetKVbACXRtnt6Q7RmnflgB7WSXu/s36uJJJA==
X-Received: by 2002:a05:6808:14c4:b0:355:40d5:400 with SMTP id f4-20020a05680814c400b0035540d50400mr13123575oiw.249.1666492258846;
        Sat, 22 Oct 2022 19:30:58 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2e02:af9:d9bc:69c5])
        by smtp.gmail.com with ESMTPSA id l10-20020a4a434a000000b004768f725b7csm10128992ooj.23.2022.10.22.19.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 19:30:58 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [Patch net] kcm: fix a race condition in kcm_recvmsg()
Date:   Sat, 22 Oct 2022 19:30:44 -0700
Message-Id: <20221023023044.149357-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Cong Wang <cong.wang@bytedance.com>

sk->sk_receive_queue is protected by skb queue lock, but for KCM
sockets its RX path takes mux->rx_lock to protect more than just
skb queue, so grabbing skb queue lock is not necessary when
mux->rx_lock is already held. But kcm_recvmsg() still only grabs
the skb queue lock, so race conditions still exist.

Close this race condition by taking mux->rx_lock in kcm_recvmsg()
too. This way is much simpler than enforcing skb queue lock
everywhere.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Tested-by: shaozhengchao <shaozhengchao@huawei.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/kcm/kcmsock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 27725464ec08..8b4e5d0ab2b6 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1116,6 +1116,7 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
+	struct kcm_mux *mux = kcm->mux;
 	int err = 0;
 	long timeo;
 	struct strp_msg *stm;
@@ -1156,8 +1157,10 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 msg_finished:
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
+			spin_lock_bh(&mux->rx_lock);
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
 			skb_unlink(skb, &sk->sk_receive_queue);
+			spin_unlock_bh(&mux->rx_lock);
 			kfree_skb(skb);
 		}
 	}
-- 
2.34.1

