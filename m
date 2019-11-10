Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB7F69B0
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKJPb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:31:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39869 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfKJPb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 10:31:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so10785085wmi.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 07:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtflVGF+Kr+eAd2dYWbOTJTeyatTdfzxiP4Ca/5ZmLU=;
        b=K+YnWWnRgLrJiLzbTxpkTMNAJA2eyRvm5n0hnBsaxcjKtFAE2rUJMTM3fxIsvVIvXq
         Ey0WI5DzSwOEnO61qIyfmqvjxIHqO9QRlWSZZfy6dM3eX4PYZpm72FrDraZlf+ftXrXm
         RcGLG9XeDjRJcWsomw49mZ3je6hBNZGOq68pqVaySga0RBXP9WY+VHFFZJnxHFJHDkh/
         yk3BtnPTmmTv5q1ScNboDTH0tPPqP49Ry4/Ib/s1zflGKIeQoRbRR1SNJjWFPQPnVi72
         iOsoM8tVl2Wgj9axwwr0GbWXXA7FR3dAgm57HJx1CcTNKmtQIfpJmGY7Hq4A1ogEMXBP
         66qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtflVGF+Kr+eAd2dYWbOTJTeyatTdfzxiP4Ca/5ZmLU=;
        b=ZQU+ZxhWHpQncx0CVgrd/fVupoWDiQoZbg8ZiSDZMwky7Z7aZo2MT1TwCH6fXBYbXk
         WSKXEbmRogclkagjjZKilNXDeRGBm2IhxadeR8tpio7v6NshK5Bc1kIKoqRtfAY+quW0
         0isdndLCMpzrAOtDDUeZA31WHqQO7yVpiCKSUP4cf422rHpEAj56SwqNsvAYd9UqCXQZ
         rt06jiPOpj6gnycI15VictYSiOYpyG1N03lWBeIGh+lW9onu6ONT5WpMPJdXzVG69siC
         Jbs1Aqy0XQkkZ9zIdGCyQl8HqvCip8fcvLI0c4ETOPJNt9u7vzGWxMSN4pz2D+1Ryswl
         ch0g==
X-Gm-Message-State: APjAAAU2caZ/5yMd40FjIrYg6b24MgA4661ScprAHZz6GxxOevLFN4cM
        SzOamJHtWAn3vPMF2qRaw50VZ/MnZoU=
X-Google-Smtp-Source: APXvYqxDI4auf30cUZjVmgS1TGos8MCJNCisoBK5GkA1hFkOKe34CMrRxbrTprmgY0+o+D1A8KA6aw==
X-Received: by 2002:a1c:1f14:: with SMTP id f20mr15391175wmf.147.1573399884500;
        Sun, 10 Nov 2019 07:31:24 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g5sm13142300wma.43.2019.11.10.07.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 07:31:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        idosch@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com
Subject: [patch net] mlxsw: core: Enable devlink reload only on probe
Date:   Sun, 10 Nov 2019 16:31:23 +0100
Message-Id: <20191110153123.15885-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Call devlink enable only during probe time and avoid deadlock
during reload.

Reported-by: Shalom Toledo <shalomt@mellanox.com>
Fixes: 5a508a254bed ("devlink: disallow reload operation during device cleanup")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 20e9dc46cacd..0a0884d86d44 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1186,10 +1186,11 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register) {
+	if (mlxsw_driver->params_register)
 		devlink_params_publish(devlink);
+
+	if (!reload)
 		devlink_reload_enable(devlink);
-	}
 
 	return 0;
 
-- 
2.21.0

