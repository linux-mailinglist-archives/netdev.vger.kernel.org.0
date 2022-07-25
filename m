Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64457FB53
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiGYI3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiGYI3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:33 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E635413F64
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id tk8so19189139ejc.7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NXYhjIzwP+S+nMxBA5I1TrroeQkdpryFyCDllEmMYME=;
        b=N+X0uVT0YJ+hn14nDC/ZiaUWFqxa6nJ9wa4Xt/jXTpVd5AL2Pi3YM7iBv2bcjbIPQW
         giXlqwJZzSBT8IlMRtf6IZg2EdgDvxKQluEEXnlVmSc/L2UMD64s7sx4kdxjM5boELMZ
         KEDRjDTs8YcmX9appMEiwXtT909IdhtbKJfzUd2tneLNd25yWU+8JPCmV3bcamQs7Pqt
         QNyUFjACDwFQIa1iutknxWYFg+Huu6Ad4aF/CffFO2claVQ/b6JU5mQi7220moofq7Y/
         78r5cVx7aSga2VcyobqxJLoSGYK0ofLCfHOVfa4/QJ1Rx1yQyO/pQ9/ujuXdL/jUS8at
         7FCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NXYhjIzwP+S+nMxBA5I1TrroeQkdpryFyCDllEmMYME=;
        b=UE6YJd+L/BhqbLpSomiav6g4+qTJANOrC4ltxTWUYHFXRWvWfa3OqQXwS1K8S95Oxd
         w8ISYWHwW3hTUO5a6SPNeFeeuv6NkC9QYn1mZtOjR44F5Uxzcl1f2FFTTy0a3DQBGi4R
         gaRR9u1z/AiO0zzzOwMHRi5rrnefdaGUyrXYN45rBEOXVMaeQUJdt6NIHrWIyxKSU0+y
         XX3lparuyVb11n3yLLVFoC0f+2p2u/NB0lMGR9MNZjCs/euZlnaIHGg+AZ6wUsbwEsdY
         Vz8OrgD+FjOW76KTTHEv9NaqBOI2sAelxsXeJR+Ezz5Mpv30PViOSmgheUzyISODwl+B
         RSSw==
X-Gm-Message-State: AJIora/9OR0kp37qUriM0nvrOJga2y3D7B81/AC1m/c0R8LU23gqHAT3
        bipv5kJCA30H5sQ36UPPOhI3jJNAdy+Nb5QJV8M=
X-Google-Smtp-Source: AGRyM1u8SsR1SSPRe9q1vRdCzp82uFyFpEclUIiVvzyhPGCwuor68MZ9RbrQG7/U64qk8G3EFLZJUA==
X-Received: by 2002:a17:907:7637:b0:72b:3a3b:7d68 with SMTP id jy23-20020a170907763700b0072b3a3b7d68mr8777636ejc.566.1658737770212;
        Mon, 25 Jul 2022 01:29:30 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id sd22-20020a170906ce3600b006fe8b456672sm4989634ejb.3.2022.07.25.01.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 02/12] net: devlink: move net check into devlinks_xa_for_each_registered_get()
Date:   Mon, 25 Jul 2022 10:29:15 +0200
Message-Id: <20220725082925.366455-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Benefit from having devlinks iterator helper
devlinks_xa_for_each_registered_get() and move the net pointer
check inside.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v3->v4:
- new patch
---
 net/core/devlink.c | 135 +++++++++++++--------------------------------
 1 file changed, 39 insertions(+), 96 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index c7abd928f389..865232a1455f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -289,7 +289,7 @@ void devl_unlock(struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devl_unlock);
 
 static struct devlink *
-devlinks_xa_find_get(unsigned long *indexp, xa_mark_t filter,
+devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
 		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
 					  unsigned long, xa_mark_t))
 {
@@ -304,33 +304,40 @@ devlinks_xa_find_get(unsigned long *indexp, xa_mark_t filter,
 	xa_find_fn = xa_find_after;
 	if (!devlink_try_get(devlink))
 		goto retry;
+	if (!net_eq(devlink_net(devlink), net)) {
+		devlink_put(devlink);
+		goto retry;
+	}
 unlock:
 	rcu_read_unlock();
 	return devlink;
 }
 
-static struct devlink *devlinks_xa_find_get_first(unsigned long *indexp,
+static struct devlink *devlinks_xa_find_get_first(struct net *net,
+						  unsigned long *indexp,
 						  xa_mark_t filter)
 {
-	return devlinks_xa_find_get(indexp, filter, xa_find);
+	return devlinks_xa_find_get(net, indexp, filter, xa_find);
 }
 
-static struct devlink *devlinks_xa_find_get_next(unsigned long *indexp,
+static struct devlink *devlinks_xa_find_get_next(struct net *net,
+						 unsigned long *indexp,
 						 xa_mark_t filter)
 {
-	return devlinks_xa_find_get(indexp, filter, xa_find_after);
+	return devlinks_xa_find_get(net, indexp, filter, xa_find_after);
 }
 
 /* Iterate over devlink pointers which were possible to get reference to.
  * devlink_put() needs to be called for each iterated devlink pointer
  * in loop body in order to release the reference.
  */
-#define devlinks_xa_for_each_get(index, devlink, filter)			\
-	for (index = 0, devlink = devlinks_xa_find_get_first(&index, filter);	\
-	     devlink; devlink = devlinks_xa_find_get_next(&index, filter))
+#define devlinks_xa_for_each_get(net, index, devlink, filter)			\
+	for (index = 0,								\
+	     devlink = devlinks_xa_find_get_first(net, &index, filter);		\
+	     devlink; devlink = devlinks_xa_find_get_next(net, &index, filter))
 
-#define devlinks_xa_for_each_registered_get(index, devlink)			\
-	devlinks_xa_for_each_get(index, devlink, DEVLINK_REGISTERED)
+#define devlinks_xa_for_each_registered_get(net, index, devlink)		\
+	devlinks_xa_for_each_get(net, index, devlink, DEVLINK_REGISTERED)
 
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
@@ -346,10 +353,9 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
-	devlinks_xa_for_each_registered_get(index, devlink) {
+	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
-		    strcmp(dev_name(devlink->dev), devname) == 0 &&
-		    net_eq(devlink_net(devlink), net))
+		    strcmp(dev_name(devlink->dev), devname) == 0)
 			return devlink;
 		devlink_put(devlink);
 	}
@@ -1376,10 +1382,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
@@ -1400,7 +1403,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -1476,12 +1478,7 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
-			devlink_put(devlink);
-			continue;
-		}
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (idx < start) {
 			idx++;
 			devlink_put(devlink);
@@ -1536,10 +1533,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
@@ -1559,7 +1553,6 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -2215,10 +2208,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		mutex_lock(&devlink->linecards_lock);
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
 			if (idx < start) {
@@ -2241,7 +2231,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		mutex_unlock(&devlink->linecards_lock);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -2484,10 +2473,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < start) {
@@ -2507,7 +2493,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -2633,7 +2618,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_pool_get)
 			goto retry;
@@ -2851,9 +2836,8 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_port_pool_get)
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+		if (!devlink->ops->sb_port_pool_get)
 			goto retry;
 
 		devl_lock(devlink);
@@ -3097,9 +3081,8 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_tc_pool_bind_get)
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+		if (!devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
 		devl_lock(devlink);
@@ -5181,10 +5164,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < start) {
@@ -5206,7 +5186,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -5413,10 +5392,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
@@ -5443,7 +5419,6 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 			}
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -5994,13 +5969,9 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, start);
-retry:
 		devlink_put(devlink);
 		if (err)
 			goto out;
@@ -6525,10 +6496,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		if (idx < start || !devlink->ops->info_get)
 			goto inc;
 
@@ -6546,7 +6514,6 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		}
 inc:
 		idx++;
-retry:
 		devlink_put(devlink);
 	}
 	mutex_unlock(&devlink_mutex);
@@ -7702,10 +7669,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry_rep;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7725,14 +7689,10 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		mutex_unlock(&devlink->reporters_lock);
-retry_rep:
 		devlink_put(devlink);
 	}
 
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry_port;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
@@ -7757,7 +7717,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			mutex_unlock(&port->reporters_lock);
 		}
 		devl_unlock(devlink);
-retry_port:
 		devlink_put(devlink);
 	}
 out:
@@ -8296,10 +8255,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
@@ -8319,7 +8275,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -8520,10 +8475,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
@@ -8544,7 +8496,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -8831,10 +8782,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
@@ -8855,7 +8803,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		devl_unlock(devlink);
-retry:
 		devlink_put(devlink);
 	}
 out:
@@ -12273,10 +12220,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	mutex_lock(&devlink_mutex);
-	devlinks_xa_for_each_registered_get(index, devlink) {
-		if (!net_eq(devlink_net(devlink), net))
-			goto retry;
-
+	devlinks_xa_for_each_registered_get(net, index, devlink) {
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
@@ -12284,7 +12228,6 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 				     &actions_performed, NULL);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
-retry:
 		devlink_put(devlink);
 	}
 	mutex_unlock(&devlink_mutex);
-- 
2.35.3

