Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE7C9B05
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfJCJtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37744 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbfJCJtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so1765644wmc.2
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z57PRHDhIwQIaIRUwks+NK6j+DqpD0IFns1Fko857yU=;
        b=H0O2iSW0pqfItxJp0KTLFgGdSSXQaY+WEj0nOIgekSHZE4/vEG/QBe9JT2O4cDov2w
         hrYb18UFFftjzuo/T3frH4MqoGwBRXERoM0XdBvg2vvCodgsy0KP+rZfviJEiJgpTaiN
         Qp+TGTpfAbF6vMJ49qn4C41CJBYA5nWG7EXiNdAXUJGdDf+8UqRR8A6vOzTloGGDTEzD
         xcSdV8yYL7n6GzV4Lmx56ZyB9qD0nMZEOuVO0oY8HTfxRY4G4auZFt+6QtPmhAhaB24P
         mk/EhIoSyl+b87oGWqWZGpNWT46T+S8LJ3BQ4cOiMqsd/+H6NSYpccJrIIa6+qIHEsPx
         ThOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z57PRHDhIwQIaIRUwks+NK6j+DqpD0IFns1Fko857yU=;
        b=PcrBFyie0mQqwgu8AcL94+sLJYj5uY9rUXzlkGl/M+koUrjDVdIUaZanYab1Ujh96y
         vaOP02d/ePmMFNtyVCVOgU25R4VhnkFIHBC8QHpXvNmfq363Uyd1oDb1eEUBsZw+i177
         PczHNIOTcSthf71YL/MHtwwihUAiZB0pTmxEd0egCPaKT2+9m2oGTYOUFBzoQL+nx+AS
         nvawkdx8T1B9IA1adfDeqFmSTQh5Y6TTKbXLbsLdl3WH42LneCHAURr2GMkSDnYdlZz6
         7gWAGYulQEfqVpa/IZDan7N4EvzjKFi3/RVvtBNIydq0qv4KYsw5oezrK+AOVgEGG00d
         iaOg==
X-Gm-Message-State: APjAAAXWwydRpPgQ7s1U4wMQoeSwyeWVBUlh+k6lWJPyj7ZKAxr1wAG7
        t0mPEv6W1OEoQ1Fv+8dwaCQCHyDJdDU=
X-Google-Smtp-Source: APXvYqyHqbMvuEwqMUsYCGJV24x94gemg2WMfuU3HIm/30I0qqMBqSzCB+dzvcH8eg/zc3VF7Z1WMA==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr6507829wmd.104.1570096187496;
        Thu, 03 Oct 2019 02:49:47 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q22sm1904678wmj.31.2019.10.03.02.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 04/15] mlxsw: spectrum_router: Don't rely on missing extack to symbolize dump
Date:   Thu,  3 Oct 2019 11:49:29 +0200
Message-Id: <20191003094940.9797-5-jiri@resnulli.us>
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
index d0db9ea71323..1eeff1d23b13 100644
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

