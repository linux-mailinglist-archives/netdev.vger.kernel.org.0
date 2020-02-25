Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E590C16BF05
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgBYKpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:33 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33062 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbgBYKpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so1930153wmc.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=alyiJMVEHZZVcF9qcZtRupgd4PPc6iD37iF33muKNRQ=;
        b=sgao1DARZA9M5ZFX76uOu3nbPY8PmuG6OpTnPrDdHpTVWMC76BjPL+UVk4fEfB1poN
         KScwZqbihBoNHK/bKL7INUgtYH8MHzdUh869+5l3FaoGsPULsUNlHCslDj8YK8kC9PXy
         EhYPsbb7U0FRPlv31w7yPq/TCANS1TdwF16oRPh01JFlE3TlhRhhzrN8tfzUIYk2z5J/
         dPCWxpbVm6q22tum/va44j+Au3+Opk2VrpNY0YKBmHtdNEOWaseGAllCoXYANpH3g9qC
         zgbDenk/+KJGNgitcMebQ889f+50SO6cNTFtLr/pPPzzhB7FtmOA0lbet59UbFq20eUV
         1Jgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=alyiJMVEHZZVcF9qcZtRupgd4PPc6iD37iF33muKNRQ=;
        b=S+YRBXUZkedt1vn8HroSDkDdgKkTHgrISobL/+SajjuPTjjPAjCh9CmAeyfhMrvNAq
         6ozX0BERdrp4WOjOOwhxfnlILqJs8+CWePa7LLAHnvaxEyU2BOlwnaUPCDKJf5zBVy7C
         7puZN1ayMdolyarwyutjyeS8mhDxTazey8CVRHxqfzuPmgv4PuF3DRFJY2n6ypDN75fc
         yUvvnGM1yq21FvUKQJOM7NwzCLCNvdDiG6WEirJO6Wei2AIvHc9OrlJeh8QGBvMBoKBq
         +LPWEsYlleCJN3JjnGWjwq8O6mOjl/qEQ4jsfRsKlbrs/QfBAohhp4kF6aVaApYa8Oo2
         ZWaw==
X-Gm-Message-State: APjAAAXRUEbJHNEEKDWBPQBQwYznYjeFZDhNd8Uje8yFHLUTMuKjPm14
        yneMxWs9MkRGFlsabetdMklcs29hWPM=
X-Google-Smtp-Source: APXvYqxwleEItucyf26dGz03wJW5jIy7WPvWW04fIJEL327Op5v8ltLs/QbNEzspJ0w/Wv7wgN6ELw==
X-Received: by 2002:a05:600c:24d2:: with SMTP id 18mr4627436wmu.149.1582627531321;
        Tue, 25 Feb 2020 02:45:31 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id e18sm22787535wrw.70.2020.02.25.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:30 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 02/10] devlink: add trap metadata type for cookie
Date:   Tue, 25 Feb 2020 11:45:19 +0100
Message-Id: <20200225104527.2849-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow driver to indicate cookie metadata for registered traps.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h        | 1 +
 include/uapi/linux/devlink.h | 2 ++
 net/core/devlink.c           | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 07923e619206..014a8b3d1499 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -541,6 +541,7 @@ struct devlink_trap_group {
 };
 
 #define DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT	BIT(0)
+#define DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE	BIT(1)
 
 /**
  * struct devlink_trap - Immutable packet trap attributes.
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ae37fd4d194a..be2a2948f452 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -252,6 +252,8 @@ enum devlink_trap_type {
 enum {
 	/* Trap can report input port as metadata */
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
+	/* Trap can report flow action cookie as metadata */
+	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
 enum devlink_attr {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0d7c5d3443d2..12e6ef749b8a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5540,6 +5540,9 @@ static int devlink_trap_metadata_put(struct sk_buff *msg,
 	if ((trap->metadata_cap & DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT) &&
 	    nla_put_flag(msg, DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT))
 		goto nla_put_failure;
+	if ((trap->metadata_cap & DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE) &&
+	    nla_put_flag(msg, DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE))
+		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
 
-- 
2.21.1

