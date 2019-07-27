Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F4677810
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfG0KFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:05:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40469 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfG0KFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:05:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so56811790wrl.7
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RTogH97AIk4m08zmmEBILrSp9HXabuVQESg6ae/RZW4=;
        b=udiVA5BP6lHUiJNsydTLCGie4hDPz/oleA6qYKErfFz8+qMEES4/fZENZjl2TBmw3a
         bahYlGQi5gYHyLT8Gp4YNSgfSNXRpLPlhWZ222sWm0MDt2xTThFhKxeicC8CuCozIyTB
         B0T/lZoZhkF2ltpJdRPYt0KUPtrXUyygWlTdKLhwMAKhPYUXa18L3aj5GeyRaJbHT6gK
         x/jMlau+z5TSmxDGAl1qwHVBnOp8JFhykxMhGow3kCPHsibOyPeHHqWI/mZhxfjK0ktz
         ZJhG/SiMRqzDHkCNKsvcPaP6yuRO8yCaG+3YU7D/5/QvHLume6rpSc41xlX2k73Fy9yF
         dmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RTogH97AIk4m08zmmEBILrSp9HXabuVQESg6ae/RZW4=;
        b=W2V6pb7aVQJ6gelj4quU/ekwBWxSFv7UsF3C1gst6ZWt0DAOe55YQJYKLh/z1Vk8DY
         6vBgtbbUXSRaymOVPsBv8r5IcVYu+VDwNOXEgLpZXkp8pzPcnrP2mVqSsYlQtTridyja
         vUhGOJhv4XEOTwtrLgde2igI10b4A6CD6+tF42Ue/VrincExV0EC1AYQyJGgBn69EaAL
         TyQ9Yi+jBvxfoh6rdrExgUBnEQlbP87uqUt2ufs60gnDoTfoqTPUtPmFDrKzcSGIXaf9
         S4n4mgeA83Lsd2KV9mlGUTyH21twBjamFjlSkiN9Nj/5igjU1kG7nwphPh8Piq+oB7Hk
         KI7A==
X-Gm-Message-State: APjAAAWx3VT6TYgaRI6gE7fsZ65eesn5eDxQxQkH22WnWyvM4zid7PBb
        jNtTitKgEmySAuKsJn81H8g7hlnp
X-Google-Smtp-Source: APXvYqymprUiaqke0hntLXyzxCAF6Kfz66XyFSQ772vWk8hsAXumUtl5uxVEW+L+i778UPllm0mxLA==
X-Received: by 2002:adf:9ece:: with SMTP id b14mr58432012wrf.192.1564221945570;
        Sat, 27 Jul 2019 03:05:45 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id c3sm59421350wrx.19.2019.07.27.03.05.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 03:05:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Sat, 27 Jul 2019 12:05:43 +0200
Message-Id: <20190727100544.28649-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
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

