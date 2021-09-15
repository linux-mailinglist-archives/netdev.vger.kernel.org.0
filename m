Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4640C36E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbhIOKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:14:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55663 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237446AbhIOKOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E5E325C00F4;
        Wed, 15 Sep 2021 06:13:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Sep 2021 06:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QqslgGeAUhhTJyU7zeenZChhFT84TNcp3cYacVwncho=; b=vvDo2BHb
        J1LA5hSQYSacopE+NFYD5dsLhJ5N1Xc/YJ0Pqw6jf6XvBzs7gKEp/n2xeBe8+Gbz
        vwr2VDAOuUDPa0oW5x+1Ez92IfWXYVVcQAYq44UnnaMKGL52ADmmhMrUaMbTM7PT
        Jez6agdCim/wyG2wMm29Ptk70LrCiF0iwJQCjvC601orgEslWg5rD+F1euYoXNh5
        /8MYUYHaU7V9AZVnWFtpQ82QH1W7y5s32GwhOqQptqqnw6QAvVGokulanC00re4k
        w7DUr/HPvmmGi44urtKOvyB8UVmobEOOBsj6riSRCAUhykNt0nvjHXCO0TrmOYt/
        ZnhWKYYZ+QH7IQ==
X-ME-Sender: <xms:TMdBYSrwSZxWnVRjXilE-e_P7OBpyqv154tgW-CefROb_i1v_qDJtA>
    <xme:TMdBYQoa7xNmRfXWSy4wot5R3F70hVWzqR0roS7u5nYEqTiJyvft9fZ8Mwu_8OjUg
    MraFBrRiPJnfMo>
X-ME-Received: <xmr:TMdBYXNqy_LreiRACwh_SN1tr_oD4W51w0VSmbk9Dcjh5YAtuOC5APYja-i9rM6fVCxogh16WRHoLhfobt85ax0J20hNprEE5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TMdBYR4RJ0N2AEJzgKObgJzH5b2mPPqaEDF3fKYYMaeRXxLKmSCYzg>
    <xmx:TMdBYR4C77hAb6EFhft7hpzOJeY1zz7jeQaIVWWDxWJVWWlQvGrF2Q>
    <xmx:TMdBYRh3OfIFqMsCsppYEMWCyzj8LJxhO2Hto7o69nkDttD-kqwMng>
    <xmx:TMdBYfQXiuBWFIzAUhZziV5nHYJv_N68TG1YAJ18n-0X12NdAYq19g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: core_env: Defer handling of module temperature warning events
Date:   Wed, 15 Sep 2021 13:13:07 +0300
Message-Id: <20210915101314.407476-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Module temperature events are currently handled in softIRQ context,
requiring the 'module_info_lock' to be a spin lock. In future patchsets
we will need to be able to hold the lock while sleeping.

Therefore, defer handling of these events using a work queue so that the
next patch will be able to convert the lock to a mutex.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 39 ++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 27e721f96b3b..27eba0a0c91c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -482,20 +482,30 @@ static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-static void mlxsw_env_mtwe_event_func(const struct mlxsw_reg_info *reg,
-				      char *mtwe_pl, void *priv)
+struct mlxsw_env_module_temp_warn_event {
+	struct mlxsw_env *mlxsw_env;
+	char mtwe_pl[MLXSW_REG_MTWE_LEN];
+	struct work_struct work;
+};
+
+static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 {
-	struct mlxsw_env *mlxsw_env = priv;
+	struct mlxsw_env_module_temp_warn_event *event;
+	struct mlxsw_env *mlxsw_env;
 	int i, sensor_warning;
 	bool is_overheat;
 
+	event = container_of(work, struct mlxsw_env_module_temp_warn_event,
+			     work);
+	mlxsw_env = event->mlxsw_env;
+
 	for (i = 0; i < mlxsw_env->module_count; i++) {
 		/* 64-127 of sensor_index are mapped to the port modules
 		 * sequentially (module 0 is mapped to sensor_index 64,
 		 * module 1 to sensor_index 65 and so on)
 		 */
 		sensor_warning =
-			mlxsw_reg_mtwe_sensor_warning_get(mtwe_pl,
+			mlxsw_reg_mtwe_sensor_warning_get(event->mtwe_pl,
 							  i + MLXSW_REG_MTMP_MODULE_INDEX_MIN);
 		spin_lock(&mlxsw_env->module_info_lock);
 		is_overheat =
@@ -524,10 +534,29 @@ static void mlxsw_env_mtwe_event_func(const struct mlxsw_reg_info *reg,
 			spin_unlock(&mlxsw_env->module_info_lock);
 		}
 	}
+
+	kfree(event);
+}
+
+static void
+mlxsw_env_mtwe_listener_func(const struct mlxsw_reg_info *reg, char *mtwe_pl,
+			     void *priv)
+{
+	struct mlxsw_env_module_temp_warn_event *event;
+	struct mlxsw_env *mlxsw_env = priv;
+
+	event = kmalloc(sizeof(*event), GFP_ATOMIC);
+	if (!event)
+		return;
+
+	event->mlxsw_env = mlxsw_env;
+	memcpy(event->mtwe_pl, mtwe_pl, MLXSW_REG_MTWE_LEN);
+	INIT_WORK(&event->work, mlxsw_env_mtwe_event_work);
+	mlxsw_core_schedule_work(&event->work);
 }
 
 static const struct mlxsw_listener mlxsw_env_temp_warn_listener =
-	MLXSW_EVENTL(mlxsw_env_mtwe_event_func, MTWE, MTWE);
+	MLXSW_EVENTL(mlxsw_env_mtwe_listener_func, MTWE, MTWE);
 
 static int mlxsw_env_temp_warn_event_register(struct mlxsw_core *mlxsw_core)
 {
-- 
2.31.1

