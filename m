Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28BCA5B44
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfIBQXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:23:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35371 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfIBQXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:23:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so7691738pgv.2
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RGVpBUTE9zlD/KEyuf5xRtBdBy5b77PBEr9fjvCgQcI=;
        b=Zhau8bJEg2IOc0fhd2r274JPpDVsC/t1k71o8gHxTeJEIswIaTtEfT6rOwoNuf2rPL
         2dBjqdLiAaChV3V5AzGG/5oG4inMp3GpXpDIb65rCWGaF3H5l6mDjhuK9RxEeQXBoWR3
         HxtDkM22A92OSMZXhpiMsEeJG5HtBsbl+Zc7TurzaVO6YoeckFZoSAWWHA/EgYcB5hWg
         tWYlNliclNNU6IirbIVTcOUw6DERYo+PWal48Bl3wAMjqeUnJGpLRSsrvC1YS0dkQhAl
         yzs9lQh726OJZCszKKzkizMtxXOTlucXOLjDvIMDk/cthA4pIY/jibH1T18755IreBe6
         WoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RGVpBUTE9zlD/KEyuf5xRtBdBy5b77PBEr9fjvCgQcI=;
        b=SNO8LKbJaUZvF+E+oCIK732JUIrfHrdIzMxw9tizbNDCbybnE4Oj0OfThKXcaKNZtv
         jblhbt23fYQxnbttZ31alpAZl0Lhx9RyZjH+I29o9wc+rDSRQgWTYxPAH2asrnnp9D5+
         xHvXJm7utx3Jm6yONjSycd1a1dvfWmR4v7aOCbMxR6spmEdQuLYiAbGQdk7XHNJ1jF6z
         PY4xmk6FRLfT6SO3+bDN7NDFNksrIGJcIUT/l3FV+2vXk081GjDHfU7GW5KxcX5/OuaJ
         1Wh62rtHsLMw8YbO0okowTBCEkrpjvnQbHr10IZAMJQYPHBn+Pi5iBTp1LLo/OnmxuuD
         iHeA==
X-Gm-Message-State: APjAAAUf1gfVdHF9TgmLZSOwxF87VxTYEW1jNft8qeppdhDXCAdpVmhZ
        Hw99cmc7BMGDsI0AgoxUpTizcXUCpGE=
X-Google-Smtp-Source: APXvYqwZt2AzsRHN5gNLOG95HAklWGx3ARuZNMCV4PF6Ju5vFJI28ISDhP1QidTTE9SoyDg0Uw9SCQ==
X-Received: by 2002:a17:90a:a611:: with SMTP id c17mr14361793pjq.17.1567441428474;
        Mon, 02 Sep 2019 09:23:48 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id a134sm11767627pfa.162.2019.09.02.09.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:23:47 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH v2] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)
Date:   Mon,  2 Sep 2019 09:23:36 -0700
Message-Id: <20190902162336.240405-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
In-Reply-To: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
References: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

There is a subtle change in behaviour introduced by:
  commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
  'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'

Before that patch /proc/net/ipv6_route includes:
00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo

Afterwards /proc/net/ipv6_route includes:
00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo

ie. the above commit causes the ::1/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).

AFAICT, this is incorrect since these routes are *not* coming from RA's.

As such, this patch restores the old behaviour.

Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
Cc: David Ahern <dsahern@gmail.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/route.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 558c6c68855f..516b2e568dae 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4365,13 +4365,14 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 	struct fib6_config cfg = {
 		.fc_table = l3mdev_fib_table(idev->dev) ? : RT6_TABLE_LOCAL,
 		.fc_ifindex = idev->dev->ifindex,
-		.fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,
+		.fc_flags = RTF_UP | RTF_NONEXTHOP,
 		.fc_dst = *addr,
 		.fc_dst_len = 128,
 		.fc_protocol = RTPROT_KERNEL,
 		.fc_nlinfo.nl_net = net,
 		.fc_ignore_dev_down = true,
 	};
+	struct fib6_info *f6i;
 
 	if (anycast) {
 		cfg.fc_type = RTN_ANYCAST;
@@ -4381,7 +4382,10 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 		cfg.fc_flags |= RTF_LOCAL;
 	}
 
-	return ip6_route_info_create(&cfg, gfp_flags, NULL);
+	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
+	if (f6i)
+		f6i->dst_nocount = true;
+	return f6i;
 }
 
 /* remove deleted ip from prefsrc entries */
-- 
2.23.0.187.g17f5b7556c-goog

