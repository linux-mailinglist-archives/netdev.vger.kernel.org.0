Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F70740F6F0
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 13:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbhIQL7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 07:59:16 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33546
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229680AbhIQL7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 07:59:11 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 229914017A;
        Fri, 17 Sep 2021 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631879868;
        bh=hR4B8r8uer+fz73h+7NGa/3G9CuLaPmiXvhN/2mcDKA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=bGjEZgpI0g3lIT+GTjeTqPHfM+bEWC5Hrg8hmsNtwM/BOXw2/g0sSovrmCHn/DIGq
         zkOSJDP6lPA5ilBPs1ueuftwNh6eDeaZ0sXtsuKR14VviHeEdVGTr/LzNa38dHP0Jg
         DLg8j99u34i54FFyyn3COika721xwy6Sy137jhxtuIooPJiHftFivggUKelxj9/Zqg
         SvHCsC27EATAwpO2k6LC9P6SI9KFrVQatXTIhMG7rCaX+VNS2TT114HR9hsLJPnd+x
         Z6qJJNs49/6+5FB5Vszcibjinsw95O6hhw6Ew65y9tZcgR0cPiytxZe9kf38TmF3eM
         BkJawhnXA4zzw==
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix uninitialized variable val
Date:   Fri, 17 Sep 2021 12:57:47 +0100
Message-Id: <20210917115747.47695-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where the condition !is_rvu_otx2(rvu) is false variable
val is not initialized and can contain a garbage value. Fix this by
initializing val to zero and bit-wise or'ing in BIT_ULL(51) to val
for the true condition case of !is_rvu_otx2(rvu).

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 4b5a3ab17c6c ("octeontx2-af: Hardware configuration for inline IPsec")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ea3e03fa55d4..29b15b544bdc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4596,9 +4596,10 @@ static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *r
 
 	cpt_idx = (blkaddr == BLKADDR_NIX0) ? 0 : 1;
 	if (req->enable) {
+		val = 0;
 		/* Enable context prefetching */
 		if (!is_rvu_otx2(rvu))
-			val = BIT_ULL(51);
+			val |= BIT_ULL(51);
 
 		/* Set OPCODE and EGRP */
 		val |= FIELD_PREP(IPSEC_GEN_CFG_EGRP, req->gen_cfg.egrp);
-- 
2.32.0

