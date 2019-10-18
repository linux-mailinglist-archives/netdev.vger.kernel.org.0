Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C5DCA49
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394445AbfJRQHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:07:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38105 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbfJRQHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:07:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id o15so6425662wru.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4COZiLJL79v/rlxbHb1kFVd8LmkD3tCSTbGcpw22Exk=;
        b=k2o/paSnzGpyQ+CE2UZhcKEj3utk0qGjHP1j1MSVtWNTgyhOniugXjjkS95JlH5iap
         GpNbovjYWcz6jHydkLL9P+y+bQuyUxQIKWWCjlCOPpCPQiYivQ2hAderJG7UsNMlPgd+
         QwxQYSLRh9U7eSFDUyqK1MoApEc4CrfhhX9o+gCQe32JuPGCo/vc7pe7SVciI83ccby8
         jYOHTh0vvzYq6vx/Jfi2XVEpOhOG6f8MuZujqu7YGWqz3su3Zq/ZBAVPRRHis2ljsnOH
         RH5EEBlK1ReudI6PX80D1nlkC917/E5QqXChaziLPDrAj9LqzlCtpP6eHve0yuXJDMFv
         eFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4COZiLJL79v/rlxbHb1kFVd8LmkD3tCSTbGcpw22Exk=;
        b=niVjYA6h+0ch+d/MRFGhBY12klaskkYjLu4fsGwLLlECXJ/TOIO38tI84MiMNJHRf+
         hF0sRjXXsoIziRsC33OtOdm5bWbZhL+xmWE1iLknfY31AtlYn6rT9EH456eUJPYSWPdV
         tbeQmsUqW2Kfrn7Wm7kPfyYYiOWFJ80oYy1wJzaQ0V88smcqF95ab/m7ltFMVeBQ/ror
         sv+JtOMiwk2so0xJOaJmrINhALmN6nUBQu0Vfpto1hxoF8xG7pFiF59l346C/IMNDt1C
         CQtPt7q2dxvZXDVxqG3nmc/bA1kseHwVPd8jllpmr6D/89cVSISg6if0segpZPGcMtzU
         eu7A==
X-Gm-Message-State: APjAAAWHF3i/vtuehjT+wM3mdm3vD7PJyNMdkgVbetH7M7yprScsEnq4
        K+MwEwfnhrMTnXk7GD5srAyFLqPhK0U=
X-Google-Smtp-Source: APXvYqwUFEq+KSfZPr++BN5SsE24QutuFRX2Pec9lsL1UYTzOGMHp+Brv7+GWwAz1IAKc2I/EMFv6A==
X-Received: by 2002:a5d:55c7:: with SMTP id i7mr8882904wrw.371.1571414848117;
        Fri, 18 Oct 2019 09:07:28 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id 5sm7360233wrk.86.2019.10.18.09.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:07:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next] devlink: add format requirement for devlink param names
Date:   Fri, 18 Oct 2019 18:07:26 +0200
Message-Id: <20191018160726.18901-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, the name format is not required by the code, however it is
required during patch review. All params added until now are in-lined
with the following format:
1) lowercase characters, digits and underscored are allowed
2) underscore is neither at the beginning nor at the end and
   there is no more than one in a row.

Add checker to the code to require this format from drivers and warn if
they don't follow.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..5969cab5bc31 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/timekeeping.h>
+#include <linux/ctype.h>
 #include <rdma/ib_verbs.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -7040,10 +7041,37 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
+static bool devlink_param_valid_name(const char *name)
+{
+	int len = strlen(name);
+	int i;
+
+	/* Name can contain lowercase characters or digits.
+	 * Underscores are also allowed, but not at the beginning
+	 * or end of the name and not more than one in a row.
+	 */
+
+	for (i = 0; i < len; i++) {
+		if (islower(name[i]) || isdigit(name[i]))
+			continue;
+		if (name[i] != '_')
+			return false;
+		if (i == 0 || i + 1 == len)
+			return false;
+		if (name[i - 1] == '_')
+			return false;
+	}
+	return true;
+}
+
 static int devlink_param_verify(const struct devlink_param *param)
 {
 	if (!param || !param->name || !param->supported_cmodes)
 		return -EINVAL;
+
+	if (WARN_ON(!devlink_param_valid_name(param->name)))
+		return -EINVAL;
+
 	if (param->generic)
 		return devlink_param_generic_verify(param);
 	else
-- 
2.21.0

