Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F981AF89E
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDSIKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSIKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:10:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E911DC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:10:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so3479089pgg.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2h3glzMUPjI+xgROtgHTbMCl89Ljq9VgKPFkuLxxr+Y=;
        b=EIYfIEgENSrkdDG/NBnlnnr+mnID4cwqImvIHE26Ki5MfmVM7qklBa7W8hTH8NEU5P
         41GF15aKjH+2JHZgWU8N24QCClrI4HSw35M5GgtpjEj5DQ/xwPLQYtZtOIP/QkvddOp+
         7x9QbBvkfQ/pOmvnoWbpjQVbWlV7mPHNFTpq4ANJeExAmsKwPC+TDoZHQKpZlkzxHdC7
         H4HWaa/cHw64VJ6k9VsClavvS6VeX5cHA0KiqNzo19N7pDrZvFkeoPAaos5K8x29ZDfl
         VS2FutrLuHe/uHxom1N79riVqmzSR08OsXAUrYScY1XF3QbMuk3k57fnpIZRsNOyBhrv
         YWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2h3glzMUPjI+xgROtgHTbMCl89Ljq9VgKPFkuLxxr+Y=;
        b=oSIxeplm79aQA4f+1FJFPxubzySdJ2m52mwbPBV7RdhkKLZbXglnUc2nqXHth3wsjq
         gnnXxIxMfL9uiqRjjgb3xGxbv2SSnZtxfFI0bYvWWjGqjxSvDDHYUlAstT7wAOdPaYip
         VowD0JsMkPNN42dZ//UYfx5Uh4Z2vJx3OsBaqH817jPk8zV7yzwu7tjsRw2P1R83VERC
         wCDlMc5cEja9U7nufGBg/EyG8NKqqMt5Q/9oMLsq0nJT5trY9Q9O+LiE2Jf5vptiNmJM
         0lvPW6ZE3bTm7nnaNcSeofWj5YvTSkOjZIzts0kGuHNwWsPGvVcF8BilFGVf7Abu871y
         NQfg==
X-Gm-Message-State: AGi0PuZIxaRMnf65vfWCgUrXVaQ2END/vvxrur/O7S13zaPNsDSEOy65
        10MilB54CQUed4GCRF7RS86JvlOZ
X-Google-Smtp-Source: APiQypKhnrec3Rd1SUHl3uwjkrThgeMbEEZbfj3O83Ue0nioY2F1yOGNGBfTBSYyS7tW2Pw4fScdcw==
X-Received: by 2002:a63:f50c:: with SMTP id w12mr10859723pgh.253.1587283809015;
        Sun, 19 Apr 2020 01:10:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z13sm10448319pjz.42.2020.04.19.01.10.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2020 01:10:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec] esp6: support ipv6 nexthdrs process for beet gso segment
Date:   Sun, 19 Apr 2020 16:10:00 +0800
Message-Id: <494257e3fab248db52f8dc6e2d0c5924a4c0c4dc.1587283800.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP6 hdr| ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm6_beet_gso_segment(), it should
skip all nexthdrs and get the real transport proto, and set
transport_header properly.

This patch is to fix it by simply calling ipv6_skip_exthdr()
in xfrm6_beet_gso_segment().

v1->v2:
  - remove skb_transport_offset(), as it will always return 0
    in xfrm6_beet_gso_segment(), thank Sabrina's check.

Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8eab2c8..160943b 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -166,7 +166,7 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -177,7 +177,12 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 		proto = ph->nexthdr;
 	}
 
-	if (x->sel.family != AF_INET6) {
+	if (x->sel.family == AF_INET6) {
+		__be16 frag;
+
+		skb->transport_header +=
+			ipv6_skip_exthdr(skb, 0, &proto, &frag);
+	} else {
 		skb->transport_header -=
 			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-- 
2.1.0

