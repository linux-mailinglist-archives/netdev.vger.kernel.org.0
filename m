Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AAD67EA3D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjA0QBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbjA0QAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:17 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C746841AE
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:10 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id s4so4353833qtx.6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYcQMbnIgjsq+2qoHJRXRTXFWfa6vSS9/8tTjeYDvZc=;
        b=l/AeVhDcrjtzX/lPFsK19b49/Q/JTsHD5XKyw1tjeUGGjKweu6et02j9LpjZwRsOXJ
         QbpR26b6UjcAyPJTKQx6J3F+FNx8IWlFcZnUCRGGCRDJtpo+0FlYztj5waLhOrAeD7ZN
         SJFnEMQD9ffqmNDv73teojSVp3Yv0Dxkymbrzw0nSFvyFTbHsG45y99urqU+Y45AHifR
         0o+IQe6pw3aL5X03XsBREHm366OaDdQEStB5hDMCSriGmsVgd+XxfwU2I03OPdeSlqw1
         dxiTXeHiowN+d1YjMQIKSexLJupopMDKuT3RmdpMDxNsPSbolMxvBHvF55gnrWSChuRD
         /0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYcQMbnIgjsq+2qoHJRXRTXFWfa6vSS9/8tTjeYDvZc=;
        b=bkB9vyz0tEESWPVgwqCRnJhlCN4qNUsu9ERvabu1v7siPyF+W5H7/x82iswYyN2lui
         wOmcB8t0GftOeoVsTsYUTLBrwZkC3Yo1i/Nq45oabPk/Nzs2j6IY3xv4pZki2lbQhcUC
         H7YDnPxgmbgZ1Mp/6F5JBuQajEkhS+9lKjBINZ/MV890QLvBIIEjiTEx/UlYe6cFW6FP
         uFqOmezxGvCg00toWt9Nca9KMPxXCJivpERylbbkbw+B3Bc2H3f6MZSRuSb43j2FGIhG
         RIk9TO+TmM31v1FfTyxi4IqqsklxcT9o2zrSlkrxIk+i2Jbqqex73xE+l6o2+sKjgpTW
         Be6g==
X-Gm-Message-State: AFqh2kpC+1LjrokhZKup/gieWkIVwiry8Z99gE4I73KSAO5cFhG7d2sx
        GZRCvW8nD94q80WdtTNxWcsYkQds8rr5sw==
X-Google-Smtp-Source: AMrXdXsgj4w2wvKcvwQdGh24//vbwzT3JLlnj0hxS/35rnZII3142jzuJE6akgaw4K/iPJSwwqCYTw==
X-Received: by 2002:ac8:5707:0:b0:3b1:80ab:38e with SMTP id 7-20020ac85707000000b003b180ab038emr76912718qtw.0.1674835209193;
        Fri, 27 Jan 2023 08:00:09 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv3 net-next 09/10] net: add gso_ipv4_max_size and gro_ipv4_max_size per device
Date:   Fri, 27 Jan 2023 10:59:55 -0500
Message-Id: <905adccfe82888a8f0ca05fe6f2abd7e3a9649a0.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
per device and adds netlink attributes for them, so that IPV4
BIG TCP can be guarded by a separate tunable in the next patch.

To not break the old application using "gso/gro_max_size" for
IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
in netif_set_gso/gro_max_size() if the new size isn't greater
than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
userspace doesn't realize the new netlink attributes.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/netdevice.h    |  6 ++++++
 include/uapi/linux/if_link.h |  3 +++
 net/core/dev.c               |  4 ++++
 net/core/dev.h               | 18 ++++++++++++++++++
 net/core/rtnetlink.c         | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 64 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 63b77cbc947e..ce075241ec47 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2010,6 +2010,9 @@ enum netdev_ml_priv_type {
  *			SET_NETDEV_DEVLINK_PORT macro. This pointer is static
  *			during the time netdevice is registered.
  *
+ * 	@gso_ipv4_max_size:	Maximum size of IPv4 GSO packets.
+ * 	@gro_ipv4_max_size:	Maximum size of IPv4 GRO packets.
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2362,6 +2365,9 @@ struct net_device {
 	struct rtnl_hw_stats64	*offload_xstats_l3;
 
 	struct devlink_port	*devlink_port;
+
+	unsigned int		gso_ipv4_max_size;
+	unsigned int		gro_ipv4_max_size;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1021a7e47a86..02b87e4c65be 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -374,6 +374,9 @@ enum {
 
 	IFLA_DEVLINK_PORT,
 
+	IFLA_GSO_IPV4_MAX_SIZE,
+	IFLA_GRO_IPV4_MAX_SIZE,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9c60190fe352..45e955eadca4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3001,6 +3001,8 @@ void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
 	dev->tso_max_size = min(GSO_MAX_SIZE, size);
 	if (size < READ_ONCE(dev->gso_max_size))
 		netif_set_gso_max_size(dev, size);
+	if (size < READ_ONCE(dev->gso_ipv4_max_size))
+		netif_set_gso_ipv4_max_size(dev, size);
 }
 EXPORT_SYMBOL(netif_set_tso_max_size);
 
@@ -10610,6 +10612,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_LEGACY_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_LEGACY_MAX_SIZE;
+	dev->gso_ipv4_max_size = GSO_LEGACY_MAX_SIZE;
+	dev->gro_ipv4_max_size = GRO_LEGACY_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
 	dev->upper_level = 1;
diff --git a/net/core/dev.h b/net/core/dev.h
index 814ed5b7b960..a065b7571441 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -100,6 +100,8 @@ static inline void netif_set_gso_max_size(struct net_device *dev,
 {
 	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
 	WRITE_ONCE(dev->gso_max_size, size);
+	if (size <= GSO_LEGACY_MAX_SIZE)
+		WRITE_ONCE(dev->gso_ipv4_max_size, size);
 }
 
 static inline void netif_set_gso_max_segs(struct net_device *dev,
@@ -114,6 +116,22 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
 {
 	/* This pairs with the READ_ONCE() in skb_gro_receive() */
 	WRITE_ONCE(dev->gro_max_size, size);
+	if (size <= GRO_LEGACY_MAX_SIZE)
+		WRITE_ONCE(dev->gro_ipv4_max_size, size);
+}
+
+static inline void netif_set_gso_ipv4_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* dev->gso_ipv4_max_size is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_ipv4_max_size, size);
+}
+
+static inline void netif_set_gro_ipv4_max_size(struct net_device *dev,
+					       unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_ipv4_max_size, size);
 }
 
 #endif
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 64289bc98887..b9f584955b77 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1074,6 +1074,8 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GSO_IPV4_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_GRO_IPV4_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
@@ -1807,6 +1809,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_GSO_IPV4_MAX_SIZE, dev->gso_ipv4_max_size) ||
+	    nla_put_u32(skb, IFLA_GRO_IPV4_MAX_SIZE, dev->gro_ipv4_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
 	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
 #ifdef CONFIG_RPS
@@ -1968,6 +1972,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 	[IFLA_ALLMULTI]		= { .type = NLA_REJECT },
+	[IFLA_GSO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_GRO_IPV4_MAX_SIZE]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2883,6 +2889,29 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE]) {
+		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]);
+
+		if (max_size > dev->tso_max_size) {
+			err = -EINVAL;
+			goto errout;
+		}
+
+		if (dev->gso_ipv4_max_size ^ max_size) {
+			netif_set_gso_ipv4_max_size(dev, max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE]) {
+		u32 gro_max_size = nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]);
+
+		if (dev->gro_ipv4_max_size ^ gro_max_size) {
+			netif_set_gro_ipv4_max_size(dev, gro_max_size);
+			status |= DO_SETLINK_MODIFIED;
+		}
+	}
+
 	if (tb[IFLA_OPERSTATE])
 		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]));
 
@@ -3325,6 +3354,10 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
 	if (tb[IFLA_GRO_MAX_SIZE])
 		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE])
+		netif_set_gso_ipv4_max_size(dev, nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]));
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE])
+		netif_set_gro_ipv4_max_size(dev, nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]));
 
 	return dev;
 }
-- 
2.31.1

