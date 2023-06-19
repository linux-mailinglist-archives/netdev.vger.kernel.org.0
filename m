Return-Path: <netdev+bounces-11865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A05BB734F44
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0FA91C20757
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAEF1BE5E;
	Mon, 19 Jun 2023 09:12:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4FFBE5A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D1EC433C8;
	Mon, 19 Jun 2023 09:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687165952;
	bh=C9Nk9/QP6OPS4jxNq9hz3jeu3Lte1JDyc4vSyqZJLlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI4Wja3flSrNux6FdpjGVJbrxdVm96gT6eM4VzNrbswJM0uodSDk5Ny98EBcrTPAX
	 M+nJCf9Y4F2zYmbmZMFjWR5Ux53L2VGT8pN+U65LD9Qbec8/wLQcrXn5BY2CtpVZ1/
	 7LRnas0WmzZJjvBIaOtxVE1XfMvucTnC1gxS56itWF8nnJr3YChTrmgs51sA45plAV
	 EWvlI3oOmInYXr1EEkHJWQCtgQmUQqb54Hs1UMr1olj96m/e613rbUH+fL+wnoO5Yp
	 81NdcYmSMl36difwuNyajHwFZEq0UZirKi1sjoCOJyePipnlFGL348WmynOogkR6nw
	 zZFlxlU4VoYbw==
From: Arnd Bergmann <arnd@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Simon Horman <simon.horman@corigine.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [v2] sfc: fix uninitialized variable use
Date: Mon, 19 Jun 2023 11:12:10 +0200
Message-Id: <20230619091215.2731541-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619091215.2731541-1-arnd@kernel.org>
References: <20230619091215.2731541-1-arnd@kernel.org>
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
Suggested-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use 'goto' instead of incorrectly entering another error path
---
 drivers/net/ethernet/sfc/tc_encap_actions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
index aac259528e73e..7e8bcdb222ad1 100644
--- a/drivers/net/ethernet/sfc/tc_encap_actions.c
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
@@ -164,6 +164,7 @@ static int efx_bind_neigh(struct efx_nic *efx,
 			 */
 			rc = -EOPNOTSUPP;
 			NL_SET_ERR_MSG_MOD(extack, "No IPv6 support (neigh bind)");
+			goto out_free;
 #endif
 		} else {
 			rt = ip_route_output_key(net, &flow4);
-- 
2.39.2


