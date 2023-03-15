Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9206BBE41
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjCOU6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjCOU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4762797B5A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d7-20020a25adc7000000b00953ffdfbe1aso22053760ybe.23
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eseN+B8QG8Ds+4P6ZelXzpzPrp4Bj0Mzr7FMUSgB46Y=;
        b=P3h/B4sJzJ6bX9zU8Sw/8B6kZPWp56QxeLVdBoQDioZncaj4MEvQ/WG5uJQ3ostDrA
         3YXXrVViblWVlFkVQ9SVIILXsNWO5OzXq99LrlsKpTh70rmcwDMYLqDTSCqxLv3MRMoU
         5jRoqHMIgx2ATITA2MCpebRGz9XCcXGZiPlLM/3XewKzudKXONveXbzk4FeiAohqVRQE
         MwQU4GXZfpLUC7ywiE/q15czSXuJy0A/0N6/4YdiqloVwYfVKKtd9KH4fJpG6Mk18c44
         VFvJgECE9vBG764+wYFTSEXjVxGP2DlT0xzhI0l32SDsDZA6Bhha7uPwj+GnkhT8o39x
         1F/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eseN+B8QG8Ds+4P6ZelXzpzPrp4Bj0Mzr7FMUSgB46Y=;
        b=OCYP3rx1D058foeDEorY1626n/kxYAUVpWwRpyaKRHJ4JWaRKPiX11xljLqwu7nQqg
         GOSuEcqJ6dsluwjVd0nHFXWoH7LrCZKspcys5G1GLb2l8RCcKyTX7jBvFPLw4XobLkCN
         cMRuP4eUI/RClOVI0TEn7cmsgCDLQVmVYhEl+CxnCIuf+d9nPeLKoo3W6/uXN6/oPYuT
         tNd6ByKJJYXvILToPfqUMeP70ZZrr1JXfA/xgcTZ8xTqD6dXd6QMMFhU/bmdGaibjX66
         +NmO9UVC+8sBsM9Zyj8nfFC6XTkcvtqARv4ENcuZIKss1BiMWM7kEAftiVr6KA5BwNjF
         yslg==
X-Gm-Message-State: AO0yUKU2Ioioa/nX9Kdw2XZpNktNivICeRze6d3pbOtJc+htmePLpdbm
        Yh/MohKGRsURib8T8LVo287RwiYAAK2++A==
X-Google-Smtp-Source: AK7set/PvBtecFJMnuHH8o99q8VIWB+PvRFzazxiyQC6cPEBqqUdAtGoF7IHDkiZSwPq9X7JzaMkjcDdA7nj5Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:347:0:b0:a06:538f:24b2 with SMTP id
 q7-20020a5b0347000000b00a06538f24b2mr21263520ybp.2.1678913872616; Wed, 15 Mar
 2023 13:57:52 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:43 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-4-edumazet@google.com>
Subject: [PATCH net-next 3/6] net: annotate lockless accesses to sk->sk_err_soft
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

tcp and dccp have been handled in different patches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 fs/dlm/lowcomms.c                | 7 ++++---
 net/atm/signaling.c              | 2 +-
 net/ipv4/af_inet.c               | 2 +-
 net/ipv6/af_inet6.c              | 2 +-
 net/ipv6/inet6_connection_sock.c | 2 +-
 net/sctp/input.c                 | 2 +-
 net/sctp/ipv6.c                  | 2 +-
 7 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index a9b14f81d655cda025d12174363a31a49093d2e3..bd786b3be5ecd6aec04f04aba180614c090bd0b9 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -601,7 +601,7 @@ static void lowcomms_error_report(struct sock *sk)
 				   "sk_err=%d/%d\n", dlm_our_nodeid(),
 				   con->nodeid, &inet->inet_daddr,
 				   ntohs(inet->inet_dport), sk->sk_err,
-				   sk->sk_err_soft);
+				   READ_ONCE(sk->sk_err_soft));
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
@@ -610,14 +610,15 @@ static void lowcomms_error_report(struct sock *sk)
 				   "dport %d, sk_err=%d/%d\n", dlm_our_nodeid(),
 				   con->nodeid, &sk->sk_v6_daddr,
 				   ntohs(inet->inet_dport), sk->sk_err,
-				   sk->sk_err_soft);
+				   READ_ONCE(sk->sk_err_soft));
 		break;
 #endif
 	default:
 		printk_ratelimited(KERN_ERR "dlm: node %d: socket error "
 				   "invalid socket family %d set, "
 				   "sk_err=%d/%d\n", dlm_our_nodeid(),
-				   sk->sk_family, sk->sk_err, sk->sk_err_soft);
+				   sk->sk_family, sk->sk_err,
+				   READ_ONCE(sk->sk_err_soft));
 		break;
 	}
 
diff --git a/net/atm/signaling.c b/net/atm/signaling.c
index 5de06ab8ed7523f93a0b3cd4775a49fef275d32a..e70ae2c113f95418297128e3405be8c699cb0253 100644
--- a/net/atm/signaling.c
+++ b/net/atm/signaling.c
@@ -125,7 +125,7 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		break;
 	case as_addparty:
 	case as_dropparty:
-		sk->sk_err_soft = -msg->reply;
+		WRITE_ONCE(sk->sk_err_soft, -msg->reply);
 					/* < 0 failure, otherwise ep_ref */
 		clear_bit(ATM_VF_WAITING, &vcc->flags);
 		break;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8db6747f892f8447e241b9a362f65c4cfe6fdbb0..940062e08f574fbfeed42f72fa8a4b5ce763110c 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1322,7 +1322,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		    sk->sk_state != TCP_SYN_SENT ||
 		    (sk->sk_userlocks & SOCK_BINDADDR_LOCK) ||
 		    (err = inet_sk_reselect_saddr(sk)) != 0)
-			sk->sk_err_soft = -err;
+			WRITE_ONCE(sk->sk_err_soft, -err);
 	}
 
 	return err;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce757e82bd0864e7605672ff2c34994..e1b679a590c997f757876d2cbc411a56b277b056 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -845,7 +845,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
 			sk->sk_route_caps = 0;
-			sk->sk_err_soft = -PTR_ERR(dst);
+			WRITE_ONCE(sk->sk_err_soft, -PTR_ERR(dst));
 			return PTR_ERR(dst);
 		}
 
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 5a9f4d722f35decddba7e06122569a2ea00cd653..0c50dcd35fe8c7179e8ea0d86c49f891a26fe59e 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -120,7 +120,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 
 	dst = inet6_csk_route_socket(sk, &fl6);
 	if (IS_ERR(dst)) {
-		sk->sk_err_soft = -PTR_ERR(dst);
+		WRITE_ONCE(sk->sk_err_soft, -PTR_ERR(dst));
 		sk->sk_route_caps = 0;
 		kfree_skb(skb);
 		return PTR_ERR(dst);
diff --git a/net/sctp/input.c b/net/sctp/input.c
index bf70371301ff46554fcf9379b648fac43350b2a9..127bf28a60330e7a6f975130924502d96b25fcf7 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -585,7 +585,7 @@ static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else {  /* Only an error on timeout */
-		sk->sk_err_soft = err;
+		WRITE_ONCE(sk->sk_err_soft, err);
 	}
 }
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 62b436a2c8fef1e39b96ea3c46b814ba54b87bda..43f2731bf590e5757b7ad2d3a92a12e4098e0d47 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -155,7 +155,7 @@ static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else {
-		sk->sk_err_soft = err;
+		WRITE_ONCE(sk->sk_err_soft, err);
 	}
 }
 
-- 
2.40.0.rc2.332.ga46443480c-goog

