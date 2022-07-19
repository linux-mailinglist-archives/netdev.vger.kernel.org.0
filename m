Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6D579368
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiGSGsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiGSGsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:48:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF31F26122
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:51 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id z23so25359157eju.8
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JiA9dlXkSuNAizAr6Yw0+INbO8WjRyrKPHU2zBnyOH4=;
        b=8WicJtQT4LdZyyqFide9aq0APJBZGTQY1j1ZTEa5M3M0P3tEATIojS744/xqtCjBpn
         CSAgNKbRnmzJ1tK3tUGOfYQK1CNV/Rve3jbUvjsaSM7CEh7yPDHAiSaUYmPANVzeAdzh
         01w6he5NmXuPYLUwxdsSeqwdKNpFFBsDRtqQVVEiL8KwrNTWo9Q2oYzhXKgf65LBLUyj
         UnUGfh+PtIcugT7uDJgDPnLI9Li0U4DyTjPf9s5xPJzKNUfu2dOYOlRAddwCNLqij6HG
         ncClfL5MwG93lYrMe0TD/tiCNYfCVe5u+U4Prv/jZlcglA/BnS0Hdx/0oUemoN88jQCb
         Agrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JiA9dlXkSuNAizAr6Yw0+INbO8WjRyrKPHU2zBnyOH4=;
        b=aVSEUTGZHOLioPW0kIu2fFeoW6Wp367inDZR1ffnddwQ/FGySmVhVGO5YF9g0w05Dy
         EiHC6nbtIytKSArA1tDctTtrlXP+jgekKB168q5TroUvCAjnSMUYo+Q8yP4pKgCo7UBR
         dyPeZxGTV6ONxM5pooH2MYGntm9qoil4mznHiNgSDuWEWU7lYYJPRidI0AKnoOn9LXYM
         O03PW6wCHkqT0YC/2tpQabK4/r72+vy9Jd235M1R5ST/OQo5YGig8YdiFqzXcsOf0z8l
         /O14JHFaaBqDjMEcdW8JZ/3GkSXlIYpFlXNauT2ZXJcWXjDYphenAubIxggVZAnf32EU
         gqqg==
X-Gm-Message-State: AJIora87tXqoG6A3lkZv/aQ2/PO42HuhLgR4lZ1lYJubGk2OhdxX4ah/
        7GGLUv6J+GoeCZMlBgqX+RXWkt4xb2Gc0dnJJUE=
X-Google-Smtp-Source: AGRyM1t34gIha64DRNkV6gRVuFMV/8LIqz9rjo2X/crSyYsvzPGjwPMGjqcHnGzzjaZ8v7ZOB6FQig==
X-Received: by 2002:a17:907:7f05:b0:72b:5a11:b357 with SMTP id qf5-20020a1709077f0500b0072b5a11b357mr29429624ejc.67.1658213330124;
        Mon, 18 Jul 2022 23:48:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v10-20020aa7cd4a000000b00437d3e6c4c7sm9951445edw.53.2022.07.18.23.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 01/12] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
Date:   Tue, 19 Jul 2022 08:48:36 +0200
Message-Id: <20220719064847.3688226-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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

Remove dependency on devlink_mutex during devlinks xarray iteration.

The devlinks xarray consistency is ensured by internally by xarray.
There is a reference taken when working with devlink using
devlink_try_get(). But there is no guarantee that devlink pointer
picked during xarray iteration is not freed before devlink_try_get()
is called.

Make sure that devlink_try_get() works with valid pointer.
Achieve it by:
1) Splitting devlink_put() so the completion is sent only
   after grace period. Completion unblocks the devlink_unregister()
   routine, which is followed-up by devlink_free()
2) Iterate the devlink xarray holding RCU read lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- new patch (originally part of different patchset)
---
 net/core/devlink.c | 113 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 95 insertions(+), 18 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 98d79feeb3dc..aca1dd7c1f07 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -70,6 +70,7 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
+	struct rcu_head rcu;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -221,8 +222,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 /* devlink_mutex
  *
  * An overall lock guarding every operation coming from userspace.
- * It also guards devlink devices list and it is taken when
- * driver registers/unregisters it.
  */
 static DEFINE_MUTEX(devlink_mutex);
 
@@ -232,10 +231,21 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
+static void __devlink_put_rcu(struct rcu_head *head)
+{
+	struct devlink *devlink = container_of(head, struct devlink, rcu);
+
+	complete(&devlink->comp);
+}
+
 void devlink_put(struct devlink *devlink)
 {
 	if (refcount_dec_and_test(&devlink->refcount))
-		complete(&devlink->comp);
+		/* Make sure unregister operation that may await the completion
+		 * is unblocked only after all users are after the enf of
+		 * RCU grace period.
+		 */
+		call_rcu(&devlink->rcu, __devlink_put_rcu);
 }
 
 struct devlink *__must_check devlink_try_get(struct devlink *devlink)
@@ -295,6 +305,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	lockdep_assert_held(&devlink_mutex);
 
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
@@ -306,6 +317,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	if (!found || !devlink_try_get(devlink))
 		devlink = ERR_PTR(-ENODEV);
+	rcu_read_unlock();
 
 	return devlink;
 }
@@ -1329,9 +1341,11 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -1358,7 +1372,9 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 	if (err != -EMSGSIZE)
@@ -1432,29 +1448,32 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
-			devlink_put(devlink);
-			continue;
-		}
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			goto retry;
 
-		if (idx < start) {
-			idx++;
-			devlink_put(devlink);
-			continue;
-		}
+		if (idx < start)
+			goto inc;
 
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
-		devlink_put(devlink);
-		if (err)
+		if (err) {
+			devlink_put(devlink);
 			goto out;
+		}
+inc:
 		idx++;
+retry:
+		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -1495,9 +1514,11 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -1523,7 +1544,9 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2177,9 +2200,11 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -2208,7 +2233,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->linecards_lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2449,9 +2476,11 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -2477,7 +2506,9 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2601,9 +2632,11 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_pool_get)
@@ -2626,7 +2659,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2822,9 +2857,11 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_port_pool_get)
@@ -2847,7 +2884,9 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -3071,9 +3110,11 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_tc_pool_bind_get)
@@ -3097,7 +3138,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5158,9 +5201,11 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5188,7 +5233,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5393,9 +5440,11 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5428,7 +5477,9 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5977,9 +6028,11 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5990,7 +6043,9 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 		if (err)
 			goto out;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 	cb->args[0] = idx;
@@ -6511,9 +6566,11 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -6537,7 +6594,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		idx++;
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
@@ -7691,9 +7750,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
@@ -7719,11 +7780,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->reporters_lock);
 retry_rep:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
 
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
@@ -7754,7 +7817,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry_port:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8291,9 +8356,11 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8319,7 +8386,9 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8518,9 +8587,11 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8547,7 +8618,9 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8832,9 +8905,11 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8861,7 +8936,9 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -9589,10 +9666,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9609,10 +9684,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -12281,9 +12354,11 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
@@ -12297,7 +12372,9 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			pr_warn("Failed to reload devlink instance into init_net\n");
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	mutex_unlock(&devlink_mutex);
 }
 
-- 
2.35.3

