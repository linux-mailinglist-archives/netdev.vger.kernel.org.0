Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3568E468922
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhLEE15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhLEE1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:53 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62681C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:27 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so8253688pja.1
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04CJvPWRnuLLyYSLB8cktrrYL+pcIfcOxTaspl2YSxY=;
        b=ij1w6TgUV477VMwqSXFfX7kT52WDbRXBc/5RUux/M0n7SAQh98UK47gXcqEbtiAplB
         rvm+biqYuLFC3Q6N9BjYxt26+9Ls96PBpAmCX2gFzN0M3oDw5SFaaMy61qalfmhBz0N2
         2QNHnU7DvdvxKA04QhSZ3PQue36YoCvsj/Of6X4ocwSqXfHq9GoHvFlxcLreoQtbEsQf
         nldAjwYoyWYxaDaABx7Jw/IQm2Sn3101/mGpWzCJcJT6kECkeeH7GAS+/qq/RiRSNaU4
         tNGbJrtAlsaXmX7f7pnmlvJmv27V2rCZm6QSndlNpt2I8kVx/L6v2GZ578sL7ZlAQ2Px
         a1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04CJvPWRnuLLyYSLB8cktrrYL+pcIfcOxTaspl2YSxY=;
        b=G20Yb00qQHso5Zgn4jlRKGJFbPsCwTeqrd7fKhHf9UWOhawmQKEBNdKVxxqTzWH9i8
         YC3aOz2Gr/NQkTGVWDWN9id+hJEmm06ZGAplR3xttBv+G35+iSWCanXZrBb4JU6GoGZh
         0lr9OCOprD+tZe1bSbY59tpjBURHrBjRbvWJf1apDZTX7x9FZLpFfy151LvgIOAT2ASn
         IAxdTcWl8Lm9L0D5WWalPn59CMrImB+0eZb+Xmntn+oezgNzuOURke3Z9q09OWGKuMpb
         P3lQg/GzqdxUtvfdMbLUNcwc5wKksoIW9n41bBYM5PiyfFF3UkRYvu2k85/zy/EzfThA
         a06g==
X-Gm-Message-State: AOAM531ISZ1L+HrMnNE5SmQ3zpHO5Cn4bmt+WVubsEqY0tZBN4uk1vOy
        ulGegXkfKfN/LzwjtRJP0Zo=
X-Google-Smtp-Source: ABdhPJwZvgcMtjDb7SMJzIlzwuubTqd7smFWVi1aLrBOmUx/B8mrV3z9fJm1Cf3Q6Hek2BWhKOZnNA==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr26842779pjb.186.1638678267003;
        Sat, 04 Dec 2021 20:24:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:26 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 22/23] ipmr, ip6mr: add net device refcount tracker to struct vif_device
Date:   Sat,  4 Dec 2021 20:22:16 -0800
Message-Id: <20211205042217.982127-23-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/mroute_base.h | 2 ++
 net/ipv4/ipmr.c             | 3 ++-
 net/ipv6/ip6mr.c            | 3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 8071148f29a6ec6a95df7e74bbfdeab5b5f6a644..e05ee9f001ffbf30f7b26ab5555e2db5cc058560 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -12,6 +12,7 @@
 /**
  * struct vif_device - interface representor for multicast routing
  * @dev: network device being used
+ * @dev_tracker: refcount tracker for @dev reference
  * @bytes_in: statistic; bytes ingressing
  * @bytes_out: statistic; bytes egresing
  * @pkt_in: statistic; packets ingressing
@@ -26,6 +27,7 @@
  */
 struct vif_device {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	unsigned long bytes_in, bytes_out;
 	unsigned long pkt_in, pkt_out;
 	unsigned long rate_limit;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260259e5626577e2b2993a6d9967aa6..4c7aca884fa9a35816008a5f3a1a58dd1baf6c06 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -696,7 +696,7 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 	if (v->flags & (VIFF_TUNNEL | VIFF_REGISTER) && !notify)
 		unregister_netdevice_queue(dev, head);
 
-	dev_put(dev);
+	dev_put_track(dev, &v->dev_tracker);
 	return 0;
 }
 
@@ -896,6 +896,7 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
 	v->dev = dev;
+	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 	if (v->flags & VIFF_REGISTER)
 		mrt->mroute_reg_vif_num = vifi;
 	if (vifi+1 > mrt->maxvif)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb88254003720549da52f39b11e9bf911f..a77a15a7f3dcb61c53a86e055b8a1507d9d591f8 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -746,7 +746,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 	if ((v->flags & MIFF_REGISTER) && !notify)
 		unregister_netdevice_queue(dev, head);
 
-	dev_put(dev);
+	dev_put_track(dev, &v->dev_tracker);
 	return 0;
 }
 
@@ -919,6 +919,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
 	v->dev = dev;
+	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (v->flags & MIFF_REGISTER)
 		mrt->mroute_reg_vif_num = vifi;
-- 
2.34.1.400.ga245620fadb-goog

