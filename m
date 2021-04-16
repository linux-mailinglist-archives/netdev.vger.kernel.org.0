Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1EB36251B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbhDPQDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239690AbhDPQDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 12:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6CF3613C0;
        Fri, 16 Apr 2021 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618588974;
        bh=06Q5aFsIDQ4rv8qLuqrHjA1SfsoMLKVrHm6ONMdCtPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itElxIiqSz5BJQY+KN43wH1lIgazWhXTF6Tyq0cK7hc352+71sDGVf62RqLzGRxP+
         bLEKVYK3MdHBpSejv7XPD+x0a+vdSXHWkyTmMSn8RjJzwdL7I46/FXCGEOjnKaUYyx
         5LCa1qgsEuzPNZx2QdzquaWyvULro4vmlegqHFJaS06hdF/9WPFjPuaLyPddBwjdBu
         rJMmNgikwgjdJVLYf8do+q0+9oilEFORElRYprRd0mlEwQzk2Q2w/Rq0TSAnO2N/gr
         kJ5utJ8Flacnhhhyh/VL9ujzHBW/GLgiBBhgtdxgS0En13WyudwMN+71dGkNLYqTk+
         bcEM+RymzwxuA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, idosch@nvidia.com
Cc:     mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool 4/6] netlink: fec: support displaying statistics
Date:   Fri, 16 Apr 2021 09:02:50 -0700
Message-Id: <20210416160252.2830567-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416160252.2830567-1-kuba@kernel.org>
References: <20210416160252.2830567-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 # ethtool  -I --show-fec eth0
FEC parameters for eth0:
Configured FEC encodings: None
Active FEC encoding: None
Statistics:
  corrected_blocks: 256
    Lane 0: 255
    Lane 1: 1
  uncorrectable_blocks: 145
    Lane 0: 128
    Lane 1: 17
 # ethtool --json -I --show-fec eth0
[ {
        "ifname": "eth0",
        "config": [ "None" ],
        "active": [ "None" ],
        "statistics": {
            "corrected_blocks": {
                "total": 256,
                "lanes": [ 255,1 ]
            },
            "uncorrectable_blocks": {
                "total": 145,
                "lanes": [ 128,17 ]
            }
        }
    } ]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/fec.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 1 deletion(-)

diff --git a/netlink/fec.c b/netlink/fec.c
index 9d15832db98a..1efd18d38142 100644
--- a/netlink/fec.c
+++ b/netlink/fec.c
@@ -7,6 +7,7 @@
 
 #include <errno.h>
 #include <ctype.h>
+#include <inttypes.h>
 #include <string.h>
 #include <stdio.h>
 
@@ -40,6 +41,79 @@ fec_mode_walk(unsigned int idx, const char *name, bool val, void *data)
 	print_string(PRINT_ANY, NULL, " %s", name);
 }
 
+static int fec_show_stats(const struct nlattr *nest)
+{
+	const struct nlattr *tb[ETHTOOL_A_FEC_STAT_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	static const struct {
+		unsigned int attr;
+		char *name;
+	} stats[] = {
+		{ ETHTOOL_A_FEC_STAT_CORRECTED, "corrected_blocks" },
+		{ ETHTOOL_A_FEC_STAT_UNCORR, "uncorrectable_blocks" },
+		{ ETHTOOL_A_FEC_STAT_CORR_BITS, "corrected_bits" },
+	};
+	bool header = false;
+	unsigned int i;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	open_json_object("statistics");
+	for (i = 0; i < ARRAY_SIZE(stats); i++) {
+		uint64_t *vals;
+		int lanes, l;
+
+		if (!tb[stats[i].attr] ||
+		    !mnl_attr_get_payload_len(tb[stats[i].attr]))
+			continue;
+
+		if (!header && !is_json_context()) {
+			printf("Statistics:\n");
+			header = true;
+		}
+
+		if (mnl_attr_get_payload_len(tb[stats[i].attr]) % 8) {
+			fprintf(stderr, "malformed netlink message (statistic)\n");
+			goto err_close_stats;
+		}
+
+		vals = mnl_attr_get_payload(tb[stats[i].attr]);
+		lanes = mnl_attr_get_payload_len(tb[stats[i].attr]) / 8 - 1;
+
+		if (!is_json_context()) {
+			fprintf(stdout, "  %s: %" PRIu64 "\n",
+				stats[i].name, *vals++);
+		} else {
+			open_json_object(stats[i].name);
+			print_u64(PRINT_JSON, "total", NULL, *vals++);
+		}
+
+		if (lanes)
+			open_json_array("lanes", "");
+		for (l = 0; l < lanes; l++) {
+			if (!is_json_context())
+				fprintf(stdout, "    Lane %d: %" PRIu64 "\n",
+					l, *vals++);
+			else
+				print_u64(PRINT_JSON, NULL, NULL, *vals++);
+		}
+		if (lanes)
+			close_json_array("");
+
+		close_json_object();
+	}
+	close_json_object();
+
+	return 0;
+
+err_close_stats:
+	close_json_object();
+	return -1;
+}
+
 int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 {
 	const struct nlattr *tb[ETHTOOL_A_FEC_MAX + 1] = {};
@@ -106,6 +180,12 @@ int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	}
 	close_json_array("\n");
 
+	if (tb[ETHTOOL_A_FEC_STATS]) {
+		ret = fec_show_stats(tb[ETHTOOL_A_FEC_STATS]);
+		if (ret < 0)
+			goto err_close_dev;
+	}
+
 	close_json_object();
 
 	return MNL_CB_OK;
@@ -119,6 +199,7 @@ int nl_gfec(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
 	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
 	int ret;
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_FEC_GET, true))
@@ -129,8 +210,10 @@ int nl_gfec(struct cmd_context *ctx)
 		return 1;
 	}
 
+	flags = get_stats_flag(nlctx, ETHTOOL_MSG_FEC_GET,
+			       ETHTOOL_A_FEC_HEADER);
 	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_FEC_GET,
-				      ETHTOOL_A_FEC_HEADER, 0);
+				      ETHTOOL_A_FEC_HEADER, flags);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

