Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F9735EB88
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347029AbhDNDp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346944AbhDNDpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71F161222;
        Wed, 14 Apr 2021 03:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371903;
        bh=h3JqAuovJa5qISADuaVsDMb+HQYlp1RC4S+FpkmkBqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYTXqIqsOnHC3+bhWbAxMnSH1CWv7eFVFp+vn7Cv/Tho/8P9VUZ+e9xB/a1ukeS40
         yfKYPD8SNwEj1lushVhnNCFHqGWaOr97pTJzEw13Dn47oWDdDwkZho87cnFCm+oK3o
         +k0YJfSszRtg82wJc+3sSJsFgQxlT+yy3++Ni1SesV7OclCXIW4dNEwMdsxfU2VaGi
         wtV/QgYAEKOSNAXGhmXObRIjeSQ8eNf2QumiFz1C34ZZBYQyQCcCvO/Q9oc9LOAJet
         XLOWSIEyCyEyfZEtgeYPlqOklIIKkhP0p6JRTMeZFCfUkkvobTd4JgBrEDIU/we+f2
         NH71NE5UkQ1ww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] ethtool: fec_prepare_data() - jump to error handling
Date:   Tue, 13 Apr 2021 20:44:50 -0700
Message-Id: <20210414034454.1970967-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414034454.1970967-1-kuba@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor fec_prepare_data() a little bit to skip the body
of the function and exit on error. Currently the code
depends on the fact that we only have one call which
may fail between ethnl_ops_begin() and ethnl_ops_complete()
and simply saves the error code. This will get hairy with
the stats also being queried.

No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/fec.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
index 31454b9188bd..3e7d091ee7aa 100644
--- a/net/ethtool/fec.c
+++ b/net/ethtool/fec.c
@@ -80,9 +80,8 @@ static int fec_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 	ret = dev->ethtool_ops->get_fecparam(dev, &fec);
-	ethnl_ops_complete(dev);
 	if (ret)
-		return ret;
+		goto out_complete;
 
 	WARN_ON_ONCE(fec.reserved);
 
@@ -98,7 +97,9 @@ static int fec_prepare_data(const struct ethnl_req_info *req_base,
 	if (data->active_fec == __ETHTOOL_LINK_MODE_MASK_NBITS)
 		data->active_fec = 0;
 
-	return 0;
+out_complete:
+	ethnl_ops_complete(dev);
+	return ret;
 }
 
 static int fec_reply_size(const struct ethnl_req_info *req_base,
-- 
2.30.2

