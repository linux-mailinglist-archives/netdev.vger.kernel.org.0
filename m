Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0EC8E0F
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfJBQOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:14:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38731 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfJBQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:14:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id 3so7609965wmi.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNX90eP3HpzGbm5vFYAF66JzZEub29yqqveUIJJeS8Y=;
        b=HRZLoLca1VMJgfdLL/2W8tv81m7ZoBwtAct6x011oS9ow8AE/u+mb0TCa62RJkLUYS
         g7kCH53mE2pvTrmEGS0nII++sTjeNCLGGGVgvsZVVbXokpkxsTjzlKWYSsWYneShS8Vm
         xmaBYBetzvpUvWXhfXNnogX9oDM5yYIGuHJah0yjkNQ/AGvFnzIkQdPTC3WPchH/8p2m
         2slrNEVc4G8pr7UpOlkIuvPCARKM7aAdcuK5GlEsNSmd8J9j4odv8sbn/U1XVvv5SdQI
         plZaSpHo3hFIXxT3bCZ5PzUB6N4vu3oIjHj//QkzDn/3MJ+iPy2oznvTUuJ3Q2mS5VLQ
         xYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNX90eP3HpzGbm5vFYAF66JzZEub29yqqveUIJJeS8Y=;
        b=KkaUsi+JuCnbjjzkxhIo00kqpT5gKZtsy0s/ZFqZK8jKjBnqijbgF+eKmr85GOkCCm
         DCf7eXA50WS2qs6Bvgprg5wfFTOzd++OAx4i1RpIE2J5JX7mfSjHEaN+7wtH5U3UjEBz
         4Z76/aX3fvqSqyiZaawZOmvKCeCMN3ZZs5Kkdp7P2MO83pT8qeVYkNDZKDtRbA+e36ed
         qCETcFeI1JTm8RgeJBt/OO5V62azIHecvOTjICwisLcmBP9J6FjpvzrRGFMVB43qtgqR
         RZcOKYXtdC6rIcuh9eTzf+N4wXG7m39eD5N36GSV4LE2V2yTK6C8yIfCxLe5JH6/gvnP
         o94A==
X-Gm-Message-State: APjAAAViMdvcEuEhi47kIbcT2IufIoRbTOMn7C1lkRrMx68l8jL0rxNl
        2Yfnsd09yLVxbSRmbElLeYSl8oZjYPk=
X-Google-Smtp-Source: APXvYqz5vOVdU0yqJgbESFRop+Eh9k1CCmu4pBesp7uIAVMMhtSCxeKJLSsMcbu537Rz3q2gZ/HUjg==
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr3500313wmj.162.1570032876812;
        Wed, 02 Oct 2019 09:14:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q19sm45847343wra.89.2019.10.02.09.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:14:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2-next v2 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Wed,  2 Oct 2019 18:14:34 +0200
Message-Id: <20191002161435.3243-1-jiri@resnulli.us>
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

