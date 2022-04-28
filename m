Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83793512CFD
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245433AbiD1HiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245406AbiD1Hh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:37:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98879BAE0;
        Thu, 28 Apr 2022 00:34:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q12so3298273pgj.13;
        Thu, 28 Apr 2022 00:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1mspzsUF1iI0MD7JQe8ZOLEKxGS7fA1Ommjjb4lZ61M=;
        b=DGN7wqnj24KAFfyvI6ckEngyhvdrSu79jbZPokWSy3YjKFRFuyYi2mrLqKaUCC4kAu
         9cKBEXCuUnEdZ0N1NM1Y6jqDpbRmAHMtDkz1Ee7FebXGrOWsTO0QwifcUhYoqns/BxbM
         64TXYHjYdfZMBOiRaLF4Azgbe2sgp9F5Co3XJknQ4VwybWX9CeztkReWp4pOZvOvbVDU
         KVuTApjRebN2yXBRa2aFExsaIpVusqA57rMrftyrS3I9eLsrgS1q4u6NhYQi+NAgYbCh
         7yDyz4AFs2NgX20iDnmzrLRHigcQlopSmQ/KvqYWYuQgOnZ6MT5Uk1LoX1DS9px1CJ0v
         j+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1mspzsUF1iI0MD7JQe8ZOLEKxGS7fA1Ommjjb4lZ61M=;
        b=7eQkIjnpB8DOg/QltNntur6iAK9M8G3YY9wrrMQCEkxr+1GIsb9X2KippWk1Stv9tb
         Fns6I+j0W7MSwCx+CTHUHHLHUDfJvyO/fSDMzT13RGWFf9LExzz7lNeVMetIFz56Vtp9
         d3a/RqszxmlQWAX2FG3Jj+au7DC5obi9UjXwd4S05ZCDZ3Jp86cgSBJljz3Kyguzi2Bd
         azofJCteg29pCfBpINBl8kPsmzx2JhsEZATdfWrGJUQjGEpNCMvJbkXWZEzrGWAQV4fz
         zls+TSwqHfnVzqmcRpCA+5szVgwH5d2F4iSkZITE+xOyE3uYImnZ0JhnBiVjlH4DttpA
         RTgA==
X-Gm-Message-State: AOAM530oBckF3g2kwaYmvwP/PeVKJq48Ce8E/r745S2gS47vKeO7WoTf
        pJGBsDlHV0tCymLhK6Xja5I=
X-Google-Smtp-Source: ABdhPJwS5fxCKB8HMSAQo/w32L0x+OhtfV/zySpL/k6FCH1BDgq1DSADcLC3Rd0hTsJfVSO+A6frNQ==
X-Received: by 2002:a63:5a20:0:b0:3aa:2fd0:9e94 with SMTP id o32-20020a635a20000000b003aa2fd09e94mr27674517pgb.602.1651131283285;
        Thu, 28 Apr 2022 00:34:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm21369511pfo.175.2022.04.28.00.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 00:34:42 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: tcp: add skb drop reasons to tcp connect request
Date:   Thu, 28 Apr 2022 15:33:39 +0800
Message-Id: <20220428073340.224391-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428073340.224391-1-imagedong@tencent.com>
References: <20220428073340.224391-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

For now, the return value of tcp_v4_conn_request() has the following
means:

  >=0: the skb is acceptable, free it with consume_skb()
  <0 : the skb is unacceptable, free it with kfree_skb() and send a
       RESET

In order to get the drop reasons from tcp_v4_conn_request(), we make
some changes to its return value:

  ==0: the skb is acceptable, free it with consume_skb()
  >0:  the return value is exactly the skb drop reasons, free it with
       kfree_skb_reason() without sendind RESET
  <0:  the same as what we do before

( As a negative value can be returned by
struct inet_connection_sock_af_ops.conn_request(), so we can't make
the return value of tcp_v4_conn_request() as num skb_drop_reason
directly. )

Therefore, previous logic is not changed, as tcp_v4_conn_request()
never return a positive before.

With drop reasons returned, the caller of tcp_v4_conn_request(), which
is tcp_rcv_state_process(), will call kfree_skb_reason() instead of
consume_skb().

Following new drop reasons are added:

  SKB_DROP_REASON_LISTENOVERFLOWS
  SKB_DROP_REASON_TCP_REQQFULLDROP

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- don't free skb in conn_request, as Eric suggested, and use it's
  return value to pass drop reasons.
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  2 ++
 net/ipv4/tcp_input.c       | 20 ++++++++++++++------
 net/ipv4/tcp_ipv4.c        |  2 +-
 net/ipv6/tcp_ipv6.c        |  4 ++--
 5 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453..f33b3636bbce 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -469,6 +469,10 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_BIG,	/* packet size is too big (maybe exceed
 					 * the MTU)
 					 */
+	SKB_DROP_REASON_LISTENOVERFLOWS, /* accept queue of the listen socket is full */
+	SKB_DROP_REASON_TCP_REQQFULLDROP, /* request queue of the listen
+					   * socket is full
+					   */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a477bf907498..de6c93670437 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -80,6 +80,8 @@
 	EM(SKB_DROP_REASON_IP_INADDRERRORS, IP_INADDRERRORS)	\
 	EM(SKB_DROP_REASON_IP_INNOROUTES, IP_INNOROUTES)	\
 	EM(SKB_DROP_REASON_PKT_TOO_BIG, PKT_TOO_BIG)		\
+	EM(SKB_DROP_REASON_LISTENOVERFLOWS, LISTENOVERFLOWS)	\
+	EM(SKB_DROP_REASON_TCP_REQQFULLDROP, TCP_REQQFULLDROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index daff631b9486..412367b7dfd6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6411,7 +6411,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct request_sock *req;
-	int queued = 0;
+	int err, queued = 0;
 	bool acceptable;
 	SKB_DR(reason);
 
@@ -6438,13 +6438,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			err = icsk->icsk_af_ops->conn_request(sk, skb);
 			local_bh_enable();
 			rcu_read_unlock();
 
-			if (!acceptable)
+			if (err < 0)
 				return 1;
-			consume_skb(skb);
+			if (err)
+				kfree_skb_reason(skb, err);
+			else
+				consume_skb(skb);
 			return 0;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
@@ -6878,6 +6881,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	SKB_DR(reason);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
@@ -6886,12 +6890,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
 	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
-		if (!want_cookie)
+		if (!want_cookie) {
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop;
+		}
 	}
 
 	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		SKB_DR_SET(reason, LISTENOVERFLOWS);
 		goto drop;
 	}
 
@@ -6947,6 +6954,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7007,6 +7015,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	__reqsk_free(req);
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_conn_request);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 157265aecbed..6a49470d30db 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1470,7 +1470,7 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	return SKB_DROP_REASON_IP_INADDRERRORS;
 }
 EXPORT_SYMBOL(tcp_v4_conn_request);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 782df529ff69..92f4a58fdc2c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1158,7 +1158,7 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 
 	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
 		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
-		return 0;
+		return SKB_DROP_REASON_IP_INADDRERRORS;
 	}
 
 	return tcp_conn_request(&tcp6_request_sock_ops,
@@ -1166,7 +1166,7 @@ static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 
 drop:
 	tcp_listendrop(sk);
-	return 0; /* don't send reset */
+	return SKB_DROP_REASON_IP_INADDRERRORS; /* don't send reset */
 }
 
 static void tcp_v6_restore_cb(struct sk_buff *skb)
-- 
2.36.0

