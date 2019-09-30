Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDA6C1CB1
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbfI3IPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:15:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44689 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729977AbfI3IPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:15:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id i18so10076649wru.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 01:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72Bti5Xomu8lsqeLJ36Ug9HO3KzArhM7QjYJiIwz0/E=;
        b=hLB7V/XbSx3HjfswJvRZYpvG8BLfPQFJLFqDsvQpzF5lFVmh0DOTnlhFCRcsq8HiNz
         IiXeyUTDN/LYekP3RYRZtogpg1+tD0Y8pWjQS133XikLZr2FAkujrFhpPXjQAt68EkLe
         kz6LjYLUZzp5jFLaVSN9k1cMuBOuDTPKkuL660hcIvkheZVq2Y6HD1/Wxlq0P9dMVA8l
         TaZ7yQ9YT/ERbuKF5EPIDu2epYBkQ/SSqG6SsI1Gx5+Sk2Qe6BGDY7htq3HmoB1Q70m1
         ZR20tpa0cL1+IUyujmu7aZ8e2MV7+WC+ZnAsf/xLYA8EF6bSEyW90Wi3LQL/FGK0cbVK
         9vUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72Bti5Xomu8lsqeLJ36Ug9HO3KzArhM7QjYJiIwz0/E=;
        b=ey3pp5jUzIUCeN6AtzwEm5nmQrYRNumsecsvzt/HHl6xIy566nKFNr3XCjRpOejw2P
         6uusk1T/+cZgp9srAGqkrhB+a3aI25f9eev5g3yRNXz2Q2y1a2XbB3DT0bsnMKNmMea3
         8yBUcEP6u8ghkPYj1loAj0YQHq5v/QL1cmNf76ScP1S39VRRCwaYRIrYmFtxbMQVF+bh
         K8gIyerG9WROOPK1Nwsti0PIqBMZzKZSWELDFICIERydGTAcrCwhjCFEzueQtALa1qrk
         h1NMr70vguxMth6mOkc8u991hMhp2PDv3I2Pne4o4cPoEeluoqGpNbm/njStutd5jbDf
         e4aw==
X-Gm-Message-State: APjAAAWz1+GdAQs2V0KSLdKwhk7wEzmwapjxjehca+oDpg7L80aDwH0x
        7gdr1PbRf7pDlAqTtNKoADIDgOGstZU=
X-Google-Smtp-Source: APXvYqz7gGSLajG3vrZYWf0SBAA4hRmEaVIoUf3MUkXqgIdP7TCkDwtjFkuuTrcCbZpsDfFl30pddA==
X-Received: by 2002:a5d:5185:: with SMTP id k5mr12878386wrv.341.1569831316002;
        Mon, 30 Sep 2019 01:15:16 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id r2sm15652380wrm.3.2019.09.30.01.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:15:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: [patch net-next 3/3] mlxsw: spectrum: Use per-netns netdevice notifier registration
Date:   Mon, 30 Sep 2019 10:15:11 +0200
Message-Id: <20190930081511.26915-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930081511.26915-1-jiri@resnulli.us>
References: <20190930081511.26915-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The mlxsw_sp instance is not interested in events happening in other
network namespaces. So use "_net" variants for netdevice notifier
registration/unregistration and get only events which are happening in
the net the instance is in.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dcf9562bce8a..a54a0dc82ff2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4864,7 +4864,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	 * respin.
 	 */
 	mlxsw_sp->netdevice_nb.notifier_call = mlxsw_sp_netdevice_event;
-	err = register_netdevice_notifier(&mlxsw_sp->netdevice_nb);
+	err = register_netdevice_notifier_net(&init_net,
+					      &mlxsw_sp->netdevice_nb);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to register netdev notifier\n");
 		goto err_netdev_notifier;
@@ -4887,7 +4888,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_ports_create:
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 err_dpipe_init:
-	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
+	unregister_netdevice_notifier_net(&init_net,
+					  &mlxsw_sp->netdevice_nb);
 err_netdev_notifier:
 	if (mlxsw_sp->clock)
 		mlxsw_sp->ptp_ops->fini(mlxsw_sp->ptp_state);
@@ -4973,7 +4975,8 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 
 	mlxsw_sp_ports_remove(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
-	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
+	unregister_netdevice_notifier_net(&init_net,
+					  &mlxsw_sp->netdevice_nb);
 	if (mlxsw_sp->clock) {
 		mlxsw_sp->ptp_ops->fini(mlxsw_sp->ptp_state);
 		mlxsw_sp->ptp_ops->clock_fini(mlxsw_sp->clock);
-- 
2.21.0

