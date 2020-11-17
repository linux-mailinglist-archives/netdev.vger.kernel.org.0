Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F72B5BAC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgKQJTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKQJTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:19:42 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF0C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 01:19:41 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so21621601edj.13
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 01:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=TqMwoXlLGLYY6cUKl8e9D85L5mY2Ccy8ksn24MB45r8=;
        b=XopOFs3zG2ZDLVPf/rH5fmQmJ5erk2jyk3Q0UYyhK1ivmPTkOEGsOawSXdSJhRrC6O
         cRwBlRabVWaK6x24wuUBmaqBqXuG+wmFczA8QJxXFNTppS3ziN5w5HBJCreuUw6Whb9/
         sfc3xTIq0wscAShwDqf7KtBdfrlC3TEmBOqhTqPFRA0wu2+QoBKC+ELcIuPn84SRdaIn
         ID3Wltj+ktblkmHHa0Y69r7oNRyg6xsqkquSihtiR8+4QmR+hEhb8gxXjUOC5X1aIk73
         68RxRezc8VxTCakAm9yMG2Pk68/Alf61y0FO5HerWCEKlu06mAf7PqWODI8gZDJ4VWjQ
         i2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=TqMwoXlLGLYY6cUKl8e9D85L5mY2Ccy8ksn24MB45r8=;
        b=HSxVAp97IyCxfUY//3HghZ7UpOC1WjkjzeV4JA1K4fAYTOW3PJHpfNatRjRHxmwWvV
         UaokES5Vv+GNPmgfdGUAlfYYmFLyYSi7EpIFRz0NlH4fA10nUiX50MOwznCiX2WIAoOc
         ucQDLsHXNo6h2+HArQYoanwB74tOBgTPzaFtChQNKmdfmKCOpe4UGNLcddUVI283f9xz
         n5qIgv2skL0v619RZoS2yjRh32119u8ZoROPoRop+BLwnW147lvhhpj5tDttoyQ8QeD4
         3LVZW+Ip6OgFAGgMmhvDWaMhercF/ccuw82rwru9fqRVxvgnJdeM4FYz4bI4bHtCspgS
         a4Jg==
X-Gm-Message-State: AOAM533LK4JooVeJ1l07S18SwiB1MPzsGi1ycOHmhNY/aF9dBmVCUs6x
        LEH6YfYGMo2CT8VJk1bEyrg=
X-Google-Smtp-Source: ABdhPJyQk+JHV5A2A4NS+s+V24G0nh9XGLlQ2b66jdlMT2KiLJrOGcLx7Pk8iW75CogAaGjjkzXMFg==
X-Received: by 2002:aa7:d34e:: with SMTP id m14mr19156326edr.42.1605604780023;
        Tue, 17 Nov 2020 01:19:40 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id e1sm11799734edy.8.2020.11.17.01.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 01:19:39 -0800 (PST)
Date:   Tue, 17 Nov 2020 10:19:38 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: [PATCH v2] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201117091938.GA562664@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an IPv6 routes encapsulation attribute
to the result of netlink RTM_GETROUTE requests
(i.e. ip route get 2001:db8::).

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv6/route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..d7e94eac3136 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5489,6 +5489,10 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	rtm->rtm_scope = RT_SCOPE_UNIVERSE;
 	rtm->rtm_protocol = rt->fib6_protocol;
 
+	if (dst && dst->lwtstate && lwtunnel_fill_encap(skb, dst->lwtstate,
+	    RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
+		goto nla_put_failure;
+
 	if (rt6_flags & RTF_CACHE)
 		rtm->rtm_flags |= RTM_F_CLONED;
 
-- 
2.25.1

