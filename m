Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C4D284262
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgJEWHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgJEWHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:52 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 316A420870;
        Mon,  5 Oct 2020 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935671;
        bh=DVcxO2OxXVn/1C7Pd8CKcK12RNrbUOq9dlz+At66euw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f91HwAQwtYPIpy8bIxtREHjeFK/YC/2NSUbj7dCfHRceqhnGui9RVvjIx49Hlo06o
         sJ3tR9zm0j37ZBlCuTieL5MZPtiwMIvMC5r2PFeUuLXk37ghdIdco5mOsRUHfVFLWe
         IA+ydm+caS43FPpJuHLex9wKMVXFI7yPVWANw49E=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>,
        dsahern@gmail.com, pablo@netfilter.org
Subject: [PATCH net-next v2 5/7] netlink: create helpers for checking type is an int
Date:   Mon,  5 Oct 2020 15:07:37 -0700
Message-Id: <20201005220739.2581920-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of policies which check if type is a uint or sint.
Factor the checking against the list of value sizes to a helper
for easier reuse.

v2: - new patch

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@resnulli.us
CC: dsahern@gmail.com
CC: pablo@netfilter.org
---
 include/net/netlink.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 5a5ff97cc596..c5aa46f379bc 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -362,20 +362,21 @@ struct nla_policy {
 #define NLA_POLICY_BITFIELD32(valid) \
 	{ .type = NLA_BITFIELD32, .bitfield32_valid = valid }
 
+#define __NLA_IS_UINT_TYPE(tp)						\
+	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 || tp == NLA_U64)
+#define __NLA_IS_SINT_TYPE(tp)						\
+	(tp == NLA_S8 || tp == NLA_S16 || tp == NLA_S32 || tp == NLA_S64)
+
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_OR_BINARY_TYPE(tp)		\
-	(__NLA_ENSURE(tp == NLA_U8 || tp == NLA_U16 ||	\
-		      tp == NLA_U32 || tp == NLA_U64 ||	\
+	(__NLA_ENSURE(__NLA_IS_UINT_TYPE(tp) ||	\
 		      tp == NLA_MSECS ||		\
 		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_SINT_TYPE(tp)			\
-	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_S16  ||	\
-		      tp == NLA_S32 || tp == NLA_S64) + tp)
+	(__NLA_ENSURE(__NLA_IS_SINT_TYPE(tp)) + tp)
 #define NLA_ENSURE_INT_OR_BINARY_TYPE(tp)		\
-	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
-		      tp == NLA_S16 || tp == NLA_U16 ||	\
-		      tp == NLA_S32 || tp == NLA_U32 ||	\
-		      tp == NLA_S64 || tp == NLA_U64 ||	\
+	(__NLA_ENSURE(__NLA_IS_UINT_TYPE(tp) ||		\
+		      __NLA_IS_SINT_TYPE(tp) ||		\
 		      tp == NLA_MSECS ||		\
 		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
-- 
2.26.2

