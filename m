Return-Path: <netdev+bounces-3940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EE8709AE7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5595C1C212A3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4421210969;
	Fri, 19 May 2023 15:09:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41BDC2F5;
	Fri, 19 May 2023 15:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39691C433EF;
	Fri, 19 May 2023 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684508964;
	bh=c1dg5Ciwd6p/IoOCat4qrtA6b96sOCi6/kT15aNsBpo=;
	h=Subject:From:To:Cc:Date:From;
	b=GhoXBhHwIxzGP3gFPkHk+kBNhiJ0kGd2a322tCfyXBM3512m04QDudzadoGdTFNNv
	 cBI4eEONkQ7uvoT+aiYHFpYFXU1UDavP/eh8uCrwtnd1k4+YEmGoBKEh4RWdfhX5Ci
	 pbmn91xSqLb067vQzpmv+W5I+iYJEIQATu9Yuk/TE2iCWkvChQ5zFwYI83WukKCNUe
	 ZYLgvBYdERdtCW70oDSLdquL1S+oRM2U+PbdPKn+Ja6f2120geBfBHbWhv9WJMxvBG
	 tGzT2X0hK3qSRcROPAKYi1iyje0jkkATF5PVGsHCjC00SBJ80i8YwC3pVoisD7WB7q
	 v/pf92lBJABmg==
Subject: [PATCH] net/handshake: Squelch allocation warning during Kunit test
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
Cc: Linux Kernel Functional Testing <lkft@linaro.org>,
 Chuck Lever <chuck.lever@oracle.com>
Date: Fri, 19 May 2023 11:09:12 -0400
Message-ID: 
 <168450889814.157177.678686730886780464.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

The "handshake_req_alloc excessive privsize" kunit test is intended
to check what happens when the maximum privsize is exceeded. The
WARN_ON_ONCE_GFP at mm/page_alloc.c:4744 can be disabled safely for
this allocator call site.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Fixes: 88232ec1ec5e ("net/handshake: Add Kunit tests for the handshake consumer API")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/request.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

I sent this fix to the reporter last week, but haven't posted it to
netdev@ yet.

diff --git a/net/handshake/request.c b/net/handshake/request.c
index d78d41abb3d9..24097cccd158 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -120,7 +120,8 @@ struct handshake_req *handshake_req_alloc(const struct handshake_proto *proto,
 	if (!proto->hp_accept || !proto->hp_done)
 		return NULL;
 
-	req = kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
+	req = kzalloc(struct_size(req, hr_priv, proto->hp_privsize),
+		      flags | __GFP_NOWARN);
 	if (!req)
 		return NULL;
 



