Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1939285D9A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgJGKyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgJGKyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:54:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF991C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:54:05 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ758-000qv0-1U; Wed, 07 Oct 2020 12:54:02 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY attr
Date:   Wed,  7 Oct 2020 12:53:50 +0200
Message-Id: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The ETHTOOL_A_STRSET_COUNTS_ONLY flag attribute was previously
not allowed to be used, but now due to the policy size reduction
we would access the tb[] array out of bounds since we tried to
check for the attribute despite it not being accepted.

Fix both issues by adding it correctly to the appropriate policy.

Fixes: ff419afa4310 ("ethtool: trim policy tables")
Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/ethtool/netlink.h | 2 +-
 net/ethtool/strset.c  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3f5719786b0f..d8efec516d86 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,7 +347,7 @@ extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
-extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
+extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_ONLY + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 0734e83c674c..0baad0ce1832 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -103,6 +103,7 @@ const struct nla_policy ethnl_strset_get_policy[] = {
 	[ETHTOOL_A_STRSET_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STRSET_COUNTS_ONLY]	= { .type = NLA_FLAG },
 };
 
 static const struct nla_policy get_stringset_policy[] = {
-- 
2.26.2

