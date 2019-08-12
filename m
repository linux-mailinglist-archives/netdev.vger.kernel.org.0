Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793ED8A017
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfHLNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:51:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34737 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfHLNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:51:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so104672087wrm.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U2Xf5R6hMDwEXCRhmRcwsPfKOQOkN2Rq8Cqk6jU7WRY=;
        b=Iej/2OBkrURmrL/YYOmL5zRPI3jDdpAoHhJqLMnBmpIizjm5paAgKNpUyeCBoajcMb
         dArqchOaz1r73n3ET2yS3ez//TMo7bzeP7DHx6WVa9L8w9qDKFhrJ/zGss97knJ70udR
         +1GlTSbDcwy5jcpf6B9+AvuooEwigmzR0sg8HtJ98GQICnpnPIp2atUQQrDoSgLhwe1I
         7wnjHGuURcoPR/mVKfWiyAy9pmt05O8zbOkzA8VbqLmVtb9chIa2rCHHdbZd9cHf+iqy
         eauhkGDyrQcZUNwoIuuiP2AWs7h90s2xBD3poEcRrZLd+JEBdI0gLnyvCu300CvPRE+Q
         XyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2Xf5R6hMDwEXCRhmRcwsPfKOQOkN2Rq8Cqk6jU7WRY=;
        b=TeUuiZves+v2h4D7G+3HMmwj6Vcq/hGrItQ6xGH6RLsh6xbLSSeDgscKUFinoDSJwI
         uPTlQWLN46hB67O44wR2HP5a5AQg4V1RNy3hFYJtADioO6GugR9QqvtNv+449nioEX7D
         V7cA7TqBWlOgsJuFugB4YfgsdFPMgA/yY9qb9CE7pC506rpZcwmGNnC3JQtwjyJZ2jjL
         jVkjOpSBSH8EDufcz6uM2OaOpO7/ZElJ0mrJcONSH8QI9MdzgXSZHpzq12qu+Y0LWM+i
         iYqfUd+x7NSlYZ3N7y6a6gMmYRKdGitVLe6HfBxNsYYPci/q2KepFYr19xVcJGGrGxw/
         iiow==
X-Gm-Message-State: APjAAAVUrHJ9wxGgsFBqfRAwftpUXK+SOBF+jApdy0GnCxhtk+zlrALd
        /HW3XxW+zyXR/abral6T58W7UOLRN3I=
X-Google-Smtp-Source: APXvYqw/Ne8GvJZcQAo5Ae4h0okUD3GtsBTD6cEO11BmNDNKc1bWxeBTc9WmUDwQ+z7FeRrH6DRa8Q==
X-Received: by 2002:a5d:5343:: with SMTP id t3mr1928977wrv.156.1565617904807;
        Mon, 12 Aug 2019 06:51:44 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id n14sm207677523wra.75.2019.08.12.06.51.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:51:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v3 1/2] devlink: introduce cmdline option to switch to a different namespace
Date:   Mon, 12 Aug 2019 15:51:42 +0200
Message-Id: <20190812135143.31264-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
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
index 91c85dc1de73..6bda25e92238 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -31,6 +31,7 @@
 #include "mnlg.h"
 #include "json_writer.h"
 #include "utils.h"
+#include "namespace.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -6333,7 +6334,7 @@ static int cmd_health(struct dl *dl)
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
-	       "       devlink [ -f[orce] ] -b[atch] filename\n"
+	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
 }
@@ -6479,6 +6480,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
+		{ "Netns",		required_argument,	NULL, 'N' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -6494,7 +6496,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpv",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvN:",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -6520,6 +6522,12 @@ int main(int argc, char **argv)
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

