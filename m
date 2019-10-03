Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB30C9B0D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfJCJuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:50:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46686 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbfJCJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id o18so2176571wrv.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=DzMQrczRGlQGK8CfuoRWR9sUCpFio1Gsn19W7Tm17341PV9stFz/oAnI4wR9sD/QrJ
         iqsIcmwBXcsNrQACER28bNaQxntXHQRHOojeZ1bXwBeJrYonWQ3NlNI6APxa3IVbnPCD
         Retqntmt2mCEsqGPUL/5+A9sHaWOCEuMF5jAfKvHd7hDIBPiUZUkiKrDInXHm02mfQwz
         EU2gVlbjSbHhX1dr1/Zabkr3WUjJj3lWIuAX6lF7c/nS4WYQ3Lrzr2sgq/LhBrj6hjy7
         xhDR+X4z/QiQ0RgJup8SPe6Ld3Q8S9I5nyWY6Q9FkTtuK/3PiNIp/l6XEzXKw78efRFr
         bClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BbKhWQ01CoUHr+m9nw0qiRRJeDxhASRfk9qHR9YoalY=;
        b=LBIwpfkVSdsO6+L15bECsfBDcvRx10vd41KUGNAE20nGSZuNsG//6noDAT5xS1zUCe
         +sUbj/zqBQFuiriZvnLbMW7iLIpy497cKRySJsc5rQMN30CYH98NRNJWMJPvyVDIcQx/
         0ZTfXCHMOu/gNJyYrmvmgf67ZpeRkFw3Zu1LrN+xFTEIstOSrbVNqTfbCp86k0fzEvu9
         CbSE7esfVXpWUKdYMHGfMhau2kJnOOFx+czADKN5etEcTH/KaMzJ1uJpM5GVd+y9ODnz
         LlLIhJWPMYONtMZHt3YSsaZ6z3dOFWNIXpWFuFCs98Qqeihd7FZi+E5Hkk4uHl914uoo
         yOXA==
X-Gm-Message-State: APjAAAWfMQJyuC6pp7GZqjqhtRy8DsrdKDXXjsJoDOE0tDmCuv9uNKVC
        qyKE3sV83jJMDSjdnmu8HHSMX6/ykmk=
X-Google-Smtp-Source: APXvYqz2qF71laiAWy5A0slWGiXiC17zeBsX3bZdujeG624eWWqak8DSYgfZHBQQOcx7yrV6oV4pQA==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr6680023wrw.314.1570096197615;
        Thu, 03 Oct 2019 02:49:57 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id a3sm2937015wmc.3.2019.10.03.02.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 13/15] netdevsim: take devlink net instead of init_net
Date:   Thu,  3 Oct 2019 11:49:38 +0200
Message-Id: <20191003094940.9797-14-jiri@resnulli.us>
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

