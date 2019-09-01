Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F238A4AF9
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfIARsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 13:48:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43875 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbfIARsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 13:48:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so7520982pfn.10
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 10:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KodrCIAkldt+ysuQg0/3FfqNo9yzZiPeizaRuyLLuB8=;
        b=uOKzo2a9pQgaF1JqcThhpDKLDFDW5K3NPpZruDCv7JZ3r/Dp5LNXzKpTDqULNTOeoq
         PN2WF6aZVf+waX+urQ70BYrkECtUdGZcRKubmlkmx1qjwW5MYpQxuiUti1a8rVUZsQBb
         PZln4WXzLZbJjIb/izg+c1TXkodTjct+4J9n1rv9XdF/3oH46jilkULaQZ4wFDeU5/6x
         4penCglEaUtJCtGDVssu3RLeEOOIqr1x+D1bW1ZqUO1zIhfckBlxohXlhxshUACrQD7q
         xlTVlmHuJrW28s4mOb29CovDTv8F1dbuKbN2nU+s3La6QQwTlU25lBcBOR3QJOaXY1Hq
         uKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KodrCIAkldt+ysuQg0/3FfqNo9yzZiPeizaRuyLLuB8=;
        b=ct5bN/Bp4zif1AyHKa9R6kWtNgsVDxJId+JHNRR7YAyS1a1/wjbSTFGIk1w7CdXDtI
         8RaS2+1pBTPJhDtX4k48Ssde1Mz+BU4yyWyL35USo/myrDKGYcs/jWNI4IbaJhcoyqBI
         7o6jixC766KE/DT7RqebjsqxLL4BcsymTWhXm+Y8ZHGtxTx0L4WEq/ENRX6u8Pxl+18x
         zocN+s8OC9G6pS6KhhS9y4PALeNoL/HbVI9zA1yIf1x8k9hxOAhXGT2KUOVUFoDPx+rq
         HQyeeTFyslK9pwjSgypdzv4lftYDqLH870eZAuthnh9yBgvHkCrDEWVgo1RrXGLTnToG
         +BIA==
X-Gm-Message-State: APjAAAUOJH2RY/eDD0xoM6Wm2UquuJWEfOus8ht6ad9Q6oboKmSr24RJ
        B8Np2IucWdezuCnm9qU1lwg=
X-Google-Smtp-Source: APXvYqw/JnNvb7Y4SZ1o3mvaCNr0n+CkdLv/v/xNK9+6jlJSJ9pGdGI1u+KHA8x33lMhkRtfrzhH9A==
X-Received: by 2002:a63:6686:: with SMTP id a128mr21475780pgc.361.1567360093196;
        Sun, 01 Sep 2019 10:48:13 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id n19sm2346195pfa.67.2019.09.01.10.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 10:48:12 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)
Date:   Sun,  1 Sep 2019 10:47:59 -0700
Message-Id: <20190901174759.257032-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
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

ie. the above commit causes the ::/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).

AFAICT, this is incorrect since these routes are *not* coming from RA's.

As such, this patch restores the old behaviour.

Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/route.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 558c6c68855f..cee977e52d34 100644
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
@@ -4381,7 +4382,9 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 		cfg.fc_flags |= RTF_LOCAL;
 	}
 
-	return ip6_route_info_create(&cfg, gfp_flags, NULL);
+	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
+	f6i->dst_nocount = true;
+	return f6i;
 }
 
 /* remove deleted ip from prefsrc entries */
-- 
2.23.0.187.g17f5b7556c-goog

