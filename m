Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F736BEDEA
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjCQQUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCQQUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:20:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE832E0C4
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:20:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so5708699ybg.15
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679070005;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bhsjgd4QyurXDwprxxOe77fncg+avg4pK+7XNOqydjY=;
        b=Rfe338kMdDYmmAv5rIjDM6MuYKgH/YGiCEz2YitLwex6J8EXa+uPXcyV5+r160F6yv
         a13KGOcv81GILTdn0BnC61BlJSetbiQwOkbsH/k3vj4zfxklxUCC5gBTKTg641yIpSj8
         f6Wl4A1+mnPR7a9V3s9HbD97kE+Pjz8rp9rInJAcgbgRyd0l8LcJblhHQvLfp5oRAavI
         CkCsSoMOUyuyFUlTDDh3un32gL7RPa/9AzyS1NPzG5cHinlcnwZM7PeUbonOw+NLMNC6
         zHyXTsDVkKcZnEz8OWO5hT779FPzwQ7iGLTBDVNDlMqPgXglNRpqj/UatzcegEX+rHoK
         WcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070005;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bhsjgd4QyurXDwprxxOe77fncg+avg4pK+7XNOqydjY=;
        b=Eu2K62i/VG29+ESOphAdHO3sEd0fNiSQNHmaHW5nY8tCuwO0ExsTf9hC88ZTpyH+hX
         JcRZ3yRzbF9/cqKQkpRCQ+cYsu69HvWemI64Klij1BAAr9Hncf3e+BpmeFwYN9Pg7pr7
         k7xNjYRZsjlIoP3dk4/OgGN+fw1dX7maEBBUwrSA66l/h9KUDl7fXmLPyGE8GAGmJCOG
         zQPIocTiQpBiTsgcoB/TsdXz9NUSQx/yIcnhcIDaKdMoOznptU94O3V+2WtTMvYgWQpP
         c/7KsuzVWTiFnklrJgHSnWFWyZvs+8fowO1f7xqlkZqaOsBV+hoVXSggsZWjihz+PSa3
         LYnQ==
X-Gm-Message-State: AO0yUKWl4Q7KXLDIeocFxYTdMsoz0SV7UayEiH1EfeZEcklrWbFUKG/6
        8c9h8Nw7zolx+i6ptMoMqhpT8rRwHRCBQA==
X-Google-Smtp-Source: AK7set9lvfvu5osrlYYG1ZrEfn6Yxq1ZceiTlE4M+eLjXl6XMo7SOXIXdWMsYzrNbPD9OuDb6CalpIdnLBlZHA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1888:b0:b4a:3896:bc17 with SMTP
 id cj8-20020a056902188800b00b4a3896bc17mr136134ybb.0.1679070004830; Fri, 17
 Mar 2023 09:20:04 -0700 (PDT)
Date:   Fri, 17 Mar 2023 16:20:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317162002.2690357-1-edumazet@google.com>
Subject: [PATCH net-next] net/packet: remove po->xmit
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
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

Use PACKET_SOCK_QDISC_BYPASS atomic bit instead of a pointer.

This removes one indirect call in fast path,
and READ_ONCE()/WRITE_ONCE() annotations as well.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Willem de Bruijn <willemb@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 net/packet/af_packet.c | 24 +++++++++---------------
 net/packet/internal.h  |  2 +-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7b9367b233d34d1a8338233f2c1bd96e9a28e14c..497193f73030c385a2d33b71dfbc299fbf9b763d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -270,8 +270,11 @@ static noinline struct sk_buff *nf_hook_direct_egress(struct sk_buff *skb)
 }
 #endif
 
-static int packet_direct_xmit(struct sk_buff *skb)
+static int packet_xmit(const struct packet_sock *po, struct sk_buff *skb)
 {
+	if (!packet_sock_flag(po, PACKET_SOCK_QDISC_BYPASS))
+		return dev_queue_xmit(skb);
+
 #ifdef CONFIG_NETFILTER_EGRESS
 	if (nf_hook_egress_active()) {
 		skb = nf_hook_direct_egress(skb);
@@ -305,12 +308,6 @@ static void packet_cached_dev_reset(struct packet_sock *po)
 	RCU_INIT_POINTER(po->cached_dev, NULL);
 }
 
-static bool packet_use_direct_xmit(const struct packet_sock *po)
-{
-	/* Paired with WRITE_ONCE() in packet_setsockopt() */
-	return READ_ONCE(po->xmit) == packet_direct_xmit;
-}
-
 static u16 packet_pick_tx_queue(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
@@ -2872,8 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		packet_inc_pending(&po->tx_ring);
 
 		status = TP_STATUS_SEND_REQUEST;
-		/* Paired with WRITE_ONCE() in packet_setsockopt() */
-		err = READ_ONCE(po->xmit)(skb);
+		err = packet_xmit(po, skb);
 		if (unlikely(err != 0)) {
 			if (err > 0)
 				err = net_xmit_errno(err);
@@ -3076,8 +3072,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	/* Paired with WRITE_ONCE() in packet_setsockopt() */
-	err = READ_ONCE(po->xmit)(skb);
+	err = packet_xmit(po, skb);
+
 	if (unlikely(err != 0)) {
 		if (err > 0)
 			err = net_xmit_errno(err);
@@ -3359,7 +3355,6 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	init_completion(&po->skb_completion);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
-	po->xmit = dev_queue_xmit;
 
 	err = packet_alloc_pending(po);
 	if (err)
@@ -4010,8 +4005,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		/* Paired with all lockless reads of po->xmit */
-		WRITE_ONCE(po->xmit, val ? packet_direct_xmit : dev_queue_xmit);
+		packet_sock_flag_set(po, PACKET_SOCK_QDISC_BYPASS, val);
 		return 0;
 	}
 	default:
@@ -4126,7 +4120,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = packet_sock_flag(po, PACKET_SOCK_TX_HAS_OFF);
 		break;
 	case PACKET_QDISC_BYPASS:
-		val = packet_use_direct_xmit(po);
+		val = packet_sock_flag(po, PACKET_SOCK_QDISC_BYPASS);
 		break;
 	default:
 		return -ENOPROTOOPT;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 680703dbce5e04fc26d0fdeab1c1c911b71a8729..62e9c3eefba26638557facfd291456da3dfb6119 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -128,7 +128,6 @@ struct packet_sock {
 	unsigned int		tp_tstamp;
 	struct completion	skb_completion;
 	struct net_device __rcu	*cached_dev;
-	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
 	atomic_t		tp_drops ____cacheline_aligned_in_smp;
 };
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_HAS_VNET_HDR,
 	PACKET_SOCK_RUNNING,
 	PACKET_SOCK_PRESSURE,
+	PACKET_SOCK_QDISC_BYPASS,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

