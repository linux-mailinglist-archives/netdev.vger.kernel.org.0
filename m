Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE294CC4DE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiCCSRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiCCSRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2772A1A363B
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:27 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id s11so5354680pfu.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rdku8wN/DyyUY/n9gocDNJH4wx8eXfzLXshEVqbfILE=;
        b=n1Hf/bZGchm9wabHBlWxJ79qtT3HHE5QY6Xlpr+miZNbnLYI8EQQCfI+qu+yctt+Tf
         xCeqdVl09H6PMUiwEFqqCELyk6XfeLLMamfThKUsgud13A9tZI14Un0W9PYw3vSGQyZu
         8/1MNm7r8ZYMiKG1EegeqDlGtBTSGvIS66WlBayWIt4JoVQdSlV8iGDUv1YFf45IsAVe
         14X0/3rfTzu2uuEj0S9l4McwT/jmCOT75RzBekC2NGEl5tnS20MV2jjouWjJFlBjBzPl
         Xyjwqgqo8Cldc6IevsW/o29w4HoqaZ5+9dvtWcP0nclqwfqQPGmQDa/F3zqXm1TmMgUI
         JXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rdku8wN/DyyUY/n9gocDNJH4wx8eXfzLXshEVqbfILE=;
        b=zbFSZh3exjlhSnLywfcMQPZ2bqKINd/RilWJhOyDArK8IYP8Q7bRThpa1otS35cbIc
         KdxVw+Tky6QGp1LSfYX62LZDyYYDqnxHS87Ntmt/atT3zA+zyoASY9vvNgjHhyB89o/l
         6YARNoqenpxEVvaUExy7fU54AGyf5PQyiagkDEim/XinopwAZh9GugKJMuQsOPhlqszN
         M570lFHK1PpKC2d0oMHeWSwVJhey3cVAbegckQvkAbZTEBMrzZ+gQd4eu74a0Qxyv83v
         EkrhZ4OxhjHTlqXIk06zlBNZjbW8CE0bQ+IBg4MGqlE20wt8XNfnF7hRLk4skWRn3lhT
         mPXQ==
X-Gm-Message-State: AOAM533guBMDMZPbn7KD2R/pLOwGpVBARoxUaWTRAabSB47lOH+C/x0h
        azvTn5qWw2TX2e/AUQn4GKw=
X-Google-Smtp-Source: ABdhPJxbSI77OPieFivUL34oUsE/K1EdNI08cOQaUOcX2wgbhkAxbOhyKRHIT+RHiioQ3zQHAHD/lw==
X-Received: by 2002:a63:90c4:0:b0:37c:7f96:8cdb with SMTP id a187-20020a6390c4000000b0037c7f968cdbmr1463109pge.24.1646331385621;
        Thu, 03 Mar 2022 10:16:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 01/14] net: add netdev->tso_ipv6_max_size attribute
Date:   Thu,  3 Mar 2022 10:15:54 -0800
Message-Id: <20220303181607.1094358-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220303181607.1094358-1-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Some NIC (or virtual devices) are LSOv2 compatible.

BIG TCP plans using the large LSOv2 feature for IPv6.

New netlink attribute IFLA_TSO_IPV6_MAX_SIZE is defined.

Drivers should use netif_set_tso_ipv6_max_size() to advertize their limit.

Unchanged drivers are not allowing big TSO packets to be sent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h          | 10 ++++++++++
 include/uapi/linux/if_link.h       |  1 +
 net/core/dev.c                     |  2 ++
 net/core/rtnetlink.c               |  3 +++
 tools/include/uapi/linux/if_link.h |  1 +
 5 files changed, 17 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 19a27ac361efb64068e2b9954eb85261283b3d60..3b59359b5e4d35f40fb90d594e78cb88befbbcbf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1951,6 +1951,7 @@ enum netdev_ml_priv_type {
  *	@dev_registered_tracker:	tracker for reference held while
  *					registered
  *	@offload_xstats_l3:	L3 HW stats for this netdevice.
+ *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2289,6 +2290,7 @@ struct net_device {
 	netdevice_tracker	watchdog_dev_tracker;
 	netdevice_tracker	dev_registered_tracker;
 	struct rtnl_hw_stats64	*offload_xstats_l3;
+	unsigned int		tso_ipv6_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4898,6 +4900,14 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gro_max_size, size);
 }
 
+/* Used by drivers to give their hardware/firmware limit for LSOv2 packets */
+static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	dev->tso_ipv6_max_size = size;
+}
+
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index ddca20357e7e89b5f204b3117ff3838735535470..c8af031b692e52690a2760e9d79c9462185e2fc9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -363,6 +363,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 5db2443c237132946fd0f3dc095d29711cccec12..aa37d3f2ca1afe53b05b7d71be1dbdccaeca4f6b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10461,6 +10461,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
+	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a66b6761b88b1c63c916fc085f4d9e8523bb0659..864c411c124040e2076289f8714f8b043563408c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1027,6 +1027,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_TSO_IPV6_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1732,6 +1733,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1885,6 +1887,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e1ba2d51b717b7ac7f06e94ac9791cf4c8a5ab6f..441615c39f0a24eeeb6e27b4ca88031bcc234cf8 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -348,6 +348,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
-- 
2.35.1.616.g0bdcbb4464-goog

