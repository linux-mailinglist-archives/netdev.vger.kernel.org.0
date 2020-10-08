Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1FD286D2D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 05:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgJHDbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 23:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 23:31:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032CBC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 20:31:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o9so2060382plx.10
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 20:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qYTaebhwD+erOEN/Ss5QNd8/JzEr8NVtI+Cry0U9/J4=;
        b=mLp0RlTxXt5NrvVoQ09KJNfQjdHfvuzfFZBeaPQVKQInYeJLNO3OqQ9ANqhcBDE8Cr
         rbthLngDlSZsznmQVg7+ELG4wMygZ12Hv0Op268BsIHxXnaMRnbt0dxhmC3PEd9AcKns
         BeQBvdMt4RbmHf83AHxmVvJ4r20ZlqtUTsi6gLoyqjTpwQFsabfOjB1CJfhh2yCcbQnD
         z76Dr+qqdHwrgPOCTXSY5APtDk64kt2aeJprlYnaS2tI3OowjUV0QMpFPNsawj80N2QM
         PG21Iqv76v8N2MtwkA4n7qP8s+wdKLEoPJv9hfJjZS6kiP4Ozk2RjYu0YK3V29uQIHn7
         HEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYTaebhwD+erOEN/Ss5QNd8/JzEr8NVtI+Cry0U9/J4=;
        b=Nrr/7Dc2B03eBOPQcWIWhEJgugjryEh6g2oAtUEnMezgMW+7J3c2/lhuQmyr67PYVl
         qYaJr9ELA3BqI9yyEcf3QffeiiCDO9/rteQaTnJWhc9UBjIm48iOvIKgmezIuhWOjl7S
         s/TMq+e3+NnHyHbdT79h98bmlzKUcd5nHXP9hWmeb6XreVro+v8DsbbzCmmoBlQEwNge
         sc/SOZzxdfEk6c1RqGcv10HMbTyb6w69S88HSK2vxZMPwdMPcm3zPxWySYhoUlYYGsfZ
         ZjKJyIHpnzCsuqQNdtBHS2i7f8m5XrI1Yaxoy+GwosAs11338EU7AE0V31JZZaxFDxm7
         Sp+g==
X-Gm-Message-State: AOAM532hDdSm6jBQQLRDqqL6HNQ0JKkA8lE7XnJMdDFWmeU9lQTHKDWv
        Ezq9HCaQ0uYfhY+9Kw+oNDQ=
X-Google-Smtp-Source: ABdhPJyq5t4/i6HJfeHcR5f2VKgFGMUifCI4Kw+mey/s5CzfmYfBAgpY7jT3ieMdVAQnUn/yBEBTpg==
X-Received: by 2002:a17:902:8ec7:b029:d2:42fe:37de with SMTP id x7-20020a1709028ec7b02900d242fe37demr5557902plo.23.1602127874522;
        Wed, 07 Oct 2020 20:31:14 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id 32sm5241161pgu.17.2020.10.07.20.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 20:31:13 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Subject: [PATCH 2/2] net/ipv6: ensure ip6_dst_mtu_forward() returns at least IPV6_MIN_MTU
Date:   Wed,  7 Oct 2020 20:31:02 -0700
Message-Id: <20201008033102.623894-2-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20201008033102.623894-1-zenczykowski@gmail.com>
References: <20201008033102.623894-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is basically just a refactor.

But it does affect (a presumably buggy) call site in:
  net/netfilter/nf_flow_table_core.c
  flow_offload_fill_route()

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip6_route.h | 4 ++--
 net/ipv6/ip6_output.c   | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 598415743f46..25c113dd88ea 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -313,14 +313,14 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 	struct inet6_dev *idev;
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 	if (mtu)
-		return mtu;
+		return max(mtu, (unsigned)IPV6_MIN_MTU);
 
 	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
 	mtu = idev ? idev->cnf.mtu6 : IPV6_MIN_MTU;
 	rcu_read_unlock();
 
-	return mtu;
+	return max(mtu, (unsigned)IPV6_MIN_MTU);
 }
 
 u32 ip6_mtu_from_fib6(const struct fib6_result *res,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c78e67d7747f..bc85f92adaf9 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -540,8 +540,6 @@ int ip6_forward(struct sk_buff *skb)
 	}
 
 	mtu = ip6_dst_mtu_forward(dst);
-	if (mtu < IPV6_MIN_MTU)
-		mtu = IPV6_MIN_MTU;
 
 	if (ip6_pkt_too_big(skb, mtu)) {
 		/* Again, force OUTPUT device used as source address */
-- 
2.28.0.806.g8561365e88-goog

