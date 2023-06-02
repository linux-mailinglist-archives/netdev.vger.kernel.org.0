Return-Path: <netdev+bounces-7288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2507071F87A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E7C62819C9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321F017E5;
	Fri,  2 Jun 2023 02:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78C15BA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E44EC433A7;
	Fri,  2 Jun 2023 02:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673355;
	bh=+VDxKsUYDvyMqHDVPGzyFg47QX+FsJyHX/y2Cmqnupo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONzT9gRai+vG10BkP7YI/R+TdjXNj6TpfPtcNDZwDjrmHS8+cdtDoegn4EvPwJFe5
	 HtZO3R/NrqD8swQL56JR9wwd7dbq5Cw/nNi2QqFIKmr2BwWRasfgqao1FdYDSq5ZqK
	 hQsxSBT9pIl1dUt1pdkOwZkME3yprVA3yFGDmS06rRGJTjfO6hGfRLsdE4F0ySEyNT
	 ke17OxOtQH2+me4UPcGYwjqN4cV6tTGj1t1c3dccHRUQ/3Z7q22gKspsRpa1+d6Ezw
	 mQmfcIUZPQGbNlOGklSRXKFmxRgF49eHLhJTVIxtNKWE8XoNCl+5khKuezTXgZFz5a
	 8XhBNHCFrerjQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/10] tools: ynl-gen: add error checking for nested structs
Date: Thu,  1 Jun 2023 19:35:43 -0700
Message-Id: <20230602023548.463441-6-kuba@kernel.org>
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

Parsing nested types may return an error, propagate it.
Not marking as a fix, because nothing uses YNL upstream.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 2ceb4ce1423f..8bf4b70216d7 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -424,7 +424,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                             f"{self.enum_name}, &{var}->{self.c_name})")
 
     def _attr_get(self, ri, var):
-        get_lines = [f"{self.nested_render_name}_parse(&parg, attr);"]
+        get_lines = [f"if ({self.nested_render_name}_parse(&parg, attr))",
+                     "return MNL_CB_ERROR;"]
         init_lines = [f"parg.rsp_policy = &{self.nested_render_name}_nest;",
                       f"parg.data = &{var}->{self.c_name};"]
         return get_lines, init_lines, None
-- 
2.40.1


