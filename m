Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B838A55DF91
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiF0NzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiF0NzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:55:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BEAAE60
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eo8so13211192edb.0
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1GhFy/+2w0tntU3LJ7qFmHA6iGAhL99mhT+mpbAn2e0=;
        b=03qUGQDIEBl+lWHOxW/wFIc87Igg7xtbiC+lpxaW+NO5C8mPiKi6C+ux9qM/H/CzNN
         SOriI21gGIB/LcQ9YY5/x1n621x8XrlY9sa+YxwCAeDjWsbY9rLBdLk5VGFCpidYq9qG
         CgjU8nrOnJ3Ws4XzyqvrPluIVJnWcBwRFMdA1Gb8HsFy7KAabgWvKAuyhrAIpoqd8dS/
         q8h7ihhDZs3jQgwBaGrswO9FB6dg5qTuj+lVmjZoZubnHBtk2pUpQwvE12FZUmgTkNIJ
         Tyy4MmR26WyOX9CUeDgwk1O+Y/7Wjs/siHrfpAkuOlUrkQyM8YQJo34F3Uc4sNYlQsVw
         /z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1GhFy/+2w0tntU3LJ7qFmHA6iGAhL99mhT+mpbAn2e0=;
        b=3nlQPhjG5UAs/KWUbP1cizP85Mfqs+puwqfS81tqPJPh+wfZLo1nUHLrt79Bjlq+K5
         bzGdEJQkBdKmJcmEAhp682vHS6eTUG+I2WBF7H5Zh66cg9BreNgL3xA0yh0Vc8nEIRc+
         pKfqQxFWbjaiJ60PaeomhcaH/VqS+OVfYuxK/jffd8hHvzjCGlmPLXU4iGSkWXI8MLqe
         hfHViEiyiueB18/CT53cxfYyjSTx5qGHgV2qS+54BGZgewQR7HwpsiWoKIx0kdSO8nn0
         cUAjAhg7aWKWftpfbyUPMBB4Apu1Uu+wfnQ4Fr8QZODkDjE/iCqgwL3xYhoEEyyrqQFf
         UBGQ==
X-Gm-Message-State: AJIora+8V6gN2iluqIWiPYh/2XVjx08SLznuhG2zDE14xOOnqo40hR7j
        gQXvjS5OpMT9YhvA/LOJzD0ChS8R1OWBFOKPXZY=
X-Google-Smtp-Source: AGRyM1tPGaQFIcxKkAFcvNiQ6NcuPGOwfSJAgRKmmDeScrcQIIy5e9es0RoJyGv0W4vrGArAbcam1w==
X-Received: by 2002:a05:6402:299a:b0:435:c75:64e6 with SMTP id eq26-20020a056402299a00b004350c7564e6mr17100645edb.134.1656338104364;
        Mon, 27 Jun 2022 06:55:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d2-20020aa7d682000000b0042dddaa8af3sm7533239edr.37.2022.06.27.06.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 06:55:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next RFC 1/2] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
Date:   Mon, 27 Jun 2022 15:55:00 +0200
Message-Id: <20220627135501.713980-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220627135501.713980-1-jiri@resnulli.us>
References: <20220627135501.713980-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 net/core/devlink.c | 113 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 95 insertions(+), 18 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index db61f3a341cb..9e34b4b9b19b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -69,6 +69,7 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
+	struct rcu_head rcu;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -220,8 +221,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 /* devlink_mutex
  *
  * An overall lock guarding every operation coming from userspace.
- * It also guards devlink devices list and it is taken when
- * driver registers/unregisters it.
  */
 static DEFINE_MUTEX(devlink_mutex);
 
@@ -231,10 +230,21 @@ struct net *devlink_net(const struct devlink *devlink)
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
@@ -288,6 +298,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	lockdep_assert_held(&devlink_mutex);
 
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
@@ -299,6 +310,7 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 
 	if (!found || !devlink_try_get(devlink))
 		devlink = ERR_PTR(-ENODEV);
+	rcu_read_unlock();
 
 	return devlink;
 }
@@ -1322,9 +1334,11 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -1351,7 +1365,9 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 	if (err != -EMSGSIZE)
@@ -1425,29 +1441,32 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
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
 
@@ -1488,9 +1507,11 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -1516,7 +1537,9 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2173,9 +2196,11 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -2204,7 +2229,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->linecards_lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2445,9 +2472,11 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -2473,7 +2502,9 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2597,9 +2628,11 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_pool_get)
@@ -2622,7 +2655,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -2818,9 +2853,11 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_port_pool_get)
@@ -2843,7 +2880,9 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -3067,9 +3106,11 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_tc_pool_bind_get)
@@ -3093,7 +3134,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5154,9 +5197,11 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5184,7 +5229,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5389,9 +5436,11 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5424,7 +5473,9 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -5973,9 +6024,11 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -5986,7 +6039,9 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 		if (err)
 			goto out;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 	cb->args[0] = idx;
@@ -6507,9 +6562,11 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -6533,7 +6590,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 		idx++;
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
@@ -7687,9 +7746,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
@@ -7715,11 +7776,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
@@ -7750,7 +7813,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry_port:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8287,9 +8352,11 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8315,7 +8382,9 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8514,9 +8583,11 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8543,7 +8614,9 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8828,9 +8901,11 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8857,7 +8932,9 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -9585,10 +9662,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9605,10 +9680,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -12118,9 +12191,11 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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
@@ -12134,7 +12209,9 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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

