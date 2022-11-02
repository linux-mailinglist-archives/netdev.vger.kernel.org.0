Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B44615B84
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiKBEen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKBEem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:34:42 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52851FCFF;
        Tue,  1 Nov 2022 21:34:38 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-12c8312131fso19141391fac.4;
        Tue, 01 Nov 2022 21:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wS4tDVH6GZmAdKGIIk3ZJCdxVz/QayrTgx7P0+QvSDQ=;
        b=JBn2HQsWqL1sGyMrJyn9uFKGUMvwv3p8LDfXTthatPO9Hxs10vqm8iUnqF8Ip1EDxC
         xkHwLOTyxdL1OB3K02msS3vVdXWFWiVDDmCyb/bPlf4tJIeIoTWt+P4a7pDG3v0ZNcM4
         rdRtUuNYlY6gajjNcMP3yeGvQGlZUxLBtwpHbWMkQM7clwylKzbT4yOg7Hc40btFv31w
         ar1HIinuTpTrMHRbuIO6cqcws6ISKXxJLrNC3ND0eyvpYNgdnsFIcEs9mYhnqyBMNubw
         wCKiHF8d6V2OtItxcgkuOFSUxkYWKG6/YwQVwe1XPzVZc7BNE+NGQVp+YctsG3Ol0DsP
         GzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wS4tDVH6GZmAdKGIIk3ZJCdxVz/QayrTgx7P0+QvSDQ=;
        b=AgppsH7kTIk9lM51ciOmoQYaHUksBov1rIlcM3PIFGbrpSe0dKstav4m2zP/7OnPEF
         MhGvql0m4t/jUWVWkbSr8QvBDpfThU+gIGwIhgrYPkhHCSmcSUbY+H9Q9A4mbFMUXvlz
         R6hsdw2M9v7oVQrWIq03I/wDmPIOkEtOhs8w0ybR97G7OjIHhdf5Ct/ZM8Rl2CxsKIo/
         +7+UrZiJHDOmPcbXtkCbWg7c6iVhXTdQwbpkI08hWGpyIfGDAfsbCmWMc85ylj0q0dC8
         FH62iqhPdids5TOZKlTq7DTDGb6efvi7raU/ngULwbndq+uqUVJkigSEOiMFY8UXAIDl
         qJSQ==
X-Gm-Message-State: ACrzQf3GyQmsgF4orcWg3oIK260eZJxMNFb0vKpW4ackqM2irc3pXrIV
        zSafZdrcHsmVozvGwMWMkFmrolxfK1M=
X-Google-Smtp-Source: AMsMyM4iejsXHD7L8NmT0gnwrxrbpR1FJIaSTpyCnpK9IN/80lBRuqQvaYQ8k94X8FNOGUr6qkKY1Q==
X-Received: by 2002:a05:6870:e609:b0:137:de59:4526 with SMTP id q9-20020a056870e60900b00137de594526mr13008103oag.0.1667363676960;
        Tue, 01 Nov 2022 21:34:36 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d033:e63d:a624:eb65])
        by smtp.gmail.com with ESMTPSA id g10-20020a4a250a000000b00480fd5b0d6bsm1882459ooa.22.2022.11.01.21.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 21:34:36 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf v2] sock_map: move cancel_work_sync() out of sock lock
Date:   Tue,  1 Nov 2022 21:34:17 -0700
Message-Id: <20221102043417.279409-1-xiyou.wangcong@gmail.com>
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

Stanislav reported a lockdep warning, which is caused by the
cancel_work_sync() called inside sock_map_close(), as analyzed
below by Jakub:

psock->work.func = sk_psock_backlog()
  ACQUIRE psock->work_mutex
    sk_psock_handle_skb()
      skb_send_sock()
        __skb_send_sock()
          sendpage_unlocked()
            kernel_sendpage()
              sock->ops->sendpage = inet_sendpage()
                sk->sk_prot->sendpage = tcp_sendpage()
                  ACQUIRE sk->sk_lock
                    tcp_sendpage_locked()
                  RELEASE sk->sk_lock
  RELEASE psock->work_mutex

sock_map_close()
  ACQUIRE sk->sk_lock
  sk_psock_stop()
    sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
    cancel_work_sync()
      __cancel_work_timer()
        __flush_work()
          // wait for psock->work to finish
  RELEASE sk->sk_lock

We can move the cancel_work_sync() out of the sock lock protection,
but still before saved_close() was called.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Reported-by: Stanislav Fomichev <sdf@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 2 +-
 net/core/skmsg.c      | 7 ++-----
 net/core/sock_map.c   | 7 ++++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b645193b..70d6cb94e580 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1efdc47a999b..e6b9ced3eda8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -803,16 +803,13 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
-void sk_psock_stop(struct sk_psock *psock, bool wait)
+void sk_psock_stop(struct sk_psock *psock)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
 	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
-
-	if (wait)
-		cancel_work_sync(&psock->work);
 }
 
 static void sk_psock_done_strp(struct sk_psock *psock);
@@ -850,7 +847,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a660baedd9e7..81beb16ab1eb 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
@@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
-	sk_psock_put(sk, psock);
+	sk_psock_stop(psock);
 	release_sock(sk);
+	cancel_work_sync(&psock->work);
+	sk_psock_put(sk, psock);
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
-- 
2.34.1

