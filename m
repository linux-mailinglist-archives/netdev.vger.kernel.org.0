Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995E0B2A2F
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfINGqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37278 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfINGqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id r195so4857182wme.2
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=07VDUuxSvstNjpboveGcx1uS6trBPHXOCcUfsgu9YXM=;
        b=L1sjUUHi5WGqj+xtFyoeNwCkw6HVbTeZ/ixA74Cwy4+OvD07y0eagBKpxi6Ckd5Yg9
         WBQA9uFzHwuQfFX0UfuNRQtNHtu18o+cMXjcPWfCCWLvTEjxSsumzA1FcVXmtKzoHi4D
         FKgR2PTeXMvjGbdLCVHZ1baaKQ1WvvnBTjKp6COe54hZU0wcI+pKlpPbLpXSL2pi5ehu
         6dwOHvNBsSpiM+m2Flq/UArapgWkYfu52e2UFmmN8PdA1pioqSklHTFIqxYOK5+0nBBZ
         pXbGg0P8nfHLP07kX3w9R1bib/adoZlChu/TjsR1Utxkcmfh8WacDKhdtD3cUfXQAQ+Q
         m4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=07VDUuxSvstNjpboveGcx1uS6trBPHXOCcUfsgu9YXM=;
        b=ITXVTrRv45rcNLqGiNtwqCP/tMcdZ/j4q5rq73cLEzUQTGjWhozcyQPeiwo2A5HuPS
         W4AfzG3+ui10SrueQMY4fPhRqzqCJDnAKCQYx4wpIZoFQ/NT/TTPTRBppAs+t/AMhBrp
         x5et/YZEOV6cZKhP5cFj5tM0LaAW6zHCyxjvCbdlmGk1FrOQkTqJ29tMpdm4Ca5HD9gg
         RjXHNfCun4lI6ardiQ+memb+WjrRlYjvNqt7+cu5VL7PihkDG0T9AmYs0+ZdgSDCFOKu
         mreQNERwfc7AtcTsa7yyF1n3xdjpGQmyNRM7YtsBYV/W082kdIOOo+1TDZQfXQjPRnO5
         2dDw==
X-Gm-Message-State: APjAAAWOo378fUZxTY+RG98+21BdwPNJ9VnF2RfL7OJs67fv7B53L+DY
        jmjRSAgGE2DAm0q6EgZhtbjrrEnjslo=
X-Google-Smtp-Source: APXvYqxndoD2/cqAF46pjAevcPXzn3towDlmoqQkcnTkDaf31fcSWOykM0uHsPWTzlCbilPqai28ng==
X-Received: by 2002:a7b:c844:: with SMTP id c4mr6317725wml.7.1568443578321;
        Fri, 13 Sep 2019 23:46:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b7sm10346977wrj.28.2019.09.13.23.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:18 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 08/15] mlxsw: Register port netdevices into net of core
Date:   Sat, 14 Sep 2019 08:46:01 +0200
Message-Id: <20190914064608.26799-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When creating netdevices for ports, put then under network namespace
that the core/parent devlink belongs to.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
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
index 91e4792bb7e7..92b37b806dc1 100644
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

