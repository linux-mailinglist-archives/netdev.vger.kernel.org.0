Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E2596F41
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 04:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfHUCKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 22:10:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34892 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfHUCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 22:10:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn20so443823plb.2
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 19:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Zt49/34P6b1d5qt6HSrtOQYZ1fvRJlkcgU3u6J5tSI=;
        b=YGS7cR46cgRDBlXZoZdp+/GFXP6bKTV6IroVX5A+9ha3uTqjEcAFfmQD2FcdHSgHdI
         JGmC9fh45i3zV5OvJLbqQ3QLwtfxCkIbC/TUhLdrQyjMkx9M6kkLt12cMxYFcOhBHwOD
         4fCHE7VJAyJtWO98SBLN0KXYB81saCPUVIb34KHzpWftix4UkYWlTZjyqVSQul8pV1b0
         7TeA3N5u+iqem3BcsRyHxotUl+qwJubRby91jHLcW3Pd83o3ypbKqCp+gS6v4P1sNTEF
         sLvKZBK6h7H3kblhkIlEKoP8+Wk2XJ8IhIJLEcEniztCB+zBpqbZXnrP/V4rbruhNMUz
         T3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Zt49/34P6b1d5qt6HSrtOQYZ1fvRJlkcgU3u6J5tSI=;
        b=Pvu7peGE2+XScEKEXl2F2Ei2llh3NPxKRI2LmmGjaIhZy4F609XqRlPgE4aojYfOey
         0y3M72RGLTEwum4VsdmlNekPSwL/ZE+d0vU2JNWzPC11SNeaure1oa4ZTlmbewNo//OW
         q+a+SGXgERLApcKupgzighVvFlaJRRmD0fXzlq7RQGus9dURS9LX2lZFGI7FrJlSxU8c
         VgRVT6tiy/tTUtpJieoIrzuSTJ6GMClvmHFDblDtrmxJPKz9gKSNa5d145lqYQIhI40O
         XpjfhG0JLy6vzlpbhKLn07B0Uzhy7n7EKTjjKIMffRFFYFsXCjrbKRRDrTxSp2XiK3PZ
         81iA==
X-Gm-Message-State: APjAAAWnWtt5PAYvw2Ams/B6LaJDBxDFqPAmhF1+eKO4Tua8HpOIEfho
        2v7fxw1zcH4cusf9P+GaiX4earQBE5M=
X-Google-Smtp-Source: APXvYqx81MNtvFZ6dbjgVFhFuMFGvBDxvwwlw16/TtD6btlGm3CLWpObmcvQ0c/xT58oBWMohItqtA==
X-Received: by 2002:a17:902:2888:: with SMTP id f8mr30985404plb.26.1566353419344;
        Tue, 20 Aug 2019 19:10:19 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k3sm36717073pfg.23.2019.08.20.19.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 19:10:18 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 2/2] xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md mode
Date:   Wed, 21 Aug 2019 10:09:54 +0800
Message-Id: <20190821020954.21165-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190821020954.21165-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190821020954.21165-1-liuhangbin@gmail.com>
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

