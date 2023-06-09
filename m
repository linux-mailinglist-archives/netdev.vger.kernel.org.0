Return-Path: <netdev+bounces-9732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 267DA72A584
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75E021C211B6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39EC271FF;
	Fri,  9 Jun 2023 21:43:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA90923C75
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADEBC433A0;
	Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347036;
	bh=MElNLUKM5e8YgWUuBPs+3zH2fRfitvS7osVF4y4gg/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nshyh+qOXJMgBx6tPwZ0tTUcdttSrd74ZbzEEH6vAPJAnWMukY95OzZWBycNFec26
	 ESJDNBZOivfv88SgEpMQopL6dOiTSusO6I9sjAvZQ3pXzCxnUgu5tDRvK5H3eaErAc
	 rM87NIAMnacwV+jr56skztZi9OiKkwDtOrVrPK1tEqNFuT6QbLLr42C/0UjNhoY6h+
	 8t3pXS1tfKH9d2ujfzlRSWxUhnQi3Aiuv77M5cjnybRMehg6tr9UbaX94g1RrT8l8v
	 HLRlfPWymRrtQzS2k/GFxd1Wi/Cv8/zlcV8nXkOvCyvubHURKGTE8DchZYJm4lsFEQ
	 gmi2tz0gnjN6g==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/12] tools: ynl-gen: don't generate enum types if unnamed
Date: Fri,  9 Jun 2023 14:43:39 -0700
Message-Id: <20230609214346.1605106-6-kuba@kernel.org>
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

If attr set or enum has empty enum name we need to use u32 or int
as function arguments and struct members.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 05b49aa459a7..82ee6c7fa22d 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -268,7 +268,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         else:
             self.is_bitfield = False
 
-        if 'enum' in self.attr and not self.is_bitfield:
+        maybe_enum = not self.is_bitfield and 'enum' in self.attr
+        if maybe_enum and self.family.consts[self.attr['enum']].enum_name:
             self.type_name = f"enum {self.family.name}_{c_lower(self.attr['enum'])}"
         else:
             self.type_name = '__' + self.type
@@ -652,7 +653,14 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 class EnumSet(SpecEnumSet):
     def __init__(self, family, yaml):
         self.render_name = c_lower(family.name + '-' + yaml['name'])
-        self.enum_name = 'enum ' + self.render_name
+
+        if 'enum-name' in yaml:
+            if yaml['enum-name']:
+                self.enum_name = 'enum ' + c_lower(yaml['enum-name'])
+            else:
+                self.enum_name = None
+        else:
+            self.enum_name = 'enum ' + self.render_name
 
         self.value_pfx = yaml.get('name-prefix', f"{family.name}-{yaml['name']}-")
 
-- 
2.40.1


