Return-Path: <netdev+bounces-9728-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5942E72A57E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05884281A30
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F168423C91;
	Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFDD23425
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB28C433D2;
	Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347035;
	bh=WjTJgaQ/AuS7O8gjbqngtXsS8S0oNnRbT3UfMejMoFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahnBKs5g/3Uabl3HnQOQkHUFc7pRdEv30rg4mVqH4z+FABAOlmnVSfRh9lHszcIf8
	 mkBlTTbG7TmROt0Lx1NaRFo5R+t03xJgSNl30MrlzBlzHbemW7V70ncqxjklfQHEQ0
	 z9OWz2lfq3p1Z2Xmv1p7C6tR/GUsJuomqqxA+mZ35hqGKCXIE1hElPobm54iaLpMxy
	 5bdHh0VBO5eJ7lRG2Zpvd0uG/9iIg8qETVY7KFJ6umakbyfmln0EUTAf3bQMlXDWYa
	 5IRhG5XIyy/KP9PScRr2bItyOoNg/euJIkpQySynUuzOUDZydgrLErARqWdeFWs3rc
	 KQBdaev3qT5OA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/12] netlink: specs: support setting prefix-name per attribute
Date: Fri,  9 Jun 2023 14:43:37 -0700
Message-Id: <20230609214346.1605106-4-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ethtool's PSE PoDL has a attr nest with different prefixes:

/* Power Sourcing Equipment */
enum {
	ETHTOOL_A_PSE_UNSPEC,
	ETHTOOL_A_PSE_HEADER,			/* nest - _A_HEADER_* */
	ETHTOOL_A_PODL_PSE_ADMIN_STATE,		/* u32 */
	ETHTOOL_A_PODL_PSE_ADMIN_CONTROL,	/* u32 */
	ETHTOOL_A_PODL_PSE_PW_D_STATUS,		/* u32 */

Header has a prefix of ETHTOOL_A_PSE_ and other attrs prefix of
ETHTOOL_A_PODL_PSE_ we can't cover them uniformly.
If PODL was after PSE life would be easy.

Now we either need to add prefixes to attr names which is yucky
or support setting prefix name per attr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml      | 4 ++++
 Documentation/netlink/genetlink-legacy.yaml | 4 ++++
 tools/net/ynl/ynl-gen-c.py                  | 7 +++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index 8e8c17b0a6c6..0519c257ecf4 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -195,6 +195,10 @@ additionalProperties: False
                     description: Max length for a string or a binary attribute.
                     $ref: '#/$defs/len-or-define'
               sub-type: *attr-type
+              # Start genetlink-c
+              name-prefix:
+                type: string
+              # End genetlink-c
 
       # Make sure name-prefix does not appear in subsets (subsets inherit naming)
       dependencies:
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index ac4350498f5e..b474889b49ff 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -226,6 +226,10 @@ additionalProperties: False
                     description: Max length for a string or a binary attribute.
                     $ref: '#/$defs/len-or-define'
               sub-type: *attr-type
+              # Start genetlink-c
+              name-prefix:
+                type: string
+              # End genetlink-c
               # Start genetlink-legacy
               struct:
                 description: Name of the struct type used for the attribute.
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 89d9471e9c2b..05b49aa459a7 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -58,8 +58,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         delattr(self, "enum_name")
 
     def resolve(self):
-        self.enum_name = f"{self.attr_set.name_prefix}{self.name}"
-        self.enum_name = c_upper(self.enum_name)
+        if 'name-prefix' in self.attr:
+            enum_name = f"{self.attr['name-prefix']}{self.name}"
+        else:
+            enum_name = f"{self.attr_set.name_prefix}{self.name}"
+        self.enum_name = c_upper(enum_name)
 
     def is_multi_val(self):
         return None
-- 
2.40.1


