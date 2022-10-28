Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3F610C6B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJ1InN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1InJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:43:09 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF41C5A44
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:43:05 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id o8so3638604qvw.5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Lf/psRwX7p94u6q+A00cEDXXTb5ONBapMsapCfl1a4=;
        b=FjZKxDV9SrYtw7u2jrPW39QA7DEx5y94s3tzsTdeOZO72wJy8kmddkjKtHYyw822VH
         +VlApMD4cRHoav1vns/qD1yFc1qNNymY6wx2R/NVCAtvU/e40uvYBJ9aAXiMQ5G4lt5e
         +Ev9EjTC16kHFwVDw2xXCsS4QN6oVZHo1zCJXTQWqYP/b6qoY2fBOmw//1FaWu5XUhSe
         qQSsMSDK6w8Mr42ygMpvIFNndxQtHhxTjWNHVU8g5sLjlS1md72IcFJM+FhuUXAN6jZ8
         NnVtjryMWsj0+hD3pZEl4/2a8KbE43/UI8MB48ezYu1RRYjeIrgUKpYswGEU1S4YqIdX
         9cWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Lf/psRwX7p94u6q+A00cEDXXTb5ONBapMsapCfl1a4=;
        b=nziVqVbbvicX7fOqrIy/0SxZ+hSx6izJOGuJPaxR6hp/NrNddXrqFeTUatJB1hOYBJ
         LueJAnpTKrgvPzzJEUONI8aZcwUbDkMCGKQAwerID3tfBzn5grta4BZr1uDUB1foM+Dh
         WHiNoIV90bvYwsP72O+O3+/wGyOo7vVzH7GsP+xAtJPp0k8Mw6IGajoiQygopVN0pOVx
         WQXk0L7aCDQWVBgjZd10LxzapMjPtrtMQLwyfthM0En7yjf5V6hcdpbcwunXohd+O53q
         ctAcG6kLqPEWmqWAxMSp4Skxgu0GX+NOZSYbThqKz6tc9OqGrph4jkMg8TLv2FDdjr0J
         4DhA==
X-Gm-Message-State: ACrzQf2NM27M/xl3U5wlBQHZt4+Uq6VytrJAGrajoGaqq+1Szv9+o+KD
        JlNuX4TzVGGPcuoqmXrzclb/qOAVszZ5sA==
X-Google-Smtp-Source: AMsMyM5yOgYv4nQ8oVRT4WrBG5gN37uatl2oc0NuVHxsNsjVw2O8nZy1DoAVxCwNwKdFd1xQ2Z783Q==
X-Received: by 2002:a05:6214:21e3:b0:4b2:7965:191b with SMTP id p3-20020a05621421e300b004b27965191bmr45379163qvj.55.1666946584087;
        Fri, 28 Oct 2022 01:43:04 -0700 (PDT)
Received: from dell-per730-23.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id br40-20020a05620a462800b006ec9f5e3396sm2510706qkb.72.2022.10.28.01.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:43:03 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 net-next 4/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
Date:   Fri, 28 Oct 2022 04:42:24 -0400
Message-Id: <20221028084224.3509611-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028084224.3509611-1-liuhangbin@gmail.com>
References: <20221028084224.3509611-1-liuhangbin@gmail.com>
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

This patch use the new helper unregister_netdevice_many_notify() for
rtnl_delete_link(), so that the kernel could reply unicast when userspace
 set NLM_F_ECHO flag to request the new created interface info.

At the same time, the parameters of rtnl_delete_link() need to be updated
since we need nlmsghdr and portid info.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/rtnetlink.h        | 2 +-
 net/core/rtnetlink.c           | 7 ++++---
 net/openvswitch/vport-geneve.c | 2 +-
 net/openvswitch/vport-gre.c    | 2 +-
 net/openvswitch/vport-netdev.c | 2 +-
 net/openvswitch/vport-vxlan.c  | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index cd94f65dc2a9..d9076a7a430c 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -186,7 +186,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
 				    struct netlink_ext_ack *extack);
-int rtnl_delete_link(struct net_device *dev);
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm,
 			u32 portid, const struct nlmsghdr *nlh);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 839ff8b7eadc..d2f27548fc0b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3110,7 +3110,7 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
-int rtnl_delete_link(struct net_device *dev)
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh)
 {
 	const struct rtnl_link_ops *ops;
 	LIST_HEAD(list_kill);
@@ -3120,7 +3120,7 @@ int rtnl_delete_link(struct net_device *dev)
 		return -EOPNOTSUPP;
 
 	ops->dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	unregister_netdevice_many_notify(&list_kill, portid, nlh);
 
 	return 0;
 }
@@ -3130,6 +3130,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
@@ -3171,7 +3172,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = rtnl_delete_link(dev);
+	err = rtnl_delete_link(dev, portid, nlh);
 
 out:
 	if (netnsid >= 0)
diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 89a8e1501809..b10e1602c6b1 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -91,7 +91,7 @@ static struct vport *geneve_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index e6b5e76a962a..4014c9b5eb79 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -57,7 +57,7 @@ static struct vport *gre_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		return ERR_PTR(err);
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 2f61d5bdce1a..903537a5da22 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -172,7 +172,7 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 * if it's not already shutting down.
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
-		rtnl_delete_link(vport->dev);
+		rtnl_delete_link(vport->dev, 0, NULL);
 	netdev_put(vport->dev, &vport->dev_tracker);
 	vport->dev = NULL;
 	rtnl_unlock();
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 188e9c1360a1..0b881b043bcf 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -120,7 +120,7 @@ static struct vport *vxlan_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
-- 
2.37.3

