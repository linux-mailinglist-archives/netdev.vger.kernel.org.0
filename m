Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1727519A209
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 00:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgCaWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 18:44:26 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:39759 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbgCaWo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 18:44:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585694665; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=6PyO/V46ozkSCZoOi/+d24kO4jXebE7KSXxe4djHrrs=; b=a2PmdiNMWXdSBCnbT/decXLfMVF2oiva/2K7fyjD+ihDjZJOSSGP1F2HttZnUpyE2k5N/neT
 wWLtvl3+dis8jOQAv7U34jlCuWs5jKQgxXtIJdoCBgSVjlwIBFMD2bOGfjFANCGfJ5lTPZLn
 qVbLRZGcyxGxqt6r5bAMMwPKUf4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e83c7c4.7f444aaf55a8-smtp-out-n01;
 Tue, 31 Mar 2020 22:44:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4495CC433BA; Tue, 31 Mar 2020 22:44:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA632C433F2;
        Tue, 31 Mar 2020 22:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CA632C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     ap420073@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Alex Elder <elder@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] net: qualcomm: rmnet: Allow configuration updates to existing devices
Date:   Tue, 31 Mar 2020 16:43:48 -0600
Message-Id: <20200331224348.12539-1-subashab@codeaurora.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows the changelink operation to succeed if the mux_id was
specified as an argument. Note that the mux_id must match the
existing mux_id of the rmnet device or should be an unused mux_id.

Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
Reported-by: Alex Elder <elder@linaro.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fbf4cbcf1a65..06332984399d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -294,19 +294,24 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-		if (rmnet_get_endpoint(port, mux_id)) {
-			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
-			return -EINVAL;
-		}
 		ep = rmnet_get_endpoint(port, priv->mux_id);
 		if (!ep)
 			return -ENODEV;
 
-		hlist_del_init_rcu(&ep->hlnode);
-		hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
+		if (mux_id != priv->mux_id) {
+			if (rmnet_get_endpoint(port, mux_id)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "MUX ID already exists");
+				return -EINVAL;
+			}
 
-		ep->mux_id = mux_id;
-		priv->mux_id = mux_id;
+			hlist_del_init_rcu(&ep->hlnode);
+			hlist_add_head_rcu(&ep->hlnode,
+					   &port->muxed_ep[mux_id]);
+
+			ep->mux_id = mux_id;
+			priv->mux_id = mux_id;
+		}
 	}
 
 	if (data[IFLA_RMNET_FLAGS]) {
-- 
2.26.0
