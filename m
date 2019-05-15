Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6568E1F83E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfEOQKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:10:20 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:48164 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbfEOQKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:10:20 -0400
Received: by mail-vs1-f74.google.com with SMTP id f5so41147vsq.15
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UxtWdN2+ixHDQh52r8qVnkGB26RijPMk+1Y4tkfPdCs=;
        b=bcpASvwlE1vmADRLohz5rbtJk1LbAnA5NyAeLQdAygGM6b28rk+58rge+c+y4MIQe1
         YQo9KuSJGKvszRLFotv9vSQOz6lO2zI6t8Lea6jA7JhHDWuN9wHODC4TA9E3GoeEVhT8
         m9nrqjAyMYNNwFH2F5bOqMVQLmzOPORwc5JqJ4u3177Nl9vCuYD4UKmwUUGvytkJDb0R
         APCDEl895FPsxQ08j6uTVuH+niVf4EmaRuEj9ofUKbQ8+LpQaoZohrsypkotWkFivVTV
         Y9gs6NswAlkKYYUcm7YpsCrE+jleLkBTMXs+zycjj0b0Plvm1JJndNRSGQ4nMj8rA6Ti
         UrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UxtWdN2+ixHDQh52r8qVnkGB26RijPMk+1Y4tkfPdCs=;
        b=pkP+NFCGHxMXAPdxeCaqDCjlRJNOttUYfi6wCn7xn5rzITmiLGFIyiw7Tu9cvNym0K
         otR0IJC4R8Y1uagPPSYBtq7GpnAMELWy4dkq32Get/1jygrjvxDuyusmBHGl32hiP1jz
         SHS+eXjZfLoVBRETTbTwhGCZxxgV3v3RDPuXGJTwOqSf6o94lGDMLDYQZ1y81wvxBYmP
         OO+4GdNRSHJ5+IGhfenhc/R/+9pMa9iBsDNvXq0dLywAhJPhF29X36yeRUn/NUtKDB8H
         xZQ2W0wH3qxE5tkRjuSLanFlTuoZhkdJrFmN5+4g7mv5asG5p3lrPBKQjdXT4EyXqLgD
         4SQQ==
X-Gm-Message-State: APjAAAV2tU8IQiFptl/gip8IRdwwos9rcBNnu8lnnlnOsO7ahIAlyB3C
        KudNE4F/BjkHNtyE5DZI9brnZYns54L9Jw==
X-Google-Smtp-Source: APXvYqxf0Xe9eCFbIkbKvWY7SUP//Cpx4sSXQdMUxL8putlXFAUNWXmEs5EEdD1/EbiJBZBxdHuVjlnLhKOmRw==
X-Received: by 2002:ab0:2b19:: with SMTP id e25mr6172532uar.68.1557936618994;
 Wed, 15 May 2019 09:10:18 -0700 (PDT)
Date:   Wed, 15 May 2019 09:10:15 -0700
Message-Id: <20190515161015.16115-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] tcp: do not recycle cloned skbs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is illegal to change arbitrary fields in skb_shared_info if the
skb is cloned.

Before calling skb_zcopy_clear() we need to ensure this rule,
therefore we need to move the test from sk_stream_alloc_skb()
to sk_wmem_free_skb()

Fixes: 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Willem de Bruijn <willemb@google.com>
---
 include/net/sock.h | 2 +-
 net/ipv4/tcp.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4d208c0f9c14b7c8f5975dcc69e13d89d1880df5..0680fa98849761d187c0149a57fa2d5d683a9a76 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1473,7 +1473,7 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	sk->sk_wmem_queued -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
-	if (!sk->sk_tx_skb_cache) {
+	if (!sk->sk_tx_skb_cache && !skb_cloned(skb)) {
 		skb_zcopy_clear(skb, true);
 		sk->sk_tx_skb_cache = skb;
 		return;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1fa15beb83806696a6b4f5eddb7e45c13a2dea45..53d61ca3ac4b4ee8992742247629bce7f71ee659 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -855,7 +855,7 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 
 	if (likely(!size)) {
 		skb = sk->sk_tx_skb_cache;
-		if (skb && !skb_cloned(skb)) {
+		if (skb) {
 			skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 			sk->sk_tx_skb_cache = NULL;
 			pskb_trim(skb, 0);
-- 
2.21.0.1020.gf2820cf01a-goog

