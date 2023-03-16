Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415636BC31D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPBK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPBKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FCF227A1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m6-20020a056902118600b00aeb1e3dbd1bso200368ybu.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fD3vOEmDHSOCX90shYM3Z/5MIpN18u9GGL4H/VGeM1M=;
        b=gOLrBwvBhR3YR4lzfze3t3dqg3783BrspkQJf+5o33FoQ+X31RvGIr7jpJvshkFJrB
         9JBqIVvprL3+U+A0GZp+gGtE6o+sBVyRk/vDKtYcQVjrEJ5nIOICxu88sHTae1iNi5K3
         mkhMUpQ6bsTtfribwiU0El6E/Boyjz/cJAdfLM6CsC9+b5hE6bzSuttTX2+gtMLeOgYA
         r5oT2rg6Dbj8kiccXoG+5d5D272Zv977NATfdLLcUhW1LmO72ERIxV6VEwSyS7GX1Zfi
         O90WegdwsHvsbYFUytlZmeY6hyP1Poy1ySZmdBaAI3M5NtUPLNS1UC/DqutNgj57Y801
         26oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fD3vOEmDHSOCX90shYM3Z/5MIpN18u9GGL4H/VGeM1M=;
        b=keNuuGC6cmjt8b6BIsBtrmuwsP6LBkZaZ/1wxkjMmfFVIGMzpJXaLgRfCBKf7Wk4QI
         KoG+vm1JZtLKD0/SFcn4+rfIArXPZCBFfx/pi2lD5jKwj3ZOd+3lD9hcmeR/nNcO346S
         Sm8/5BdKxSuZajz9i/BBz2iZwHe1hQS+mvB0N/Y4C1kUVb2Yd7ng9IvkrGDr8zjAZt6w
         Z5cgsapRzKG2BtbNh9TJ37/USZ+DP+y+tofcKdraiIupJakJI8h946BMSOaJZnLSNRe/
         W9AC+B3YVIQ19VJzRgHzvhknur8hUkmi1qTn7l31DUDcaxxdZpmGgzr3wNzdpfzEP1Cy
         YVMA==
X-Gm-Message-State: AO0yUKVVpVouztjI+XHj2ln/o288uhczaKPIa7zKlFLiMJzfWZaftedp
        t6JvO7TzRdMBYXpMiyN3As6jgxPJIdwonw==
X-Google-Smtp-Source: AK7set8elTFzKjjWdEMz/cgxjFaMRRFYro0mfuHxGpirkENRGReZ90Txx3oD9HTwwsoHe1e08W2jd4KuJgbg9Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1024:b0:b4a:3896:bc17 with SMTP
 id x4-20020a056902102400b00b4a3896bc17mr3182493ybt.0.1678929022632; Wed, 15
 Mar 2023 18:10:22 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:06 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-2-edumazet@google.com>
Subject: [PATCH net-next 1/9] net/packet: annotate accesses to po->xmit
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

po->xmit can be set from setsockopt(PACKET_QDISC_BYPASS),
while read locklessly.

Use READ_ONCE()/WRITE_ONCE() to avoid potential load/store
tearing issues.

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4e76e2ae153ea3b3c7d73ef6ac2f8c2742f790d..d25dd9f63cc4f11ad8197ab66d60180b6358132f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -307,7 +307,8 @@ static void packet_cached_dev_reset(struct packet_sock *po)
 
 static bool packet_use_direct_xmit(const struct packet_sock *po)
 {
-	return po->xmit == packet_direct_xmit;
+	/* Paired with WRITE_ONCE() in packet_setsockopt() */
+	return READ_ONCE(po->xmit) == packet_direct_xmit;
 }
 
 static u16 packet_pick_tx_queue(struct sk_buff *skb)
@@ -2867,7 +2868,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		packet_inc_pending(&po->tx_ring);
 
 		status = TP_STATUS_SEND_REQUEST;
-		err = po->xmit(skb);
+		/* Paired with WRITE_ONCE() in packet_setsockopt() */
+		err = READ_ONCE(po->xmit)(skb);
 		if (unlikely(err != 0)) {
 			if (err > 0)
 				err = net_xmit_errno(err);
@@ -3070,7 +3072,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	err = po->xmit(skb);
+	/* Paired with WRITE_ONCE() in packet_setsockopt() */
+	err = READ_ONCE(po->xmit)(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)
 			err = net_xmit_errno(err);
@@ -4007,7 +4010,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		po->xmit = val ? packet_direct_xmit : dev_queue_xmit;
+		/* Paired with all lockless reads of po->xmit */
+		WRITE_ONCE(po->xmit, val ? packet_direct_xmit : dev_queue_xmit);
 		return 0;
 	}
 	default:
-- 
2.40.0.rc2.332.ga46443480c-goog

