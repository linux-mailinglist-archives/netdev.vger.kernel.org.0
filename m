Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8EC8DFC
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfJBQMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37281 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJBQMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so20363606wro.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gKhKIeZQO4PLxR8hjsn0TTvjRgdzYwngyrAcsjqQxhw=;
        b=1QEUfE+G9ElcRPSMl/4N6GfJhnC8+i8djaKjp982PGyKeaGbmVh4QLuQtXPNJoxz5O
         OzozZXti9QODACz5O3k61cx2H3/mud43m1+E54XkKX8Irx11Hm9fbH+yKsL2zqN6qgFS
         cINgZQQbGLFH6BnJtBVpbtyelJLuIKyenSY6GctNDZgF5BMBiOy0NCaUALi18xcd8oul
         8WvDmjD51EQwSU8Mv8md4et40DpMbF5RF5QRGO+hi6mBR7eCBy8l/DfNQdUQSGJWXe5l
         f3QPnUuwm8063WfkjS9SVMgSLiwSIKnL/G0blTmq3CJF/05dymeUp3fq/ghTBrRQqb0f
         M82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gKhKIeZQO4PLxR8hjsn0TTvjRgdzYwngyrAcsjqQxhw=;
        b=sZRzHMK9nIvEMFFBxZNQ4SPbGhSgzXUZ370eBth87zCDlUfZtsw8x+h2ea7oWIyoBe
         HdCe3tLmQc2CqkIgrdXuxQT2Y9/5DTzajT9BJfiHwhf2+m5dXMZLBCNhknVo/BdFT15J
         956woeQ3xUk0PJz2VNGvJIZxgM6meoaeJnPRIRmpLTDDov+Hwwe27p+OQavDVHVoIJti
         +xu2A9OoOuD1OkHMqWKwMOVHDcKf2JZZu56RU+bTOUuJhQnP2uF303MTz0Sle7mC4z3X
         fRDQUtjGkaoKdvD+CAyeQdSu4Ps4wXZMV56427UqcuFv2Zj6R+Z4oLiPg2CsUAbygENO
         Adcw==
X-Gm-Message-State: APjAAAVV83Mdwx7Hj1+KfX/mQrARzcgf0eCkVX+AC9e0rzcQJ63YQT5V
        fre1qMFtjdT8LS2ckpDlV5o+7ysD7b0=
X-Google-Smtp-Source: APXvYqyXjj6gKWHLkLIVd66uSUffQdIk6V10Z7g83LOVoROUBTM75s/c26VUW6PdaGPezq5NCIRGUg==
X-Received: by 2002:adf:ed04:: with SMTP id a4mr3411689wro.77.1570032761014;
        Wed, 02 Oct 2019 09:12:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b7sm16726342wrj.28.2019.10.02.09.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 08/15] mlxsw: Register port netdevices into net of core
Date:   Wed,  2 Oct 2019 18:12:24 +0200
Message-Id: <20191002161231.2987-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
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

