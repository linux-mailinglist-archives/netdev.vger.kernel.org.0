Return-Path: <netdev+bounces-1474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507E86FDE14
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18572814F6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55628C12;
	Wed, 10 May 2023 12:48:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DDA20B42
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C65C433EF;
	Wed, 10 May 2023 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683722900;
	bh=p4qS+sgfbOwq8qH6rp0eTVGyaZSlldvV22xWjtrHZhw=;
	h=From:Date:Subject:To:Cc:From;
	b=E8pTjzTKVXmDFGCGZio2k4dHI4c6liz+V3TekHQAR7qgpF0lsLzXDJ4jaR9Pg5Dbm
	 QzGztv3axS/vrPll76syqz2M2IHDDQ3JTKbnsZS+U+3vqQ0CklEDtmTvziknjfswJv
	 1zcSN2ZlT63LAYbM4t3Ndx8CYQMbGLsrokesfncAl4Qg5PcrR/maHYQWqA2RpQypch
	 1PtxQIlKTdTz8sBkGbgAxa+FdvshpxqjbbDkWmuthK56sttpkXlVwsXvsGj8kaPg9c
	 EVG88ISA7poh0aGkF/uF72d1oLH5S33RU3xhQDPlqayb2uEgiXuEkIKCZ/K8IXcYNf
	 h3355cuyHc7eQ==
From: Simon Horman <horms@kernel.org>
Date: Wed, 10 May 2023 14:48:11 +0200
Subject: [PATCH RFC net] tipic: guard against buffer overrun in
 bearer_name_validate()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230510-tpic-bearer_name_validate-v1-1-016d882e4e99@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIqSW2QC/x2NQQrCMBBFr1JmbSCNVMSt4AHcFimTZGIH4lgms
 Qildze4fB/efxsUUqYCl24DpZULv6VBf+ggzChPMhwbg7PuaIfemrpwMJ5QSSfBF00rZo5YySQ
 7JDqdk3MuQvM9FjJeUcLcHuSTcxsXpcTff3CE++3aCVV47PsPyRL9dIkAAAA=
To: Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Per Liden <per.liden@nospam.ericsson.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>, netdev@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net
X-Mailer: b4 0.12.2

Smatch reports that copying media_name and if_name to name_parts may
overwrite the destination.

 .../bearer.c:166 bearer_name_validate() error: strcpy() 'media_name' too large for 'name_parts->media_name' (32 vs 16)
 .../bearer.c:167 bearer_name_validate() error: strcpy() 'if_name' too large for 'name_parts->if_name' (1010102 vs 16)

This does seem to be the case, although perhaps it never occurs in
practice due to well formed input.

Guard against this possibility by using strscpy() and failing if
truncation occurs.

Compile tested only.

Fixes: b97bf3fd8f6a ("[TIPC] Initial merge")
Signed-off-by: Simon Horman <horms@kernel.org>
---
 net/tipc/bearer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 35cac7733fd3..a82cd8f351a5 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -163,8 +163,12 @@ static int bearer_name_validate(const char *name,
 
 	/* return bearer name components, if necessary */
 	if (name_parts) {
-		strcpy(name_parts->media_name, media_name);
-		strcpy(name_parts->if_name, if_name);
+		if (strscpy(name_parts->media_name, media_name,
+			    TIPC_MAX_MEDIA_NAME) < 0)
+			return 0;
+		if (strscpy(name_parts->if_name, if_name,
+			    TIPC_MAX_IF_NAME) < 0)
+			return 0;
 	}
 	return 1;
 }


