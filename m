Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F1040C371
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhIOKO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:14:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57853 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237468AbhIOKOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:54 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id DE9155C0172;
        Wed, 15 Sep 2021 06:13:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 15 Sep 2021 06:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Yneql+3AT8D8iJLtYGCF/YH50hp5Zj/DPKQBmx0euu4=; b=EZaodx61
        FvXICqrTGRh16NpF14y/D4kssUdYyo4CEJsFNLKqCXNUYXwSb1V6Abd5CSOxp2Ft
        XT/iwXIN+tdfNqT9Br0d4MLiiFhx/MMWCsrjI3R+ippZ3wCGa7XXeaRXfC+/inpz
        2s1zWsujs3Uc9Rdi2sHL9ai+OpgALSIdvj5+1Cd0Hok8ocEYEpw3qUK9Jr6r+Aii
        53vbSTIVsAJMcIMeL6da/rSuUHo2euzg+6wQwddEDa+LxcYkJ1AIrV4SEshohXo9
        /d5VkMFho6jO0IxSdfoNDfBPrSXqEiN4Pf+YGjYAAYrq339I5STwOGX4pD7F+Zsl
        5+GcRaGWRDDj5A==
X-ME-Sender: <xms:TsdBYe0oVtK0NpPjYrmSNVmY2LhUrz7--szm-Jxo7m67O8AUHvBwlA>
    <xme:TsdBYRF35n9fgFx-LxD5XGAwVs6n_eA35zNWSmlfAzpSB6ZrDGd19pZBP-Tuq2JRP
    jQzKIq6jT9JSII>
X-ME-Received: <xmr:TsdBYW5QJv0iYvb9juAGVSBe1j-3C_bk_zsPZk-l6tqn2nsQtfgJz6E4N6TS_lfgAg4deCQeFArma6dogXcAL6JA22JV4RfhuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TsdBYf1-3gPcEIkro1g9GOmvro6INjTJxSsObx3BgUfhySabQ2uFcA>
    <xmx:TsdBYREkUz-7Q4kCtMdC5psSaRReWx9bLRhI2lnB5uKJgFYwUyBbtw>
    <xmx:TsdBYY89YCfoSCS0Y2q7lb1wfdDl07UQXU4Y0sFpiaoAH4qPS6ixgg>
    <xmx:TsdBYaNPs50QhcL6Rq_uG2W8UT3xwQT4Vq34JOzSza1zvCR2leBrnA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: core_env: Convert 'module_info_lock' to a mutex
Date:   Wed, 15 Sep 2021 13:13:08 +0300
Message-Id: <20210915101314.407476-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

After the previous patch, the lock is always taken in process context so
it can be converted to a mutex. It is needed for future changes where we
will need to be able to sleep when holding the lock.

Convert the lock to a mutex.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 27eba0a0c91c..543f401cb5c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/ethtool.h>
 #include <linux/sfp.h>
+#include <linux/mutex.h>
 
 #include "core.h"
 #include "core_env.h"
@@ -19,7 +20,7 @@ struct mlxsw_env_module_info {
 struct mlxsw_env {
 	struct mlxsw_core *core;
 	u8 module_count;
-	spinlock_t module_info_lock; /* Protects 'module_info'. */
+	struct mutex module_info_lock; /* Protects 'module_info'. */
 	struct mlxsw_env_module_info module_info[];
 };
 
@@ -507,7 +508,7 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 		sensor_warning =
 			mlxsw_reg_mtwe_sensor_warning_get(event->mtwe_pl,
 							  i + MLXSW_REG_MTMP_MODULE_INDEX_MIN);
-		spin_lock(&mlxsw_env->module_info_lock);
+		mutex_lock(&mlxsw_env->module_info_lock);
 		is_overheat =
 			mlxsw_env->module_info[i].is_overheat;
 
@@ -517,13 +518,13 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 			 * warning OR current state in "no warning" and MTWE
 			 * does not report warning.
 			 */
-			spin_unlock(&mlxsw_env->module_info_lock);
+			mutex_unlock(&mlxsw_env->module_info_lock);
 			continue;
 		} else if (is_overheat && !sensor_warning) {
 			/* MTWE reports "no warning", turn is_overheat off.
 			 */
 			mlxsw_env->module_info[i].is_overheat = false;
-			spin_unlock(&mlxsw_env->module_info_lock);
+			mutex_unlock(&mlxsw_env->module_info_lock);
 		} else {
 			/* Current state is "no warning" and MTWE reports
 			 * "warning", increase the counter and turn is_overheat
@@ -531,7 +532,7 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 			 */
 			mlxsw_env->module_info[i].is_overheat = true;
 			mlxsw_env->module_info[i].module_overheat_counter++;
-			spin_unlock(&mlxsw_env->module_info_lock);
+			mutex_unlock(&mlxsw_env->module_info_lock);
 		}
 	}
 
@@ -597,9 +598,9 @@ static void mlxsw_env_pmpe_event_work(struct work_struct *work)
 			     work);
 	mlxsw_env = event->mlxsw_env;
 
-	spin_lock_bh(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->module_info_lock);
 	mlxsw_env->module_info[event->module].is_overheat = false;
-	spin_unlock_bh(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->module_info_lock);
 
 	err = mlxsw_env_module_has_temp_sensor(mlxsw_env->core, event->module,
 					       &has_temp_sensor);
@@ -699,9 +700,9 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
 		return -EINVAL;
 
-	spin_lock_bh(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->module_info_lock);
 	*p_counter = mlxsw_env->module_info[module].module_overheat_counter;
-	spin_unlock_bh(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->module_info_lock);
 
 	return 0;
 }
@@ -725,7 +726,7 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (!env)
 		return -ENOMEM;
 
-	spin_lock_init(&env->module_info_lock);
+	mutex_init(&env->module_info_lock);
 	env->core = mlxsw_core;
 	env->module_count = module_count;
 	*p_env = env;
@@ -755,6 +756,7 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 err_module_plug_event_register:
 	mlxsw_env_temp_warn_event_unregister(env);
 err_temp_warn_event_register:
+	mutex_destroy(&env->module_info_lock);
 	kfree(env);
 	return err;
 }
@@ -765,5 +767,6 @@ void mlxsw_env_fini(struct mlxsw_env *env)
 	/* Make sure there is no more event work scheduled. */
 	mlxsw_core_flush_owq();
 	mlxsw_env_temp_warn_event_unregister(env);
+	mutex_destroy(&env->module_info_lock);
 	kfree(env);
 }
-- 
2.31.1

