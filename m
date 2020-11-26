Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964292C5B9B
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 19:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404196AbgKZSJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 13:09:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391523AbgKZSJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 13:09:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606414172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OD+yTlKGKIuIWEQTlagOHVTutRQ0VrwxI5cdaeptkbA=;
        b=YIPuwfmAvPwm0sHwQUJTy5UEARTBEOJPAIO1NvLi8BKy5DaVVteOkBai7LZQ2GvWQKYxBS
        g9wRjUs1UhkHeDsS5GVy0+Hr2056DLPP+CFRuljDuD7a2cL3sCkU9v8kPPZZXvoxw+Kkme
        Vu2a+dheNUlggTttitZEkktwjiBJcNU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-Rffco7pXN9ScwQTX9Y11_Q-1; Thu, 26 Nov 2020 13:09:27 -0500
X-MC-Unique: Rffco7pXN9ScwQTX9Y11_Q-1
Received: by mail-wr1-f72.google.com with SMTP id g5so1678851wrp.5
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 10:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OD+yTlKGKIuIWEQTlagOHVTutRQ0VrwxI5cdaeptkbA=;
        b=jhckA4CDIXSMKGCHt/QbBv6yX6lVlYqThBdzbPz6oAS1kz6HYQb9YLEfJlbebNMGgf
         NOvmi5E0am8B1RAzhfdvzWhaoOhQI5j08s9AI/J3JP9F+oUBR86QDiPxFK2boZfjasUZ
         R5B42hwhVf+8SNBi42pB+60Azyi+TNTidndQqbhwh/7VahajM6xWCShCmK2qvbYiPnzQ
         HDzKhJ5ry81pwuW0SiRLjLzEM2s/iLJD/fzk2I1wJckQzxj8G4IKtp4WtqlB9VzUT9yF
         ZP6Ttfj/jYjG5m+YjKFcUGhivcYcrG7vFxvPwvyXRk7/+93Jsp5GNdnIj7I5nTg4k7RY
         rF6w==
X-Gm-Message-State: AOAM532r6djBEt6mtKpTm7xT0iVAf8pwcwuAqSvIYKVEokUMNqpCrA1L
        0rpaJ+tz+zOpv5VCI10elWMp9C1Pxba76epEFWNHkBjsJOf67wKfjmNC3bdlGWLyM7fnRphIn9v
        k5StwgsDANtpf0+Bu
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr5353544wrr.48.1606414165836;
        Thu, 26 Nov 2020 10:09:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxA62khGFivRn8F3dt0CIZ3kFxA6yZXH6UIVrT3G3YXA/eKZRiqKbh1ouIHNkRKixH718Jolw==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr5353525wrr.48.1606414165654;
        Thu, 26 Nov 2020 10:09:25 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 90sm9875593wrl.60.2020.11.26.10.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 10:09:24 -0800 (PST)
Date:   Thu, 26 Nov 2020 19:09:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Russell Strong <russell@strong.id.au>
Subject: [PATCH net] ipv4: Fix tos mask in inet_rtm_getroute()
Message-ID: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When inet_rtm_getroute() was converted to use the RCU variants of
ip_route_input() and ip_route_output_key(), the TOS parameters
stopped being masked with IPTOS_RT_MASK before doing the route lookup.

As a result, "ip route get" can return a different route than what
would be used when sending real packets.

For example:

    $ ip route add 192.0.2.11/32 dev eth0
    $ ip route add unreachable 192.0.2.11/32 tos 2
    $ ip route get 192.0.2.11 tos 2
    RTNETLINK answers: No route to host

But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
actually be routed using the first route:

    $ ping -c 1 -Q 2 192.0.2.11
    PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
    64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms

    --- 192.0.2.11 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms

This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
return results consistent with real route lookups.

Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/route.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dc2a399cd9f4..9f43abeac3a8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3222,7 +3222,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 	fl4.daddr = dst;
 	fl4.saddr = src;
-	fl4.flowi4_tos = rtm->rtm_tos;
+	fl4.flowi4_tos = rtm->rtm_tos & IPTOS_RT_MASK;
 	fl4.flowi4_oif = tb[RTA_OIF] ? nla_get_u32(tb[RTA_OIF]) : 0;
 	fl4.flowi4_mark = mark;
 	fl4.flowi4_uid = uid;
@@ -3246,8 +3246,9 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		fl4.flowi4_iif = iif; /* for rt_fill_info */
 		skb->dev	= dev;
 		skb->mark	= mark;
-		err = ip_route_input_rcu(skb, dst, src, rtm->rtm_tos,
-					 dev, &res);
+		err = ip_route_input_rcu(skb, dst, src,
+					 rtm->rtm_tos & IPTOS_RT_MASK, dev,
+					 &res);
 
 		rt = skb_rtable(skb);
 		if (err == 0 && rt->dst.error)
-- 
2.21.3

