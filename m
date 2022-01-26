Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9531649C4AC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiAZHm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiAZHm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:42:26 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5EFC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:42:26 -0800 (PST)
Received: from [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4] (unknown [IPv6:2a0d:e40:0:4000:a33d:5e2a:b8b4:d3c4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nuclearcat)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5C2CC1F410AB;
        Wed, 26 Jan 2022 07:42:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1643182944;
        bh=XaiTG6bV6/eJi8W3aiq7c9HFv823kI4lLhF6BQ8szWA=;
        h=Subject:From:To:Cc:Date:From;
        b=K9x1MML/GTUe0f/qLEP5ozI91gA/N0bWpB7eCd1v8MoIZWj2HMQqUgCWoMnI0qrRT
         C/V2opnb+FD4ijF5C0+dVuPrufIEtcg/mdi4lmI/OHyrTELsOSxWr+qMsxW4fZxFL0
         s5VhAvOxX4lWe6CrSvKnm3dkYin9k8Hm+kv4wiFeuEpzCWs6yp3ecyoquEiHPNAw0r
         7usHbBU343YSOszMIIWbIsugE99VPZkthBHhkFUhkxfBcLyzJrlAOw9DfFBrvmuCbm
         b7o58k2F31UgyfftJRW332gLRVxv0/1xywOhdFjIt7MbmU6l3ItfNdbHBNRGaphCZq
         kqTvJWJxptT8g==
Message-ID: <ad11e84b9107c9f35bdda5b08073f7742bbe8dfc.camel@collabora.com>
Subject: [PATCH ethtool-next v3] features: add --json support
From:   Denys Fedoryshchenko <denys.f@collabora.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 26 Jan 2022 09:42:20 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding json to make ethtool more machine friendly. 
No change in normal text output:

Features for enx0c37961ce55a:
rx-checksumming: off [fixed]
tx-checksumming: off
	tx-checksum-ipv4: off [fixed]
	tx-checksum-ip-generic: off [fixed]
	tx-checksum-ipv6: off [fixed]
	tx-checksum-fcoe-crc: off [fixed]
	tx-checksum-sctp: off [fixed]
scatter-gather: off
	tx-scatter-gather: off [fixed]
	tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: off
	tx-tcp-segmentation: off [fixed]
	tx-tcp-ecn-segmentation: off [fixed]
	tx-tcp-mangleid-segmentation: off [fixed]
	tx-tcp6-segmentation: off [fixed]
generic-segmentation-offload: off [requested on]

...skip similar lines...

JSON output:
[ {
        "ifname": "enx0c37961ce55a",
        "rx-checksumming": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "tx-checksumming": {
            "active": false,
            "fixed": null,
            "requested": null
        },
        "tx-checksum-ipv4": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "tx-checksum-ip-generic": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "tx-checksum-ipv6": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "tx-checksum-fcoe-crc": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "tx-checksum-sctp": {
            "active": false,
            "fixed": true,
            "requested": false
        },
        "scatter-gather": {
            "active": false,
            "fixed": null,
            "requested": null
        },
        "tx-scatter-gather": {
            "active": false,
            "fixed": true,
            "requested": false
        },


...skip similar lines...

v2:
 - formatting fixes
 - show each feature as object with available attributes

v3:
 - report "fixed" and "requested" as nil for the special features

Signed-off-by: Denys Fedoryshchenko <denys.f@collabora.com>
---
 ethtool.c          |  1 +
 netlink/features.c | 39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 5d718a2..28ecf69 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5734,6 +5734,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
+		.json	= true,
 		.func	= do_gfeatures,
 		.nlfunc	= nl_gfeatures,
 		.help	= "Get state of protocol offload and other features"
diff --git a/netlink/features.c b/netlink/features.c
index 2a0899e..a4dae8f 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -82,8 +82,17 @@ static void dump_feature(const struct feature_results *results,
 		 feature_on(results->wanted, idx))
 		suffix = feature_on(results->wanted, idx) ?
 			" [requested on]" : " [requested off]";
-	printf("%s%s: %s%s\n", prefix, name,
-	       feature_on(results->active, idx) ? "on" : "off", suffix);
+	if (is_json_context()) {
+		open_json_object(name);
+		print_bool(PRINT_JSON, "active", NULL, feature_on(results->active, idx));
+		print_bool(PRINT_JSON, "fixed", NULL,
+			   (!feature_on(results->hw, idx) || feature_on(results->nochange, idx)));
+		print_bool(PRINT_JSON, "requested", NULL, feature_on(results->wanted, idx));
+		close_json_object();
+	} else {
+		printf("%s%s: %s%s\n", prefix, name,
+		       feature_on(results->active, idx) ? "on" : "off", suffix);
+	}
 }
 
 /* this assumes pattern contains no more than one asterisk */
@@ -153,9 +162,18 @@ int dump_features(const struct nlattr *const *tb,
 					feature_on(results.active, j);
 			}
 		}
-		if (n_match != 1)
-			printf("%s: %s\n", off_flag_def[i].long_name,
-			       flag_value ? "on" : "off");
+		if (n_match != 1) {
+			if (is_json_context()) {
+				open_json_object(off_flag_def[i].long_name);
+				print_bool(PRINT_JSON, "active", NULL, flag_value);
+				print_null(PRINT_JSON, "fixed", NULL, NULL);
+				print_null(PRINT_JSON, "requested", NULL, NULL);
+				close_json_object();
+			} else {
+				printf("%s: %s\n", off_flag_def[i].long_name,
+				       flag_value ? "on" : "off");
+			}
+		}
 		if (n_match == 0)
 			continue;
 		for (j = 0; j < results.count; j++) {
@@ -210,8 +228,10 @@ int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 
 	if (silent)
 		putchar('\n');
-	printf("Features for %s:\n", nlctx->devname);
+	open_json_object(NULL);
+	print_string(PRINT_ANY, "ifname", "Features for %s:\n", nlctx->devname);
 	ret = dump_features(tb, feature_names);
+	close_json_object();
 	return (silent || !ret) ? MNL_CB_OK : MNL_CB_ERROR;
 }
 
@@ -234,7 +254,12 @@ int nl_gfeatures(struct cmd_context *ctx)
 				      ETHTOOL_FLAG_COMPACT_BITSETS);
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, features_reply_cb);
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, features_reply_cb);
+	delete_json_obj();
+
+	return ret;
 }
 
 /* FEATURES_SET */
-- 
2.30.2



