Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2709C320EA5
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhBVAGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 19:06:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:51718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhBVAGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 19:06:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ADB1AAC6F;
        Mon, 22 Feb 2021 00:05:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 867886079B; Mon, 22 Feb 2021 01:05:24 +0100 (CET)
Message-Id: <87e48543d091a6851ba1bd62c6fb79cf11a478de.1613952250.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] ioctl: less confusing error message for master-slave
 parameter
To:     netdev@vger.kernel.org
Cc:     Bruce LIU <ccieliu@gmail.com>
Date:   Mon, 22 Feb 2021 01:05:24 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fallback code issues a reasonable error message when a subcommand
implemented only via netlink would end up being processed by ioctl code,
e.g. because a new ethtool runs on an older kernel without netlink support.
But when a netlink only parameter is passed to subcommand which is
recognized by ioctl code in general, it is handled as an unknown one.

At the the moment, there is only one such parameter: master-slave for
'-s' subcommand. As it is not handled by the generic command line parser,
address this with a quick fix and leave updating the generic parser for
later.

Reported-by: Bruce LIU <ccieliu@gmail.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index fb90e9e456b9..15e9d34831b3 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -72,6 +72,16 @@ static void exit_bad_args(void)
 	exit(1);
 }
 
+static void exit_nlonly_param(const char *name) __attribute__((noreturn));
+
+static void exit_nlonly_param(const char *name)
+{
+	fprintf(stderr,
+		"ethtool: parameter '%s' can be used only with netlink\n",
+		name);
+	exit(1);
+}
+
 typedef enum {
 	CMDL_NONE,
 	CMDL_BOOL,
@@ -3066,6 +3076,8 @@ static int do_sset(struct cmd_context *ctx)
 					ARRAY_SIZE(cmdline_msglvl));
 				break;
 			}
+		} else if (!strcmp(argp[i], "master-slave")) {
+			exit_nlonly_param(argp[i]);
 		} else {
 			exit_bad_args();
 		}
-- 
2.30.1

