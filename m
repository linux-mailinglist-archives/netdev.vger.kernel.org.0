Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB76BBE43
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjCOU6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:59 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7F85FE1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:56 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54161af1984so146888177b3.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iS5NG+l1Ri5GQsSZCTYhkIV+HTvVblXcWqLmFFcH7WU=;
        b=NZSTl/qyDAxZUKrExuVCNr5zQmoo8tXeG1R0jGDMj4T61oJ+wJUCRF4J4oXSdg4soC
         WcBNO+kiWoQ2PaAUTT0LNsKdlzC/z19cJmWOtBfbMCNRXrxeQ+rUP0QeDH5gzJIefYWR
         fnzgKFc0sy42WJ4Rb+d6zpNt9GXvI/8A55Y6HJwYLIxdOP2CH9u0YkONRZMG3awmhi1S
         6VKD4LA6yYHubD6VQH69ICrvtf1C41fsadpOjgKb0mYZLTx+rdcgB66OxjGpVoWlE9xM
         CNOsyN7EIVqCOEzOM3WJqf4oqUA7RttOMTrmbt02Ac5i//I8ZlPUPUm3bduBdwzWtDZv
         EuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iS5NG+l1Ri5GQsSZCTYhkIV+HTvVblXcWqLmFFcH7WU=;
        b=zi/Dmuvfpqs85/l3Cdk0V9Jx7X7jk/PRQjV1AeKS+37jhG9m94/yUZ1QFqzLiLfpi1
         kQwTZTLmxNxhgnQP368fOQF3W0IvHu25caRhMGrVxDzML0uN1mYphnMaQIZMM3wSvhoB
         xUBIUWfTn0OgrYh/sumVz9gwJIxHJTaJkLszY1uWtF87bMYnWQwVPyRRgoNRKn1894oe
         ckg7ZeGCtw6WwRKdPxPckhKxykWSgkg/aenrDzk3JxnrhNXX217ZQCbTz+T/VucFsEFx
         6mMIPmJxgxMmdj47IqSpNX82H5k0pEymY37NHMNm7Hif0WaSf8Py/6MjE0roZWvFKC0f
         tsNQ==
X-Gm-Message-State: AO0yUKWW13kr8eKlHkEYFUbH3QWXKh+E3okdN1mrbOd4VJ5iiwMTH42o
        5RtB+oFVy0SlC/hxfDzOFohTBBbn2OQYuA==
X-Google-Smtp-Source: AK7set9fiZorJiHDeV5lWAqwKlYF8qeRzmD8U6ZzRJovWFBisV2VddoMtSnIy5MZoyjK2ORfi0aVO4m8XZtu9Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:f210:0:b0:b30:e597:fee6 with SMTP id
 i16-20020a25f210000000b00b30e597fee6mr10108703ybe.6.1678913875329; Wed, 15
 Mar 2023 13:57:55 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:45 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-6-edumazet@google.com>
Subject: [PATCH net-next 5/6] mptcp: annotate lockless accesses to sk->sk_err
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

mptcp_poll() reads sk->sk_err without socket lock held/owned.

Add READ_ONCE() and WRITE_ONCE() to avoid load/store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/protocol.c   | 8 ++++----
 net/mptcp/subflow.c    | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 56628b52d1001a967eb2e504bdbeac0c4cd17acc..cbaa1b49f7fe949b9de8f4be0cf74cea6cecc106 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2019,7 +2019,7 @@ static int mptcp_event_put_token_and_ssk(struct sk_buff *skb,
 	    nla_put_s32(skb, MPTCP_ATTR_IF_IDX, ssk->sk_bound_dev_if))
 		return -EMSGSIZE;
 
-	sk_err = ssk->sk_err;
+	sk_err = READ_ONCE(ssk->sk_err);
 	if (sk_err && sk->sk_state == TCP_ESTABLISHED &&
 	    nla_put_u8(skb, MPTCP_ATTR_ERROR, sk_err))
 		return -EMSGSIZE;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3ad9c46202fc63a5b3a870bf2ba994a8d9148264..3005a5adf715e8d147c119b0b4c13fcc58fe99f6 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2463,15 +2463,15 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	/* Mirror the tcp_reset() error propagation */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
-		sk->sk_err = ECONNREFUSED;
+		WRITE_ONCE(sk->sk_err, ECONNREFUSED);
 		break;
 	case TCP_CLOSE_WAIT:
-		sk->sk_err = EPIPE;
+		WRITE_ONCE(sk->sk_err, EPIPE);
 		break;
 	case TCP_CLOSE:
 		return;
 	default:
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
@@ -3791,7 +3791,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	/* This barrier is coupled with smp_wmb() in __mptcp_error_report() */
 	smp_rmb();
-	if (sk->sk_err)
+	if (READ_ONCE(sk->sk_err))
 		mask |= EPOLLERR;
 
 	return mask;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4ae1a7304cf0da1840a1d236969549d18cf8ff97..01874059a16865ecb4ec464443f68a30c814f565 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1335,7 +1335,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			subflow->reset_reason = MPTCP_RST_EMPTCP;
 
 reset:
-			ssk->sk_err = EBADMSG;
+			WRITE_ONCE(ssk->sk_err, EBADMSG);
 			tcp_set_state(ssk, TCP_CLOSE);
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
 				sk_eat_skb(ssk, skb);
@@ -1419,7 +1419,7 @@ void __mptcp_error_report(struct sock *sk)
 		ssk_state = inet_sk_state_load(ssk);
 		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
 			inet_sk_state_store(sk, ssk_state);
-		sk->sk_err = -err;
+		WRITE_ONCE(sk->sk_err, -err);
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
 		smp_wmb();
-- 
2.40.0.rc2.332.ga46443480c-goog

