Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF62112A5E
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfECJZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51654 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfECJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURM-0005qF-Eh; Fri, 03 May 2019 11:25:12 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 4/8] netlink: allow NLA_MSECS to have range validation
Date:   Fri,  3 May 2019 11:24:57 +0200
Message-Id: <20190503092501.10275-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
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
index 2b91a15803b0..2b035bf8daf6 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -374,7 +374,8 @@ struct nla_policy {
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_TYPE(tp)			\
 	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
-		      tp == NLA_U32 || tp == NLA_U64) + tp)
+		      tp == NLA_U32 || tp == NLA_U64 ||	\
+		      tp == NLA_MSECS) + tp)
 #define NLA_ENSURE_SINT_TYPE(tp)			\
 	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_S16  ||	\
 		      tp == NLA_S32 || tp == NLA_S64) + tp)
@@ -382,7 +383,8 @@ struct nla_policy {
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
index b549b290d3fa..c8789de96046 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -135,6 +135,7 @@ static int nla_validate_int_range_unsigned(const struct nla_policy *pt,
 		value = nla_get_u32(nla);
 		break;
 	case NLA_U64:
+	case NLA_MSECS:
 		value = nla_get_u64(nla);
 		break;
 	default:
@@ -211,6 +212,7 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U16:
 	case NLA_U32:
 	case NLA_U64:
+	case NLA_MSECS:
 		return nla_validate_int_range_unsigned(pt, nla, extack);
 	case NLA_S8:
 	case NLA_S16:
-- 
2.17.2

