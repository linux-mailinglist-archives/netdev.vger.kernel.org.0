Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DE53615B6
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhDOWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237552AbhDOWxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65080610FA;
        Thu, 15 Apr 2021 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527201;
        bh=h3JqAuovJa5qISADuaVsDMb+HQYlp1RC4S+FpkmkBqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eE8NvCD24h2Q3STxfhDPHYyq03+xjHUOvgsWzT/5fMGlmNqm8Qu7DFsvzaOzVVu7N
         HiOtii3zxvhZcgMHGd3tVRptzxiG/KW/KeiqXArHf8KQCRkqlaxG3ZyHw9pqSAwPJH
         BqQdbrVGyW1sCRBK3XaMPolcVS1bzllyEjUgHe/sX+1T0Pjg6m0usE9PF2qfvdRnr7
         Ojp72U3jpY4eugsr6GkZthHgjLoxXb/qlBQxvm8l8HqNbSTkWLG3kUP4dgGeUwuQa8
         vjU4HVSsO2m3peYDWDTHwXxT8MVQySRepOTeKrmAgnPSZQgVqOs+rOOxzUngUTXzUz
         YSkoKXKPAmo8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/6] ethtool: fec_prepare_data() - jump to error handling
Date:   Thu, 15 Apr 2021 15:53:14 -0700
Message-Id: <20210415225318.2726095-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
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

