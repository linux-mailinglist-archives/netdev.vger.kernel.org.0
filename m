Return-Path: <netdev+bounces-9373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 056BA728A08
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF88828177C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B1934D7D;
	Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C1234CDA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28397C433A4;
	Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258729;
	bh=CYDwa46e2g2vbY79jA15d/xXiwuFAN1k92YOis2BwRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATNPHWfuVzq/gKjEFzliHFlP/B2O57nqQlj/drYy7h1h2FxOPBdhEsksFPdzau+n2
	 3CAu984NvTDddr8bZn4fOXQmebl3Xh4jimKceAxIJLvJhI/gC9ZuURM3VPNC0rAzRS
	 PE3EDjH/hUSVjHb9OOGf9YCGGFSCWm4u36r0OppSw/cXuLhw7GNNW7V5SD10rjpZt8
	 wBDIYMr5Z9LKh7MT+sAYRETFQdAan74K9AnwpB4P/enzueNv0/G2B6obKdavFkTYwW
	 LuNxaeLbpbJvb9obteZGH29ft7J5pksJfMBDR+fTbJGdkQ8KQErGsugWsXnZPFC6Ur
	 f3ARlPk3/pSkQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/12] tools: ynl: regen: regenerate the if ladders
Date: Thu,  8 Jun 2023 14:11:54 -0700
Message-Id: <20230608211200.1247213-7-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Renegate the code to combine } and else and use tmp variable
to store type.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/generated/devlink-user.c   | 74 ++++++++++++------------
 tools/net/ynl/generated/fou-user.c       | 31 ++++------
 tools/net/ynl/generated/handshake-user.c | 29 +++++-----
 tools/net/ynl/generated/netdev-user.c    |  7 ++-
 4 files changed, 67 insertions(+), 74 deletions(-)

diff --git a/tools/net/ynl/generated/devlink-user.c b/tools/net/ynl/generated/devlink-user.c
index 4604b6829fd0..939bd45feaca 100644
--- a/tools/net/ynl/generated/devlink-user.c
+++ b/tools/net/ynl/generated/devlink-user.c
@@ -126,7 +126,9 @@ int devlink_dl_info_version_parse(struct ynl_parse_arg *yarg,
 	const struct nlattr *attr;
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_VERSION_NAME) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_INFO_VERSION_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -137,8 +139,7 @@ int devlink_dl_info_version_parse(struct ynl_parse_arg *yarg,
 			dst->info_version_name = malloc(len + 1);
 			memcpy(dst->info_version_name, mnl_attr_get_str(attr), len);
 			dst->info_version_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_VERSION_VALUE) {
+		} else if (type == DEVLINK_ATTR_INFO_VERSION_VALUE) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -167,13 +168,14 @@ int devlink_dl_reload_stats_entry_parse(struct ynl_parse_arg *yarg,
 	const struct nlattr *attr;
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_STATS_LIMIT) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_RELOAD_STATS_LIMIT) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_stats_limit = 1;
 			dst->reload_stats_limit = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_STATS_VALUE) {
+		} else if (type == DEVLINK_ATTR_RELOAD_STATS_VALUE) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_stats_value = 1;
@@ -208,7 +210,9 @@ int devlink_dl_reload_act_stats_parse(struct ynl_parse_arg *yarg,
 		return ynl_error_parse(yarg, "attribute already present (dl-reload-act-stats.reload-stats-entry)");
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_STATS_ENTRY) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_RELOAD_STATS_ENTRY) {
 			n_reload_stats_entry++;
 		}
 	}
@@ -255,13 +259,14 @@ int devlink_dl_reload_act_info_parse(struct ynl_parse_arg *yarg,
 		return ynl_error_parse(yarg, "attribute already present (dl-reload-act-info.reload-action-stats)");
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_ACTION) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_RELOAD_ACTION) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_action = 1;
 			dst->reload_action = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_ACTION_STATS) {
+		} else if (type == DEVLINK_ATTR_RELOAD_ACTION_STATS) {
 			n_reload_action_stats++;
 		}
 	}
@@ -308,7 +313,9 @@ int devlink_dl_reload_stats_parse(struct ynl_parse_arg *yarg,
 		return ynl_error_parse(yarg, "attribute already present (dl-reload-stats.reload-action-info)");
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_ACTION_INFO) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_RELOAD_ACTION_INFO) {
 			n_reload_action_info++;
 		}
 	}
@@ -347,7 +354,9 @@ int devlink_dl_dev_stats_parse(struct ynl_parse_arg *yarg,
 	parg.ys = yarg->ys;
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_STATS) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_RELOAD_STATS) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_stats = 1;
@@ -356,8 +365,7 @@ int devlink_dl_dev_stats_parse(struct ynl_parse_arg *yarg,
 			parg.data = &dst->reload_stats;
 			if (devlink_dl_reload_stats_parse(&parg, attr))
 				return MNL_CB_ERROR;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_REMOTE_RELOAD_STATS) {
+		} else if (type == DEVLINK_ATTR_REMOTE_RELOAD_STATS) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.remote_reload_stats = 1;
@@ -400,7 +408,9 @@ int devlink_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 	parg.ys = yarg->ys;
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_BUS_NAME) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_BUS_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -411,8 +421,7 @@ int devlink_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->bus_name = malloc(len + 1);
 			memcpy(dst->bus_name, mnl_attr_get_str(attr), len);
 			dst->bus_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_DEV_NAME) {
+		} else if (type == DEVLINK_ATTR_DEV_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -423,20 +432,17 @@ int devlink_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->dev_name = malloc(len + 1);
 			memcpy(dst->dev_name, mnl_attr_get_str(attr), len);
 			dst->dev_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_FAILED) {
+		} else if (type == DEVLINK_ATTR_RELOAD_FAILED) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_failed = 1;
 			dst->reload_failed = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_RELOAD_ACTION) {
+		} else if (type == DEVLINK_ATTR_RELOAD_ACTION) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.reload_action = 1;
 			dst->reload_action = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_DEV_STATS) {
+		} else if (type == DEVLINK_ATTR_DEV_STATS) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.dev_stats = 1;
@@ -576,7 +582,9 @@ int devlink_info_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 		return ynl_error_parse(yarg, "attribute already present (devlink.info-version-stored)");
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
-		if (mnl_attr_get_type(attr) == DEVLINK_ATTR_BUS_NAME) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == DEVLINK_ATTR_BUS_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -587,8 +595,7 @@ int devlink_info_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->bus_name = malloc(len + 1);
 			memcpy(dst->bus_name, mnl_attr_get_str(attr), len);
 			dst->bus_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_DEV_NAME) {
+		} else if (type == DEVLINK_ATTR_DEV_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -599,8 +606,7 @@ int devlink_info_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->dev_name = malloc(len + 1);
 			memcpy(dst->dev_name, mnl_attr_get_str(attr), len);
 			dst->dev_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_DRIVER_NAME) {
+		} else if (type == DEVLINK_ATTR_INFO_DRIVER_NAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -611,8 +617,7 @@ int devlink_info_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->info_driver_name = malloc(len + 1);
 			memcpy(dst->info_driver_name, mnl_attr_get_str(attr), len);
 			dst->info_driver_name[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_SERIAL_NUMBER) {
+		} else if (type == DEVLINK_ATTR_INFO_SERIAL_NUMBER) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -623,14 +628,11 @@ int devlink_info_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->info_serial_number = malloc(len + 1);
 			memcpy(dst->info_serial_number, mnl_attr_get_str(attr), len);
 			dst->info_serial_number[len] = 0;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_VERSION_FIXED) {
+		} else if (type == DEVLINK_ATTR_INFO_VERSION_FIXED) {
 			n_info_version_fixed++;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_VERSION_RUNNING) {
+		} else if (type == DEVLINK_ATTR_INFO_VERSION_RUNNING) {
 			n_info_version_running++;
-		}
-		else if (mnl_attr_get_type(attr) == DEVLINK_ATTR_INFO_VERSION_STORED) {
+		} else if (type == DEVLINK_ATTR_INFO_VERSION_STORED) {
 			n_info_version_stored++;
 		}
 	}
diff --git a/tools/net/ynl/generated/fou-user.c b/tools/net/ynl/generated/fou-user.c
index 23c8f347547e..4271b5d43c58 100644
--- a/tools/net/ynl/generated/fou-user.c
+++ b/tools/net/ynl/generated/fou-user.c
@@ -172,42 +172,38 @@ int fou_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 	dst = yarg->data;
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
-		if (mnl_attr_get_type(attr) == FOU_ATTR_PORT) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == FOU_ATTR_PORT) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.port = 1;
 			dst->port = mnl_attr_get_u16(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_IPPROTO) {
+		} else if (type == FOU_ATTR_IPPROTO) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.ipproto = 1;
 			dst->ipproto = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_TYPE) {
+		} else if (type == FOU_ATTR_TYPE) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.type = 1;
 			dst->type = mnl_attr_get_u8(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_REMCSUM_NOPARTIAL) {
+		} else if (type == FOU_ATTR_REMCSUM_NOPARTIAL) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.remcsum_nopartial = 1;
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_LOCAL_V4) {
+		} else if (type == FOU_ATTR_LOCAL_V4) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.local_v4 = 1;
 			dst->local_v4 = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_PEER_V4) {
+		} else if (type == FOU_ATTR_PEER_V4) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.peer_v4 = 1;
 			dst->peer_v4 = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_LOCAL_V6) {
+		} else if (type == FOU_ATTR_LOCAL_V6) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -217,8 +213,7 @@ int fou_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->_present.local_v6_len = len;
 			dst->local_v6 = malloc(len);
 			memcpy(dst->local_v6, mnl_attr_get_payload(attr), len);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_PEER_V6) {
+		} else if (type == FOU_ATTR_PEER_V6) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
@@ -228,14 +223,12 @@ int fou_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 			dst->_present.peer_v6_len = len;
 			dst->peer_v6 = malloc(len);
 			memcpy(dst->peer_v6, mnl_attr_get_payload(attr), len);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_PEER_PORT) {
+		} else if (type == FOU_ATTR_PEER_PORT) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.peer_port = 1;
 			dst->peer_port = mnl_attr_get_u16(attr);
-		}
-		else if (mnl_attr_get_type(attr) == FOU_ATTR_IFINDEX) {
+		} else if (type == FOU_ATTR_IFINDEX) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.ifindex = 1;
diff --git a/tools/net/ynl/generated/handshake-user.c b/tools/net/ynl/generated/handshake-user.c
index 7c204bf4c7cb..3a0392b3355e 100644
--- a/tools/net/ynl/generated/handshake-user.c
+++ b/tools/net/ynl/generated/handshake-user.c
@@ -116,13 +116,14 @@ int handshake_x509_parse(struct ynl_parse_arg *yarg,
 	const struct nlattr *attr;
 
 	mnl_attr_for_each_nested(attr, nested) {
-		if (mnl_attr_get_type(attr) == HANDSHAKE_A_X509_CERT) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == HANDSHAKE_A_X509_CERT) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.cert = 1;
 			dst->cert = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_X509_PRIVKEY) {
+		} else if (type == HANDSHAKE_A_X509_PRIVKEY) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.privkey = 1;
@@ -171,37 +172,33 @@ int handshake_accept_rsp_parse(const struct nlmsghdr *nlh, void *data)
 		return ynl_error_parse(yarg, "attribute already present (accept.peer-identity)");
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
-		if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_SOCKFD) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == HANDSHAKE_A_ACCEPT_SOCKFD) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.sockfd = 1;
 			dst->sockfd = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_MESSAGE_TYPE) {
+		} else if (type == HANDSHAKE_A_ACCEPT_MESSAGE_TYPE) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.message_type = 1;
 			dst->message_type = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_TIMEOUT) {
+		} else if (type == HANDSHAKE_A_ACCEPT_TIMEOUT) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.timeout = 1;
 			dst->timeout = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_AUTH_MODE) {
+		} else if (type == HANDSHAKE_A_ACCEPT_AUTH_MODE) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.auth_mode = 1;
 			dst->auth_mode = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_PEER_IDENTITY) {
+		} else if (type == HANDSHAKE_A_ACCEPT_PEER_IDENTITY) {
 			n_peer_identity++;
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_CERTIFICATE) {
+		} else if (type == HANDSHAKE_A_ACCEPT_CERTIFICATE) {
 			n_certificate++;
-		}
-		else if (mnl_attr_get_type(attr) == HANDSHAKE_A_ACCEPT_PEERNAME) {
+		} else if (type == HANDSHAKE_A_ACCEPT_PEERNAME) {
 			unsigned int len;
 
 			if (ynl_attr_validate(yarg, attr))
diff --git a/tools/net/ynl/generated/netdev-user.c b/tools/net/ynl/generated/netdev-user.c
index fe0da71f653c..12069784637e 100644
--- a/tools/net/ynl/generated/netdev-user.c
+++ b/tools/net/ynl/generated/netdev-user.c
@@ -79,13 +79,14 @@ int netdev_dev_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 	dst = yarg->data;
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct genlmsghdr)) {
-		if (mnl_attr_get_type(attr) == NETDEV_A_DEV_IFINDEX) {
+		unsigned int type = mnl_attr_get_type(attr);
+
+		if (type == NETDEV_A_DEV_IFINDEX) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.ifindex = 1;
 			dst->ifindex = mnl_attr_get_u32(attr);
-		}
-		else if (mnl_attr_get_type(attr) == NETDEV_A_DEV_XDP_FEATURES) {
+		} else if (type == NETDEV_A_DEV_XDP_FEATURES) {
 			if (ynl_attr_validate(yarg, attr))
 				return MNL_CB_ERROR;
 			dst->_present.xdp_features = 1;
-- 
2.40.1


