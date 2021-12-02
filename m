Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FF465CAC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355182AbhLBD0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355170AbhLBD0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:07 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48B2C061758
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:22:45 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v19so19229065plo.7
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3AtGaI5Z9dy79c6BymwnVzO55YEIgeVodtM3Ea3/0D8=;
        b=MShumrO9UeU+aonyjKgYJ2+JJ1SF6XWvMHw+4Itl0I/3INa8QduU5I0qIjbzwCe9Ki
         gmVHh7oVCi8NnrE2Hhi6tHb4tOXWR1UdjOU/ST4EHsF1j84qkoJgE/7pV9VVgG0ZtP9A
         xZpodG4DZDQHXaWB3KR2ELZ+zQqfC6Kr/Vu2XpF1UKmIsJPPQbwj+mSBPGScPbYCRfSj
         GjA+8PyOL42F+mFbJO+0/n44kPfOfdUJJPp2FDkVzhlvGHmk2pHtGsO1hrjY5DPl2eeQ
         UEmSOf0Xthm5A+Z2mkWzqQKaZw4IG+bbQ7Mkt3t19mp7puboz+h9c1Zj/RAJ7sDfpDbx
         TvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3AtGaI5Z9dy79c6BymwnVzO55YEIgeVodtM3Ea3/0D8=;
        b=IiC4v7Tm0VmXFthez0TyVw5Bomaqs8z1F1DiHFygvOGx1APOXjXqwRGbOB2jqeQpUl
         Zgwr6ONWYiajLsP480d0nSsmaehGp/Sxo9PinMhj5gV4NIg3X37Fc2ehOoOMO7oysh59
         z/+/+SBMuh5SA5cLUk37uwXdZ2WjooirxbU860ELzi/HxNj+5u6gvTxTkURf0LYWOqEq
         lmICSKT3Hd5KeFDxjNQxcg+64R6q/zTaQvA5iPPC8TNxcfLtFtdGPoPg7lxiah2kcH/H
         XEJPxfRKu2npJJfTJ5ek7/GPZRFR5uklGiD85iIRqaDolPHFTUUoSzboWcV4i71ivI58
         NaTA==
X-Gm-Message-State: AOAM531y5souy5B6OlTTQWVYFrAkDrxk8Zra/LNNUSZ6PFZhy+cslw/V
        LRt3jL3Tuxkvfpyj3/KCLjE=
X-Google-Smtp-Source: ABdhPJypXFbKcMDQ/lHMbbNnq3zuBKJh31oAinf7KDlolq6+p59JtSBtt7P/zhWOKnqJuOA3VRRLsg==
X-Received: by 2002:a17:903:30cd:b0:141:c6dd:4d03 with SMTP id s13-20020a17090330cd00b00141c6dd4d03mr12551154plc.16.1638415365373;
        Wed, 01 Dec 2021 19:22:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:22:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 11/19] sit: add net device refcount tracking to ip_tunnel
Date:   Wed,  1 Dec 2021 19:21:31 -0800
Message-Id: <20211202032139.3156411-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Note that other ip_tunnel users do not seem to hold a reference
on tunnel->dev. Probably needs some investigations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip_tunnels.h | 3 +++
 net/ipv6/sit.c           | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index bc3b13ec93c9dcd3f5d4c0ad8598200912172863..0219fe907b261952ec1f140d105cd74d7eda6b40 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -104,7 +104,10 @@ struct metadata_dst;
 struct ip_tunnel {
 	struct ip_tunnel __rcu	*next;
 	struct hlist_node hash_node;
+
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct net		*net;	/* netns for packet i/o */
 
 	unsigned long	err_time;	/* Time when the last ICMP error
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 1b57ee36d6682e04085aa271c6c5c09e6e3a7b7e..057c0f83c8007fb0756ca0d3a2231fab8eebaacb 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -521,7 +521,7 @@ static void ipip6_tunnel_uninit(struct net_device *dev)
 		ipip6_tunnel_del_prl(tunnel, NULL);
 	}
 	dst_cache_reset(&tunnel->dst_cache);
-	dev_put(dev);
+	dev_put_track(dev, &tunnel->dev_tracker);
 }
 
 static int ipip6_err(struct sk_buff *skb, u32 info)
@@ -1463,7 +1463,7 @@ static int ipip6_tunnel_init(struct net_device *dev)
 		dev->tstats = NULL;
 		return err;
 	}
-	dev_hold(dev);
+	dev_hold_track(dev, &tunnel->dev_tracker, GFP_KERNEL);
 	return 0;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

