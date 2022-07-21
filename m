Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB557CD8A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiGUOZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiGUOYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:24:54 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3445087214
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:24:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id z23so3452424eju.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtGui3cKEwxLvTPkquPNo04ZlFztBcgC2vAUL5ujRGU=;
        b=hyvEH0SnEW5w1DI5fcZnlqg3BvVy64LDAWKSPLTaCtbtGb683UuD4TCpLp+2OcH7V0
         4CQxwtXZd/1DQdBr+XVamx7ZwlnxCw3Dbh5vh35VHSMH2Jf1sSZTHYv5r9b3R7Vsh6xp
         xuM5c67HaPbPo8jMH160R56M+18X2GUtbH38V7esWef7NCC7ZL6MAf18yPo/WMu5tT5c
         sBJgA0ULK/+6zAEPKe4JjkUaZQaTpF/GZyfJwv3Thobfj0+6lj9gQTN33G7lcj14Bomq
         QNcxsWcVYqTuY8FOA68UhcyrxvLIiOX46eANSXd3P0VzAIojTT1AvZj0sHCCxcgf5XuX
         GWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtGui3cKEwxLvTPkquPNo04ZlFztBcgC2vAUL5ujRGU=;
        b=hiTxQjga8RiMfJiZicyHVuIJr+7LJ1pnDWZfNee5tqtctzHhz2nF0rYrmRBasB2qg9
         Dv4Kxmn6aB7NDgCw1QTy7YNeIfOoCPHM2v7q93xj/so2snpJ8gQL15i2f33KBpzQEZ0l
         +M5gVVn3vR1AQOoDROJixZthOogMIlQUHx3mjiELYhjPhrnUkGra4AS5Fiwr5L9yqBlr
         mn9ZtExhWNjOU66FqNJKn5YyoyJzqwSizAI6UAiC6k4hn2yI0s8GVOu7nYxpcUvLjMtl
         8dddEIcUQBfhP+BGG2oM22VycIEFkiedf1tikNy50faibIWunlCnfPMro2lCZRTnfSaz
         2E2g==
X-Gm-Message-State: AJIora+d2tXnBI6K8tWuXDpFR6dIsULlyGMk6un9yJXke6u4k2/vSUt/
        7ZN/tRtgG3nMsn2WYji1tNehLTkV6sR6y1Zs6fY=
X-Google-Smtp-Source: AGRyM1trfZeZRgFgn7G9QotfTTdjoSAgIp/lhJKdiTEYVnrZ4RRIdW1YTTfYhjQHFiXkUvzIuriAlQ==
X-Received: by 2002:a17:907:3f29:b0:72b:91df:2c4b with SMTP id hq41-20020a1709073f2900b0072b91df2c4bmr40402192ejc.206.1658413466028;
        Thu, 21 Jul 2022 07:24:26 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k7-20020a056402048700b0043a61f6c389sm1072490edv.4.2022.07.21.07.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:24:25 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next] mlxsw: core: Fix use-after-free calling devl_unlock() in mlxsw_core_bus_device_unregister()
Date:   Thu, 21 Jul 2022 16:24:24 +0200
Message-Id: <20220721142424.3975704-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
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

Do devl_unlock() before freeing the devlink in
mlxsw_core_bus_device_unregister() function.

Reported-by: Ido Schimmel <idosch@nvidia.com>
Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 61eb96b93889..1b61bc8f59a2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2296,8 +2296,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 		devl_resources_unregister(devlink);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
 	if (!reload) {
-		devlink_free(devlink);
 		devl_unlock(devlink);
+		devlink_free(devlink);
 	}
 
 	return;
@@ -2305,8 +2305,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
 	devl_resources_unregister(devlink);
-	devlink_free(devlink);
 	devl_unlock(devlink);
+	devlink_free(devlink);
 }
 EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
 
-- 
2.35.3

