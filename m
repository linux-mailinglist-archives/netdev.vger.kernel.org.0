Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E16BBE44
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjCOU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjCOU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E411E9F5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m13-20020a25800d000000b00b3dfeba6814so10598432ybk.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XP3fVRTpCXJGZScuoS1xDW2XosYIWBu+rxBokDi7VFg=;
        b=GPtgfuQeseYSMPeQC9pdRwDtB3PohRYjAg2AWO38IUfwI4e8ovmGaJ24J0Wta9XbTU
         9GYfS2CGPsiJwIoz0h7Jq6MRpV1421HX8lc9DMFqkP0ijtDVqLzrae3HoP92Ar10GFix
         K44vJg/sp7dbkWqLdoK3M0lhEhVrDgwGRlo7aep3fNR8kKLg0ARL+JcoUPvuXYbtshZR
         aM3Db+HXaeZGoTkJhRwzo/zvN2ZRz9SX5dhLEFwPA0m8FQtP7ocX11DlBpW/9evAIEvG
         QshJ/goX8WdAw/SdSpDM35x5mI+5d0e9jKJoiRfAonxkavDjqdcqb3mmPGEW6FXqTgA3
         mEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XP3fVRTpCXJGZScuoS1xDW2XosYIWBu+rxBokDi7VFg=;
        b=PNlMuvWEANDZMraxVqIDxlkz+8zyO561Rn+gFFb7B4SlCjU207pADlpe3J7VbK6THI
         OoVIpoD9SttJMQmDlH0JlKCIqcMOzsDu5adHFgPOGuwm+SjA+UFiEaRLS51Ilhp7hjJh
         5sSD0aeJgJr6bAp9dLWmg8UlnK+QVTO1YGToHELFEQhoFXSDEI/c2A2aOcAmv600PlHH
         1OLYwK8R6VSTSsui91etttaxBn8H68XUcWFNQ2XnaRz8aG5+R7ZJLdhznK9ADBrDizmU
         KWSHBBwdOS24js+W8Bc5ym6wjUOf3Zdf26leO/aRJS7vxEQgdGsFnzOPgep1mxYEH1jq
         Bbyg==
X-Gm-Message-State: AO0yUKUD8ySnME3gN5ESD+IRBuHNXsXMNIhxJoo7KuLznK0I89c9fTEq
        32eWEVYgonlM9Dx+T/8IfULzQzM3V/2bxA==
X-Google-Smtp-Source: AK7set9EBAS93fMhmEIG564kjq/CKRiCSKQKurlI7cM2HDzlbP0cJMbV6UC4z5QYaEwTk6oaMrDJ3FheS+slUQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:bc49:0:b0:541:f929:28dc with SMTP id
 b9-20020a81bc49000000b00541f92928dcmr777386ywl.3.1678913876810; Wed, 15 Mar
 2023 13:57:56 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:46 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-7-edumazet@google.com>
Subject: [PATCH net-next 6/6] af_unix: annotate lockless accesses to sk->sk_err
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix_poll() and unix_dgram_poll() read sk->sk_err
without any lock held.

Add relevant READ_ONCE()/WRITE_ONCE() annotations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/unix/af_unix.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b0f18ecce4470d6fd21c084a3ea49e04dcbb9bd..fb31e8a4409ed979e4443e7d3d392a5e0f2c424b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -557,7 +557,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 		 * when peer was not connected to us.
 		 */
 		if (!sock_flag(other, SOCK_DEAD) && unix_peer(other) == sk) {
-			other->sk_err = ECONNRESET;
+			WRITE_ONCE(other->sk_err, ECONNRESET);
 			sk_error_report(other);
 		}
 	}
@@ -630,7 +630,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 			/* No more writes */
 			skpair->sk_shutdown = SHUTDOWN_MASK;
 			if (!skb_queue_empty(&sk->sk_receive_queue) || embrion)
-				skpair->sk_err = ECONNRESET;
+				WRITE_ONCE(skpair->sk_err, ECONNRESET);
 			unix_state_unlock(skpair);
 			skpair->sk_state_change(skpair);
 			sk_wake_async(skpair, SOCK_WAKE_WAITD, POLL_HUP);
@@ -3165,7 +3165,7 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err)
+	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
 	if (sk->sk_shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
@@ -3208,7 +3208,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-- 
2.40.0.rc2.332.ga46443480c-goog

