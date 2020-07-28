Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2755A22FF5D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgG1CN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgG1CN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 22:13:56 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07119C061794;
        Mon, 27 Jul 2020 19:13:55 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so17336662qkg.5;
        Mon, 27 Jul 2020 19:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=YDVBsGb32WAV2bYPhkkBngeiB34L97VYqUXiSzFh1lk=;
        b=mxAMaYUg2RZAVGiCQwhbSk+BbkhCj3V/1vQFy0hg/JrUNCod4W4bLz6qjqVk11P2T3
         N3KVmoQf5BNzWyGkHZgBtFyq5QYQ+dnDTkgLodO686VdG7X8Ay5XBu4z7w2lpm38BwmM
         GGvGkrZAtdCxueoV8mXFvbBYeAfOOXM9deFkG8hkwv4t8Yac947E3blsU8l7mhFl1Xva
         qoGkV6DK3x4SaT+ZdNzzVHV+ir5MVGKmRRPVDBfU7Sz3Uq+V0mcwYDtshREOBLrLxpqx
         PWDBPw+a8HEi0wXfcYair4oWDYTlnkUfc+AQkMUoeY4YQGtjQ4HIpZnURmkUZXNbyptF
         uVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=YDVBsGb32WAV2bYPhkkBngeiB34L97VYqUXiSzFh1lk=;
        b=Wi7WB3COJDTOQeNEqSeZlnrvXHL9Uol9l6y+1ef40av1ZxGgu12U+v3/GSAkESIAWb
         qj7FJvteJLYf7eWPbfySnoz9T7I1zP/3AzU4MKbTJYPytuItI4ubQFx9+p+ecHlkSwsf
         jcUZBjXvDWkjTICWzm2yqXIETkJAZHVdlbrHzlNw+HMh7FEF9d03MzoaGrXiG0CKsVrE
         Lku7nPYOk5YhSXVPSY3JOLubZnrE2sDPLkNJMbDVB7XOLuz2luONSsRf934ws3sZ9xze
         qKLU1tfJ6o3Cfw5jjbj5SpG1QVjy6Mmb101PepHFd1u3+IsQhNdFguOiJMyfDtGBjg5c
         9Axw==
X-Gm-Message-State: AOAM530LTSU9egFRWp3qm7SdjMXzNje1qQTTsBfP6/CLQs7mJ8XdR1LQ
        4ClEDv3s6HQM62j9476xjYY=
X-Google-Smtp-Source: ABdhPJzx2tSN8MONHs72U24IlF2aRfDocwZkLq/vYpS7GSHxZ1RujP1jHKPXNMNKvaSdvyrzvSBcaQ==
X-Received: by 2002:a37:916:: with SMTP id 22mr26744240qkj.231.1595902435137;
        Mon, 27 Jul 2020 19:13:55 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:1c07:59d3:2e55:8338])
        by smtp.googlemail.com with ESMTPSA id o39sm17475262qtj.0.2020.07.27.19.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 19:13:54 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
Date:   Mon, 27 Jul 2020 22:13:48 -0400
Message-Id: <20200728021348.4116-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200727033810.28883-1-gaurav1086@gmail.com>
References: <20200727033810.28883-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add return to fix build issue. Haven't reproduced this issue at
my end. 

My hypothesis is this: In function: ip6_xmit(), we have
const struct ipv6_pinfo *np = inet6_sk(sk); which returns NULL.

Further down the function, there's a check:
if (np) hlimit = hp->htop_limit 

Further, we have a call
ip6_flow_hdr(hdr, tclass, ip6_make_flowlabel(net, skb, fl6->flowlabel,
ip6_autoflowlabel(net, np), fl6)); . 

Hence np = NULL gets passed in
the function ip6_autoflowlabel() which accesses np-> without check which
may cause a segment violation.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/ip6_output.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8a8c2d0cfcc8..94a07c9bd925 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -181,10 +181,10 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
 {
-	if (!np->autoflowlabel_set)
-		return ip6_default_np_autolabel(net);
-	else
+	if (np && np->autoflowlabel_set)
 		return np->autoflowlabel;
+	else
+		return ip6_default_np_autolabel(net);
 }
 
 /*
-- 
2.17.1

