Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B083745DF
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhEERIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236882AbhEERDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:03:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DD661403;
        Wed,  5 May 2021 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232911;
        bh=pHtSuaRD9ECuqmij18bMGNVoZYyhXTDFP66B78+ACxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezOlnzw0ldE5GBcvKnPwcGllPHbPGxH/3oLz1v+53AljE3JGDuulTUrVvbQglSXr7
         Yb2I+VjBlShi0moO0viOJvLFEKDlikThDHQCH42H7/hRKMNkTB+u0RYusptCBMYX70
         18/uh7a6WTZ5nJC4TZHVwPpJM6ZCOrZV0FZL1O9VtlBmPZd2WesC1oukpKgBuRHBnh
         Kc2Z+OH+j5Fbkl/N4ddZoxdiBV1VDe/Nj7PT+tE74ftL4RjEhz/90ZZk5uPj4EQSdh
         BTmdyeHqoYx1xjiLDVapexibevZnrDqOpweQHHvc1qSsl23zr8u95fPLn32ldkT8DO
         K/45OySr5gLxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/22] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
Date:   Wed,  5 May 2021 12:41:22 -0400
Message-Id: <20210505164129.3464277-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164129.3464277-1-sashal@kernel.org>
References: <20210505164129.3464277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit e5272ad4aab347dde5610c0aedb786219e3ff793 ]

Fix the following out-of-bounds warning:

net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index acb0c2631c79..0c5aff3bb539 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3129,7 +3129,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		 * primary.
 		 */
 		if (af->is_any(&addr))
-			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
+			memcpy(&addr, sctp_source(asconf), sizeof(addr));
 
 		peer = sctp_assoc_lookup_paddr(asoc, &addr);
 		if (!peer)
-- 
2.30.2

