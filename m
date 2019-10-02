Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C138C8DF1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfJBQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33858 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJBQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so20379661wrx.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z57PRHDhIwQIaIRUwks+NK6j+DqpD0IFns1Fko857yU=;
        b=vvA09zxuXFTXnc+WL0b2O78PRG1nB9Ie7ZiDVubDy4ncU8kUOcNkjfHYo49ir1bvrM
         28DOBXtg9AqvxR/otn0APD09N8eLXf4wn0dilwA9dtsH/tfLhoESk5ZH+2YJdVzJNTvv
         VcgoxxguW27RgKcNW7Dos0GfLvJPX492D+mG+kE7ZGsIxJC6TSPLI6t7mvd+2XQ9jpqc
         wHsI/lPd/yMC0YsOyTALUr236Seuw8Cosk50FnFiaeQslkbTq6GNXAYIyJzfgslpOVkG
         an8ycUJx8vGH1P9AgkTMrU/+RyiM7PY26grP2fRxJ1fFaWNQ5Ttde5ScahMHoEVBj6eR
         Os/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z57PRHDhIwQIaIRUwks+NK6j+DqpD0IFns1Fko857yU=;
        b=qalGeDLST1k/Hsg6vrE/+u8LwbpMAnkbnl5QGKace0pBMjQHEOe1WEPtK0ZvBQm/xj
         l0gVsMyO8oOPvDF8X3v5H5S9OPbC51S82A/+pfHzaZw58Q/sxNujxNY4cu4WIB371X+4
         fuVMCEhM5bfRaj9OYWOWJrv/56Gume9VYaVSzKGEoxiKIRhNHRT6NkJa54jX+xBuNk6G
         ZBKMaRnQb2pHD7Zl2CdqGb3mMvqH6xaMXyiLqrLG2KjTD1hHodXC6kkmwSF2r1YoMpAF
         2ZLIsXovRgDJIirwJN/DlD8ZhLe0iUTvP+lJ0WUHnogCBEsUGjxZ5E2eemOZPDy7WiaX
         y0VQ==
X-Gm-Message-State: APjAAAV32GbnjtsFJd4zeI/2vP4FFJXQKFt6Gz8xmdWLSb+48UPh/EiP
        QLQJ+syvvRC2UdXbPc7gu3itSrCJ0C0=
X-Google-Smtp-Source: APXvYqy8jQFZnHdj174O4Zr2uepT+qVKV93jqf4gxNfyCxKrBD44DkdQwumIQkvyJml/yQnMyIuvNA==
X-Received: by 2002:a5d:4251:: with SMTP id s17mr3568779wrr.126.1570032756831;
        Wed, 02 Oct 2019 09:12:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y12sm18077048wrn.74.2019.10.02.09.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 04/15] mlxsw: spectrum_router: Don't rely on missing extack to symbolize dump
Date:   Wed,  2 Oct 2019 18:12:20 +0200
Message-Id: <20191002161231.2987-5-jiri@resnulli.us>
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

