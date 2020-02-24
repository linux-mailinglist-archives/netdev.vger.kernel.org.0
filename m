Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77529169F55
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgBXHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44283 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBXHgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:05 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so9053261wrx.11
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+i9AwLOhPgoHEsiGl6aT1i8OUDmGFnf5MG2d3X8wLo=;
        b=BUCdQz4jyoEavvjGHMsaRXJnSs1drbXyVeh3AjOAEaL7T6YFh2RnVwqTx/xuPnC4pT
         bMFa/ysCriTlthmNa/FXIYGiyqJdRvQpZPZm8h6+U6fze901Um3nctfcLnJzqVPZZiru
         EJiI4y99Q/vU7xHu5h0F+z6/CVyAFA21GbLJZj6Z9UWlH5q+ZgubT6iEN42S5SZuOQqf
         kquSaV87VF1BBD8ATdpgcWLTycsOZkzeFUl/fewlrE7HPXwLoHqfociApkA0g0rTFN9M
         bdhUGiSyrQlI4k8W3p2tnI+3PJL2sw8B+ZZAnZbiwvvCGdtGDdvcfUOcTPlbaYKwN10x
         yK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+i9AwLOhPgoHEsiGl6aT1i8OUDmGFnf5MG2d3X8wLo=;
        b=jxF4L0hk+/L2BT9RWZS8K+dpiAwX+JqcwtGMG9+ZwblBm+LfZSL9DF0rPQkGooT2/w
         NZGNnoC0a0xruihsixCnpCcLLibHd0NEKPDOPWrrmoZ37+lFZnieGKJPlkw8Dae8Q8Gm
         5spQVjJ8PkITCG3p9h4ezNfOlVM9O/3s95R7OT9Crdcw8UIhH3+jJC75HROslYabHYsl
         YwXiHA2Wz34qimssKRW+sK8PniOwRiRuigr+ObDeGXGOoJ2OnwKPbjadDFJaLbujreUG
         lRV3mWl5uxgWBmaDdIqKkZzyXCsUPxef+9fXY9ll9+rVIEgclHZuvqKmybSi0JeTg9EC
         SDgw==
X-Gm-Message-State: APjAAAUbIKP+g03QHYl/Tn0QNCXbzsLRJL+Gxo5m5u9b7hrCuxO61LbW
        0SpwoqqTa5q32xVGw69jpbSCKv0C26M=
X-Google-Smtp-Source: APXvYqysaE6/khLYtweCyhztsG6PFcq0YF8YuWPVT7brqSlAtRwIZIsdUqfeESdrejUb1QSLBUpRBQ==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr62026048wrl.190.1582529763162;
        Sun, 23 Feb 2020 23:36:03 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id u62sm17433073wmu.17.2020.02.23.23.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:02 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 03/16] mlxsw: spectrum_trap: Use listener->en/dis_action instead of hard-coded values
Date:   Mon, 24 Feb 2020 08:35:45 +0100
Message-Id: <20200224073558.26500-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The listener fields en_action and dis_action now contain the actions to
be used for TRAP and DROP devlink trap actions. Use them directly
instead of the hard-coded values.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 7b0fb3cf71ea..7c6a9634cdbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -329,10 +329,10 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 
 		switch (action) {
 		case DEVLINK_TRAP_ACTION_DROP:
-			hw_action = MLXSW_REG_HPKT_ACTION_SET_FW_DEFAULT;
+			hw_action = listener->dis_action;
 			break;
 		case DEVLINK_TRAP_ACTION_TRAP:
-			hw_action = MLXSW_REG_HPKT_ACTION_TRAP_EXCEPTION_TO_CPU;
+			hw_action = listener->en_action;
 			break;
 		default:
 			return -EINVAL;
-- 
2.21.1

