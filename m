Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2305A6BC31E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCPBKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCPBK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4548227A1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54352648c1eso895227b3.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y107cRwBl43mrWmrSP5HTBsZO0lp5nVwGZdECHAP7/w=;
        b=tPaN1CuoSJCKmzY8X6+cU6l68tJ0Sd3EwLkSijUqGzadSHt6DoKZeWBhhPUn9bkVb2
         Zb3jQ8EUMtC+4kYCl6cAUfrXTID89c4xPYJJof2mdWrVYkKKOY//Sk/8k8NeXGnnLAyg
         M9ObLQ9qk6KkfE+THYBmRidXKm0Ce8/+nJSMD+DOvtnrfblq52jID7d/Rd0iWw2QMUos
         Y+RPUa76PSF8cHD+GflTVtpPnwjghnyhJRP/wsG1kWy5ZUzhaI8DEaXgoTItusa6ihZp
         h9qQQIurFv3AtpwmKnFlWlv7Tu201pydAcx7zvgaktzcPH1xRl/2ihYf0+R0PB2Z8Vwd
         3ojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y107cRwBl43mrWmrSP5HTBsZO0lp5nVwGZdECHAP7/w=;
        b=VdD38YHeM5jkJL4x02jloItxEcVXbd3QuROvSB4f11a4OHsYKaSLUnKWNToCNAlZ+g
         gWTYjzFHEZ+9yTSROOBpfb4JhUAxIUkfagDTU41LDbl9lOmVr+hrAstvn/jO2rtzszqd
         dvT/Iy+lXgBM1gyE8PT9fRHs/PX2jSvPRImRBqELUjV1nRC6ExnnF5hABqD/LSARcFB2
         e9ubQLRjBDcKxD7SGtRAwDljgn+mB6KD5xY20tZCiJS3BmxQPjvsfuX7DTAL9Qh/OpdZ
         Dw0foik1eQV1/QfT7kjpKNQAl4pjJ4KQ/x2Rfe6gKGAM49Lios8svKRLYr72VckbVoSI
         CXjA==
X-Gm-Message-State: AO0yUKUGLXuXWBjhzbeMewnHGH8bXaI5nAGYI27mv1pTqQw9UyBYIv9h
        imHL3iyC59scTM1Oy4FK7lm2yGmLYsHHjQ==
X-Google-Smtp-Source: AK7set/j0VepCUh8C0tytxDeQi1zG5Zx4i+rbSTF8yWHIE6skIHX0ekQ77c3Wm150ieqE5jtgUVSmUZiTgPQfg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:725:b0:b58:b42d:945c with SMTP
 id l5-20020a056902072500b00b58b42d945cmr396033ybt.0.1678929024130; Wed, 15
 Mar 2023 18:10:24 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:07 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-3-edumazet@google.com>
Subject: [PATCH net-next 2/9] net/packet: convert po->origdev to an atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

syzbot/KCAN reported that po->origdev can be read
while another thread is changing its value.

We can avoid this splat by converting this field
to an actual bit.

Following patches will convert remaining 1bit fields.

Fixes: 80feaacb8a64 ("[AF_PACKET]: Add option to return orig_dev to userspace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 10 ++++------
 net/packet/diag.c      |  2 +-
 net/packet/internal.h  | 22 +++++++++++++++++++++-
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d25dd9f63cc4f11ad8197ab66d60180b6358132f..af7c44169b869dc65be293c5594edba919a7fe4b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2184,7 +2184,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 	sll = &PACKET_SKB_CB(skb)->sa.ll;
 	sll->sll_hatype = dev->type;
 	sll->sll_pkttype = skb->pkt_type;
-	if (unlikely(po->origdev))
+	if (unlikely(packet_sock_flag(po, PACKET_SOCK_ORIGDEV)))
 		sll->sll_ifindex = orig_dev->ifindex;
 	else
 		sll->sll_ifindex = dev->ifindex;
@@ -2461,7 +2461,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	sll->sll_hatype = dev->type;
 	sll->sll_protocol = skb->protocol;
 	sll->sll_pkttype = skb->pkt_type;
-	if (unlikely(po->origdev))
+	if (unlikely(packet_sock_flag(po, PACKET_SOCK_ORIGDEV)))
 		sll->sll_ifindex = orig_dev->ifindex;
 	else
 		sll->sll_ifindex = dev->ifindex;
@@ -3914,9 +3914,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		lock_sock(sk);
-		po->origdev = !!val;
-		release_sock(sk);
+		packet_sock_flag_set(po, PACKET_SOCK_ORIGDEV, val);
 		return 0;
 	}
 	case PACKET_VNET_HDR:
@@ -4065,7 +4063,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = po->auxdata;
 		break;
 	case PACKET_ORIGDEV:
-		val = po->origdev;
+		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
 		break;
 	case PACKET_VNET_HDR:
 		val = po->has_vnet_hdr;
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 07812ae5ca073e0c7622034939c1b7eeb378d567..e1ac9bb375b313dbb4af9a4f9aa3cf5fe7e0f47e 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -25,7 +25,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_RUNNING;
 	if (po->auxdata)
 		pinfo.pdi_flags |= PDI_AUXDATA;
-	if (po->origdev)
+	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
 	if (po->has_vnet_hdr)
 		pinfo.pdi_flags |= PDI_VNETHDR;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b1aed2565267c0288e013e23ff51f2fcac..178cd1852238d39596acbc58afa0ce12159663d1 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -116,9 +116,9 @@ struct packet_sock {
 	int			copy_thresh;
 	spinlock_t		bind_lock;
 	struct mutex		pg_vec_lock;
+	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
 	unsigned int		auxdata:1,	/* writer must hold sock lock */
-				origdev:1,
 				has_vnet_hdr:1,
 				tp_loss:1,
 				tp_tx_has_off:1;
@@ -144,4 +144,24 @@ static inline struct packet_sock *pkt_sk(struct sock *sk)
 	return (struct packet_sock *)sk;
 }
 
+enum packet_sock_flags {
+	PACKET_SOCK_ORIGDEV,
+};
+
+static inline void packet_sock_flag_set(struct packet_sock *po,
+					enum packet_sock_flags flag,
+					bool val)
+{
+	if (val)
+		set_bit(flag, &po->flags);
+	else
+		clear_bit(flag, &po->flags);
+}
+
+static inline bool packet_sock_flag(const struct packet_sock *po,
+				    enum packet_sock_flags flag)
+{
+	return test_bit(flag, &po->flags);
+}
+
 #endif
-- 
2.40.0.rc2.332.ga46443480c-goog

