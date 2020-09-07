Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86513260429
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgIGSFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:05:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729726AbgIGSEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 14:04:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599501890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=wEV7c2hoejQ1ixum50rA5xwKvNmSW5uoo1V8Pac1bKo=;
        b=E4pUSDNFVNkGaVDsM5mr5Og+r+k6Zt2TFwU6Jgk2I2ArPo6I89LVTSdSzSvzASzwe8CUCw
        4qmd0Slo+xq/4K5OZmavcX45yVn8kk+Ohvl8t63w6ImEteogqjqtNxvozBpFRq2OIDx0Ot
        6LPSkLu9FopmPqoi52/5lqRYgAFfhnw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-jqEXeUu2NeuXPN3o0uRmiQ-1; Mon, 07 Sep 2020 14:04:48 -0400
X-MC-Unique: jqEXeUu2NeuXPN3o0uRmiQ-1
Received: by mail-qt1-f200.google.com with SMTP id b54so7681740qtk.17
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 11:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wEV7c2hoejQ1ixum50rA5xwKvNmSW5uoo1V8Pac1bKo=;
        b=egJXOBvUCLeJAoUXhN8yfx+2tEjGdHY4+oXsEdQ8ApOgdCTOgohE7D43EEX5xW9jTS
         /RQFhuTZIY2OYNhqFx9hZ70jmaW9ksFALLD+YpRV/f5uaI33C7cU9cDsWnyCy9NPYvDY
         t/Ha0dPeu00pNmBBUjirH7Cq1GjZH9d50A5SUJEE/8LwsCkf+in9BGJiM9YV2b3t2vHH
         A0X3qUdMNPI9RSQ6ce8iAuah2vODJPAw8rOmRtJILcD8tCn/R/BR47+t9EhhoM/kzmbD
         8Jl5sOLyua8qJx9MLkG9r1/9TENoC15W7AYnGobDoTPlEiLnXeHFl/vdyyTNOQ15z46u
         Y/Dw==
X-Gm-Message-State: AOAM530UbMU9IJT5exc2ne72biaiI/Kg+kLEEg/IdWmlbg/3b+P9lmWG
        n1DYSTaKcYLeDBO1CVMO6aB/mMwykhaDDtZ4HgUxYtYHTV2nZGKQhmJJKlPyGps2bTnugr3tiYy
        SHCoXpYIy4HRYe88x
X-Received: by 2002:a37:8c02:: with SMTP id o2mr18932748qkd.461.1599501888001;
        Mon, 07 Sep 2020 11:04:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc9bmRu1RY4kwHcHrlv9A879aAJwVxMmr05CDWzHdIf5f9kZB3pGIWJMKzUyS2DL1f0/pOQg==
X-Received: by 2002:a37:8c02:: with SMTP id o2mr18932729qkd.461.1599501887741;
        Mon, 07 Sep 2020 11:04:47 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id e24sm11088555qka.76.2020.09.07.11.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:04:47 -0700 (PDT)
From:   trix@redhat.com
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: sched: skip an unnecessay check
Date:   Mon,  7 Sep 2020 11:04:38 -0700
Message-Id: <20200907180438.11983-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Reviewing the error handling in tcf_action_init_1()
most of the early handling uses

err_out:
	if (cookie) {
		kfree(cookie->data);
		kfree(cookie);
	}

before cookie could ever be set.

So skip the unnecessay check.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/sched/act_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 063d8aaf2900..f64af9d9dfee 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -976,7 +976,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 #endif
 		NL_SET_ERR_MSG(extack, "Failed to load TC action module");
 		err = -ENOENT;
-		goto err_out;
+		goto err_free;
 	}
 
 	/* backward compatibility for policer */
@@ -1013,11 +1013,12 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 err_mod:
 	module_put(a_o->owner);
-err_out:
+err_free:
 	if (cookie) {
 		kfree(cookie->data);
 		kfree(cookie);
 	}
+err_out:
 	return ERR_PTR(err);
 }
 
-- 
2.18.1

