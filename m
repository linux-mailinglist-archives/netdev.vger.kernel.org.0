Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E2E6BBE3F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjCOU57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjCOU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D751592BF7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so21850568ybw.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jm4quXT9GdONi9aN2bs9m6TICuwdhg/hGupGJ5ulp1c=;
        b=TZYm+PS3/qN+/obkmLyCpgI3WcrqS5fPcJJE26bke1Gu0iZy6PxS4ulrNUyU0yTIds
         T4xtHYqZHEHgSP2KBcg1uzo01YOjrp8P2PUWJ0kUCs3CO4UNAlvyOxzUrM5/eC+V5EcM
         E41BC6VmKywxpXDA4ibKlyORkaccV+gaifvMJM2EwpuA3xah8rm+/GCkF3W5gJhnu+gZ
         t/CoPhA7IZwecMuoq4qwBXVmPEMZcbkwwpQVRwXG5rcQKyD89fkuK2UJ+kQz/qCKHxbc
         FKXUZ9R9MdUCpSHdDYg3XjATyO54QNECjHFzMLxhvqXTy0ivGb/PnRZd05moBPflzYlX
         JuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jm4quXT9GdONi9aN2bs9m6TICuwdhg/hGupGJ5ulp1c=;
        b=m6xS0NL/cMhdGbu1nSm5O7lIj7bD4cRO+iBgeDps38Scad/qWmkPCeEqEiv/jYhUGY
         obaUsypQ+gYFJBbiOTJqKTI5ErtccfdhYVc7LUMrks2BuTsOgsj2dUdrNOc0aohxkSP6
         9+RTJ7Sm5SgJX9lxlCI+nFNCGJGjCQisw3uZ1xrtaD0D19Y1DWn6nn3xblSiD70FKtRf
         BYLTzRSBlXGsR072QiLRD/tqxjTNJRVX9AptylgRPECIN0/KJpX6PQnKk8eLkIO562uf
         CRYzdhx5bxZLqMQM7kwWwpXJCscKALzb4wakO+aI+uNocMXfBO0bkjzvM9hEBFO4nQYc
         bMpw==
X-Gm-Message-State: AO0yUKXVuGWzWyaCGYBsgs8j4wrzR1A3KbzpKaJ1mHwKqgaQsVw4+knT
        HLftMdB6CkdeiNXK5n/cE/C7KThBgTPz5A==
X-Google-Smtp-Source: AK7set/xxBAwgX1asPWCaW90CCaSHb0p1NKeUVZvrN37EaVY1lzbG0LQJxW9mch1WKt6ZIXNto0X1GC4xG/Fhw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:251:b0:9f1:6c48:f95f with SMTP
 id k17-20020a056902025100b009f16c48f95fmr14362657ybs.5.1678913871156; Wed, 15
 Mar 2023 13:57:51 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:42 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-3-edumazet@google.com>
Subject: [PATCH net-next 2/6] dccp: annotate lockless accesses to sk->sk_err_soft
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

This field can be read/written without lock synchronization.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/dccp/ipv4.c  | 12 +++++++-----
 net/dccp/ipv6.c  | 11 ++++++-----
 net/dccp/timer.c |  2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index b780827f5e0a5b4296e1e6a2e78dbd7f111d3402..3ab68415d121ce393168030b6821215ff28b1af4 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -177,7 +177,7 @@ static inline void dccp_do_pmtu_discovery(struct sock *sk,
 	 * for the case, if this connection will not able to recover.
 	 */
 	if (mtu < dst_mtu(dst) && ip_dont_fragment(sk, dst))
-		sk->sk_err_soft = EMSGSIZE;
+		WRITE_ONCE(sk->sk_err_soft, EMSGSIZE);
 
 	mtu = dst_mtu(dst);
 
@@ -339,8 +339,9 @@ static int dccp_v4_err(struct sk_buff *skb, u32 info)
 			sk_error_report(sk);
 
 			dccp_done(sk);
-		} else
-			sk->sk_err_soft = err;
+		} else {
+			WRITE_ONCE(sk->sk_err_soft, err);
+		}
 		goto out;
 	}
 
@@ -364,8 +365,9 @@ static int dccp_v4_err(struct sk_buff *skb, u32 info)
 	if (!sock_owned_by_user(sk) && inet->recverr) {
 		sk->sk_err = err;
 		sk_error_report(sk);
-	} else /* Only an error on timeout */
-		sk->sk_err_soft = err;
+	} else { /* Only an error on timeout */
+		WRITE_ONCE(sk->sk_err_soft, err);
+	}
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b9d7c3dd1cb39852be3a03556e976c09757d391d..47fb108342239a0d26de913021ed489216bf5093 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -174,17 +174,18 @@ static int dccp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			 */
 			sk_error_report(sk);
 			dccp_done(sk);
-		} else
-			sk->sk_err_soft = err;
+		} else {
+			WRITE_ONCE(sk->sk_err_soft, err);
+		}
 		goto out;
 	}
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk_error_report(sk);
-	} else
-		sk->sk_err_soft = err;
-
+	} else {
+		WRITE_ONCE(sk->sk_err_soft, err);
+	}
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index 27a3b37acd2efea080d1d52e9f4097046e61f05f..b3255e87cc7e130bbcbfd1cd4aa98ba03d7cefaf 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -19,7 +19,7 @@ int  sysctl_dccp_retries2		__read_mostly = TCP_RETR2;
 
 static void dccp_write_err(struct sock *sk)
 {
-	sk->sk_err = sk->sk_err_soft ? : ETIMEDOUT;
+	sk->sk_err = READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT;
 	sk_error_report(sk);
 
 	dccp_send_reset(sk, DCCP_RESET_CODE_ABORTED);
-- 
2.40.0.rc2.332.ga46443480c-goog

