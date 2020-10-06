Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA763284E96
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgJFPEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgJFPEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:33 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA93206CB;
        Tue,  6 Oct 2020 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996672;
        bh=zoZ+0kjLHvCLFkFzCWm5daKUx3r60Kvsci5LHnZYE58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVwa/xXOFzaFWrBe9VEKffxKEdwg2U7vqMgDBvdAMC8MrHkddwa0BC+Ea92FnpDoQ
         6hzOluQpGpSc6ZiwSn++x6o4yFDwSloWMWEV0nx1mxtBvBYuH7UfX3Pjiz+f3QnVQ4
         vG6kBJHprumjqPIMS7BrUN3sYu7p3kkX4tFTrJeA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 2/6] pause: add --json support
Date:   Tue,  6 Oct 2020 08:04:21 -0700
Message-Id: <20201006150425.2631432-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No change in normal text output:

 # ./ethtool  -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		on
TX:		on
RX negotiated: on
TX negotiated: on

JSON:

 # ./ethtool --json -a eth0
[ {
        "ifname": "eth0",
        "autonegotiate": true,
        "rx": true,
        "tx": true,
        "negotiated": {
            "rx": true,
            "tx": true
        }
    } ]

v2:
 - restructure show_bool() so we can use its logic for show_bool_val()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/coalesce.c |  6 +++---
 netlink/netlink.h  | 21 ++++++++++++++++-----
 netlink/pause.c    | 44 ++++++++++++++++++++++++++++++++------------
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 65f75cf9a8dd..07a92d04b7a1 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -36,9 +36,9 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (silent)
 		putchar('\n');
 	printf("Coalesce parameters for %s:\n", nlctx->devname);
-	printf("Adaptive RX: %s  TX: %s\n",
-	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]),
-	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]));
+	show_bool("rx", "Adaptive RX: %s  ",
+		  tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]);
+	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]);
 	show_u32(tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS],
 		 "stats-block-usecs: ");
 	show_u32(tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL],
diff --git a/netlink/netlink.h b/netlink/netlink.h
index dd4a02bcc916..1012e8e32cd8 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -98,17 +98,28 @@ static inline void show_u32(const struct nlattr *attr, const char *label)
 		printf("%sn/a\n", label);
 }
 
-static inline const char *u8_to_bool(const struct nlattr *attr)
+static inline const char *u8_to_bool(const uint8_t *val)
 {
-	if (attr)
-		return mnl_attr_get_u8(attr) ? "on" : "off";
+	if (val)
+		return *val ? "on" : "off";
 	else
 		return "n/a";
 }
 
-static inline void show_bool(const struct nlattr *attr, const char *label)
+static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
+{
+	if (is_json_context()) {
+		if (val)
+			print_bool(PRINT_JSON, key, NULL, val);
+	} else {
+		print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
+	}
+}
+
+static inline void show_bool(const char *key, const char *fmt,
+			     const struct nlattr *attr)
 {
-	printf("%s%s\n", label, u8_to_bool(attr));
+	show_bool_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
 }
 
 /* misc */
diff --git a/netlink/pause.c b/netlink/pause.c
index 7b6b3a1d2c10..c960c82cba5f 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -40,8 +40,8 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
 	struct pause_autoneg_status ours = {};
 	struct pause_autoneg_status peer = {};
 	struct nl_context *nlctx = data;
-	bool rx_status = false;
-	bool tx_status = false;
+	uint8_t rx_status = false;
+	uint8_t tx_status = false;
 	bool silent;
 	int err_ret;
 	int ret;
@@ -72,8 +72,11 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
 		else if (peer.pause)
 			tx_status = true;
 	}
-	printf("RX negotiated: %s\nTX negotiated: %s\n",
-	       rx_status ? "on" : "off", tx_status ? "on" : "off");
+
+	open_json_object("negotiated");
+	show_bool_val("rx", "RX negotiated: %s\n", &rx_status);
+	show_bool_val("tx", "TX negotiated: %s\n", &tx_status);
+	close_json_object();
 
 	return MNL_CB_OK;
 }
@@ -121,21 +124,34 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		return err_ret;
 
 	if (silent)
-		putchar('\n');
-	printf("Pause parameters for %s:\n", nlctx->devname);
-	show_bool(tb[ETHTOOL_A_PAUSE_AUTONEG], "Autonegotiate:\t");
-	show_bool(tb[ETHTOOL_A_PAUSE_RX], "RX:\t\t");
-	show_bool(tb[ETHTOOL_A_PAUSE_TX], "TX:\t\t");
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "Pause parameters for %s:\n",
+		     nlctx->devname);
+
+	show_bool("autonegotiate", "Autonegotiate:\t%s\n",
+		  tb[ETHTOOL_A_PAUSE_AUTONEG]);
+	show_bool("rx", "RX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_RX]);
+	show_bool("tx", "TX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_TX]);
+
 	if (!nlctx->is_monitor && tb[ETHTOOL_A_PAUSE_AUTONEG] &&
 	    mnl_attr_get_u8(tb[ETHTOOL_A_PAUSE_AUTONEG])) {
 		ret = show_pause_autoneg_status(nlctx);
 		if (ret < 0)
-			return err_ret;
+			goto err_close_dev;
 	}
 	if (!silent)
-		putchar('\n');
+		print_nl();
+
+	close_json_object();
 
 	return MNL_CB_OK;
+
+err_close_dev:
+	close_json_object();
+	return err_ret;
 }
 
 int nl_gpause(struct cmd_context *ctx)
@@ -156,7 +172,11 @@ int nl_gpause(struct cmd_context *ctx)
 				      ETHTOOL_A_PAUSE_HEADER, 0);
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, pause_reply_cb);
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, pause_reply_cb);
+	delete_json_obj();
+	return ret;
 }
 
 /* PAUSE_SET */
-- 
2.26.2

