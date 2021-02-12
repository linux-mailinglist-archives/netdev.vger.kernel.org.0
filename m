Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8970F319E59
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 13:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBLMY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 07:24:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhBLMXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 07:23:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E2464E13;
        Fri, 12 Feb 2021 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613132593;
        bh=hcZRkQSjgnShWQZ1idUAkK6Rpsxk85/eOREJlPAgw9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=KBBPfYYPR2jxf/k+MfdxvacCYEV5z9Ds9nL5QZ6Mm7zqzGzflAdDqZ4bZD/L7ioCF
         7bgFKHQXQqkWEdOme840w8fH1mkVN8oZzCpViPs9PH+y5QFb59PQmrBnAMheGRVwmu
         BlJVSrtGfHNoQQmXhTsz5x6EsJ7r0rW0bo4+5XjWkP7KXrFWz5ORch09+a7up3ALVI
         yR2d03SA0boHzMgPvImJ7rDHIzF9zJB1CKNa92ypU6tR8A36ihC/YYW2khEtVK/5VS
         zJlg7Dmf2UQdk1If9G5zcVznxKYOZon5zY/MmQhjTnBy0iF/VPw2/gu0cyagIgkciT
         Cr7J6100nlHaA==
Date:   Fri, 12 Feb 2021 06:23:10 -0600
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
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] octeontx2-pf: Fix out-of-bounds read in
 otx2_get_fecparam()
Message-ID: <20210212122310.GA262609@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code at line 967 implies that rsp->fwdata.supported_fec may be up to 4:

 967: if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX)

If rsp->fwdata.supported_fec evaluates to 4, then there is an
out-of-bounds read at line 971 because fec is an array with
a maximum of 4 elements:

 954         const int fec[] = {
 955                 ETHTOOL_FEC_OFF,
 956                 ETHTOOL_FEC_BASER,
 957                 ETHTOOL_FEC_RS,
 958                 ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
 959 #define FEC_MAX_INDEX 4

 971: fecparam->fec = fec[rsp->fwdata.supported_fec];

Fix this by properly indexing fec[] with rsp->fwdata.supported_fec - 1.
In this case the proper indexes 0 to 3 are used when
rsp->fwdata.supported_fec evaluates to a range of 1 to 4, correspondingly.

Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Addresses-Coverity-ID: 1501722 ("Out-of-bounds read")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 237e5d3321d4..f7e8ada32a26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -968,7 +968,7 @@ static int otx2_get_fecparam(struct net_device *netdev,
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else
-			fecparam->fec = fec[rsp->fwdata.supported_fec];
+			fecparam->fec = fec[rsp->fwdata.supported_fec - 1];
 	}
 	return 0;
 }
-- 
2.27.0

