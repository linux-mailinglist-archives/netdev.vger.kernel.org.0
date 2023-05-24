Return-Path: <netdev+bounces-5136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD42D70FC2F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1A471C20C0F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84EC19E72;
	Wed, 24 May 2023 17:07:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1134A60859
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AEEC433D2;
	Wed, 24 May 2023 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684948052;
	bh=9QQDE5aHQQ7Z6qlW7A5xkrog5EBpEq6APfJfe/gwIx8=;
	h=From:To:Cc:Subject:Date:From;
	b=qS5wLycPu2Rf8E1L9eg30lthnimlF22q23tdVV+VDv+YxAe6ejiq6Tj3dxA/cFUFE
	 Fm5XhUO08j+fNTHgj8hgKaGGkXIu9FDIxr2DovE70ar4QFKtMmS7GM1YpvcTreKBLu
	 4xBjYVK10fCrpWFueZPaILj/LYlCYCSMo5dc3iDPVCQVl7Q+caW/tPwhu2BM/He2ky
	 yDYF9B86EoRNbEVYpj3ULYZuUFTg/1MlEkdG2Xkz/2dUOyX0lJnOEsQ0ihm0pInYM2
	 dz8sF1Z6Sa7A4gZNjOvJrSkJJCcCqUQygs+bFGnybd+m8WLnUpdnxIC/OiuFoeleMV
	 5HUXBhWLKUlFA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	donald.hunter@gmail.com
Subject: [PATCH net] tools: ynl: avoid dict errors on older Python versions
Date: Wed, 24 May 2023 10:07:12 -0700
Message-Id: <20230524170712.2036128-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Python 3.9.0 or newer supports combining dicts() with |,
but older versions of Python are still used in the wild
(e.g. on CentOS 8, which goes EoL May 31, 2024).
With Python 3.6.8 we get:

  TypeError: unsupported operand type(s) for |: 'dict' and 'dict'

Use older syntax. Tested with non-legacy families only.

Fixes: f036d936ca57 ("tools: ynl: Add fixed-header support to ynl")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: donald.hunter@gmail.com

This is arguably not a fix, but those trying YNL on 6.4 will likely
appreciate not running into the problem.
---
 tools/net/ynl/lib/ynl.py | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 39a2296c0003..7c7a54d6841c 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -578,8 +578,9 @@ genl_family_name_to_id = None
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name)
-                           | gm.fixed_header_attrs)
+                rsp_msg = self._decode(gm.raw_attrs, op.attr_set.name)
+                rsp_msg.update(gm.fixed_header_attrs)
+                rsp.append(rsp_msg)
 
         if not rsp:
             return None
-- 
2.40.1


