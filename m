Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7948FC54
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 12:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiAPLbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 06:31:04 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42938 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiAPLbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 06:31:04 -0500
Received: from [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4] (unknown [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nuclearcat)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id EFDDB1F40F42;
        Sun, 16 Jan 2022 11:31:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642332663;
        bh=jYC1ivGXkTH7ZSQrJ/baQGLgjwrUhWspL3C76Cj60K0=;
        h=Subject:From:To:Cc:Date:From;
        b=RPujsdLHyGjc5eCCg0S3kEFWPU24aFq7VwyqOipIvLW5Q/PslRZmh4B4y93j7FFEZ
         LLhk7wa1/3xF+eRe5ADh9kALgbTCUCG0dpGBwrzB5urrg/xxmBVvw/3GpoGmAoQMLn
         jTaRjJCS5TfBqdYQk8fTQU9eLe5TKI9EJB/XJcYe1QtsQi0aZyUUQ1xxNMc2XMHK4y
         uBMu86tRTz5VMc+BT7CnU10csPSrdlyTN0FIiEgzIxs7WogRwfMs1oX3XuV920mnOi
         E69W1Ysys7J0xnRUWKk8PRqNp9AUSoSAnVVgeVWzhXpV1yPSs2O9vfG/D9oUfvdc+i
         t7LeptAIOiFig==
Message-ID: <266fbaa6b59bbbee6f216f46f3641fdcc3032bd0.camel@collabora.com>
Subject: [PATCH ethtool-next] features: add --json support
From:   Denys Fedoryshchenko <denys.f@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Date:   Sun, 16 Jan 2022 13:31:00 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normal text output remain as before, adding json to make ethtool 
more machine friendly.

Signed-off-by: Denys Fedoryshchenko <denys.f@collabora.com>
---
 ethtool.c          |  1 +
 netlink/features.c | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 064bc69..c4905f0 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5729,6 +5729,7 @@ static const struct option args[] = {
 		.opts	= "-k|--show-features|--show-offload",
 		.func	= do_gfeatures,
 		.nlfunc	= nl_gfeatures,
+		.json	= true,
 		.help	= "Get state of protocol offload and other features"
 	},
 	{
diff --git a/netlink/features.c b/netlink/features.c
index 2a0899e..cbe3edc 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -77,13 +77,23 @@ static void dump_feature(const struct feature_results *results,
 	}
 
 	if (!feature_on(results->hw, idx) || feature_on(results->nochange, idx))
-		suffix = " [fixed]";
+		suffix = "[fixed]";
 	else if (feature_on(results->active, idx) !=
 		 feature_on(results->wanted, idx))
 		suffix = feature_on(results->wanted, idx) ?
-			" [requested on]" : " [requested off]";
-	printf("%s%s: %s%s\n", prefix, name,
+			"[requested on]" : "[requested off]";
+
+	if (is_json_context()) {
+		char *name_suffix = malloc(strlen(name)+strlen("-opt")+1);
+
+		sprintf(name_suffix, "%s-opt", name);
+		print_bool(PRINT_JSON, name, NULL, feature_on(results->active, idx));
+		print_string(PRINT_JSON, name_suffix, NULL, suffix);
+		free(name_suffix);
+	} else {
+		printf("%s%s: %s %s\n", prefix, name,
 	       feature_on(results->active, idx) ? "on" : "off", suffix);
+	}
 }
 
 /* this assumes pattern contains no more than one asterisk */
@@ -153,9 +163,14 @@ int dump_features(const struct nlattr *const *tb,
 					feature_on(results.active, j);
 			}
 		}
-		if (n_match != 1)
-			printf("%s: %s\n", off_flag_def[i].long_name,
+		if (n_match != 1) {
+			if (is_json_context()) {
+				print_bool(PRINT_JSON, off_flag_def[i].long_name, NULL, flag_value);
+			} else {
+				printf("%s: %s\n", off_flag_def[i].long_name,
 			       flag_value ? "on" : "off");
+			}
+		}
 		if (n_match == 0)
 			continue;
 		for (j = 0; j < results.count; j++) {
@@ -210,8 +225,10 @@ int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 
 	if (silent)
 		putchar('\n');
-	printf("Features for %s:\n", nlctx->devname);
+	open_json_object(NULL);
+	print_string(PRINT_ANY, "ifname", "Features for %s:\n", nlctx->devname);
 	ret = dump_features(tb, feature_names);
+	close_json_object();
 	return (silent || !ret) ? MNL_CB_OK : MNL_CB_ERROR;
 }
 
@@ -232,9 +249,14 @@ int nl_gfeatures(struct cmd_context *ctx)
 	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_FEATURES_GET,
 				      ETHTOOL_A_FEATURES_HEADER,
 				      ETHTOOL_FLAG_COMPACT_BITSETS);
+
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, features_reply_cb);
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, features_reply_cb);
+
+	delete_json_obj();
+	return ret;
 }
 
 /* FEATURES_SET */
-- 
2.32.0



