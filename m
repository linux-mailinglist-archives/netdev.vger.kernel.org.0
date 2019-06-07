Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2CC3981E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbfFGV5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:57:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44122 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbfFGV5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:57:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so4030496qtk.11
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 14:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNukxXdxo8xZZQw6dA5r+4fHcFuZWTFSP4/22G57NpM=;
        b=pcgkLYNQeJS6Nm3twuvXGoXyy1gjUO+acjumJPT8jZnskVg0ZjzWddV6DVeqzS5y72
         J+WjG9h5dOd7ZBSkkkl81Hn4OShI6wCrqPbPc9dlFBP3yFrrpPm0D1SQfs+xg7qOw61q
         KhWwES80lr9aCZrbkt2K32GS3a2De6G4mb4Gmua/hkODaxdBHjCol9u7eqKaffvUQF7v
         Eezfdts03D8bfLQQu/4gRu/R+X1asdXbNFulbhDjB5hg6BsPYBsPlIOgH9+mfPnFm3/X
         WZJ27bEKi0Kiii0GioxWhCB6aCnW65mKufaSXY/TwDARZbLUdwESmoVmNP53dimKqZOI
         Ppdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNukxXdxo8xZZQw6dA5r+4fHcFuZWTFSP4/22G57NpM=;
        b=jiarrxQoPW3STSJT6oyyPRLBHtbMALRIuRLycj3WO5D4cAdyybKtDiDVu2SLvjxy1z
         QHVdTnkaLxAZBZikRm7xyJYMqA3i+pwwhfo14MdslbT/0aS3Cc+KvwQ+Up0dE7u9PHuG
         wL9yBIIvkdL6+YE/jTzWWLaxI6jgxhPdBe4YZJkX+D8dIJTghFMsVLn43rRzrm8jFis1
         eT9x66FrOw7b0yVWNmFwLomVKxic2Zk/Sl8RdSJZnBRtQkFm9K/2iG3Bgp2lmCyPeC5f
         Og+OaI7GJfyrY4qv9QqUx37xtpgWlcjkedhsPl/qGwJpujUQY9IoXrmxDrhlWoIs3XHX
         oSuA==
X-Gm-Message-State: APjAAAURM2gidrtKDrzca4Hs8bAPvT3nNeVuVVmPLY6/eSX8T6c5FYiJ
        8EalvhFYk9Pg4Gw3CGNmRnr3DIy4
X-Google-Smtp-Source: APXvYqx18aoU4vQ1ojFRnVCQKyWlPPxyvA8OzSdDvs9opZMBA65ZIgqlXOSoiV2Tv311Uect18wjVw==
X-Received: by 2002:aed:21b1:: with SMTP id l46mr47556276qtc.281.1559944671769;
        Fri, 07 Jun 2019 14:57:51 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id c7sm1394576qth.53.2019.06.07.14.57.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 14:57:50 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: correct udp zerocopy refcnt also when zerocopy only on append
Date:   Fri,  7 Jun 2019 17:57:48 -0400
Message-Id: <20190607215748.146484-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The below patch fixes an incorrect zerocopy refcnt increment when
appending with MSG_MORE to an existing zerocopy udp skb.

  send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt 1
  send(.., MSG_ZEROCOPY | MSG_MORE);	// refcnt still 1 (bar frags)

But it missed that zerocopy need not be passed at the first send. The
right test whether the uarg is newly allocated and thus has extra
refcnt 1 is not !skb, but !skb_zcopy.

  send(.., MSG_MORE);			// <no uarg>
  send(.., MSG_ZEROCOPY);		// refcnt 1

Fixes: 100f6d8e09905 ("net: correct zerocopy refcnt with udp MSG_MORE")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/ip_output.c  | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8c9189a41b136..16f9159234a20 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -918,7 +918,7 @@ static int __ip_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
+		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 934c88f128abb..834475717110e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1340,7 +1340,7 @@ static int __ip6_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
+		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

