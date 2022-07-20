Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C1D57B94A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbiGTPM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbiGTPMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:46 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD52E58856
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk26so26557124wrb.11
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B2IDX7YCrgie2P6s2mQVFc/WKskRbIgnqkDfi5L0Mow=;
        b=iYxy8ORTYoy/c0gFYqSEMf0gg9cFsV/5lDYWQCTP4ac80XB6qcJatYty6L07DyzPrO
         6ndTf7Sfsko8iqacZRCOLnIHouUmC1NK3lJ5GirjCDS4iSrivr0qcdED4x4HN6m3BAbv
         MSxF07JomtTAVgrACyOOnG+sLpFSdueCbJGi8oRnesGhlaB5k+/niuRMhD8vQHTVvTNi
         XGjW/ntiBaCZDaxYZTtlxbq1IU1LnXVbIPKmI99hklu3TrdH2OSlklikT8QF8w7wvjAr
         vFB5xt7xfEwphi6gvnocCheAJokwqnqlCnaE+nSP/TrDqGS+7KsWM0310vqr15JQfql1
         ObLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2IDX7YCrgie2P6s2mQVFc/WKskRbIgnqkDfi5L0Mow=;
        b=nKbzZL5IzY/4fCzkIvn6dsd9SYuYORCuzfTysspoDTvgEsSGMR/fvWq6uV+JYDQJRJ
         SrpjBUbcBPD26UlMg4TXreTni9YbdFQZpa/jXdJP7wx1xAy6WGQ9a0uetVfC+dBtsPvp
         ITW65mZ32wLCKXbnddU9o+EeAdsAWbJagIun/cDcTwik3P+MgTS38rcNYuGLtc8qt+Gp
         igMcEGFJaQT8z+YTxgt5oy8fxW82stwTGlm8TUrsyXyRboYDTXzGLo1+zkh2ZF2fnf6/
         iIIsJ3iGWMfNWGUNlfLCh6CW+1JZKwveRnU0jySRuEXZ8OKqifEJYsKyDVpHz8vV3woT
         C8ZA==
X-Gm-Message-State: AJIora91x9F/U6sKuk2Ab0MxntDq8Tj3GSawTynzkbHR5/7Og++hnf1O
        irNIFqERID6ltmfvMfnsZvGGN++3X4/AILvoYHk=
X-Google-Smtp-Source: AGRyM1tSSZfmxlCyeaKbiLQT/MvvgJQBOHMAhsQh/aCnpnqNMGK8VxuVfnVfz5hi5N2ep6H2bfDZgw==
X-Received: by 2002:a5d:4708:0:b0:21e:4eda:5cda with SMTP id y8-20020a5d4708000000b0021e4eda5cdamr1516893wrq.337.1658329959226;
        Wed, 20 Jul 2022 08:12:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe44c000000b0021e491fd250sm1950957wrm.89.2022.07.20.08.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 01/11] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
Date:   Wed, 20 Jul 2022 17:12:24 +0200
Message-Id: <20220720151234.3873008-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
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

The reason is that devlink_register/unregister() functions taking
devlink_mutex would deadlock during devlink reload operation of devlink
instance which registers/unregisters nested devlink instances.

The devlinks xarray consistency is ensured internally by xarray.
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
v2->v3:
- s/enf/end/ in devlink_put() comment
- added missing rcu_read_lock() call to info_get_dumpit()
- extended patch description by motivation
- removed an extra "by" from patch description
v1->v2:
- new patch (originally part of different patchset)
---
 net/core/devlink.c | 114 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 96 insertions(+), 18 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 98d79feeb3dc..6a3931a8e338 100644
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
+		 * is unblocked only after all users are after the end of
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
@@ -6531,13 +6588,16 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 			err = 0;
 		else if (err) {
 			devlink_put(devlink);
+			rcu_read_lock();
 			break;
 		}
 inc:
 		idx++;
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	mutex_unlock(&devlink_mutex);
 
 	if (err != -EMSGSIZE)
@@ -7691,9 +7751,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
@@ -7719,11 +7781,13 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
@@ -7754,7 +7818,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry_port:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8291,9 +8357,11 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8319,7 +8387,9 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8518,9 +8588,11 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8547,7 +8619,9 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -8832,9 +8906,11 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
+	rcu_read_lock();
 	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
 		if (!devlink_try_get(devlink))
 			continue;
+		rcu_read_unlock();
 
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
@@ -8861,7 +8937,9 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devl_unlock(devlink);
 retry:
 		devlink_put(devlink);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -9589,10 +9667,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9609,10 +9685,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -12281,9 +12355,11 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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
@@ -12297,7 +12373,9 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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

