Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670BD76048
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 10:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfGZID2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 04:03:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46185 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZID2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 04:03:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so5347411pgk.13;
        Fri, 26 Jul 2019 01:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aNZ6zNbsaKjh51lz8tJIfnHcrXSDVIs4DFqNHJ79L3E=;
        b=CQwAma3Pu8O0jCDic//Euaxbbj1NkYvWFtvRH+Dax4Y2t1g9x8oY1qNcwARAvQwCv3
         DmXnyVNtcuaFGEKh1wU5hTiE/eknjrSgFkCJg6jcudveZkfGdjY8mXeyaUBctSpH6aGT
         +3YS2vWMOwuqagfWH4mKiy8UUKboVeRggtmR50fiuqjPsF94g912m1V3KbiL3PcKUX8G
         oxva2u+G8QHjsSQ7XChFH5r39SiQrql6mP2GnztLW5P6atAPn0w3Al184igFsI8iHHJL
         BRWBmGfvUqvW1q3zsfyfk0c3hjBdMCK3S7QkKfZ2eElregu9hPvgcjT34az8gVcnzI9E
         bczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aNZ6zNbsaKjh51lz8tJIfnHcrXSDVIs4DFqNHJ79L3E=;
        b=cAK4zCBKQ/81C5IySC6DIKUDWqhR2hNiWg+T8q4Bq2en1drnOQYiql61itmDHnyRD5
         AzLVIQ3NHJLfJT2HcKNo5Tp4AFhi2vlryYddCGats1NnVynacu68xec3yPR5hA++1DQF
         yUe9bHG1DBGcbgtKQI8hKf4+6n75fO2+CGxpKEwkTs/BhSBj/JILdbs8y+/3EMLxrfAx
         Zc4cQ1r6Vv9T1D17Pb+GJ6gjdJjTPOkzx8DJsS/Mg5EVYizV17G/Yc0TBXmodyyf/ot8
         70F3W7kS3Y7YBszM/XMpqSEhI760z/3Dr0SHFwBOrh3YOzrQeloyB4jdpXNSrX8uLn6l
         1x7A==
X-Gm-Message-State: APjAAAXolK2TVeTCCbjRYD39piBK/0yR1gnOe7hbe9la9AbbBCeYfZrL
        GCdsWSDo7oAlwk0QT3zn3F4=
X-Google-Smtp-Source: APXvYqy6vAuLBnR+hOegMSm522XbZmn+L9+SYmZ2SWYpWAIunYNoCmlj8nB4Fvijx/H1Rp9DkGGu2g==
X-Received: by 2002:a63:36cc:: with SMTP id d195mr49258558pga.157.1564128207719;
        Fri, 26 Jul 2019 01:03:27 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id b26sm59386976pfo.129.2019.07.26.01.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 01:03:27 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] net: ipv6: Fix a possible null-pointer dereference in vti6_link_config()
Date:   Fri, 26 Jul 2019 16:03:21 +0800
Message-Id: <20190726080321.4466-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vti6_link_config(), there is an if statement on line 649 to check
whether rt is NULL:
    if (rt)

When rt is NULL, it is used on line 651:
    ip6_rt_put(rt);
        dst_release(&rt->dst);

Thus, a possible null-pointer dereference may occur.

To fix this bug, ip6_rt_put() is called when rt is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ipv6/ip6_vti.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 024db17386d2..572647205c52 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -646,9 +646,10 @@ static void vti6_link_config(struct ip6_tnl *t, bool keep_mtu)
 						 &p->raddr, &p->laddr,
 						 p->link, NULL, strict);
 
-		if (rt)
+		if (rt) {
 			tdev = rt->dst.dev;
-		ip6_rt_put(rt);
+			ip6_rt_put(rt);
+		}
 	}
 
 	if (!tdev && p->link)
-- 
2.17.0

