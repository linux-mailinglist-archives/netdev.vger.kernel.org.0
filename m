Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01834AEC0E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbiBIIUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiBIIT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:19:56 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F166BC05CB82
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:19:59 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id p7so1183980qvk.11
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 00:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ugFbCfvGmcJBACcTLS7UCyTobcismt6IcYHAvw06J0=;
        b=D1+gYjmSJPm0d+dtsurtz6DimxuYq4Nihia6kLEgLKfZ6oWSHyzk0cvjgM8rfzzZCQ
         rDXVaEk9du4iP5oTBrl2wPNh6csdpDfNlcwRPlf3pLiQsCAFVo7FO2X6wyiKDvCZCoD8
         8Kxrm7a/SfdnJ0VOlcP5dVNbEROZwK5zM/o41Edg3phIn+JMxKwaLeHT7XfRNzqkbUtF
         uK43suNyA0d6+shErcLzKIenjS5u4NBPnPkFKlkdFLsbHz+byqtMUsEUuCEAtx9Hxjdp
         GGxIt5zGXEC4EbLOuwF4XtKeP2CNcO//fAcu4FYnVmHfPaPB69czLSAXYyDXr/34DNaz
         4gFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ugFbCfvGmcJBACcTLS7UCyTobcismt6IcYHAvw06J0=;
        b=ja/2dN6wma5oFsKpuodiq0gsXk0537gjyK+/nchNSiWp9tI7uL4Low+IIZUVv9hu1c
         WXltQupYQ0ZBo5SucbcuegRwb2ZDJ18OJwHvu+CBGvn+T0ZSjlQODZBnj+UDMRyzO9KX
         Ci5zc2CfiDbIJh5Zp3Kc5T6jtvjGZGrOk0CBST4xfo5Ft5184bGsYEjYkXkuskMbmeT2
         rSeO4dBQvHMalkg77xayzRSuqM0QkhNm+0V/k70x6D25FQVAv79ktXcUOFAS54lTUUt5
         nCzYb8ayfVMIjb3WGFgQ6fxxA0FCgck/455Uc0cMCobQ+g/5xbbVMTJ+mn7SN5Ex3tNu
         Bf+g==
X-Gm-Message-State: AOAM53250ET384eWiCo96f7gdOpUJY6yVT/pw4+KyHEMuhayy/qLsiFp
        qjeV2IyaYUd+Nuvl0v9514lhVV2GmiqtjQ==
X-Google-Smtp-Source: ABdhPJzHS7IQBDnfOIbDBSpIs7wnk3tHRvSEWS7b85QQaCIbo4E7YLa//J6Bl4tU6rilT7TOWbo89w==
X-Received: by 2002:a05:6214:5298:: with SMTP id kj24mr712104qvb.67.1644394798962;
        Wed, 09 Feb 2022 00:19:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x18sm8837717qta.57.2022.02.09.00.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:19:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH net 1/2] vlan: introduce vlan_dev_free_egress_priority
Date:   Wed,  9 Feb 2022 03:19:55 -0500
Message-Id: <b5aaacdb995efbca70ae85b748828171d0029bc2.1644394642.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1644394642.git.lucien.xin@gmail.com>
References: <cover.1644394642.git.lucien.xin@gmail.com>
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

This patch is to introduce vlan_dev_free_egress_priority() to
free egress priority for vlan dev, and keep vlan_dev_uninit()
static as .ndo_uninit. It makes the code more clear and safer
when adding new code in vlan_dev_uninit() in the future.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/8021q/vlan.h         | 2 +-
 net/8021q/vlan_dev.c     | 7 ++++++-
 net/8021q/vlan_netlink.c | 7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 1a705a4ef7fa..5eaf38875554 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -129,6 +129,7 @@ void vlan_dev_set_ingress_priority(const struct net_device *dev,
 				   u32 skb_prio, u16 vlan_prio);
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
+void vlan_dev_free_egress_priority(const struct net_device *dev);
 int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
 			       size_t size);
@@ -139,7 +140,6 @@ int vlan_check_real_dev(struct net_device *real_dev,
 void vlan_setup(struct net_device *dev);
 int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack);
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head);
-void vlan_dev_uninit(struct net_device *dev);
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 26d031a43cc1..e5d23e75572a 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -622,7 +622,7 @@ static int vlan_dev_init(struct net_device *dev)
 }
 
 /* Note: this function might be called multiple times for the same device. */
-void vlan_dev_uninit(struct net_device *dev)
+void vlan_dev_free_egress_priority(const struct net_device *dev)
 {
 	struct vlan_priority_tci_mapping *pm;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
@@ -636,6 +636,11 @@ void vlan_dev_uninit(struct net_device *dev)
 	}
 }
 
+static void vlan_dev_uninit(struct net_device *dev)
+{
+	vlan_dev_free_egress_priority(dev);
+}
+
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 0db85aeb119b..53b1955b027f 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -183,10 +183,11 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 		return -EINVAL;
 
 	err = vlan_changelink(dev, tb, data, extack);
-	if (!err)
-		err = register_vlan_dev(dev, extack);
 	if (err)
-		vlan_dev_uninit(dev);
+		return err;
+	err = register_vlan_dev(dev, extack);
+	if (err)
+		vlan_dev_free_egress_priority(dev);
 	return err;
 }
 
-- 
2.27.0

