Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB7A23A3AB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHCL5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:41774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCL5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 089D5ABF1
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B2F9A60754; Mon,  3 Aug 2020 13:57:09 +0200 (CEST)
Message-Id: <4e6a60bf95b819912eb08cb13276791d8ec9feac.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/7] cable_test: clean up unused parameters
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:09 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions nl_cable_test_ntf_attr() and nl_cable_test_tdr_ntf_attr() do not
use nlctx parameter and as they are not callbacks with fixed signature, we
can simply drop it. Once we do, the same is true for cable_test_ntf_nest()
and cable_test_tdr_ntf_nest().

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/cable_test.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index c2b9c97d1239..d39b7d82efb0 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -88,8 +88,7 @@ static char *nl_pair2txt(uint8_t pair)
 	}
 }
 
-static int nl_cable_test_ntf_attr(struct nlattr *evattr,
-				  struct nl_context *nlctx)
+static int nl_cable_test_ntf_attr(struct nlattr *evattr)
 {
 	unsigned int cm;
 	uint16_t code;
@@ -122,14 +121,13 @@ static int nl_cable_test_ntf_attr(struct nlattr *evattr,
 	return 0;
 }
 
-static void cable_test_ntf_nest(const struct nlattr *nest,
-				struct nl_context *nlctx)
+static void cable_test_ntf_nest(const struct nlattr *nest)
 {
 	struct nlattr *pos;
 	int ret;
 
 	mnl_attr_for_each_nested(pos, nest) {
-		ret = nl_cable_test_ntf_attr(pos, nlctx);
+		ret = nl_cable_test_ntf_attr(pos);
 		if (ret < 0)
 			return;
 	}
@@ -180,7 +178,7 @@ static int cable_test_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_NTF_NEST])
-		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST], nlctx);
+		cable_test_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_NTF_NEST]);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		if (ctctx)
@@ -339,8 +337,7 @@ static int nl_get_cable_test_tdr_step(const struct nlattr *nest,
 	return 0;
 }
 
-static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr,
-				      struct nl_context *nlctx)
+static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 {
 	uint32_t first, last, step;
 	uint8_t pair;
@@ -391,14 +388,13 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr,
 	return 0;
 }
 
-static void cable_test_tdr_ntf_nest(const struct nlattr *nest,
-				    struct nl_context *nlctx)
+static void cable_test_tdr_ntf_nest(const struct nlattr *nest)
 {
 	struct nlattr *pos;
 	int ret;
 
 	mnl_attr_for_each_nested(pos, nest) {
-		ret = nl_cable_test_tdr_ntf_attr(pos, nlctx);
+		ret = nl_cable_test_tdr_ntf_attr(pos);
 		if (ret < 0)
 			return;
 	}
@@ -450,8 +446,7 @@ int cable_test_tdr_ntf_stop_cb(const struct nlmsghdr *nlhdr, void *data)
 	}
 
 	if (tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST])
-		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST],
-					nlctx);
+		cable_test_tdr_ntf_nest(tb[ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST]);
 
 	if (status == ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED) {
 		if (ctctx)
-- 
2.28.0

