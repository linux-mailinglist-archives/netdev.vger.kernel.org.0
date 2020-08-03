Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE523A3AE
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgHCL52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:41840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgHCL5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18858ABF1
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C32FD60754; Mon,  3 Aug 2020 13:57:18 +0200 (CEST)
Message-Id: <820434dc601a5382260711db05764f33898dfcfe.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 5/7] netlink: mark unused parameters of bitset walker
 callbacks
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:18 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some callbacks used with walk_bitset() do not use all parameters passed to
them. Mark unused parameters explicitly to get rid of compiler warnings.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/pause.c     | 3 ++-
 netlink/privflags.c | 2 +-
 netlink/settings.c  | 9 ++++++---
 netlink/tsinfo.c    | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/netlink/pause.c b/netlink/pause.c
index 48215d29aa34..7b6b3a1d2c10 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -21,7 +21,8 @@ struct pause_autoneg_status {
 	bool	asym_pause;
 };
 
-static void pause_autoneg_walker(unsigned int idx, const char *name, bool val,
+static void pause_autoneg_walker(unsigned int idx,
+				 const char *name __maybe_unused, bool val,
 				 void *data)
 {
 	struct pause_autoneg_status *status = data;
diff --git a/netlink/privflags.c b/netlink/privflags.c
index a06cd6d88d9d..299ccdc21581 100644
--- a/netlink/privflags.c
+++ b/netlink/privflags.c
@@ -19,7 +19,7 @@
 /* PRIVFLAGS_GET */
 
 static void privflags_maxlen_walk_cb(unsigned int idx, const char *name,
-				     bool val, void *data)
+				     bool val __maybe_unused, void *data)
 {
 	unsigned int *maxlen = data;
 	unsigned int len, n;
diff --git a/netlink/settings.c b/netlink/settings.c
index 726259d83702..17ef000ed812 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -656,7 +656,8 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
-void wol_modes_cb(unsigned int idx, const char *name, bool val, void *data)
+void wol_modes_cb(unsigned int idx, const char *name __maybe_unused, bool val,
+		  void *data)
 {
 	struct ethtool_wolinfo *wol = data;
 
@@ -704,7 +705,8 @@ int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
-void msgmask_cb(unsigned int idx, const char *name, bool val, void *data)
+void msgmask_cb(unsigned int idx, const char *name __maybe_unused, bool val,
+		void *data)
 {
 	u32 *msg_mask = data;
 
@@ -714,7 +716,8 @@ void msgmask_cb(unsigned int idx, const char *name, bool val, void *data)
 		*msg_mask |= (1U << idx);
 }
 
-void msgmask_cb2(unsigned int idx, const char *name, bool val, void *data)
+void msgmask_cb2(unsigned int idx __maybe_unused, const char *name,
+		 bool val, void *data __maybe_unused)
 {
 	if (val)
 		printf(" %s", name);
diff --git a/netlink/tsinfo.c b/netlink/tsinfo.c
index 03ce91cd4314..c6571ffc16ff 100644
--- a/netlink/tsinfo.c
+++ b/netlink/tsinfo.c
@@ -16,7 +16,7 @@
 /* TSINFO_GET */
 
 static void tsinfo_dump_cb(unsigned int idx, const char *name, bool val,
-			   void *data)
+			   void *data __maybe_unused)
 {
 	if (!val)
 		return;
-- 
2.28.0

