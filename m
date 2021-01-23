Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4090D301833
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbhAWUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbhAWUAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:12 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A85EC061356
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:38 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id q8so12291039lfm.10
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7DFWD5qel0j71Y8L6cBxsrwCWoQdL04CuvfzZDaeHcM=;
        b=yvQ4uXsDAYfBJkqlT3MyUl0ZBWVUe01nRz+N1+GR2Q9k5tOy+KLft+1CmVfGwETzk8
         CnU5ppyuQkrPRCE506yn5BR+SNXxMH9AZJ3rgriBKF73227uHGz3t7hasIGg5xacFwqt
         NONIsukcXXFamEDgk23K8GVYMo+6ERkao3tiLcExrIA3ysTfg9zNU+kVCoR1l+EjBU39
         GsNLdcCdsFOi7fMbvOd4NsX+gD6uRoKB950DfZcoHHN7FoMj8sD0plIK6EDQb2gfoGwB
         flKw+AwBAMeHzssduzH6yVov90Y7A8bD61n3gXvlHttpgIMlVj4IV9QeCRTDT34CiOJd
         Wj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DFWD5qel0j71Y8L6cBxsrwCWoQdL04CuvfzZDaeHcM=;
        b=bxj/iZEAa0NbL8+yVUs0AgPa92REEvu9lQMuM4hmKz5QIPzoZU5IETh+VyodfLHywz
         k+pagXEkZVfsknf11SM5/Zmr0aPRpNTI6QQrvPMcvRgmEHY/S2M7BnHjCHb7KkYmzoRP
         y6emZZN8q8olQXFo8AHhyMT1HXDpXUNLMLL2yE+bwl6d9OhOP/IVgAsGP2utkOz1nRYz
         E/QFdvupRBpAXZmBn1EeLbeYX8Y5zPj/uhAnljrcOcCKeiUNFFFrxMuE+/loPZzsIhRe
         yOuMVlJFVWqXsj3Sy4wDNO97haNHH4Hco3PkzetI5WvfQ9UeidcLJfbDDUaYmnHp9XfP
         lu0Q==
X-Gm-Message-State: AOAM533G0TzzOuozH2gNJDoqFbYR8KPrbHzsbX9DJOiqWJ/s5UKbujcU
        GJf6ZvqRW64EzXOAdKSajdatng==
X-Google-Smtp-Source: ABdhPJwiJKhcP2K7kCf+vgV44yBD/7o0EmM5/7HcAQKxjsHM7IE6QOJ1m8h9RqJohY1x4I/O9cCnnQ==
X-Received: by 2002:a05:6512:3157:: with SMTP id s23mr29733lfi.275.1611431976944;
        Sat, 23 Jan 2021 11:59:36 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:36 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 08/16] gtp: set dev features to enable GSO
Date:   Sat, 23 Jan 2021 20:59:08 +0100
Message-Id: <20210123195916.2765481-9-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4a3a52970856..df2f227680eb 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -532,7 +532,11 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(r))
 		goto err_rt;
 
-	skb_reset_inner_headers(skb);
+	r = udp_tunnel_handle_offloads(skb, true);
+	if (unlikely(r))
+		goto err_rt;
+
+	skb_set_inner_protocol(skb, skb->protocol);
 
 	gtp_push_header(skb, pctx, &port);
 
@@ -614,6 +618,8 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_LLTX;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
+	dev->features	|= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
 	netif_keep_dst(dev);
 
 	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
-- 
2.27.0

