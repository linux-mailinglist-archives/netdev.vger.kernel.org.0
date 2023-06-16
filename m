Return-Path: <netdev+bounces-11349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22448732B18
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BCB91C20F81
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF14D520;
	Fri, 16 Jun 2023 09:08:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C16F9F5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B15C433C0;
	Fri, 16 Jun 2023 09:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686906530;
	bh=6H2J61C/zhonIL9tyV87l0liBvz4B9aaRzMD1YpvQE4=;
	h=From:To:Cc:Subject:Date:From;
	b=XkA67CHY1l+/tBfiCQacrRszQ1FP6oXVHm5ALNsIXr8juvZASfoEOzpZltWLv1qVa
	 MAgvEtQkesLYwgMy/4gDfqYvp/gcie/gDWHkSvfm1w+86ecyiiEpt/kFLplu1vTlv7
	 5x4oie6b2M3sir6hIzR18fRZrFrJMOWJ7ZAK8/hlg+zE11g/JzOHOBQj3JrWzhMaVJ
	 qFh2Jl7MHO7Sa8BUiK4mdKIIhBesmn890oA0PSesNnWPeQ68ncgqt2lAx+hPxEikZj
	 q3e3hZzQhtfeW/ux3bsO5cYPL/5oLX5mcqHt1bt5V3hQY3h8zkkvcB8h1JgtMwR5Ol
	 9CmN1N/q/O6+A==
From: Arnd Bergmann <arnd@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] sfc: fix uninitialized variable use
Date: Fri, 16 Jun 2023 11:08:18 +0200
Message-Id: <20230616090844.2677815-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The new efx_bind_neigh() function contains a broken code path when IPV6 is
disabled:

drivers/net/ethernet/sfc/tc_encap_actions.c:144:7: error: variable 'n' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
                if (encap->type & EFX_ENCAP_FLAG_IPV6) {
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/tc_encap_actions.c:184:8: note: uninitialized use occurs here
                if (!n) {
                     ^
drivers/net/ethernet/sfc/tc_encap_actions.c:144:3: note: remove the 'if' if its condition is always false
                if (encap->type & EFX_ENCAP_FLAG_IPV6) {
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/tc_encap_actions.c:141:22: note: initialize the variable 'n' to silence this warning
                struct neighbour *n;
                                   ^
                                    = NULL

Change it to use the existing error handling path here.

Fixes: 7e5e7d800011a ("sfc: neighbour lookup for TC encap action offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/sfc/tc_encap_actions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
index aac259528e73e..cfd76d5bbdd48 100644
--- a/drivers/net/ethernet/sfc/tc_encap_actions.c
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
@@ -163,6 +163,7 @@ static int efx_bind_neigh(struct efx_nic *efx,
 			 * enabled how did someone create an IPv6 tunnel_key?
 			 */
 			rc = -EOPNOTSUPP;
+			n = NULL;
 			NL_SET_ERR_MSG_MOD(extack, "No IPv6 support (neigh bind)");
 #endif
 		} else {
-- 
2.39.2


