Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3346AC9B19
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfJCJvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:51:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36414 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfJCJvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:51:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so2249636wrd.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNX90eP3HpzGbm5vFYAF66JzZEub29yqqveUIJJeS8Y=;
        b=iKFbS8akOJBfT+E2ZtRHBWEgdly2UVLK4x0IulucznVvROJkocts3wiqFj9CoZhUk9
         JTYdtn4LMwLsN5o0YzqUzKEKw/mOXQfOjfQkwuZvS2/FMgnf1OMrcr1YZHSqOaQd/4FV
         GgszR6DWaBlrptsw+/0AeBrxhASexYRCKzA+e3lGHsp/ziAV0bcx5xX+t7j/XlbidE7q
         TBr7eaaRy38AFnuErSnL74+ec0slv4PuneLgLhtD/cu6vL8kIz82D4IlSxL/0I32kEj8
         Na/7dA5xDM/Uhi9+COZchxyDWm0EdZBUNS3p2OoKX3SRv7bsoBJ1yyTz1H7NxdYg0umz
         8/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNX90eP3HpzGbm5vFYAF66JzZEub29yqqveUIJJeS8Y=;
        b=mG2bggdZRJBQCMDeC8n84zVCS1gMemMoCPcOMRePyem5BNiKavCqsXu28nUqG2Zzm/
         Vet1vGs9pYzGcrJEyDGcePU7r1sFPMrvwtRQXBeXimOBn7IEdaTd6CRUFcLFGEe6TZ1/
         np7gGjfZAwwlt6KNuLL30Kl4Nyzh8OG7Z/SAiCB0/GbhjMMBBwiAToz/I8EEGBENK3jn
         ZFhjVXmvrg5TVuZ0J+NatJlVJ7iuf5I64LVsKzpldMoj/AOhnYUg4vKHDbjA66FloByF
         y8RlKs3AlUui8OngZq6ZDUNFsbi1zT8rN59xHX51TV/MV5G07YHOSUavBI1qBSiXCC1C
         CBMw==
X-Gm-Message-State: APjAAAXKJgjW7i0DJcYoigGPIM9VrMzwoeKHF0yst3CmRIVDH78RMbX+
        idfAakmlFdYvaIz6uWM9EoxG6CMlGIE=
X-Google-Smtp-Source: APXvYqwqFl9AmabbO0PTf21pQZAcDGm9DmZJgXr3jgKL1oBXbSM0lRrltAMAZcyeP9kzHSm2rlvgBw==
X-Received: by 2002:a5d:45c6:: with SMTP id b6mr5508679wrs.4.1570096276200;
        Thu, 03 Oct 2019 02:51:16 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id y186sm3991704wmb.41.2019.10.03.02.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:51:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2-next v3 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Thu,  3 Oct 2019 11:51:14 +0200
Message-Id: <20191003095115.10098-1-jiri@resnulli.us>
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

Similar to ip tool, add an option to devlink to operate under certain
network namespace. Unfortunately, "-n" is already taken, so use "-N"
instead.

Example:

$ devlink -N testns1 dev show

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- added patch description
---
 devlink/devlink.c  | 12 ++++++++++--
 man/man8/devlink.8 |  4 ++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 5e762e37540c..852e2257cb64 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -32,6 +32,7 @@
 #include "mnlg.h"
 #include "json_writer.h"
 #include "utils.h"
+#include "namespace.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -7023,7 +7024,7 @@ static int cmd_trap(struct dl *dl)
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
-	       "       devlink [ -f[orce] ] -b[atch] filename\n"
+	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
@@ -7173,6 +7174,7 @@ int main(int argc, char **argv)
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
 		{ "statistics",		no_argument,		NULL, 's' },
+		{ "Netns",		required_argument,	NULL, 'N' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -7188,7 +7190,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvs",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -7217,6 +7219,12 @@ int main(int argc, char **argv)
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

