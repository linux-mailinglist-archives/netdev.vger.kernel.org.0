Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5749437418C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhEEQjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234783AbhEEQhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11A5661413;
        Wed,  5 May 2021 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232404;
        bh=DPhJxbCGTKtKEJllav8XGEl/X87ke2S8d3c5qt4sdl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCyAccX6DVbT+DHqjwPvZ28pBCio+VZZm2Qqi34l5oMi4t1qMLczWrlIwD3+z+MJh
         3xpr9aHUvcUmVuYAIySsn0fetIFHqSvpEVw+n0bYfIPzaDa7pKV10ws2WHwI/3zRVT
         mBb3kJIYCo0/9Dr9C4v7aYXysfOhy6a9dSkGf1MDql7RNA818BYxpVUIMDpAPcqFRy
         sL/UFbZGbScHwDvpDoMxdh7CtxqIj4A7rh9qhnbmu9AxKEANk+IlVzCTsAi/L3zlzt
         uTTSeD06DZPSxxHwVFX/vtwZ+XkbJIwKskouqDG7V6aKmac4UagErf5iSWGltbYnUZ
         NH+GaUo3okLCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 084/116] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
Date:   Wed,  5 May 2021 12:30:52 -0400
Message-Id: <20210505163125.3460440-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index f77484df097b..da4ce0947c3a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3147,7 +3147,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		 * primary.
 		 */
 		if (af->is_any(&addr))
-			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
+			memcpy(&addr, sctp_source(asconf), sizeof(addr));
 
 		if (security_sctp_bind_connect(asoc->ep->base.sk,
 					       SCTP_PARAM_SET_PRIMARY,
-- 
2.30.2

