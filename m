Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5F1BDF7F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgD2NtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgD2Ns6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:48:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB23FC03C1AE;
        Wed, 29 Apr 2020 06:48:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTn56-001vkM-TC; Wed, 29 Apr 2020 15:48:57 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/7] netlink: allow NLA_MSECS to have range validation
Date:   Wed, 29 Apr 2020 15:48:41 +0200
Message-Id: <20200429154836.b9b70600438d.I46e9164d064042d49227b9af7a686b3a02080ff0@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200429134843.42224-1-johannes@sipsolutions.net>
References: <20200429134843.42224-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since NLA_MSECS is really equivalent to NLA_U64, allow
it to have range validation as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 6 ++++--
 lib/nlattr.c          | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 94a7df4ab122..4acd7165e900 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -371,7 +371,8 @@ struct nla_policy {
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_TYPE(tp)			\
 	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
-		      tp == NLA_U32 || tp == NLA_U64) + tp)
+		      tp == NLA_U32 || tp == NLA_U64 ||	\
+		      tp == NLA_MSECS) + tp)
 #define NLA_ENSURE_SINT_TYPE(tp)			\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_S16  ||	\
 		      tp == NLA_S32 || tp == NLA_S64) + tp)
@@ -379,7 +380,8 @@ struct nla_policy {
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
 		      tp == NLA_S16 || tp == NLA_U16 ||	\
 		      tp == NLA_S32 || tp == NLA_U32 ||	\
-		      tp == NLA_S64 || tp == NLA_U64) + tp)
+		      tp == NLA_S64 || tp == NLA_U64 ||	\
+		      tp == NLA_MSECS) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
 	(__NLA_ENSURE(tp != NLA_BITFIELD32 &&		\
 		      tp != NLA_REJECT &&		\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index bb66d06cc6f9..ab7fa7726c12 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -150,6 +150,7 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 		value = nla_get_u32(nla);
 		break;
 	case NLA_U64:
+	case NLA_MSECS:
 		value = nla_get_u64(nla);
 		break;
 	default:
@@ -226,6 +227,7 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U16:
 	case NLA_U32:
 	case NLA_U64:
+	case NLA_MSECS:
 		return nla_validate_int_range_unsigned(pt, nla, extack);
 	case NLA_S8:
 	case NLA_S16:
-- 
2.25.1

