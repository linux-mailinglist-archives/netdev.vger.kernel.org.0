Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0404D40DD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiCJFsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:10 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F69AF957C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:10 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r12so3934510pla.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YrYyHNdzE/bZgTw4/T1DAouhykqpGbQHdq//8INO1ZY=;
        b=G2OWFJBcSGzie4ZKrS5oi3Bm7hXuQH+HQbukbMQtaw0recZKHC0BrSKUlc+aGlpZjt
         6pPCxSDSsOjau3NO3pHx59Bm+yR+gERGn7c6Vr6JAnQ5hjuEnhRz6K/HPM9QZ7B0e0cz
         lU7Soz3ZDOywdoGC10RAr+XXLVN1eti/PUQKFTtLQ925fBbEa3SUtkU10nf0TqNgarOc
         EZROsFvCnsnTa05dSnLxBsdV93pr7ksJHIqRunbNRPv0LYHLSCgaS4exEUrHJ4zCvbxS
         xAibBoDQOWblVs7rbjGRskx1CvEWMhApm/pjiCwIwEBxXvrqjRlbnvqwAziDKUasswBC
         3uqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YrYyHNdzE/bZgTw4/T1DAouhykqpGbQHdq//8INO1ZY=;
        b=CDw+3lDkCSwVL9kywcoHeceNeDO3rVC2ZuP2h09ZoiNLLY4UEUMKUnH5pidLjhCLh3
         J4J4fs68s3sYrurNxABMp2dkfRUc6212uxElMhIZkK7DnVIG4qx0ej3EVDzymLhDB1WO
         Jard4DLdS059GsEP10hSrVMjax3H7yRflRO9RFdR+ywrn//9M0hkACp6TBLabh0EJaeK
         0Zskas+d9NBPTOsQaKi1cQgK+6vGf6nh65Qm1fKvadstmKnQuMJXfJjU6jNUUvzVfbdp
         GOl9ONNJs9F+21AWlshM20VT2OGlKVfIVZcM6fBgXOhSpeGY84o2rcoicB574LIEdGIl
         2J0w==
X-Gm-Message-State: AOAM533hvPwFbLGNBfO2WmxSFylFPxpNH6t3rn7OPRI8qWedLdu7zsn+
        62smehpm+p5APjkMCpwbr0A=
X-Google-Smtp-Source: ABdhPJxQsm4zfbnwfjPiaD3DFOUiSyXy1gAOcsrGwqOujXWmIMs8cN1vtinOB78dCz39Rodnb1O2OQ==
X-Received: by 2002:a17:90a:fa95:b0:1bc:509f:c668 with SMTP id cu21-20020a17090afa9500b001bc509fc668mr14219281pjb.189.1646891229940;
        Wed, 09 Mar 2022 21:47:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 01/14] net: add netdev->tso_ipv6_max_size attribute
Date:   Wed,  9 Mar 2022 21:46:50 -0800
Message-Id: <20220310054703.849899-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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
index 29a850a8d4604bb2ac43b582595f301aaa96a0bc..61db67222c47664c179b6a5d3b6f15fdf8a02bdd 100644
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
 
@@ -4888,6 +4890,14 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
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
index ba69ddf85af6b4543caa91f314caf54794a3a02a..de28f634c18a65d1948a96db5678d38e9c871b1f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10467,6 +10467,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
+	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a759f9e0a8476538fb41311113daed998a7193fd..ab51b18cdb5d46b87d4a11d2f66a68968ba737d6 100644
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

