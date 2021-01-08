Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297CD2EF5DC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbhAHQdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbhAHQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:41 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FAEC0612A7
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:40 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qw4so15198789ejb.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wMJ5YK3WfuJ3cbgGf4BBey++WgyEVvISZb4dwlcdrIc=;
        b=MGIBbfkmx1+lzESrh6FEMKP38q5dsYHWvJ+kZlpqN2JofYK/UX9/NSSEeLMBb+/rGe
         1F6bBzqzy4qmyWwdKEUnQKM/lOKrakVl5KCvCK3Gz+EjNYCBu+3GTjQ2ZJuO0yP2sgsS
         h4iN2LXPfGCVkAXUUzz1ubsYrnuvgbIECsymfGAbUee175t/+eCFWiM9YIiBZvDrOSxd
         ahjB2tx060mFlWSn71zfSWwfBECghX3zMPNwPGACIGGDxMeW2Vye+Sgu6odFHIgVmUpY
         5/vpIBHMwkcEzcpxWJYUof4Zaiakm8my6WgdR7APBBNr/hUBbxmyyzaJ1YMBsY1i/Adh
         3gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wMJ5YK3WfuJ3cbgGf4BBey++WgyEVvISZb4dwlcdrIc=;
        b=acnE5d6YoLxDtxLpg7Y5UDQoSlE0N2kFdzb+b5B4jlPIH/VirwcIrwBFvVJ7ILcqaH
         DFexkENLpg2lPU4urRrrbfB+3bYtghPm6NNZ9anCb+NYDCZc7+2i6C40DUx77ECXvAL7
         YjUkVpGcdTJYMiqfL0W2Ic12YCMfokhn6VHC+IHfqt/kJSAvAOoqp5XOgmzQv87iIGhD
         D1rMxsaP02Ddmh8lq7byoPb8y5xkktBVo8zWW7FoTEbYHaCXbSJBwQs4l+ujoM+Dcti3
         G+GL6spWjzy1qjXCp2/BfgpWh9vkglqriuwvau1hyFCgXO0jLhLp7cY400puXsV5zoHi
         uEmg==
X-Gm-Message-State: AOAM532gcrJ7hnQlQesxXQhyyDo6VnI4AidDmiCD7wmmnPlV3mKoRy+F
        OlfF6WWhQ2VSRlS1r83/04w=
X-Google-Smtp-Source: ABdhPJwZg0HRf+t2+hUlSH6YJI87liMGdz+5SU5a9ntwFhL3ggqi4NJPqycz6k4zft0ViJgPq7OiMw==
X-Received: by 2002:a17:907:204b:: with SMTP id pg11mr3339665ejb.192.1610123559091;
        Fri, 08 Jan 2021 08:32:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 13/16] net: openvswitch: ensure dev_get_stats can sleep
Date:   Fri,  8 Jan 2021 18:31:56 +0200
Message-Id: <20210108163159.358043-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is an effort to convert .ndo_get_stats64 to sleepable context, and
for that to work, we need to prevent callers of dev_get_stats from using
atomic locking.

The OVS vport driver calls ovs_vport_get_stats from
ovs_vport_cmd_fill_info, a function with 7 callers: 5 under ovs_lock() and
2 under rcu_read_lock(). The RCU-protected callers are the doit and
dumpit callbacks of the OVS_VPORT_CMD_GET genetlink event. Things have
been this way ever since the OVS introduction in commit ccb1352e76cf
("net: Add Open vSwitch kernel components."), probably so that
OVS_PORT_CMD_GET doesn't have to serialize with all the others through
ovs_mutex. Sadly, now they do have to, otherwise we don't have
protection while accessing the datapath and vport structures.

Convert all callers of ovs_vport_cmd_fill_info to assume ovs_mutex
protection. This means that we can get rid of the gfp argument, since
all callers are now sleepable, we can just use GFP_KERNEL for memory
allocation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
None.

Changes in v4:
Patch is new.

 net/openvswitch/datapath.c | 38 ++++++++++++++++++--------------------
 net/openvswitch/vport.c    |  2 +-
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 160b8dc453da..318caa8f12c2 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1957,10 +1957,10 @@ static struct genl_family dp_datapath_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 };
 
-/* Called with ovs_mutex or RCU read lock. */
+/* Called with ovs_mutex */
 static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 				   struct net *net, u32 portid, u32 seq,
-				   u32 flags, u8 cmd, gfp_t gfp)
+				   u32 flags, u8 cmd)
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
@@ -1981,7 +1981,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (!net_eq(net, dev_net(vport->dev))) {
-		int id = peernet2id_alloc(net, dev_net(vport->dev), gfp);
+		int id = peernet2id_alloc(net, dev_net(vport->dev), GFP_KERNEL);
 
 		if (nla_put_s32(skb, OVS_VPORT_ATTR_NETNSID, id))
 			goto nla_put_failure;
@@ -2029,8 +2029,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
-					 GFP_KERNEL);
+	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd);
 	BUG_ON(retval == -EMSGSIZE);
 	if (retval)
 		return ERR_PTR(retval);
@@ -2038,7 +2037,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	return skb;
 }
 
-/* Called with ovs_mutex or RCU read lock. */
+/* Called with ovs_mutex */
 static struct vport *lookup_vport(struct net *net,
 				  const struct ovs_header *ovs_header,
 				  struct nlattr *a[OVS_VPORT_ATTR_MAX + 1])
@@ -2177,7 +2176,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
+				      OVS_VPORT_CMD_NEW);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2240,7 +2239,7 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_SET, GFP_KERNEL);
+				      OVS_VPORT_CMD_SET);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2282,7 +2281,7 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
+				      OVS_VPORT_CMD_DEL);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2324,23 +2323,23 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	if (!reply)
 		return -ENOMEM;
 
-	rcu_read_lock();
+	ovs_lock();
 	vport = lookup_vport(sock_net(skb->sk), ovs_header, a);
 	err = PTR_ERR(vport);
 	if (IS_ERR(vport))
 		goto exit_unlock_free;
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_GET, GFP_ATOMIC);
+				      OVS_VPORT_CMD_GET);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
-	rcu_read_unlock();
+	ovs_unlock();
 
 	return genlmsg_reply(reply, info);
 
 exit_unlock_free:
-	rcu_read_unlock();
+	ovs_unlock();
 	kfree_skb(reply);
 	return err;
 }
@@ -2352,25 +2351,24 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	int bucket = cb->args[0], skip = cb->args[1];
 	int i, j = 0;
 
-	rcu_read_lock();
-	dp = get_dp_rcu(sock_net(skb->sk), ovs_header->dp_ifindex);
+	ovs_lock();
+	dp = get_dp(sock_net(skb->sk), ovs_header->dp_ifindex);
 	if (!dp) {
-		rcu_read_unlock();
+		ovs_unlock();
 		return -ENODEV;
 	}
 	for (i = bucket; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
 
 		j = 0;
-		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node) {
+		hlist_for_each_entry(vport, &dp->ports[i], dp_hash_node) {
 			if (j >= skip &&
 			    ovs_vport_cmd_fill_info(vport, skb,
 						    sock_net(skb->sk),
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI,
-						    OVS_VPORT_CMD_GET,
-						    GFP_ATOMIC) < 0)
+						    OVS_VPORT_CMD_GET) < 0)
 				goto out;
 
 			j++;
@@ -2378,7 +2376,7 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		skip = 0;
 	}
 out:
-	rcu_read_unlock();
+	ovs_unlock();
 
 	cb->args[0] = i;
 	cb->args[1] = j;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index e66c949fd97a..ba1a52addff2 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -265,7 +265,7 @@ void ovs_vport_del(struct vport *vport)
  *
  * Retrieves transmit, receive, and error stats for the given device.
  *
- * Must be called with ovs_mutex or rcu_read_lock.
+ * Must be called with ovs_mutex.
  */
 int ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 {
-- 
2.25.1

