Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5506BC323
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCPBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPBKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886CD4E5F4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m6-20020a056902118600b00aeb1e3dbd1bso200714ybu.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppTWSXKFU7okTzqMt+UN0ijfWGNv2g2Yi+XNRICjYL0=;
        b=a5T+oJIqcuwjxtUYxoT/S0lFhEszuhQ6bphzQcIA5yg3HIlwHRhBbOWdFO4pjYPdvu
         39DnKZ37YreW1+maqrCcxQ4IUaH+jXaDmb7Pbf5WpmW0hv5vMKDX+ABfwEaU4RN5TJCo
         6C5J+0LATraLc4UnurPzVWvNuWqJ1pei9CgrlUcqfJ1ieq6TiCm1Zua8evj4ay/4aZ0H
         EXKmf/aCWCvRYyuhbfX3NAidziTuVDJZXHnV0pqmqu9kSgRrx1Cp69SqF4kuBmf4XFMf
         VVKbzPXRiDH1BeYh0eqQVTkiu5Inw7Ly0gEG9VQvFtV8cSI0k8bVsN2ZrzW3W/8nfyq+
         SpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppTWSXKFU7okTzqMt+UN0ijfWGNv2g2Yi+XNRICjYL0=;
        b=CDseJ98cdOPx1hEvesFRQotfI0XZ2XGfyPMbBsjxmvf4Ti0vv0Wa3ztHFZSjCxGa7/
         D01Z9hKJpZhM9qQ210LQ7C0VuA4wuFQx1ZLm10o7EBJ+v2RUf6jP2Q7Yr6YaNJ7kGV0N
         xmw2NNBPxZdri4iwKCCwLVgnBp3THk6sZyg/nnM/C0BfEWwfFMi+Rjjz1QJJH9UGLEea
         esEJsy3IOVL0hXzovz9MuDuiu0y0O8R5AnlTSfPIBvs2QGNbofKLwFddhi57y10OtXK2
         IcuZ1bS/WDP3nKpjFule8iifS3jY3tULUki9+eWNm750dIducJvqj1gmW2tT+UJShD2m
         bC3g==
X-Gm-Message-State: AO0yUKWtyK8bKG1GOvr+yRkWiQNeyFD+aU95iap9AgCD+qnJUXxIupAO
        r+XdB7UAXIUihRLgEUkAB1w5fsuo97jUXA==
X-Google-Smtp-Source: AK7set89IiCDs8o1sAmaUhXw86L2AMjvAaiRH/rnIN2eC0XBWm8Stikc9OxAAPPne6JJ6rDiGk38Xkv66QdxGw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:ac5f:0:b0:541:6961:8457 with SMTP id
 z31-20020a81ac5f000000b0054169618457mr1164766ywj.2.1678929031906; Wed, 15 Mar
 2023 18:10:31 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:12 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-8-edumazet@google.com>
Subject: [PATCH net-next 7/9] net/packet: convert po->has_vnet_hdr to an
 atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

po->has_vnet_hdr can be read locklessly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 19 ++++++++++---------
 net/packet/diag.c      |  2 +-
 net/packet/internal.h  |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 119063c8a1c590b715fa570354f561bfa7df5301..5a6b05e17ca214e1faeac201e647e0d34686c89a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2309,7 +2309,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		netoff = TPACKET_ALIGN(po->tp_hdrlen +
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			netoff += sizeof(struct virtio_net_hdr);
 			do_vnet = true;
 		}
@@ -2780,7 +2780,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
-	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
+	if ((size_max > dev->mtu + reserve + VLAN_HLEN) &&
+	    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	reinit_completion(&po->skb_completion);
@@ -2809,7 +2810,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		status = TP_STATUS_SEND_REQUEST;
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			vnet_hdr = data;
 			data += sizeof(*vnet_hdr);
 			tp_len -= sizeof(*vnet_hdr);
@@ -2837,7 +2838,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 					  addr, hlen, copylen, &sockc);
 		if (likely(tp_len >= 0) &&
 		    tp_len > dev->mtu + reserve &&
-		    !po->has_vnet_hdr &&
+		    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR) &&
 		    !packet_extra_vlan_len_allowed(dev, skb))
 			tp_len = -EMSGSIZE;
 
@@ -2856,7 +2857,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			}
 		}
 
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
@@ -2991,7 +2992,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
-	if (po->has_vnet_hdr) {
+	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
 		if (err)
 			goto out_unlock;
@@ -3451,7 +3452,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
-	if (pkt_sk(sk)->has_vnet_hdr) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_HAS_VNET_HDR)) {
 		err = packet_rcv_vnet(msg, skb, &len);
 		if (err)
 			goto out_free;
@@ -3931,7 +3932,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
 			ret = -EBUSY;
 		} else {
-			po->has_vnet_hdr = !!val;
+			packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4065,7 +4066,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
 		break;
 	case PACKET_VNET_HDR:
-		val = po->has_vnet_hdr;
+		val = packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR);
 		break;
 	case PACKET_VERSION:
 		val = po->tp_version;
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 8bb4ce6a8e6171fef43988fe83b0adc8100fe866..56240aaf032b25fdbbaf2ed6421cdbcc3669d1ec 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
-	if (po->has_vnet_hdr)
+	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
 		pinfo.pdi_flags |= PDI_VNETHDR;
 	if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
 		pinfo.pdi_flags |= PDI_LOSS;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 9d406a92ede8e917089943b39a0fe97b064599f3..2521176807f4f8ba430c5a94c7c50a0372b1a92a 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -118,7 +118,6 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		has_vnet_hdr:1; /* writer must hold sock lock */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_AUXDATA,
 	PACKET_SOCK_TX_HAS_OFF,
 	PACKET_SOCK_TP_LOSS,
+	PACKET_SOCK_HAS_VNET_HDR,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

