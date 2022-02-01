Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322A24A6883
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 00:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242865AbiBAX1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 18:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiBAX1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 18:27:21 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294E7C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 15:27:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso4204301pjm.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 15:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCn+JW60iWRBoW7wvDSSQRafZvHDzZZ+sxZcvrzv0Sw=;
        b=N8NXbdFCQYKc0Z6JtqLjbQvq90pvTie1VaKn7kc9I4In7RU34G/w2sVtwVrkqW6hR0
         Fbimmf8NQy7MtNAS8AyxUgD6U/3l1xQLg4Fmu+u89B9gnYgNYoJwpU9mLbWxP/DLtWEs
         +sy3pQTUBwkDIGmTcEkZoH34Bp9dnAQ2G1onxv3jjD4FF8WhwT2eBQfI6woVjoy8VpGj
         oyBzx3uiR2JO09z2qolQRMoZMDghrmlvhgzyEssrzyD5NgLOEXJb59aPRL3QgttYpFQx
         mnXJ4iZPu9EXNbPh8RR4ijrWp7SHQNd20lQQ4FfsCd/pEq0rQUcHAuh1yPlFBEa1Q550
         IStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCn+JW60iWRBoW7wvDSSQRafZvHDzZZ+sxZcvrzv0Sw=;
        b=3hRNXKDbQ3GHMVwGV53j3srkVclQ9gyBugz69oEg5hkKnUlTZZXu0Qq21g5v3red5K
         FPtc5bgV9zA3n0d7UCMWQx1Amc5zC+7vNDdv2r+QZ4LZlrTpxXrwjkjXD2oxiFtNxbzP
         xpXujWFc7CAw5obvg2K5wi36otmKPzTVwkn5kYbzMlqI6oIvqjXWc4vUFFpKf+yjc7ho
         zPBX0hApVyri5DKJBCoBagwUT9NV2psbek2VXcBfRQXxjhtV8upKa8Y8T3luBLomm64L
         za28IeT5KW0s0fiw3xGh90w7DKb79ReyVR28E818MyO1SMbeDe3oJKboHPbvOQf269xd
         fFIw==
X-Gm-Message-State: AOAM532r3iAB0S+CRNZNn4+wRyLiL3oaWJuN6tt9dLrNSqVK5oh2sdBJ
        2nvDacp3XpBksaHgCSeig2I=
X-Google-Smtp-Source: ABdhPJxCofb0nhRRaJpajyRMw39XkG5H72yZIQO1oikfHe17PGU6itGk2c+N5u3avPEq5i/VcpkucA==
X-Received: by 2002:a17:903:2449:: with SMTP id l9mr6379752pls.116.1643758040596;
        Tue, 01 Feb 2022 15:27:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:13fc:305f:6f9b:9f4d])
        by smtp.gmail.com with ESMTPSA id mq15sm4395450pjb.8.2022.02.01.15.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:27:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH iproute2] iplink: add gro_max_size attribute handling
Date:   Tue,  1 Feb 2022 15:27:15 -0800
Message-Id: <20220201232715.1585390-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

Add the ability to display or change the gro_max_size attribute.

ip link set dev eth1 gro_max_size 60000
ip -d link show eth1
5: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 9198 qdisc mq master eth0 state UP mode DEFAULT group default qlen 1000
    link/ether bc:ae:c5:39:69:66 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 46 maxmtu 9600
    <...> gro_max_size 60000

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 ip/ipaddress.c |  5 +++++
 ip/iplink.c    | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 4109d8bd2c43640bee40656c124ea6393d95a345..583c41a94a8ec964779c1e3a8305be80e43907e7 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -904,6 +904,11 @@ static int print_linkinfo_brief(FILE *fp, const char *name,
 						   ifi->ifi_type,
 						   b1, sizeof(b1)));
 		}
+		if (tb[IFLA_GRO_MAX_SIZE])
+			print_uint(PRINT_ANY,
+				   "gro_max_size",
+				   "gro_max_size %u ",
+				   rta_getattr_u32(tb[IFLA_GRO_MAX_SIZE]));
 	}
 
 	if (filter.family == AF_PACKET) {
diff --git a/ip/iplink.c b/ip/iplink.c
index a3ea775d2b23c47916e9554b8615d430a58c6a55..c0a3a9ad3e629986ee2da0ee80eaf758f98aee5f 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -118,6 +118,7 @@ void iplink_usage(void)
 		"		[ protodown { on | off } ]\n"
 		"		[ protodown_reason PREASON { on | off } ]\n"
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
+		"		[ gro_max_size BYTES ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
 		"		[nomaster]\n"
@@ -942,6 +943,15 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				       *argv);
 			addattr32(&req->n, sizeof(*req),
 				  IFLA_GSO_MAX_SEGS, max_segs);
+		}  else if (strcmp(*argv, "gro_max_size") == 0) {
+			unsigned int max_size;
+
+			NEXT_ARG();
+			if (get_unsigned(&max_size, *argv, 0))
+				invarg("Invalid \"gro_max_size\" value\n",
+				       *argv);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_GRO_MAX_SIZE, max_size);
 		} else if (strcmp(*argv, "parentdev") == 0) {
 			NEXT_ARG();
 			addattr_l(&req->n, sizeof(*req), IFLA_PARENT_DEV_NAME,
-- 
2.35.0.rc2.247.g8bbb082509-goog

