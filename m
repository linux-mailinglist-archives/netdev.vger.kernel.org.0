Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADC9F69B2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKJPbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:31:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52240 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfKJPbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 10:31:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id c17so10796769wmk.2
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 07:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RnYSxk87fb/VR6ZUTie18l/+t1zJ4HyYOkmNS4kOfmw=;
        b=aKyA2kq6O+97MYxjefnLSVVVBTjByFomDU6j03Je3AIt5y3QEILS7kLOe0Q8WNKG5U
         oRyXYZNtNVz7cNKMUMd4tvNM/OO5OhbhcIf8PI/mUuuYeqGioiLxyuxf8uzUcUaMlVFz
         72PcAUqUefscjrVEvsfBMso+PGuP17ITFwBlYPBNlUpnxoJWwSqRl2GC9o5G1Q4miujV
         vbCRqdkypZ85yAcFUIMpAqGPQ8j58nPo2Uuuk9tAnqSYIhkez5QjpJRunNZaxq+V54n+
         yIioEfure6M0rIEyVw6DKGquBq4W4pficW5v+MNpFEWZQjiaj6oBGj5it3yVYi3FZ7aq
         IDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RnYSxk87fb/VR6ZUTie18l/+t1zJ4HyYOkmNS4kOfmw=;
        b=rpIs/A28+G9Wdkkj5cCie0D0ozJhgtDRH8fJEiWjk+wIr6ujB1V8Ktoa/9BcvHOeZN
         Q790sL9x70KRFYbFsR2brHg5JV6fBxHZA3oO3+eWDp9UU6e0TZ5WesEMcoeENRS9n2zF
         /Sx64potJBIRPIAzte+0DnjP5jAxmfbwiU390SeYLKE58Loc6KPuDETZjW8EvzgIgfxR
         EIRsbXyOd/rSLwU2wUJC7SmhaaRbINjY/GNCSXBuhMrf6WZRnnj9DK4AaIJ2yE56a2nk
         6U2ly1+rikjy6S6UZFPEhRjH8J22Tcz5ixSYCF/p6iB3A9gudJyM5f3SvcMpHRGBUHS/
         zvVQ==
X-Gm-Message-State: APjAAAWyWS9CteNISKMbrl5OQmsSBPiHSCzuOuKMZvHGDTujeX0sGwpY
        g5VL8ApvMtj5UQYwpAubxWKahH79Sr0=
X-Google-Smtp-Source: APXvYqybDjXbK2wAXW+wFhFSMfpxdS8JlmYlzSPSUqvw+3bTvGE4SmQuFbfzbm1uQMZQqc6Pta3yKg==
X-Received: by 2002:a05:600c:22cb:: with SMTP id 11mr16959688wmg.117.1573399905497;
        Sun, 10 Nov 2019 07:31:45 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k1sm437344wrp.29.2019.11.10.07.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 07:31:45 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        idosch@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next] mlxsw: core: Enable devlink reload only on probe
Date:   Sun, 10 Nov 2019 16:31:44 +0100
Message-Id: <20191110153144.15941-1-jiri@resnulli.us>
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
Fixes: a0c76345e3d3 ("devlink: disallow reload operation during device cleanup")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index da436a6aad2f..42e1ce3e39e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1198,10 +1198,11 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
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

