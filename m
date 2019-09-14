Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5663EB2A35
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfING6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:58:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36076 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfING6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:58:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id t3so4885496wmj.1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dS0tFBP/UkbnP0+8JOwj2Byib5Nt6uw7QEs0tnjrEN8=;
        b=znW1JZyelsUOZ8SG2DbOukm4W12Vr2lq1L93X44n5LLpxDeuQu4qsYFOM+q3OZX6VK
         0nBO8ttIRTdpsE6t0LVA+ZO6SfwkaArnLQ9oMbPynkSFTvrVb1R/RZXr6fsE2Jym07a5
         X9YRiXFRIBGaZ3yMRQ+TB9p8XeElVrjuxjv+jHRN99dAQ+0uwhyp0dPievtSFyulIrwK
         kR1JU0+kcabA1VluSVVAGjlp8oNnV7Ai1srh65eHobEPXXt1Qi8pUjt8k1+jCbuMLcNj
         Q39BVn5ObdjE3t4HS+q+BXfSMldPEH2e2AeNk2YjLz7uDbeVodpkgKgzSA3oZleTlAmC
         8ErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dS0tFBP/UkbnP0+8JOwj2Byib5Nt6uw7QEs0tnjrEN8=;
        b=KRuEjQFFJYhUbIhgoIfwmcLYmN0fYRypMbMt6Clgg1Jm6dgAQ4+2DS5+guK76ynsP5
         F1SRjHqOSqz742eXRHutV0iJ3BD4oaab8F5HuceCeQR/J2kq1Du1kBtLamj3xLGAnJ2l
         QaiWwlnCxWTEQXyt8ur3bZN5SVdwteHtIReU8fS6T1qJve2Bk77IVlm1dETbk06Sbe3B
         QlWNePzGaxDuOJXihjnMPpXJQ20NO0e+ttCz+y7AHYXtWMIh31KVqEPj8p9YnUgSRJan
         4BLNsgQNhEZkR0J75M7Ar9Q6k4+xx38cBtNH3Vb5m0IKjKvP+Dtc7XHgDKRDarkG+bQP
         joEA==
X-Gm-Message-State: APjAAAUYNXJGW/kURPyf0viHmutaiHhbpu0NXJTtZ/6opXCos2mpebk+
        AhnuFAYpLKLYD/petZwFqhoCmXVkAcU=
X-Google-Smtp-Source: APXvYqy6DGCahvybfqMqlxsfMvr6mQm4HUucHP4vyTnn9dDDv34RqZy6FBNGr53lPUqK2MaB3SvCAQ==
X-Received: by 2002:a7b:c08d:: with SMTP id r13mr6035125wmh.39.1568444278438;
        Fri, 13 Sep 2019 23:57:58 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i9sm5290241wmf.14.2019.09.13.23.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:57:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2-next 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Sat, 14 Sep 2019 08:57:56 +0200
Message-Id: <20190914065757.27295-1-jiri@resnulli.us>
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

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v3->v4:
- rebased on top of trap patches
---
 devlink/devlink.c  | 12 ++++++++++--
 man/man8/devlink.8 |  4 ++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a1be8528c3c9..8020d76dd7f7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -31,6 +31,7 @@
 #include "mnlg.h"
 #include "json_writer.h"
 #include "utils.h"
+#include "namespace.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -6748,7 +6749,7 @@ static int cmd_trap(struct dl *dl)
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
-	       "       devlink [ -f[orce] ] -b[atch] filename\n"
+	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
@@ -6898,6 +6899,7 @@ int main(int argc, char **argv)
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
 		{ "statistics",		no_argument,		NULL, 's' },
+		{ "Netns",		required_argument,	NULL, 'N' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -6913,7 +6915,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvs",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -6942,6 +6944,12 @@ int main(int argc, char **argv)
 		case 's':
 			dl->stats = true;
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
index 12d489440a3d..7f4eda568081 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -55,6 +55,10 @@ Turn on verbose output.
 .BR "\-s" , " --statistics"
 Output statistics.
 
+.TP
+.BR "\-N", " \-Netns " <NETNSNAME>
+Switches to the specified network namespace.
+
 .SS
 .I OBJECT
 
-- 
2.21.0

