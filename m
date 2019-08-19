Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BB291E58
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfHSHxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:53:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42189 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfHSHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:53:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id i30so691869pfk.9
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 00:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Zt49/34P6b1d5qt6HSrtOQYZ1fvRJlkcgU3u6J5tSI=;
        b=MZp5fyCNElUgznQacK0sjOVcrxqgjGOIxBeqgkMPB//E/BzQgIniFbwKGMr34v/epp
         si1ArB6XvQIRDaIB8VsTtB4UrkK/pt4D09tECCQuyVGz6/radSeZMxH0S1QTrSWR4swI
         FCKgjRKlcZ5S4n0xbx2QongqaopOtp7U7i6e9H/guj72AAumxH3HnXnu0txZhqdShKUw
         1RwtovtXhT54A2bFxZgaiA9cQiWrEDmy/SC2D46NVkhdufe0gpLWFBcxSwhHWSLZkfzu
         ImzBkt6uXDitFbY0/oijtJVyazEdOdFk3ZMQfQ62TDfgaptFaZbJ1obsZ53irBG0kv/2
         s3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Zt49/34P6b1d5qt6HSrtOQYZ1fvRJlkcgU3u6J5tSI=;
        b=tKOgRR1kix2/d/yRwMWYbrJJYffEKG43y/2o3Hzbzz0vzjETgO7j7EM6VBH7Nnnh6q
         hPsk138uDrvj65/FmThYp1gIrhsat1MRyHJ4p5iFyQJn0uWL+Soy8MXb5q484nFp1iRk
         9Wm2ujyaVsd6GDiUGNaoa2zz03kt4j/ox0ceZLplqbzPYAEl8WiBtIsBORoiIYdzM7vj
         W13FYxz+aX9/vf3ECOggoEAoeOFXyvq2z2q5kFH5S+8KkwidwRoe8Y9vMmWqI9Da+DjE
         Fo1yuxeSUuM5UUT7hzi6D2A+T9NUpdhVs5eRHYwH/wkrP/wMDDgzanHqnphD8TpwkNGQ
         SsCg==
X-Gm-Message-State: APjAAAVVifq3tPpkFt3gUDdOBKRHhC4rHRxGf6JojgLq2GNLpOd0XXHM
        pIn9lzg1cNyTNiYI1frBys9ptsB33r8=
X-Google-Smtp-Source: APXvYqwC7T0PHVPXgqstP0NJqdD7qE8g6sM/04boXWLTKHX6TK57n7sS5GizapSzAmt4y542N5jFFQ==
X-Received: by 2002:a63:e807:: with SMTP id s7mr18147689pgh.194.1566201228658;
        Mon, 19 Aug 2019 00:53:48 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y188sm16941270pfb.115.2019.08.19.00.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 00:53:48 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 2/2] xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md mode
Date:   Mon, 19 Aug 2019 15:53:27 +0800
Message-Id: <20190819075327.32412-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190819075327.32412-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190819075327.32412-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In decode_session{4,6} there is a possibility that the skb dst dev is NULL,
e,g, with tunnel collect_md mode, which will cause kernel crash.
Here is what the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv6
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmpv6_send
      - icmpv6_route_lookup
        - xfrm_decode_session_reverse
          - decode_session4
            - oif = skb_dst(skb)->dev->ifindex; <-- here
          - decode_session6
            - oif = skb_dst(skb)->dev->ifindex; <-- here

The reason is __metadata_dst_init() init dst->dev to NULL by default.
We could not fix it in __metadata_dst_init() as there is no dev supplied.
On the other hand, the skb_dst(skb)->dev is actually not needed as we
called decode_session{4,6} via xfrm_decode_session_reverse(), so oif is not
used by: fl4->flowi4_oif = reverse ? skb->skb_iif : oif;

So make a dst dev check here should be clean and safe.

Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnels")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 8ca637a72697..ec94f5795ea4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3269,7 +3269,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 	struct flowi4 *fl4 = &fl->u.ip4;
 	int oif = 0;
 
-	if (skb_dst(skb))
+	if (skb_dst(skb) && skb_dst(skb)->dev)
 		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl4, 0, sizeof(struct flowi4));
@@ -3387,7 +3387,7 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
 
 	nexthdr = nh[nhoff];
 
-	if (skb_dst(skb))
+	if (skb_dst(skb) && skb_dst(skb)->dev)
 		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl6, 0, sizeof(struct flowi6));
-- 
2.19.2

