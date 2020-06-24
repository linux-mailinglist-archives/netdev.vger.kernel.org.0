Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBB8207F24
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390162AbgFXWJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:09:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387718AbgFXWJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:09:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F20DFB02E;
        Wed, 24 Jun 2020 22:09:08 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E2C5460460; Thu, 25 Jun 2020 00:09:08 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix error handling in linkstate_prepare_data()
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>
Message-Id: <20200624220908.E2C5460460@lion.mk-sys.cz>
Date:   Thu, 25 Jun 2020 00:09:08 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When getting SQI or maximum SQI value fails in linkstate_prepare_data(), we
must not return without calling ethnl_ops_complete(dev) as that could
result in imbalance between ethtool_ops ->begin() and ->complete() calls.

Fixes: 806602191592 ("ethtool: provide UAPI for PHY Signal Quality Index (SQI)")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/linkstate.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 7f47ba89054e..afe5ac8a0f00 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -78,19 +78,18 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 
 	ret = linkstate_get_sqi(dev);
 	if (ret < 0 && ret != -EOPNOTSUPP)
-		return ret;
-
+		goto out;
 	data->sqi = ret;
 
 	ret = linkstate_get_sqi_max(dev);
 	if (ret < 0 && ret != -EOPNOTSUPP)
-		return ret;
-
+		goto out;
 	data->sqi_max = ret;
 
+	ret = 0;
+out:
 	ethnl_ops_complete(dev);
-
-	return 0;
+	return ret;
 }
 
 static int linkstate_reply_size(const struct ethnl_req_info *req_base,
-- 
2.27.0

