Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF51A6E33
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbgDMVV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:21:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:51744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388978AbgDMVVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 17:21:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F829AD4F;
        Mon, 13 Apr 2020 21:21:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7D775E0FAD; Mon, 13 Apr 2020 23:21:20 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] features: accept long legacy flag names when setting
 features
To:     John Linville <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Konstantin Kharlamov <hi-angel@yandex.ru>
Message-Id: <20200413212120.7D775E0FAD@unicorn.suse.cz>
Date:   Mon, 13 Apr 2020 23:21:20 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy feature flags have long names (e.g. "generic-receive-offload")
and short names (e.g. "gro"). While "ethtool -k" shows only long names,
"ethtool -K" accepts only short names. This is a bit confusing as users
have to resort to documentation to see what flag name to use; in
particular, if a legacy flag corresponds to only one actual kernel feature,
"ethtool -k" shows the output in the same form as if long flag name were
a kernel feature name but this name cannot be used to set the flag/feature.

Accept both short and long legacy flag names in "ethool -K".

Reported-by: Konstantin Kharlamov <hi-angel@yandex.ru>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 1b4e08b6e60f..73f15b3912c1 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2297,26 +2297,33 @@ static int do_sfeatures(struct cmd_context *ctx)
 	/* Generate cmdline_info for legacy flags and kernel-named
 	 * features, and parse our arguments.
 	 */
-	cmdline_features = calloc(ARRAY_SIZE(off_flag_def) + defs->n_features,
+	cmdline_features = calloc(2 * ARRAY_SIZE(off_flag_def) +
+				  defs->n_features,
 				  sizeof(cmdline_features[0]));
 	if (!cmdline_features) {
 		perror("Cannot parse arguments");
 		rc = 1;
 		goto err;
 	}
-	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++)
+	j = 0;
+	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
 		flag_to_cmdline_info(off_flag_def[i].short_name,
 				     off_flag_def[i].value,
 				     &off_flags_wanted, &off_flags_mask,
-				     &cmdline_features[i]);
+				     &cmdline_features[j++]);
+		flag_to_cmdline_info(off_flag_def[i].long_name,
+				     off_flag_def[i].value,
+				     &off_flags_wanted, &off_flags_mask,
+				     &cmdline_features[j++]);
+	}
 	for (i = 0; i < defs->n_features; i++)
 		flag_to_cmdline_info(
 			defs->def[i].name, FEATURE_FIELD_FLAG(i),
 			&FEATURE_WORD(efeatures->features, i, requested),
 			&FEATURE_WORD(efeatures->features, i, valid),
-			&cmdline_features[ARRAY_SIZE(off_flag_def) + i]);
+			&cmdline_features[j++]);
 	parse_generic_cmdline(ctx, &any_changed, cmdline_features,
-			      ARRAY_SIZE(off_flag_def) + defs->n_features);
+			      2 * ARRAY_SIZE(off_flag_def) + defs->n_features);
 	free(cmdline_features);
 
 	if (!any_changed) {
-- 
2.26.0

