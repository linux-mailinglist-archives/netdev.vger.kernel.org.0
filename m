Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C895031A119
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBLPHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhBLPHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 10:07:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4033864E57;
        Fri, 12 Feb 2021 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613142382;
        bh=+58RbCPiJB8EXWGJM6hswdH+l8A8JJomt4JiGJkJpwI=;
        h=Date:From:To:Cc:Subject:From;
        b=t+1GckfJb1v1HFUpMTZXqEas7UNTkv2yktCxnKt6sI1GFQ+83oQafQq92spELRx78
         esbPcncVQ8FteWFJw+M8hPWqqjoA9Xmf6TOSdvxyxIH+IB2gn/2xRX0QS4DLyIUSsJ
         oo2raWUbpWqnALDEbsYOAfg2UZ4hmJdcJkt0H+7oeu73RrHKxFp0ADs4z9ua808UXO
         SDaxGO+cOT0fOEOaYUFHdGRYZBnGyPKThrpT6dGzqQpVvVzpJt/xD0EmEwHW+Hj8NX
         0PTAMB1rL1W2+Rb6ZxYH5ywxaDeTbioMlOE90jcpXsL0ppJ6RerYXGlKeL8cS23xrL
         AnhcVcZEf6rfQ==
Date:   Fri, 12 Feb 2021 09:06:19 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Christina Jacob <cjacob@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2][next] octeontx2-pf: Fix out-of-bounds read warning in
 otx2_get_fecparam()
Message-ID: <20210212150619.GA269482@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Line at 967 implies that rsp->fwdata.supported_fec may be up to 4:

if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX)

which would cause an out-of-bounds read at line 971:

fecparam->fec = fec[rsp->fwdata.supported_fec];

However, the range of values for rsp->fwdata.supported_fec is
0 to 3. Fix the if condition at line 967, accordingly.

Link: https://lore.kernel.org/lkml/MWHPR18MB142173B5F0541ABD3D59860CDE8B9@MWHPR18MB1421.namprd18.prod.outlook.com/
Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Addresses-Coverity-ID: 1501722 ("Out-of-bounds read")
Suggested-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Fix if condition.

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 237e5d3321d4..f4962a97a075 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -964,7 +964,7 @@ static int otx2_get_fecparam(struct net_device *netdev,
 	if (IS_ERR(rsp))
 		return PTR_ERR(rsp);
 
-	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
+	if (rsp->fwdata.supported_fec < FEC_MAX_INDEX) {
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else
-- 
2.27.0

