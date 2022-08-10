Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01558E53A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiHJDLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiHJDLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:11:46 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9207B81B03;
        Tue,  9 Aug 2022 20:11:45 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id c20so429023qtw.8;
        Tue, 09 Aug 2022 20:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jHImZVkI//te5SMl1xxH/2vTsjBJiQGrltsOXeaVLiI=;
        b=qyr6zLW6SssRFEFqPcOIUy5mytX++/xNFFW8KTB/D8XOB26CCWcxROaVbSBwKd7SJY
         yNt4b3rzSSJ/6qpZgkMOy8AcvPRP/vHFIvVm9k7nLkfbkCqnkt/Y1rHeeDF3ePZUIpNK
         +D0rXnBDU94s7DlKNGF1AuejkuGRaCd1WNG10KY5gYmybHVgazQ08i3IwkBXrCa7QRwf
         81ASdXIRNRYWQ/leISfXEf9wlqf29Z/9pQrLipXgMhesfhyLrNjHRIwLV/RJ0d0jOwwW
         kwi+UiSG3e/7gspP+UYg2v8H+IzEYjKHcJwrsyQliM1MO0JsHMgTh4FunrhPsJkTFwgS
         7DBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jHImZVkI//te5SMl1xxH/2vTsjBJiQGrltsOXeaVLiI=;
        b=V+lJzizyEx5Ks1Yoae6fJKBVgcPUHQVK4xhAGu+m1fkETPsHehoCZSbwvTscVVt2He
         dUsDMKf3fug4TjfR7cgePCp9I0HC7yv4bLeLhdUM5V02e0hMlOF+nvfL7UCYapzPTsri
         03HR6pw4/zEPpPzMuVdyXESr/onosG/upckA5Sdi6bb7Q95Pelsy22g860BMXNCa5T+V
         Y3fa7iZ//pZsnlwrYHRIFykuQ7ppRzYKyKvkTZvLBtYyIfPTCf0ezFhJlSBCtKQStUnu
         hxWLxP+kkqtVoPf/4EgQT3GdgspiM/tzd/gugdw2vbFvy1qNt47eLDY65QPGPf/Hlgay
         0XvA==
X-Gm-Message-State: ACgBeo2/+7eDA9xapHFZDemiDKnIEf2SFTLgYbAFpHBkXachg2LGjFnQ
        JSKa9aWVTn51k0WSOF1c8Zs=
X-Google-Smtp-Source: AA6agR5GcL2nzCCbEs2bEZF2oOhnRYZYjbwaoWVZ3Dt4sEaXubBDo+1+/VJuliIk++TpsY+/X6BvyA==
X-Received: by 2002:a05:622a:1b01:b0:343:582f:3e07 with SMTP id bb1-20020a05622a1b0100b00343582f3e07mr1200591qtb.578.1660101104647;
        Tue, 09 Aug 2022 20:11:44 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id i4-20020a05622a08c400b00342b7e4241fsm9743926qte.77.2022.08.09.20.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 20:11:44 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 1/3] net: core: export call_netdevice_notifiers_info
Date:   Tue,  9 Aug 2022 23:11:19 -0400
Message-Id: <b5f740fac8d95cd663a2a21e8ac2ab9ffd06d3c0.1660100506.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
References: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
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

When a bridge binding flag is changed for a vlan interface, the
vlan_dev_change_flags function in the 8021q module is called. Currently, this
function only sets the flag for the vlan interface and returns, which results in
a buggy behavior; it also needs to let the bridge module module know that upper
device for the bridge has changed by propagating NETDEV_CHANGEUPPER event. This
event can be triggered using call_netdevice_notifiers_info function, so export
this function.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/dev.c            | 7 +++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2563d30736e9..d17ef56c8a06 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2898,6 +2898,8 @@ netdev_notifier_info_to_extack(const struct netdev_notifier_info *info)
 }
 
 int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info);
 
 
 extern rwlock_t				dev_base_lock;		/* Device list lock */
diff --git a/net/core/dev.c b/net/core/dev.c
index 30a1603a7225..50e7483946e0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -160,8 +160,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 
 static int netif_rx_internal(struct sk_buff *skb);
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info);
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack);
@@ -1927,8 +1925,8 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
  *	are as for raw_notifier_call_chain().
  */
 
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info)
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info)
 {
 	struct net *net = dev_net(info->dev);
 	int ret;
@@ -1944,6 +1942,7 @@ static int call_netdevice_notifiers_info(unsigned long val,
 		return ret;
 	return raw_notifier_call_chain(&netdev_chain, val, info);
 }
+EXPORT_SYMBOL(call_netdevice_notifiers_info);
 
 /**
  *	call_netdevice_notifiers_info_robust - call per-netns notifier blocks
-- 
2.25.1

