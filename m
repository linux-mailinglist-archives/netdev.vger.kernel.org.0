Return-Path: <netdev+bounces-7287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D05171F879
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F0191C210C9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB624ED8;
	Fri,  2 Jun 2023 02:35:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A310F6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87140C433A0;
	Fri,  2 Jun 2023 02:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673354;
	bh=EZXAGOIGnSB3/f13EBxoN7QpZ3WQdORfp7JwPZasqNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL1ZzONxOMB1yVNUeDdKg/xiHPZ37mI1azEd8kl6xVY8R3dEp+R/RQRRgLwiTY34C
	 5DToM/oHVTsAJGQ3kH+pvrkghCHdv5559uI528YCAA47KrOY+OvLfcmGDmPt/pKR7g
	 jMQ5Kr9mzXSV2b2hpR2rbrKvJH17byQFrs5dUydCwI13cdQ/Ybf9U0bP2hbwBAfOzz
	 kvFkypSufsbyerTn9NCydIKJIZR/Uiz8maDXP+tMymc8+Zwi29PciWQ9pHjSe9qBqo
	 HdcFY54L3obAAL0hgpEhkAD9HvunmBZOQPXnmOImn41fWRD4I7EuqjNBO5tfpAyREq
	 PvRyefv9y1aRg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/10] tools: ynl-gen: don't override pure nested struct
Date: Thu,  1 Jun 2023 19:35:41 -0700
Message-Id: <20230602023548.463441-4-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602023548.463441-1-kuba@kernel.org>
References: <20230602023548.463441-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For pure structs (parsed nested attributes) we track what
forms of the struct exist in request and reply directions.
Make sure we don't overwrite the recorded struct each time,
otherwise the information is lost.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 11dcbfc21ecc..40f7c47407c8 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -825,7 +825,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                     inherit = set()
                     nested = spec['nested-attributes']
                     if nested not in self.root_sets:
-                        self.pure_nested_structs[nested] = Struct(self, nested, inherited=inherit)
+                        if nested not in self.pure_nested_structs:
+                            self.pure_nested_structs[nested] = Struct(self, nested, inherited=inherit)
                     if attr in rs_members['request']:
                         self.pure_nested_structs[nested].request = True
                     if attr in rs_members['reply']:
-- 
2.40.1


