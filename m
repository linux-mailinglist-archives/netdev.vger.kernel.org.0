Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9546E66570F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbjAKJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbjAKJLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3514618B1D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:22 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so19335332pjj.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyCDMJA7DPzkdESqIwBfi9L1EH7AY6NqunDP+Y+KNyY=;
        b=5jr0yRvH20W1L8R/S8yaGZsJprshQ/Oo5bfV2e0xces0/pvw32Jb+kRx6QaRaxWeUQ
         aY3MwYB2T0s/IFqWKzQM9qwq9jQootgQdzGKKyVAhXE/XOfuvwGxdB0ygltJW/BAquXx
         JhSA+suowN8a3qi+qnlsvB683bYHZg/RJO9Ekci4h0O8IjMPAh4tnP5ToxoOu7kEB5Wl
         8Kz/y1ymgcL1h1dWSwSxpw1SZtO4+nwLKuEfDzArug08oTvB3YaBoq3x9GRSBhrgDHGl
         VJ2rDDtuLGZe2Dat4xyGWa0pHWk0a0o2JHkaqznk//IUkHVfW62zEucB3ZVbasg3t36Y
         nlkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyCDMJA7DPzkdESqIwBfi9L1EH7AY6NqunDP+Y+KNyY=;
        b=Le7CRQ/rh9Bu/GsoH8GNrfb5dQM+gvXEa3Ke4Am/pNb3dJidTFtTgjL2n5a5Ng7Csj
         c6u25eZCdO91OOtoXTxEmKN8e4r6BPF+i16uIuz9cI5v++PHXWOlbQ22mA4/ADyG7zGK
         yTe+1fLjz0DidhL1z1zPZPoJLvdJfSwDKKU49rFHfq5TtrhzluqpsI4U59a44S8G/ASS
         aZm9tPxGf+zegZqqilj1zqyTWgbZKzZVcO45IrtqYiCeVHLhBzkoY6STNPUKnVqeTeu2
         BPZ05ctJLTsC/BsfsMuvuEj+uoudPwTwCnR/RQCMsbKflvKLKM9AHluYNOmMCaoXcFYi
         6Xjg==
X-Gm-Message-State: AFqh2kolIM0KjmXdV3TTLaK5pjvv3kLmCzKyZyBR5xFEJ83iLfTlx51O
        N5Kzhl3n0dLEZ+9gpclL4z27b6zVlMJAL3LhnH5R2Q==
X-Google-Smtp-Source: AMrXdXs9A9rMzb15gBIwm/FZCcOcpoNCgK31CMLzsUYSHDIQLE6KZ9f5pXD4YsUMCV6fl1yDw0wsIA==
X-Received: by 2002:a17:90b:2684:b0:227:203d:4d70 with SMTP id pl4-20020a17090b268400b00227203d4d70mr9009186pjb.32.1673428102460;
        Wed, 11 Jan 2023 01:08:22 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a034700b00212e5fe09d7sm8389230pjf.10.2023.01.11.01.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 09/10] devlink: remove devlink_dump_for_each_instance_get() helper
Date:   Wed, 11 Jan 2023 10:07:47 +0100
Message-Id: <20230111090748.751505-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
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

devlink_dump_for_each_instance_get() is currently called from
a single place in netlink.c. As there is no need to use
this helper anywhere else in the future, remove it and
call devlinks_xa_find_get() directly from while loop
in devlink_nl_instance_iter_dump(). Also remove redundant
idx clear on loop end as it is already done
in devlink_nl_instance_iter_dump().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2: new patch, unsquashed from the previous one
---
 net/devlink/devl_internal.h | 11 -----------
 net/devlink/netlink.c       |  5 ++++-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 2c53759421eb..b61e522321ac 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -122,17 +122,6 @@ struct devlink_gen_cmd {
 			struct netlink_callback *cb);
 };
 
-/* Iterate over registered devlink instances for devlink dump.
- * devlink_put() needs to be called for each iterated devlink pointer
- * in loop body in order to release the reference.
- * Note: this is NOT a generic iterator, it makes assumptions about the use
- *	 of @state and can only be used once per dumpit implementation.
- */
-#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
-	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
-					       &state->instance));	\
-	     state->instance++, state->idx = 0)
-
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index d4539c1aedea..3f44633af01c 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -207,7 +207,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 
 	cmd = devl_gen_cmds[info->op.cmd];
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
+	while ((devlink = devlinks_xa_find_get(sock_net(msg->sk),
+					       &state->instance))) {
 		devl_lock(devlink);
 
 		if (devl_is_registered(devlink))
@@ -221,6 +222,8 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
 		if (err)
 			break;
 
+		state->instance++;
+
 		/* restart sub-object walk for the next instance */
 		state->idx = 0;
 	}
-- 
2.39.0

