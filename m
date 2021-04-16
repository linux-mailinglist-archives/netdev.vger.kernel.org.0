Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D64362866
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbhDPTM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235122AbhDPTMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABDD9611AF;
        Fri, 16 Apr 2021 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618600344;
        bh=Rv2GvndnTmtUHMieNY3HvaWYmPwe9OWiXSUMXa7ltaY=;
        h=Date:From:To:Cc:Subject:From;
        b=psiL2cihVJWqJ4zI5xobZjykYKFmtbnwtlrYmaHfG8/g4dldrS/LkmyLKKU2dfQGM
         6KoAD9m8etWHXBpXX1LPFVxX5lVGCtrovBRqt9UhYbyRydVvoKrxjtQvmm0NoYY+wm
         I5O/E/2k7mZN258GuHAmNBpmWUTOh/kQhzfqoJmfOP8IShhGB1hDBcaWJka3aVyAox
         +ChlnOQVPN5cjCMhxPKfJ43y2xY4pqaf1a58pHlgKGTM7c8cyyZC+35PxCUzNozLoA
         iv9BppMsqbKmvtgZBqbQZmB618iwMIWgBvLCFCNcVf8ElsonHwYwxt9un33zmmHNs9
         b2jR1Gf+2yP7A==
Date:   Fri, 16 Apr 2021 14:12:36 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] sctp: Fix out-of-bounds warning in
 sctp_process_asconf_param()
Message-ID: <20210416191236.GA589296@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning:

net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 54e6a708d06e..5f9a7c028274 100644
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
2.27.0

