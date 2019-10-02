Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34FFC8DF8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfJBQMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35503 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJBQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so20378337wrt.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=nhVe/6bWg26eWkotVGLxSU84gna/t3i9qKpdGO3hENtthHm5gyxhUf6O2o+HiE5HXa
         GvBfvs79GupmGTc0DItrw6HtzVnzNDdd/XYPcPFFKXIPgwy4U49iF4KHbqcBJ1mcxnhx
         xgS33jEL1JAWuC+9dUlbnLIY1TkR1/El3DUP4qY2YM+/e1Izk4DBphQ834zh4G/72Mbb
         CoDPCak3VG4wds2yp0Si4YF9zlNEtSgzKj40KE6pvd0rGGzviW1Sub0Z3xvRn2QSgSud
         XPZaE6oF/W697+CUQpCIqsP9Aej2D/UVA21b44BmBVYFatI0EwPa9Y+m+2mmOs+p5wBE
         AtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=olKrwgn1xeDdydlk52PLzvhWyKgYfn2HxOmNUcX2yuaN1gK/BWTq1dcHwNBX+1mcoX
         7Zri0m6qkv51AkAVxcr+5i/cABbaWyvIDF2mfAdtVldz1hJA0pJEQaAUJUTmwx1dOdhn
         t8mpjo/Z9Jo8k6f+Vk9sxG2GFeZqPSLI+nCmTW8ZZytDEVSGpL6yshbIRTGYhc5cLYrz
         RwRo6opab31OKYlWddIJUeuwoaFy5T1mBItuh/Q8j76rvjOjF48ZDih2/QUYRgNNDbiQ
         xJiomiLIhlnzqLOea42bpC/oQg0t3fbt6vlCRY4zBJ2+E72wLBnieooBEbjI5tvzzENp
         XLqw==
X-Gm-Message-State: APjAAAVi+UJNZKLhES+fd2DBTBjqTIvWXRkvqFTiqtMXceO8pU2A55EF
        vBzoHSfXKcKsWhicDo3f+d17gkHNQgQ=
X-Google-Smtp-Source: APXvYqwUdUFD1QElGTVjPTjmp9LhRw3C/+egzuhv08av4zm0b4u/8fSBlYAvfIfJKtLpw2gydBQeuA==
X-Received: by 2002:adf:ec91:: with SMTP id z17mr3572975wrn.346.1570032766936;
        Wed, 02 Oct 2019 09:12:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r2sm25044560wrm.3.2019.10.02.09.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 13/15] netdevsim: take devlink net instead of init_net
Date:   Wed,  2 Oct 2019 18:12:29 +0200
Message-Id: <20191002161231.2987-14-jiri@resnulli.us>
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

