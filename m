Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87A74A7D88
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348882AbiBCBvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348879AbiBCBvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:51:50 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCFEC06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:51:50 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c9so850944plg.11
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oV0fi9GS3SaAqPwzk0bWOCbVQRtAVmVJxhvUNTGK350=;
        b=TraCUdNXgqS4FenbPHwXuPODP2OaK5EUXj+M5iHp1dgk+uoM/NxU5ncgup4bYmbUbn
         /V7uPRVZrZ5C5/tkjo0g2NK2w9wnBu9r4zvN40dNDg2vmOrt0P7ubQskhfATKLB3UcmA
         XCs+truRlYSqLx1he+YFNWzCZPSydIOwcG5f9dplzM6SJNaxiZyR1LSj1ywhTkCi//3E
         FWSNVEpyxlEAoWqbjRYvUk1zobzrUQW+kcFo6//O0oJZEFn3E4zqT+zrKViDmnn18gJ0
         KsZpdo1NFu7CJAD+fo3iuxSw/YoXNJ9NDiJML7V7g5HNfX/Nn9AUsLyPqw31shoXQ4mA
         ECMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oV0fi9GS3SaAqPwzk0bWOCbVQRtAVmVJxhvUNTGK350=;
        b=ZzVDGhCOokLp3sRLS8c6eLWnJGDcG4HqCmKFdZyCNUXM6YxUZ78inwtsAHJvRHohZZ
         PgRzXQgccqG5lHUqKIKk+Xpty/Jvycgxg/YPT5V/I2XEVZdwvBZ2jeAVaq2aYU2RYBgq
         OQ4L5NTk5Lac1fmhfmOV3GvC5NGO/xBLUDzO+13PN7eUKgdC4l/mtHHoybuhUTml2NHM
         o949I6kU9mxTCL5BMl1NMwczH3v7jOxYhzq2Ca4lIUeEm0r6/eGtx5xgOoYgR+tv6CAj
         GuUQebQXTI4KCgPex+NgiKCJSa3zLfDHv/HQlz3zLB0j/tjcos+EbLX07qrPNpIP0fe3
         A+3w==
X-Gm-Message-State: AOAM531DnoO0Ismv+p/MqJtOIt8OL8qXo17JEitzprYRO5iLIeFG3Tmq
        SyuE+6n8lIcRZPQdPKmAUBw=
X-Google-Smtp-Source: ABdhPJxlg2rLy8ujq+p5Z0oroPvLWs426IFsTCuBGABqPqY/zuexmhJtnFNbVdMOUNLWIzPkAP3e3w==
X-Received: by 2002:a17:902:dac9:: with SMTP id q9mr33692603plx.5.1643853109896;
        Wed, 02 Feb 2022 17:51:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:51:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/15] net: add netdev->tso_ipv6_max_size attribute
Date:   Wed,  2 Feb 2022 17:51:26 -0800
Message-Id: <20220203015140.3022854-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index e490b84732d1654bf067b30f2bb0b0825f88dea9..b1f68df2b37bc4b623f61cc2c6f0c02ba2afbe02 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1948,6 +1948,7 @@ enum netdev_ml_priv_type {
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
  *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
+ *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2282,6 +2283,7 @@ struct net_device {
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
 	netdevice_tracker	watchdog_dev_tracker;
+	unsigned int		tso_ipv6_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
@@ -4818,6 +4820,14 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
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
index 6218f93f5c1a92b5765bc19dfb9d7583c3b9369b..79b9d399cd297a1f79dca5ce89762800c38ed4a8 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -348,6 +348,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_IPV6_MAX_SIZE,
 
 	__IFLA_MAX
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65f9bcf88a6d73e2c9ff741d33c18..b6ca3c348d41a097baf210f2a5d966b71308c69b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10188,6 +10188,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
+	dev->tso_ipv6_max_size = GSO_MAX_SIZE;
+
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e476403231f00053e1a261f31a8760325c75c941..4cefa07195ba3b67e7b724194b5d729d395ba466 100644
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
@@ -1730,6 +1731,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_IPV6_MAX_SIZE, dev->tso_ipv6_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1883,6 +1885,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_TSO_IPV6_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 6218f93f5c1a92b5765bc19dfb9d7583c3b9369b..79b9d399cd297a1f79dca5ce89762800c38ed4a8 100644
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
2.35.0.rc2.247.g8bbb082509-goog

