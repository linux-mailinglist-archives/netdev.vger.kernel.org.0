Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9A1B9114
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 17:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDZPEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 11:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgDZPEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 11:04:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137E5C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 08:04:42 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g2so5888971plo.3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 08:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5z3Gs8144cde3/+JVA0WEYDiu1HcUEYCz3riNJht24Q=;
        b=Rx3N/3AcI9LJAthQJBd7Gqj8qP3OQCkxi/g9GlHGmMU2FFRbqN8tCjPlXDYcz6BuvI
         8hecJADhkxmY5hs5zhA65uAbS14E43ZuxXNpqtw4aTHZnccxRALQELRG93ItgWNd3Nos
         5zshhK2rGP9dnP330ELoPmCcDqMrK5Jg0ALIIcHMDQQVW6Kgp14q1YAREMbqObU6Btsd
         4iSVFLRLCUdTNltG48GDzXMqKFovfz9dbOfWloBELXgHmreW1SRHQRxQc/R1BesqjtQZ
         JTr4TnLJIuVGa0VKTX+/TVx+BuCZitD1BlP2Pn9FqGY/P7rzcYMSpwrH3ZL7caSzfW13
         YN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5z3Gs8144cde3/+JVA0WEYDiu1HcUEYCz3riNJht24Q=;
        b=sKRU4Nwfix9WRyYOZDQ5CMfAPWwRALCgnhDAl2g4d9uzUDqhSuZxrtdr/8HBFY+uyB
         L8vBZTZbgT9Z/Y46RdpIyqXf49UBQK8azc8Io3bWwu+cm5L3zz5QyOo0fDt023ywQ7Ha
         zHDsDmLAU6Y1nfZI+2K08urt+hwjVqFE4ZRMWrZo8IzpkIn/ZsgttSh3EanT1v3E/F7U
         yPfyUCKVzqL8xrvEecPv4p33IpO8qromef5jNk5LJHIwlca2cZuy5ANnvlpUQonaOwlv
         lPrnomvq0G0nbflRWB+EruBwthiE69lK+AH7n5Ai+PLvEDB+kDH6OE3R31wbdU5LNifK
         ItQQ==
X-Gm-Message-State: AGi0PubW9c0nvWA0CCN7tWC6NpUC6O9o2Dmh1YDTWhjjYZoSM/JtFrjT
        PjBlHZMVUck2kOLPOodUZbxdxJvT
X-Google-Smtp-Source: APiQypLbnvDI24lN06wEvMP/kF2zJ6Diz3tCWZJG2B2oyFy6rEtYeKu0Fdzz1XRl6UEZKYTBBkKhxw==
X-Received: by 2002:a17:90a:30a5:: with SMTP id h34mr17678018pjb.171.1587913480545;
        Sun, 26 Apr 2020 08:04:40 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-76-21-95-192.hsd1.ca.comcast.net. [76.21.95.192])
        by smtp.gmail.com with ESMTPSA id g79sm2638549pfb.60.2020.04.26.08.04.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 08:04:39 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     petrm@mellanox.com, lucien.xin@gmail.com, guy@alum.mit.edu,
        Dmitriy Andreyevskiy <dandreye@cisco.com>
Subject: [PATCH iproute2-next] erspan: Add type I version 0 support.
Date:   Sun, 26 Apr 2020 08:04:15 -0700
Message-Id: <1587913455-78048-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Type I ERSPAN frame format is based on the barebones
IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
Both type I and II use 0x88BE as protocol type. Unlike type II
and III, no sequence number or key is required.

To creat a type I erspan tunnel device:
$ ip link add dev erspan11 type erspan \
	local 172.16.1.100 remote 172.16.1.200 \
	erspan_ver 0

CC: Dmitriy Andreyevskiy <dandreye@cisco.com>
Signed-off-by: William Tu <u9012063@gmail.com>
---
I didn't notice there is Type I when I did first erspan type II code
because it is not in the ietf draft 00 and 01. It's until recently I got
request for adding type I. Spec is below at draft 02:
https://tools.ietf.org/html/draft-foschiano-erspan-02#section-4.1

To verify with Wireshark, make sure you have:
commit ef76d65fc61d01c2ce5184140f4b1bba0019078b
Author: Guy Harris <guy@alum.mit.edu>
Date:   Mon Sep 30 16:35:35 2019 -0700

	Fix checks for "do we have an ERSPAN header?"
---
 ip/link_gre.c         | 4 ++--
 ip/link_gre6.c        | 6 +++---
 man/man8/ip-link.8.in | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index d616a970e9a2..0461e5d06ef3 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -354,8 +354,8 @@ get_failed:
 			NEXT_ARG();
 			if (get_u8(&erspan_ver, *argv, 0))
 				invarg("invalid erspan version\n", *argv);
-			if (erspan_ver != 1 && erspan_ver != 2)
-				invarg("erspan version must be 1 or 2\n", *argv);
+			if (erspan_ver > 2)
+				invarg("erspan version must be 0/1/2\n", *argv);
 		} else if (is_erspan && strcmp(*argv, "erspan_dir") == 0) {
 			NEXT_ARG();
 			if (matches(*argv, "ingress") == 0)
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 94a4ee700431..9d270f4b4455 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -389,8 +389,8 @@ get_failed:
 			NEXT_ARG();
 			if (get_u8(&erspan_ver, *argv, 0))
 				invarg("invalid erspan version\n", *argv);
-			if (erspan_ver != 1 && erspan_ver != 2)
-				invarg("erspan version must be 1 or 2\n", *argv);
+			if (erspan_ver > 2)
+				invarg("erspan version must be 0/1/2\n", *argv);
 		} else if (strcmp(*argv, "erspan_dir") == 0) {
 			NEXT_ARG();
 			if (matches(*argv, "ingress") == 0)
@@ -430,7 +430,7 @@ get_failed:
 	addattr_l(n, 1024, IFLA_GRE_FLOWINFO, &flowinfo, 4);
 	addattr32(n, 1024, IFLA_GRE_FLAGS, flags);
 	addattr32(n, 1024, IFLA_GRE_FWMARK, fwmark);
-	if (erspan_ver) {
+	if (erspan_ver <= 2) {
 		addattr8(n, 1024, IFLA_GRE_ERSPAN_VER, erspan_ver);
 		if (erspan_ver == 1 && erspan_idx != 0) {
 			addattr32(n, 1024, IFLA_GRE_ERSPAN_INDEX, erspan_idx);
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 939e2ad49f4e..e8a25451f7cd 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1163,8 +1163,8 @@ It must be an address on another interface on this host.
 .BR erspan_ver " \fIversion "
 - specifies the ERSPAN version number.
 .IR version
-indicates the ERSPAN version to be created: 1 for version 1 (type II)
-or 2 for version 2 (type III).
+indicates the ERSPAN version to be created: 0 for version 0 type I,
+1 for version 1 (type II) or 2 for version 2 (type III).
 
 .sp
 .BR erspan " \fIIDX "
-- 
2.7.4

