Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D367A382
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbfG3I7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:59:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41325 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbfG3I7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:59:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so61643540wrm.8
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RTogH97AIk4m08zmmEBILrSp9HXabuVQESg6ae/RZW4=;
        b=w/r8Vc3SUjrUDF7YaI15w6BjuKRGY1g0teWlPFSzcp3tlnRzX2bCOzeCh1kssol5wI
         i6An1+6Qck0lG7mIZFZ+rJz/N1k/ZsZmdT9NtnSRXFyICOPsHhtG3p384P0euA88DxZX
         4sqyhicCMx8DWgmw7q7dldEwS1a58WaT4gNMJp1h6DYVnh9mDueNOH0P1O3RyDBX2Qdk
         lyh7SusVKXLPTUL50YIxqLbbfYkYHCtLujPU3wvRos+XyqgI5sxpxEXsmNKuJxZQkb5h
         msSgZlTO9EIBGIAc207aC/c6PYqP1c2BZ+gkO6lRmWuiaHoiKLZ9lUwwiOGlY36a0FaS
         Mazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RTogH97AIk4m08zmmEBILrSp9HXabuVQESg6ae/RZW4=;
        b=fZhU+lBEQx1UBlr9rjORN085hqaIY4jxhZ/8FsTPrkWmVZeDyFBKt137JC6MTl1iz/
         Nr489snVx+y2c2VqWuldcRDy08KAkflFDVjY8JM5j0WmCUJ+9PfUEapnbCGszsY1notj
         FcsINt5TB2+jLc/V8SsS2pN5QGkFTei6PfAawcroEZ5nrpnEr12LH6z6Q7h6Lrjp7PJC
         JdJ79GwK1jj6VV3D/kIOQ7dfCb7vB5g8ML1Tt7p+qkrlEZcwSsJmHYEKVEweLY9Vbu5q
         n7NprynzxkCrjX8la5EOALO1E4se32ZF5lHlfawa72EwFt4xj4EE/YvY4u4nU8++luu9
         6eeQ==
X-Gm-Message-State: APjAAAVCoY3S9PSsODRiTJo4IcfL8AKFddYfaxj46b4IiPwT8L76cjKz
        i93bNtU9sNIYUTA6ZtREnzEhsbjo
X-Google-Smtp-Source: APXvYqxFJcFE3vKm1QQMsCZEvQ+jg9J4dPNI+p/A+0iGNWnHJD86eyJjKwIeDrB45WwJnSZXg8Kfng==
X-Received: by 2002:a5d:6a84:: with SMTP id s4mr48949374wru.125.1564477192598;
        Tue, 30 Jul 2019 01:59:52 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c65sm63352339wma.44.2019.07.30.01.59.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:59:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v2 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Tue, 30 Jul 2019 10:59:50 +0200
Message-Id: <20190730085951.31738-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c  | 12 ++++++++++--
 man/man8/devlink.8 |  4 ++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index d8197ea3a478..9242cc05ad0c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -32,6 +32,7 @@
 #include "mnlg.h"
 #include "json_writer.h"
 #include "utils.h"
+#include "namespace.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
-	       "       devlink [ -f[orce] ] -b[atch] filename\n"
+	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
 }
@@ -6478,6 +6479,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
+		{ "Netns",		required_argument,	NULL, 'N' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -6493,7 +6495,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpv",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvN:",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -6519,6 +6521,12 @@ int main(int argc, char **argv)
 		case 'v':
 			dl->verbose = true;
 			break;
+		case 'N':
+			if (netns_switch(optarg)) {
+				ret = EXIT_FAILURE;
+				goto dl_free;
+			}
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 13d4dcd908b3..9fc9b034eefe 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -51,6 +51,10 @@ When combined with -j generate a pretty JSON output.
 .BR "\-v" , " --verbose"
 Turn on verbose output.
 
+.TP
+.BR "\-N", " \-Netns " <NETNSNAME>
+Switches to the specified network namespace.
+
 .SS
 .I OBJECT
 
-- 
2.21.0

