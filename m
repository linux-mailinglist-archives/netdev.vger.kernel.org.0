Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC6CB79D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbfJDJuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:50:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40492 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbfJDJuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 05:50:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so5148566wmj.5
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 02:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qnIzToDcmMmfNdXxGFygPg0lqtQ4FioNspL2ja8OKgU=;
        b=utWr9w6xR+pIkUPFfZ9WUDSUTjAlVPFhmbk+RZgjLzwkyAVOf8rhC0RScaBD0vYiyc
         y32t6gxiiE2ICLte8lCd8KxT0z3BTZ+xfmRlXPalBSJnaN6DDIX5ZdDh/C6JoyJhd25T
         ivymVgSyNdoXN6gOHdhJaRvgL951C7K+SwyD9k0S9ZwMZccFeFzL+oDyAE+3yU7FdcFn
         0RSsmhwZX9v1XfeUFGHf/dIeNZip7smW9BXNCQZZBW0hv2IPmuiO5G5JxOlXUPeb6KwF
         FQKIATn9LUXl8jWsrBoYVKE31QfXiyUE1I54zeWjKuMptnIiCzq7RYnTHqJstwmrQeSB
         X7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qnIzToDcmMmfNdXxGFygPg0lqtQ4FioNspL2ja8OKgU=;
        b=c8/vIFKAw4L10iqVB+kWd3sa07hlH8FDVs+8fahMYdcPTmWFWU+zZTL/iT+Wph4/5b
         8ijuKm8ULGYaxGmdj/tacdrA+YrMXIvOU7htK7+pS7lbQjyMZCTcP0pPGexKcWQKy10r
         SL16wyrgULejIAjg9kcF4RXu+nyoXtLt2SQPtx7kldR94lYRn6994M30vkba53mBVCs+
         stWp4ptM0T0Dbn60mHHJ4ocSm9NdwVZQBIy39vVNLgNSR5GV0s2SOrnYKv6KmXAcsHX2
         taY/WTu3w7eW/Z1ZoeOIQXcK5TMKFXYxC1YDMwXJ91LdSiyPkfjBOJqbvi26vj9r0k/t
         V6zg==
X-Gm-Message-State: APjAAAXJmM49yUcHIhW5Tlg6RRa8pAHa3+8ZppTogjZYXF2NkiAz2FZ7
        fcVJTFuZPnTFvTncyk70XpiV6X8HGsQ=
X-Google-Smtp-Source: APXvYqwxynyJbY3K4yAHkMn2/aHboR8htIXQ8TQGryLA/wfse51ugAuqbBq4AL/Mys4es/zsGJL3Cg==
X-Received: by 2002:a7b:c252:: with SMTP id b18mr9934109wmj.68.1570182614433;
        Fri, 04 Oct 2019 02:50:14 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id x129sm7421885wmg.8.2019.10.04.02.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 02:50:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next] net: devlink: don't ignore errors during dumpit
Date:   Fri,  4 Oct 2019 11:50:12 +0200
Message-Id: <20191004095012.1287-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, some dumpit function may end-up with error which is not
-EMSGSIZE and this error is silently ignored. Use does not have clue
that something wrong happened. Instead of silent ignore, propagate
the error to user.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680efe54a..b7edbd14518b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1035,7 +1035,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -1058,6 +1058,9 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 out:
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -1233,7 +1236,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -1256,6 +1259,9 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 out:
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -1460,7 +1466,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	struct devlink_sb *devlink_sb;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -1485,6 +1491,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 out:
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -3155,7 +3164,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -3183,6 +3192,9 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 out:
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -3411,7 +3423,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -3444,6 +3456,9 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 out:
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -4066,7 +4081,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -4094,6 +4109,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	}
 	mutex_unlock(&devlink_mutex);
 
+	if (err != -EMSGSIZE)
+		return err;
+
 	cb->args[0] = idx;
 	return msg->len;
 }
-- 
2.21.0

