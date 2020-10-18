Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C072292026
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgJRVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbgJRVcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:32:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2597C222D5;
        Sun, 18 Oct 2020 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056720;
        bh=yXlYCoOLipCk/06sWYrK1oOxN3qsJsTcRc2Eo16HeT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA6bDyDtyt7vhiGuc1ieUGS5ELO7zYNYvdwOtdtX2nwKkC7/lQgeQfRAsc7yuXQuV
         +gmX5nhTsa3Gsiho99sfwLhM0yjAOExrDksqxzib2IwHDBwU0FFl0NberFiBWSqs5+
         8Ha0Fx2z/ABgEr5VGtg9CrG+FtXX6U+/0wEk5uH4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 4/7] add support for stats in subcommands
Date:   Sun, 18 Oct 2020 14:31:48 -0700
Message-Id: <20201018213151.3450437-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new parameters (-I | --include-statistics) which will
control requesting statistic dumps from the kernel.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.8.in | 7 +++++++
 ethtool.c    | 8 ++++++++
 internal.h   | 1 +
 3 files changed, 16 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 9beb1e5791eb..429c75f3f682 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -140,6 +140,9 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool [--json]
 .I args
 .HP
+.B ethtool [-I | --include-statistics]
+.I args
+.HP
 .B ethtool \-\-monitor
 [
 .I command
@@ -499,6 +502,10 @@ Output results in JavaScript Object Notation (JSON). Only a subset of
 options support this. Those which do not will continue to output
 plain text in the presence of this option.
 .TP
+.B \-I \-\-include\-statistics
+Include command-related statistics in the output. This option allows
+displaying relevant device statistics for selected get commands.
+.TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
 .TP
diff --git a/ethtool.c b/ethtool.c
index 403616bb7fa0..1d9067e774af 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6031,6 +6031,7 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 	fprintf(stdout, "FLAGS:\n");
 	fprintf(stdout, "	--debug MASK	turn on debugging messages\n");
 	fprintf(stdout, "	--json		enable JSON output format (not supported by all commands)\n");
+	fprintf(stdout, "	-I|--include-statistics		request device statistics related to the command (not supported by all commands)\n");
 
 	return 0;
 }
@@ -6291,6 +6292,13 @@ int main(int argc, char **argp)
 			argc -= 1;
 			continue;
 		}
+		if (*argp && (!strcmp(*argp, "--include-statistics") ||
+			      !strcmp(*argp, "-I"))) {
+			ctx.show_stats = true;
+			argp += 1;
+			argc -= 1;
+			continue;
+		}
 		break;
 	}
 	if (*argp && !strcmp(*argp, "--monitor")) {
diff --git a/internal.h b/internal.h
index 935ebac3ca2e..27da8eac57bb 100644
--- a/internal.h
+++ b/internal.h
@@ -225,6 +225,7 @@ struct cmd_context {
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
 	bool json;		/* Output JSON, if supported */
+	bool show_stats;	/* include command-specific stats */
 #ifdef ETHTOOL_ENABLE_NETLINK
 	struct nl_context *nlctx;	/* netlink context (opaque) */
 #endif
-- 
2.26.2

