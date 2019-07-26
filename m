Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62375CFA
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 04:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfGZCZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 22:25:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42078 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfGZCZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 22:25:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so23965725pgb.9;
        Thu, 25 Jul 2019 19:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RwZ2nd8NIwVXWFl0thI1mUWG1z6BKwyLh5lPqCVMwKM=;
        b=tH76H4nwDR85gZNHeXv1/06vCvS8hZ5OqjDFn4E9apHKav+ipxtGHLryKB/NLw6L88
         TL1JxapU5uO33p1dI67q7qGAXpvrfJZj0QvQE2YdctalkuSc647eL9woHMqO9OnoRYpJ
         jQSbzSPrJiYYVWQU2PNvgMwruMfCpMUH0LZXhDPQP0OhTxCJS3NrvNWTjDsjojjC0CKl
         dygRM51arGRIXSgqZH3YXxBGqB5/xcTMZofwTpGIA3qEKn7XW64IM9K5Xwj0Fe2aktrD
         OfEdcg8wlZH8Xmr3nFwv1FSfSRj6PoKjVRTyPlF0WQUdoxH49dC7AhhLqaJTVLHS1jAq
         sQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RwZ2nd8NIwVXWFl0thI1mUWG1z6BKwyLh5lPqCVMwKM=;
        b=aqXC3z/Z9S+jTc0chj4D5ib7LIBt00ZqQ/SxJnVyFa7aPz0a4ylHuAhQ6wIEl8H0pt
         9DI/543OpzisTfbCC9M3oNNKZfdJfipHK5nSk+w0evpe9A8jeTKOCpVNA5uauti7H7OR
         BjjuMNfmqX76+S7zBPLyBbEWAuV23B2pVJjvkkXCHGxqd6Gp9Jy1tR47zCvKJ87SqlmR
         BxoIyL5UQwwmxcdcL8ZxeSvyUmrATNEGPjqc0xjAOYTgeKiXZOH58oatF64iI/POwZuJ
         arb8CNKT75M+fSum7c5F3rUFDiT6HQYEEdVolHMAfRtIuV5hOpLUwqArOwtAPoTOZ2tL
         NpIg==
X-Gm-Message-State: APjAAAWEYOtCWdJ61W6U1lgJuMlUkJn/LeVyjF/uYoEPUTxRgQr7skJH
        NkRF4QyykPy5+BHXfopV2s442Hk1Khk=
X-Google-Smtp-Source: APXvYqyIZD0oSRwFHUaEGuqI7Scj0dcrp1fJmJt67X/39my3vkgesALosIQgoum+BZ9h+vqdI4IDkA==
X-Received: by 2002:a17:90a:cb87:: with SMTP id a7mr98644528pju.130.1564107941933;
        Thu, 25 Jul 2019 19:25:41 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id b190sm41508375pga.37.2019.07.25.19.25.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 19:25:41 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/2] net: ipv4: Fix a possible null-pointer dereference in inet_csk_rebuild_route()
Date:   Fri, 26 Jul 2019 10:25:34 +0800
Message-Id: <20190726022534.24994-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In inet_csk_rebuild_route(), rt is assigned to NULL on line 1071.
On line 1076, rt is used:
    return &rt->dst;
Thus, a possible null-pointer dereference may occur.

To fix this bug, rt is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ipv4/inet_connection_sock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f5c163d4771b..27d9d80f3401 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1073,7 +1073,10 @@ static struct dst_entry *inet_csk_rebuild_route(struct sock *sk, struct flowi *f
 		sk_setup_caps(sk, &rt->dst);
 	rcu_read_unlock();
 
-	return &rt->dst;
+	if (rt)
+		return &rt->dst;
+	else
+		return NULL;
 }
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu)
-- 
2.17.0

