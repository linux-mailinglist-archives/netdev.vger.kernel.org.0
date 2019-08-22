Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E5B99642
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387824AbfHVOUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:20:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35191 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387766AbfHVOUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:20:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so3778240pgv.2
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 07:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f4IAtwXwNagrXS06nvnkjVXlNHUwEilJqoat+96tCA8=;
        b=Io7z8Wih8UsCR1ZkUW/YCnmTpD/Ri86592wmBKB1w970vyD3PberYs0Sln14p7uSwx
         1JS5kWGnppt2Nlo7YkgxkOiWc8W3mAUhWGjw9N4yhcFf3kEcMgf5hGg/fjS1M9N6QEsI
         Ta1CoVFH+vbWHcHd/6lGQzc4aE4ieN+sM/GEWz567gpmL+Lkg9N5XMQ71JfJFlW+gtE3
         0iycpnEqWG5KM8tN7OiUTgjIXaE9vOjjhwDfpTjNLJSnraDJ2w2aDgGAWY2VfGKqRNIS
         IlxH2cO1yVYlPImAQP7EpiVgmKmdjsepZ+Lt1jyOVVvOYIMnw+wb9VXbVxIOvIcj60fI
         4CRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f4IAtwXwNagrXS06nvnkjVXlNHUwEilJqoat+96tCA8=;
        b=TkWwcbMexPrRQdYBhLnLpKB8xeBtqxyfyy16BpCcmV50S8mFS9Z899OWTrteHBQSAl
         RGjKpc1DUiaLM7ySCKi7khsUQaavMmboYDagb9fYDIfVwfpAOA2eO027Y61x8qFB5HQs
         lgm+jf1nuKskxkzNKF1PA7zZl9oi7Jw5olpw0YM/YzeOfcV3OA1Y0M/aXahHyb02YJeO
         gWjpuiOsubcJWx7QrF9HwT5cpmYpw0UcAOabQyELRZqw2MS9qcu/AXegSI6c3TcHBtpa
         RYngLYY5y+P7oxkzIPlGvQwaGabnubWRpJ71Htl+hf+FW9DATyywfF/kiuCDwSimtkuw
         HebQ==
X-Gm-Message-State: APjAAAW9V9DwDXObSDvCP11bvCTTHIwYAnhoxTeE7ITrgaZLqgbu4dr+
        GumbNGyT78+02CFN/kGK3BaF35jSTptDFA==
X-Google-Smtp-Source: APXvYqxu3Za7neqNccdwaA1UDi4wRwncd3MDOCd/eGyba/Yg6j1E+BUXW2FappegmuJbV+lQgvw2MQ==
X-Received: by 2002:a65:62cd:: with SMTP id m13mr33732843pgv.437.1566483614122;
        Thu, 22 Aug 2019 07:20:14 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11sm3076747pju.2.2019.08.22.07.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 07:20:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 2/2] xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md mode
Date:   Thu, 22 Aug 2019 22:19:49 +0800
Message-Id: <20190822141949.29561-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190822141949.29561-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190822141949.29561-1-liuhangbin@gmail.com>
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

v4: No changes.

v3: No changes.

v2: fix the issue in decode_session{4,6} instead of updating shared dst dev
in {ip_md, ip6}_tunnel_xmit.

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

