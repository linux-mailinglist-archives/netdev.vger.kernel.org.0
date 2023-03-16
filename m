Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163136BC31F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCPBKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPBK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D265BCB0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w200-20020a25c7d1000000b00b3215dc7b87so211605ybe.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qV0O1pdVqzov4eW6Jjg5vX8bJq0BnRH8Yb4/f8yXv2M=;
        b=K3PygB/iuu2P55I5sjJMZpb2CPB4TRPc5uvtKLHuwENYLb81GLC0hxH+FM95ZQLqfp
         OuUs3AWU5sZJ0+VzFak/gMiuw+mvVeT9wn2wC2owL33dd8MMGJp/oV7AP6hkw27M/yrF
         8Iv+lOADkABp8WYam3xYoWg2DK7zrDI6meapqKVJ68IqyTTN5/uC8aDmKOI1EGGChj6k
         /GRs6mrbrAnqsrUYk34E9kJZrFlgx0fJRYjnvYBK41vg8FagUIfvCsgg4yjk4wGUni2N
         U8cKo1l77s2Vn3ptouNvKUNWAG3fZba2Zyjqqx8ZFAIne1Gpf91i/8lmZwkkB222QFOJ
         lb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qV0O1pdVqzov4eW6Jjg5vX8bJq0BnRH8Yb4/f8yXv2M=;
        b=nouuXP0KpxSPIbByTvaaIFf5CrLQQggcUVbOdgK3jXCPKuHrq5dwHxIx9jD15ky5MK
         7BVVeyz6Zpxuwmj6rwKoQNYJT+E0lyhri3sOu15bpyPtzft+xVYOAlwGwXv89Vj2JiKc
         c3PkyThGLXs/XM9hvWggc00T8YyD89AO4EfsTJDF5WWUVaQYtE7AFts7j+K1KEvMkfui
         y6k4wtH3D+uIOjlYveNiZad6zbFRG2LgEsSeXuDJCEzrlcThCtdZsmLWaBbPduV8lb1i
         qvGLBVDvvl75jqUqaPy9iV8OKx9hviXwW1jWRV3KjKRMx7DsgNqRZYhqc+CdsXxElaPl
         oKsQ==
X-Gm-Message-State: AO0yUKVdkBz2wRicbswg/ADLptRPE58Q2Iv8JmLLc3ImcBB9BjZ9LTwt
        FRbRFbXSDa9Y8SogPbZSS5wdKrhvN7g1vA==
X-Google-Smtp-Source: AK7set9IRR0DsdTtrKa2b3TscnuEbXS1wlH4xQa4kyTSA9bgJVAmn8SucHqC3EVKV8NLpfDiWW39sp5l4HAFhQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1028:b0:b4c:9333:293 with SMTP
 id x8-20020a056902102800b00b4c93330293mr3060269ybt.11.1678929025520; Wed, 15
 Mar 2023 18:10:25 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:08 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-4-edumazet@google.com>
Subject: [PATCH net-next 3/9] net/packet: convert po->auxdata to an atomic flag
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

po->auxdata can be read while another thread
is changing its value, potentially raising KCSAN splat.

Convert it to PACKET_SOCK_AUXDATA flag.

Fixes: 8dc419447415 ("[PACKET]: Add optional checksum computation for recvmsg")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 8 +++-----
 net/packet/diag.c      | 2 +-
 net/packet/internal.h  | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index af7c44169b869dc65be293c5594edba919a7fe4b..ecd9fc27e360cc85be35de568e6ebcb2dbbd9d39 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3514,7 +3514,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-	if (pkt_sk(sk)->auxdata) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_AUXDATA)) {
 		struct tpacket_auxdata aux;
 
 		aux.tp_status = TP_STATUS_USER;
@@ -3900,9 +3900,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		lock_sock(sk);
-		po->auxdata = !!val;
-		release_sock(sk);
+		packet_sock_flag_set(po, PACKET_SOCK_AUXDATA, val);
 		return 0;
 	}
 	case PACKET_ORIGDEV:
@@ -4060,7 +4058,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 		break;
 	case PACKET_AUXDATA:
-		val = po->auxdata;
+		val = packet_sock_flag(po, PACKET_SOCK_AUXDATA);
 		break;
 	case PACKET_ORIGDEV:
 		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
diff --git a/net/packet/diag.c b/net/packet/diag.c
index e1ac9bb375b313dbb4af9a4f9aa3cf5fe7e0f47e..d704c7bf51b2073f792ff35c1f46fba251dd4761 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -23,7 +23,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_flags = 0;
 	if (po->running)
 		pinfo.pdi_flags |= PDI_RUNNING;
-	if (po->auxdata)
+	if (packet_sock_flag(po, PACKET_SOCK_AUXDATA))
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 178cd1852238d39596acbc58afa0ce12159663d1..3bae8ea7a36f523d554177acfb6b6e960ba6965c 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -118,8 +118,7 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		auxdata:1,	/* writer must hold sock lock */
-				has_vnet_hdr:1,
+	unsigned int		has_vnet_hdr:1, /* writer must hold sock lock */
 				tp_loss:1,
 				tp_tx_has_off:1;
 	int			pressure;
@@ -146,6 +145,7 @@ static inline struct packet_sock *pkt_sk(struct sock *sk)
 
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
+	PACKET_SOCK_AUXDATA,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

