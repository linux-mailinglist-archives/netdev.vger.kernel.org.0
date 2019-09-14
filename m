Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5110B2A2C
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfINGq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34792 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfINGq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so24257923wrx.1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=cw3a/JZgduZR8rXYM2gO2LcxQaeK2NFkBS1hOkqin1PQ7VjSZBBloBFKKPeVPzfDiW
         sYLsGBYBsl4o/0G8kYuKg2shQ8EjDCEPeiKjl9J5a9Bnzftr/FQpA9izSRTtjK+sr4BV
         dj3gA1KAV+6Ij8M1BXCSGj8bikvxTomnzwaWpLdjFkFFIK8D7COCb+8wxr3XlKcFQVB2
         8YSjmt2iXswBB6R2lx/czagVdi6S6lszZhmMUZrt2XT4R13loehdxifcjibBBeszQlDy
         LXynB/XNE4r3XaYiEkhJKRXnNj3IlRyYrwom7OQxwagDiuyCw18uQ+tQ93Dd9E2kRMMl
         U1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=aDvaYwhbhCed9/TPNaviTdwnGZ8Lj9Ncc9HTwCNio5hAy8zRlX1366Ki1hWSPl2QC+
         D9iTjeAS942aKJYJJQ/Q7ECGmC2jVm2BYrtoeBHQQn5uVT0U3ltQqlDA+43UmbP0DXbj
         ve0K8hORXJphxbiPAa7b9QYQpTKzwp20Y+i5TWLMoov990i22wtH3iFfdXStYkarvvb7
         g7XYhqHiHVs6hmT6O8hDtTM9EEOsViycLwPWyGu5UijEdPIIDNTZJVMjVt++vpBJrUMU
         t5/uYzRV+i5jNXnrHWQlJ1RfST0g3oGVLtXl6Ek0ZbKtmqqtiwPxAIdre1F+6PKaBglb
         XtUQ==
X-Gm-Message-State: APjAAAUE5IpS7HpT5nJDfNSlDoNJ9xGZjI07hzt4vxFWp85tAZX71N9/
        LoSKEVbNmLj1fFmnMf0plNScTpIhfxo=
X-Google-Smtp-Source: APXvYqyXteN9IvTx8jAvCTqUXf3CaRSBkNzr3lR0oV+nG/jpP14xHWEINi3xmh2T0bduJVOyJCudvA==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr4316591wrn.335.1568443582878;
        Fri, 13 Sep 2019 23:46:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g73sm5920975wme.10.2019.09.13.23.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 13/15] netdevsim: take devlink net instead of init_net
Date:   Sat, 14 Sep 2019 08:46:06 +0200
Message-Id: <20190914064608.26799-14-jiri@resnulli.us>
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

Follow-up patch is going to allow to reload devlink instance into
different network namespace, so use devlink_net() helper instead
of init_net.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index fdc682f3a09a..13540dee7364 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -260,7 +260,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	nsim_fib_set_max_all(data, devlink);
 
 	data->fib_nb.notifier_call = nsim_fib_event_nb;
-	err = register_fib_notifier(&init_net, &data->fib_nb,
+	err = register_fib_notifier(devlink_net(devlink), &data->fib_nb,
 				    nsim_fib_dump_inconsistent, extack);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
@@ -300,6 +300,6 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 					    NSIM_RESOURCE_IPV4_FIB_RULES);
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV4_FIB);
-	unregister_fib_notifier(&init_net, &data->fib_nb);
+	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	kfree(data);
 }
-- 
2.21.0

