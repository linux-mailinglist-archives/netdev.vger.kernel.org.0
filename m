Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D3B2A25
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfINGqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38447 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfINGqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id o184so4842730wme.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EzzDuz9ba8gCfD7Pb+HpvvJ9BwyjV+XpvGFSzKNJjMM=;
        b=Z3y72GZNEG3Pyf2nfVzvR95uvztnFOF+QqUS6x13h92CLdd1DU1zVnXyL/wL3/tw0X
         AEg2lvOeUnshb4tH4khHjKWqeo/oStro0ziYpVlrryP/TBXo/Kda3imOGkgU837WPWJN
         teIwir1dp1JjnG2mZfLn/ZEjOWilule5Jqh1jVp5y92ObOdMZjkL4NzLFMZkPAqUnYOj
         N4n9ha3K1rwZZ2yklEXSGX70jM98zl9B0YJKL01R0oCxiLqzaVUiiWySG/Ga0FlwhdMC
         1Wn0ToUrvA17aRjXm8nxjCzwHK40H1EuugQgWXSY35PMn0n8TgqBO5XL22fY9OE/xy8R
         kZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzzDuz9ba8gCfD7Pb+HpvvJ9BwyjV+XpvGFSzKNJjMM=;
        b=diRcrRad4Qg6PPIsxLqfwOr34XSAIaLkO/N2aqoKUxSqLSsDjaLaiideP+PeSNzAg1
         wzzVlXxwIC74U5K5QbVJHGMa2p9AKtcpbKHc6TNTUGIi9mAzcQOb15s1G1ax+4JVlpKh
         6Mvp1L9N9MrM23917j/SwZqo5KM3NmO9zxPcbJiH4mVb2vdEuFiqUcRaBXr++/GZPwfx
         3Uu5ZPAgV2ngityq0seBu+RqUsS0DhAbHCm1xnpawgesnvQlNMdvxlScxsupSjxBp3NR
         FGdoHJ2MvgGEYPB7sRj9dsYKiUa8o9SsJIDIh0pMHk/yS5dOr9cHTSr/3nl46cjwrHVn
         a/OA==
X-Gm-Message-State: APjAAAXxT5NznFQZd5tZmjXmbRAYktfjoPF6rf219wOvvQ00Z70t3e9i
        DCydxwSByFKnN61RG5bJUW2r62P9DA0=
X-Google-Smtp-Source: APXvYqxAHAVVhY+GhwlbiRM4o2QLEmdSG52Yl4yvZZCTPZ7RhihQB56D58r7+QaU7mFR09vshz/BJA==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr6062274wmb.151.1568443574057;
        Fri, 13 Sep 2019 23:46:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u10sm2988920wrg.55.2019.09.13.23.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 04/15] mlxsw: spectrum_router: Don't rely on missing extack to symbolize dump
Date:   Sat, 14 Sep 2019 08:45:57 +0200
Message-Id: <20190914064608.26799-5-jiri@resnulli.us>
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

Currently if info->extack is NULL, mlxsw assumes that the event came
down from dump. Originally, the dump did not propagate the return value
back to the original caller (fib_notifier_register()). However, that is
now happening. So benefit from this and push the error up if it happened.
Remove rule cases in work handlers that are now dead code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 22 +------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6d78d2002335..43dbe25674f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6019,12 +6019,6 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_RULE_ADD:
-		/* if we get here, a rule was added that we do not support.
-		 * just do the fib_abort
-		 */
-		mlxsw_sp_router_fib_abort(mlxsw_sp);
-		break;
 	case FIB_EVENT_NH_ADD: /* fall through */
 	case FIB_EVENT_NH_DEL:
 		mlxsw_sp_nexthop4_event(mlxsw_sp, fib_work->event,
@@ -6065,12 +6059,6 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 					 fib_work->fib6_work.nrt6);
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
-	case FIB_EVENT_RULE_ADD:
-		/* if we get here, a rule was added that we do not support.
-		 * just do the fib_abort
-		 */
-		mlxsw_sp_router_fib_abort(mlxsw_sp);
-		break;
 	}
 	rtnl_unlock();
 	kfree(fib_work);
@@ -6112,12 +6100,6 @@ static void mlxsw_sp_router_fibmr_event_work(struct work_struct *work)
 					      &fib_work->ven_info);
 		dev_put(fib_work->ven_info.dev);
 		break;
-	case FIB_EVENT_RULE_ADD:
-		/* if we get here, a rule was added that we do not support.
-		 * just do the fib_abort
-		 */
-		mlxsw_sp_router_fib_abort(mlxsw_sp);
-		break;
 	}
 	rtnl_unlock();
 	kfree(fib_work);
@@ -6262,9 +6244,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	case FIB_EVENT_RULE_DEL:
 		err = mlxsw_sp_router_fib_rule_event(event, info,
 						     router->mlxsw_sp);
-		if (!err || info->extack)
-			return notifier_from_errno(err);
-		break;
+		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_ADD:
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
-- 
2.21.0

