Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775E226B5E5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgIOXxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbgIOXxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3AD321D94;
        Tue, 15 Sep 2020 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213981;
        bh=LBqDMkrjlv5dLjyPOsbKb9C2dvRMS/xy0yz2QcuWA64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KziuyQWUDijDzVb9RVvK7E5db3XwZu+TD9fmAHMc1OAJdXrjse+60KChOgLpG4Rvu
         qd0GI4pJqNl4LALtvWGtFmoLMaGQY/RwCh5O5hzce+J/p29ExzZPH6S0BPnvMqZmh6
         gN0Rgnhy2TRorPMjuB9fQIKUP9V6GcLB8uWfymQs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 4/5] add support for stats in subcommands
Date:   Tue, 15 Sep 2020 16:52:58 -0700
Message-Id: <20200915235259.457050-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915235259.457050-1-kuba@kernel.org>
References: <20200915235259.457050-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index 42c4767db33e..00cf7870376c 100644
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
index ae5310e9e306..309539579cc9 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5963,6 +5963,7 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 	fprintf(stdout, "FLAGS:\n");
 	fprintf(stdout, "	--debug MASK	turn on debugging messages\n");
 	fprintf(stdout, "	--json		enable JSON output format (not supported by all commands)\n");
+	fprintf(stdout, "	-I|--include-statistics		request device statistics related to the command (not supported by all commands)\n");
 
 	return 0;
 }
@@ -6223,6 +6224,13 @@ int main(int argc, char **argp)
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
index d096a28abfa2..1c0652d28793 100644
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

