Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580683742A7
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhEEQrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235952AbhEEQpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F1F6141B;
        Wed,  5 May 2021 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232562;
        bh=DPhJxbCGTKtKEJllav8XGEl/X87ke2S8d3c5qt4sdl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtBsbxcjADFfsxD6H961nCHSJ5EfBjxmUb1LReu0nN3rX0k7duninJgjy8WJIB+Zc
         RW5f9WVS0QPQP3X0EUEziF5cGeu6N94VZEGQLimlR6RVEKTfjgMB2Yv+ybhNhp9y/v
         Y3q0gdAfaWiGR/pcuQe3gIxF171ihSCFMOB68kHDgP15vjvDWFiqRk3eTIxJ4LEerI
         BRpsrbVEY3gvmovDqP6+6InoRu1JF1QdQTHpWOiiC8J2sKoiTqlhUWILnSmnOdJIjS
         gVPde2qQaHfvrsjph2DkhBupqYjB8kisvSKDDwhUIP802/ZgZc1e0gO/Tkpk0Chk/0
         v4jYfctrhE/DA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 074/104] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
Date:   Wed,  5 May 2021 12:33:43 -0400
Message-Id: <20210505163413.3461611-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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

