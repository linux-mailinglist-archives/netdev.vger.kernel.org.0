Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2919B786
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 23:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbgDAVZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 17:25:21 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:40064 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732357AbgDAVZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 17:25:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585776320; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=qgHymjyPZ8Ec5ryLmaRSeax9BmrhEYDEn2yMgu+McXg=; b=IivWznKisEnKPZBJ96eW37YnBfWtf6RIjPscO/xIuD6wpLULyMSrU1JtfWQVAdlDVMy4TxgP
 FR3x9vpdgQCABxtHklPUePrcvai8e4eSd1sB110aQXfVstzguhLdsMHsImwZoD5rbUIE93y0
 AnHXfmZyBxKFwG3DwJFwAD8E1oc=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8506b6.7f095ab4d8f0-smtp-out-n04;
 Wed, 01 Apr 2020 21:25:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7930AC43637; Wed,  1 Apr 2020 21:25:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53D22C433F2;
        Wed,  1 Apr 2020 21:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53D22C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     elder@linaro.org, ap420073@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net v2] net: qualcomm: rmnet: Allow configuration updates to existing devices
Date:   Wed,  1 Apr 2020 15:23:55 -0600
Message-Id: <20200401212355.11643-1-subashab@codeaurora.org>
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
Reported-and-tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
v1->v2: Get the endpoint within the mux check as mentioned by Alex.
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 1305522f72d6..40efe60eff8d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -282,7 +282,6 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev;
-	struct rmnet_endpoint *ep;
 	struct rmnet_port *port;
 	u16 mux_id;
 
@@ -297,19 +296,27 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-		if (rmnet_get_endpoint(port, mux_id)) {
-			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
-			return -EINVAL;
-		}
-		ep = rmnet_get_endpoint(port, priv->mux_id);
-		if (!ep)
-			return -ENODEV;
 
-		hlist_del_init_rcu(&ep->hlnode);
-		hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
+		if (mux_id != priv->mux_id) {
+			struct rmnet_endpoint *ep;
+
+			ep = rmnet_get_endpoint(port, priv->mux_id);
+			if (!ep)
+				return -ENODEV;
 
-		ep->mux_id = mux_id;
-		priv->mux_id = mux_id;
+			if (rmnet_get_endpoint(port, mux_id)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "MUX ID already exists");
+				return -EINVAL;
+			}
+
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
