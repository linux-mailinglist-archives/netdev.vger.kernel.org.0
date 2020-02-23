Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF43216969B
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBWHbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39796 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBWHbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so6103206wme.4
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ynrgChH9USEvNYYWaKD0sP+5DNWQTYUObpfKSbrKRTo=;
        b=E8jjNU77aQBMtzVNlgRwFzn7x/qf84PvOiHrcU8YVWrSdIZwyDtgZg0h7zPEE3TQfS
         e6ctHF6lpUXVWl+304AaHaGpn2Hq+P8tMyhPpWj4EWl8BW2o09xPd8SQ8Pxee+cbo0hl
         RR5kT5Z8Jel6yeEtwUwWN+v3aqJhlPqUWOXymm27iLL4U1+AWO2N5DGzFVERBIUzuxAe
         YfNU6grvGIrsXjvTPRdJyQFHotK3H3Eioz0Byx5holn6BMbLKS0nJig02YENV4sWnYZ8
         Mil7RG5M8w22GKDDxrWKksBd95xEzxXhqrBBFOcppgWtn6LSIzTfyddyKqmRO39ubdWF
         CglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ynrgChH9USEvNYYWaKD0sP+5DNWQTYUObpfKSbrKRTo=;
        b=dnwsDjOXzq4+Ddia9yGGq9CxlEPOEgYoHKbmGo2X3N/gmYZkHwu2/s14BQqE1ti66Z
         kVUWBgfoxKcxFhCpUyEtiIqVOGisfkJ6ymzENV+3dj8AzGP2a9FPpH8eAQbisYcgGwAP
         veHuqmrBvJsogbeUX7Q3RiqIE2N1YtcCPc5mHIrrBfJqYkqgXb2qXntb2Hy74KvW6Ded
         JTsmh1x5R0cEXGvdfNjzAsEicyzX2g2vMuzmKldZwrReQ/E/hJZGjF1tgjcf3o2Y9CfQ
         ktSUNir0h3n+9dGyrd8UNycXp4utcpVNB5c6/1bd9FAO+QvesokyWnd5xx7pnzrrfNkF
         U1yw==
X-Gm-Message-State: APjAAAXPZNHbhCQPBzFYW/GqH7JdwOBcX8IZuA1dGMxNUHg2XOBLp6Uq
        yrD2d1aOCFYYVRmS2q3vcnU61C2BH1Y=
X-Google-Smtp-Source: APXvYqxkLCIK0h/YbbEJ7guO0TRml7noKZqC8Lsax3xp31xh9pOX0pXtqc42kAwkN52f53akSb7OIw==
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr14225286wme.36.1582443107037;
        Sat, 22 Feb 2020 23:31:47 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id d17sm7077039wmb.36.2020.02.22.23.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:46 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 01/12] mlxsw: spectrum_trap: Use err variable instead of directly checking func return value
Date:   Sun, 23 Feb 2020 08:31:33 +0100
Message-Id: <20200223073144.28529-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When calling mlxsw_sp_rx_listener(), use err variable instead of directly
checking func return value.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 60205aa3f6a5..28d2c09c867e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -199,11 +199,13 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp;
 	struct devlink *devlink;
+	int err;
 
 	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
-	if (mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port))
+	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
+	if (err)
 		return;
 
 	devlink = priv_to_devlink(mlxsw_sp->core);
@@ -221,11 +223,13 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp;
 	struct devlink *devlink;
+	int err;
 
 	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
-	if (mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port))
+	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
+	if (err)
 		return;
 
 	devlink = priv_to_devlink(mlxsw_sp->core);
-- 
2.21.1

