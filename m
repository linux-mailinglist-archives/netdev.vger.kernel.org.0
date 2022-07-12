Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7888571D00
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiGLOlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiGLOlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:41:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8198DBA384
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a5so11470721wrx.12
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwmkKepYaQPG3xsqn+DwHZ7XE2byRrcxOGkZ6YwM6Xc=;
        b=GrJ0tTkawzbPbZyYoegIcs64bNt/LIPYKidPO13i2ls7DKH/Sx8NbgXQejBmw1k+52
         td0O/vMDH9gk28Sh0weQ6dAoue7A3FudSqwB5KJ0skjHEkghqj+GLnGNWJKbg2HKbpdJ
         UrALUzmwiaJUQEAp68xKNmN93ASg4VgKNetuoYaXdGSNwR/6yAxJ0b7cnORz0fYB16SU
         bUPnVOMD/WZ6YYlRsXGHfNzppuoUJTttwlXJLa22tZbhPiH0cCSynoOJ8GDogXNUWjnK
         TIGj/WZCBfZGlPFgHzezWaT+Qer2iqw5E8g3pOVT1X+fTNK4pLCxURqMQ3ydMNabKKgN
         Sk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwmkKepYaQPG3xsqn+DwHZ7XE2byRrcxOGkZ6YwM6Xc=;
        b=q7D0Hwjj+lAcVaFqHYkI89ueirNWfcO7niwjxwXlvr3lZlfsea1Cu5pvVNy2MhRaEd
         Dx+5uIGHeCJVulJBTxMHXT6feIZ25TyrK+Q0c9WcXRNu71CrFhcLh0gnXfKJeG2yG3qO
         jLVNt47js/dq5Jjr45eg0fRo3pZ9glrHjFVFsLQntUsAELEssV9HIMVrFui7wfmuKTxt
         wHWkaoQ9u7YnKAhdfATy0nMc5a+NOsuDJ++YRDc56sIEP7FucVSG9kZ/s/H4fkCmpeMU
         S0njFmrCWJA9z/evAxtePH5p25ZXv65ZEQIHWyXtD5HOjIZJ5Y00qsxBlLt3S6Cod1kn
         HCDw==
X-Gm-Message-State: AJIora+oyha7xRONO2Pdl4VqquRFf+i8/sp/6n4qLIl4054QSAkRn/wg
        cUnNPmf6zWeJYwZokVtyiS7OQSBwZp3Kn3xQkA0=
X-Google-Smtp-Source: AGRyM1tKv7O9dmWsVuBuQlaB7D/FC7llIwKaFKFoiNxFabPkpTfEh2ATStY72zUgh38kriBabAeoWA==
X-Received: by 2002:a5d:4602:0:b0:21d:6784:cdcb with SMTP id t2-20020a5d4602000000b0021d6784cdcbmr21871455wrq.470.1657636876960;
        Tue, 12 Jul 2022 07:41:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6681000000b0021d6924b777sm8269499wru.115.2022.07.12.07.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:41:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFCv2 2/9] net: devlink: add unlocked variants of devling_trap*() functions
Date:   Tue, 12 Jul 2022 16:41:05 +0200
Message-Id: <20220712144112.2905407-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712144112.2905407-1-jiri@resnulli.us>
References: <20220712144112.2905407-1-jiri@resnulli.us>
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

Add unlocked variants of devl_trap*() functions to be used in drivers
called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- s/ret/err/
- quashed the similar traps policer patch
---
 include/net/devlink.h |  20 +++++
 net/core/devlink.c    | 180 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 168 insertions(+), 32 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 88c701b375a2..fb1e17d998b6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1745,9 +1745,15 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 					 const char *component,
 					 unsigned long timeout);
 
+int devl_traps_register(struct devlink *devlink,
+			const struct devlink_trap *traps,
+			size_t traps_count, void *priv);
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
 			   size_t traps_count, void *priv);
+void devl_traps_unregister(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count);
 void devlink_traps_unregister(struct devlink *devlink,
 			      const struct devlink_trap *traps,
 			      size_t traps_count);
@@ -1755,17 +1761,31 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 			 void *trap_ctx, struct devlink_port *in_devlink_port,
 			 const struct flow_action_cookie *fa_cookie);
 void *devlink_trap_ctx_priv(void *trap_ctx);
+int devl_trap_groups_register(struct devlink *devlink,
+			      const struct devlink_trap_group *groups,
+			      size_t groups_count);
 int devlink_trap_groups_register(struct devlink *devlink,
 				 const struct devlink_trap_group *groups,
 				 size_t groups_count);
+void devl_trap_groups_unregister(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count);
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count);
 int
+devl_trap_policers_register(struct devlink *devlink,
+			    const struct devlink_trap_policer *policers,
+			    size_t policers_count);
+int
 devlink_trap_policers_register(struct devlink *devlink,
 			       const struct devlink_trap_policer *policers,
 			       size_t policers_count);
 void
+devl_trap_policers_unregister(struct devlink *devlink,
+			      const struct devlink_trap_policer *policers,
+			      size_t policers_count);
+void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d2a4e6ee1be6..b0f6e8388880 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11544,7 +11544,7 @@ static void devlink_trap_disable(struct devlink *devlink,
 }
 
 /**
- * devlink_traps_register - Register packet traps with devlink.
+ * devl_traps_register - Register packet traps with devlink.
  * @devlink: devlink.
  * @traps: Packet traps.
  * @traps_count: Count of provided packet traps.
@@ -11552,16 +11552,16 @@ static void devlink_trap_disable(struct devlink *devlink,
  *
  * Return: Non-zero value on failure.
  */
-int devlink_traps_register(struct devlink *devlink,
-			   const struct devlink_trap *traps,
-			   size_t traps_count, void *priv)
+int devl_traps_register(struct devlink *devlink,
+			const struct devlink_trap *traps,
+			size_t traps_count, void *priv)
 {
 	int i, err;
 
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -11573,7 +11573,6 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
@@ -11581,24 +11580,47 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devl_traps_register);
+
+/**
+ * devlink_traps_register - Register packet traps with devlink.
+ * @devlink: devlink.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ * @priv: Driver private information.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_traps_register(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count, void *priv)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_traps_register(devlink, traps, traps_count, priv);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
 
 /**
- * devlink_traps_unregister - Unregister packet traps from devlink.
+ * devl_traps_unregister - Unregister packet traps from devlink.
  * @devlink: devlink.
  * @traps: Packet traps.
  * @traps_count: Count of provided packet traps.
  */
-void devlink_traps_unregister(struct devlink *devlink,
-			      const struct devlink_trap *traps,
-			      size_t traps_count)
+void devl_traps_unregister(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count)
 {
 	int i;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11607,6 +11629,23 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
+}
+EXPORT_SYMBOL_GPL(devl_traps_unregister);
+
+/**
+ * devlink_traps_unregister - Unregister packet traps from devlink.
+ * @devlink: devlink.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_traps_unregister(struct devlink *devlink,
+			      const struct devlink_trap *traps,
+			      size_t traps_count)
+{
+	devl_lock(devlink);
+	devl_traps_unregister(devlink, traps, traps_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
@@ -11766,20 +11805,20 @@ devlink_trap_group_unregister(struct devlink *devlink,
 }
 
 /**
- * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * devl_trap_groups_register - Register packet trap groups with devlink.
  * @devlink: devlink.
  * @groups: Packet trap groups.
  * @groups_count: Count of provided packet trap groups.
  *
  * Return: Non-zero value on failure.
  */
-int devlink_trap_groups_register(struct devlink *devlink,
-				 const struct devlink_trap_group *groups,
-				 size_t groups_count)
+int devl_trap_groups_register(struct devlink *devlink,
+			      const struct devlink_trap_group *groups,
+			      size_t groups_count)
 {
 	int i, err;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11791,7 +11830,6 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
@@ -11799,26 +11837,65 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devl_trap_groups_register);
+
+/**
+ * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_trap_groups_register(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_trap_groups_register(devlink, groups, groups_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
 
+/**
+ * devl_trap_groups_unregister - Unregister packet trap groups from devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ */
+void devl_trap_groups_unregister(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int i;
+
+	devl_assert_locked(devlink);
+	for (i = groups_count - 1; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, &groups[i]);
+}
+EXPORT_SYMBOL_GPL(devl_trap_groups_unregister);
+
 /**
  * devlink_trap_groups_unregister - Unregister packet trap groups from devlink.
  * @devlink: devlink.
  * @groups: Packet trap groups.
  * @groups_count: Count of provided packet trap groups.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count)
 {
-	int i;
-
 	devl_lock(devlink);
-	for (i = groups_count - 1; i >= 0; i--)
-		devlink_trap_group_unregister(devlink, &groups[i]);
+	devl_trap_groups_unregister(devlink, groups, groups_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
@@ -11905,7 +11982,7 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 }
 
 /**
- * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * devl_trap_policers_register - Register packet trap policers with devlink.
  * @devlink: devlink.
  * @policers: Packet trap policers.
  * @policers_count: Count of provided packet trap policers.
@@ -11913,13 +11990,13 @@ devlink_trap_policer_unregister(struct devlink *devlink,
  * Return: Non-zero value on failure.
  */
 int
-devlink_trap_policers_register(struct devlink *devlink,
-			       const struct devlink_trap_policer *policers,
-			       size_t policers_count)
+devl_trap_policers_register(struct devlink *devlink,
+			    const struct devlink_trap_policer *policers,
+			    size_t policers_count)
 {
 	int i, err;
 
-	devl_lock(devlink);
+	devl_assert_locked(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11934,35 +12011,74 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	devl_unlock(devlink);
-
 	return 0;
 
 err_trap_policer_register:
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devl_trap_policers_register);
+
+/**
+ * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ *
+ * Return: Non-zero value on failure.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+int
+devlink_trap_policers_register(struct devlink *devlink,
+			       const struct devlink_trap_policer *policers,
+			       size_t policers_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_trap_policers_register(devlink, policers, policers_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
 
+/**
+ * devl_trap_policers_unregister - Unregister packet trap policers from devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ */
+void
+devl_trap_policers_unregister(struct devlink *devlink,
+			      const struct devlink_trap_policer *policers,
+			      size_t policers_count)
+{
+	int i;
+
+	devl_assert_locked(devlink);
+	for (i = policers_count - 1; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, &policers[i]);
+}
+EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
+
 /**
  * devlink_trap_policers_unregister - Unregister packet trap policers from devlink.
  * @devlink: devlink.
  * @policers: Packet trap policers.
  * @policers_count: Count of provided packet trap policers.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
  */
 void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count)
 {
-	int i;
-
 	devl_lock(devlink);
-	for (i = policers_count - 1; i >= 0; i--)
-		devlink_trap_policer_unregister(devlink, &policers[i]);
+	devl_trap_policers_unregister(devlink, policers, policers_count);
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
-- 
2.35.3

