Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3530A19E663
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgDDQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:26 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39393 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgDDQQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:25 -0400
Received: by mail-wr1-f48.google.com with SMTP id p10so12263643wrt.6
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/zF3dgXAwj+IK4mLLxahzXuS4p1jPsYXpNrQeCsFYEg=;
        b=etsWENlJMyeOQLxrxRpQSDNgJT5rljbgTEew7o7B2ycuyUV+h7n8H1x5uGQSKOAUn7
         yEotRqggj/p2Dg9N2Qgkqf35ChyhcH3ml1Y5aToLpK7NsWfpDlfDxi6vp4lGMQpHy6Q4
         sV5Nncoq8B9yZxdEVY7na0ALtlWst0/9ie1+wrFhq8UyTcqLalZVU5okO3hyQgdfytxk
         kElNqThF+4Ahx2+awFr3s3UemivHoGQSTU1St83onpD3mS4tc0jkF1BlWgi9nYx7nNty
         Ojn119Gzg1ketZ1O9EL4QKhhE/RcRBNn6yUW6cppiy//ZGjo83A5GszawsdViylfDDdt
         3n7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/zF3dgXAwj+IK4mLLxahzXuS4p1jPsYXpNrQeCsFYEg=;
        b=Un3FlAA2B3/Nar9BBbEbvLwMBhMQMwlaN/Th0lu4qL3sbz+C/jTdLa2bTDcZci4/1l
         ZEyXxE8pfeKMwrQPbxgw7LUi6qssdpYMmr27GB5GyxwgtNPSDA2GAPsz9AkLfUDCHdVw
         tHNmn2j2Q7+n53nfi9zs+eTonZgvc3caai9mHfM3XicSS6By+yuayE+11r/E2ixnoycY
         0HbZcZkqAiCMqE21UTNaMzpN0MC9x6yAnXZaaAfDMO9KIQOr1NN8Vi1NBsuEN/gVL4f7
         t+eFmCLBcNwriZAZ2QKKqvWJkEgO2trCY7ueq4R6AMeWaaiGq/xcs+DgJfbXQHkj764D
         7QWQ==
X-Gm-Message-State: AGi0PuZEWsYKLWX57//5fjo9c1QlZdf8mzaCFTpq6GmEotlk4Zr59udb
        BVx4DtRW3NqJuhrsiSiCfJoYzsWktNE=
X-Google-Smtp-Source: APiQypJtck0Rs02g0dhxDgHNTCklS7rFCZZvM98f28y6nWZQH9eizMjDcxnm2kx8QZkr6l8Mcf4Ftg==
X-Received: by 2002:a05:6000:370:: with SMTP id f16mr15431129wrf.9.1586016984210;
        Sat, 04 Apr 2020 09:16:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x206sm16337130wmg.17.2020.04.04.09.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 1/8] devlink: remove custom bool command line options parsing
Date:   Sat,  4 Apr 2020 18:16:14 +0200
Message-Id: <20200404161621.3452-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Change the code that is doing custom processing of boolean command line
options to use dl_argv_bool(). Extend strtobool() to accept
"enable"/"disable" to maintain current behavior.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 6434e68593ea..0109d30cba41 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -752,9 +752,11 @@ static int strtobool(const char *str, bool *p_val)
 {
 	bool val;
 
-	if (!strcmp(str, "true") || !strcmp(str, "1"))
+	if (!strcmp(str, "true") || !strcmp(str, "1") ||
+	    !strcmp(str, "enable"))
 		val = true;
-	else if (!strcmp(str, "false") || !strcmp(str, "0"))
+	else if (!strcmp(str, "false") || !strcmp(str, "0") ||
+		 !strcmp(str, "disable"))
 		val = false;
 	else
 		return -EINVAL;
@@ -1089,20 +1091,6 @@ static int eswitch_inline_mode_get(const char *typestr,
 	return 0;
 }
 
-static int dpipe_counters_enable_get(const char *typestr,
-				     bool *counters_enable)
-{
-	if (strcmp(typestr, "enable") == 0) {
-		*counters_enable = 1;
-	} else if (strcmp(typestr, "disable") == 0) {
-		*counters_enable = 0;
-	} else {
-		pr_err("Unknown counter_state \"%s\"\n", typestr);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int eswitch_encap_mode_get(const char *typestr, bool *p_mode)
 {
 	if (strcmp(typestr, "enable") == 0) {
@@ -1349,14 +1337,8 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			o_found |= DL_OPT_DPIPE_TABLE_NAME;
 		} else if (dl_argv_match(dl, "counters") &&
 			   (o_all & DL_OPT_DPIPE_TABLE_COUNTERS)) {
-			const char *typestr;
-
 			dl_arg_inc(dl);
-			err = dl_argv_str(dl, &typestr);
-			if (err)
-				return err;
-			err = dpipe_counters_enable_get(typestr,
-							&opts->dpipe_counters_enable);
+			err = dl_argv_bool(dl, &opts->dpipe_counters_enable);
 			if (err)
 				return err;
 			o_found |= DL_OPT_DPIPE_TABLE_COUNTERS;
-- 
2.21.1

