Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37CB9C9B08
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfJCJtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41607 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfJCJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id q9so2208373wrm.8
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gKhKIeZQO4PLxR8hjsn0TTvjRgdzYwngyrAcsjqQxhw=;
        b=tiC1dFHbD3Grskobrf3bRS5FpMSsBABZbFZHAbRfX4uLLnDneCEH1vI9MMn339Bykj
         3kuYpN5HIfW/zm2I5097mG7plJkhGMARZxkVf1GxV8IVtwiPsI0ADjZoIjR6WAKro5vE
         fhxNvx+BONz4NzFjvQ+a8mDzVeRbFzGkeY8GL2qXjWRY5h60OMXbgjHKXVJKRt/earlO
         BWIBHPI4zqxuw5Nwr3AUiohFGNGVLkKrltgchKg2gLQdBArY8TPzkcfOn1rfCuPei9iX
         A08LS2W2d+ZL4kvA5tVB4YEtiYQNPh9XoKUHdkCUzDV320Axz7VwBjBWlIQn89r8lLEG
         PtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gKhKIeZQO4PLxR8hjsn0TTvjRgdzYwngyrAcsjqQxhw=;
        b=qnR5nmLVI3/78rfNEFpRuo2n/WKW54/FXd9Inlauw/AoQ1WQ8EmlVWcFxY7vhnPGVA
         afZSf9bft3cES6G93u2ccwfNtvcBzQ6OFBaUVK93F6diMIXDVwh+iSRt9R02/H+peaUT
         oeo3jlYMXeNkr29D4CELcbgQe409a45tkZKuRft9AbR4cFsreJB81/uwy7g+g9ONEYzI
         XA0VQSUVUyLU7P1X4h8Zdpk4lI/yQ/FrBcUe3qtF4XpR5tOFA2A8jVhda5HdZprRtM/9
         rucGAtyao08BTRFQfOnOphvqGVVu1uXGrO0+0m2GA9+DVqRlTgNGWBA6+sogmIyUYJku
         HUDw==
X-Gm-Message-State: APjAAAUE4iOme/93q2YJOsySQdQgzcTjJcO63g8byWKkExXzLttidT3H
        I43d2ELsyaO8MAL3ol4C2OkiwcEQMaA=
X-Google-Smtp-Source: APXvYqxx8nlhlOcERJ8QrcpGnhmU7oXZv0Dh40s9nnX4bHhuGrLn9rjAynbtUx/+0IOr4NopWkldxg==
X-Received: by 2002:adf:e387:: with SMTP id e7mr6462875wrm.306.1570096191449;
        Thu, 03 Oct 2019 02:49:51 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id i5sm2200857wmd.21.2019.10.03.02.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 08/15] mlxsw: Register port netdevices into net of core
Date:   Thu,  3 Oct 2019 11:49:33 +0200
Message-Id: <20191003094940.9797-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When creating netdevices for ports, put them under network namespace
that the core/parent devlink belongs to.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- s/then/them/ in the patch description
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 1 +
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 471b0ca6d69a..cee16ad58307 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -172,6 +172,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	}
 
 	SET_NETDEV_DEV(dev, mlxsw_m->bus_info->dev);
+	dev_net_set(dev, mlxsw_core_net(mlxsw_m->core));
 	mlxsw_m_port = netdev_priv(dev);
 	mlxsw_m_port->dev = dev;
 	mlxsw_m_port->mlxsw_m = mlxsw_m;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 250448aecd67..a9ea9c7b9e59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3635,6 +3635,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_alloc_etherdev;
 	}
 	SET_NETDEV_DEV(dev, mlxsw_sp->bus_info->dev);
+	dev_net_set(dev, mlxsw_sp_net(mlxsw_sp));
 	mlxsw_sp_port = netdev_priv(dev);
 	mlxsw_sp_port->dev = dev;
 	mlxsw_sp_port->mlxsw_sp = mlxsw_sp;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 1c14c051ee52..a4d09392a8d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -992,6 +992,7 @@ static int __mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	if (!dev)
 		return -ENOMEM;
 	SET_NETDEV_DEV(dev, mlxsw_sx->bus_info->dev);
+	dev_net_set(dev, mlxsw_core_net(mlxsw_sx->core));
 	mlxsw_sx_port = netdev_priv(dev);
 	mlxsw_sx_port->dev = dev;
 	mlxsw_sx_port->mlxsw_sx = mlxsw_sx;
-- 
2.21.0

