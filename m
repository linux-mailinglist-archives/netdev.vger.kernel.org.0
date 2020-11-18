Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B72B8030
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgKRPOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgKRPOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:14:40 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15ADC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:14:39 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id w13so3204354eju.13
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dQYxPgqJKHoyWomXmxrytC+kAd3PRIYMJZ4helooJzE=;
        b=R113tc6FCKnGKdt8tRnwQYUnSlD4AFHLLnHiUnNwg2jJMVosSMM2Zye4FFAAkKaei6
         IHarykQcFpYKe0DTqMPEz4TqGEvAAH0vI4VSmSL/bjV0H5bpCv1YFhF+1ZBn6OHPQEfH
         1hVww+X3vtFj2jxgygoGQxG59yBTP63z3VeEPeP9q+buG1YQtyhhblXMKcZG/Mx02v4i
         HsunwNtseY6S1yQIkJtg3rG7pIFoT0ex75maJiWJE1vrIVK4ddDdi671utTA+oZx+cH+
         J9dS5DXyfP7Esj/ToC4EZwSCc/eE4RptGfso9ayZ996REOkYFU78jc87lCjBMcHev6/b
         5P8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dQYxPgqJKHoyWomXmxrytC+kAd3PRIYMJZ4helooJzE=;
        b=tzeD1fVIpolBeWud6UaMHJU+dZyr3ewGzQJrD3pQhELCjjger3Gn3rurajY0aILb/f
         C8EF9xFJWTqGxBKiiskZEFeYx6Xdbi8fJmhpJqf/tomqUXHwQ9+Wco+DqgI9ueiUlYDC
         fHp7YIFD/wBLPmNtNXV8Bz63+iccNtLEycI2TZjKm/hq2kgENM8cyNSSPfbdz48SKyDA
         yAvlPzJ1+FYd9v5bBAgAfAOJTZ+2qzdZI74SSlzfcAogcARce6Ets7hGWqDDeLY0PmCv
         f4UTa/1svJT59Hf8vl8Q15AQEVCP1k1IKjMML8aENdo4ny+pN3tiEuG+o6K/YSY3hBJ6
         2G7Q==
X-Gm-Message-State: AOAM530nrXeuTqXDhEjOeePVtkJF3UPDyEwwBrexn3UMUx6yGIKPEfFC
        TslTjlkINLEEXMHwIfHXYTs+sLGtGBcJ4w==
X-Google-Smtp-Source: ABdhPJygs0NsgH1/I7STX/6o4s3UWq8CmvNlHQ//WPdqq0oBNbRxIi+rDmD8V/sct6FTK4ByvAEabA==
X-Received: by 2002:a17:906:892:: with SMTP id n18mr23597024eje.1.1605712478310;
        Wed, 18 Nov 2020 07:14:38 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id y25sm10668630eje.52.2020.11.18.07.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 07:14:37 -0800 (PST)
Date:   Wed, 18 Nov 2020 16:14:36 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: [PATCH v3] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201118151436.GA420026@tws>
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
index 7e0ce7af8234..64bda402357b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5558,6 +5558,10 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 		if (dst->dev && nla_put_u32(skb, RTA_OIF, dst->dev->ifindex))
 			goto nla_put_failure;
+
+		if (dst && dst->lwtstate &&
+		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
+			goto nla_put_failure;
 	} else if (rt->fib6_nsiblings) {
 		struct fib6_info *sibling, *next_sibling;
 		struct nlattr *mp;
-- 
2.25.1

