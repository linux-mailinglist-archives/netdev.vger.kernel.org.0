Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059031A412
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhBLRwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhBLRwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 12:52:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680CB64E9A;
        Fri, 12 Feb 2021 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613152319;
        bh=wGwQsAwZ1k9v0j7Vwt7Ai/MM+Mhs0Gb0UbBLuunFHmw=;
        h=Date:From:To:Cc:Subject:From;
        b=gH3Zai2URZXYsRqakW4Y6fB3mT8S9CSi+XFeBAkURA00RCfGQEpFg88m8R8ljt7Ex
         C8/Z92H9PyaLBwwPV3aRoxPc3CCLSyZhkZuBUTv10A17bJ/TOwbHxE6TZQh9BvNWph
         zapAvuyCO6JlcTjR94A875uR+fyLSlGdM9KzGj/osi3naJtS/VnEIrB5fB5Uyu7ZtI
         wonhMCVAlG9q3e3yn/PDReZZpnCiCAZDvBfraAm7qpr9ps9h+K+YK8DS4BkKxw8G75
         XKW+DB36xbFWzANrFJtGlWcT/m1JLzDkYf8rr+3FwvTnDzAVJCa83e/bMUuQpdjwcL
         pdJlGbkH5cppg==
Date:   Fri, 12 Feb 2021 11:51:56 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] i40e: Fix incorrect argument in call to ipv6_addr_any()
Message-ID: <20210212175156.GA277354@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the right argument to be passed is &tcp_ip6_spec->ip6dst,
not &tcp_ip6_spec->ip6src, when calling function ipv6_addr_any().

Addresses-Coverity-ID: 1501734 ("Copy-paste error")
Fixes: efca91e89b67 ("i40e: Add flow director support for IPv6")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 8a4dd77a12da..a8a2b5f683a2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4250,7 +4250,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 				    (struct in6_addr *)&ipv6_full_mask))
 			new_mask |= I40E_L3_V6_DST_MASK;
 		else if (ipv6_addr_any((struct in6_addr *)
-				       &tcp_ip6_spec->ip6src))
+				       &tcp_ip6_spec->ip6dst))
 			new_mask &= ~I40E_L3_V6_DST_MASK;
 		else
 			return -EOPNOTSUPP;
-- 
2.27.0

