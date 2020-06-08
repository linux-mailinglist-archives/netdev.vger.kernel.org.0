Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9006C1F2CD5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgFHXQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbgFHXQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CF020775;
        Mon,  8 Jun 2020 23:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658187;
        bh=U0mGWfLnsVmloTJ83K1kKc/LB2uPVbUSQIKW8pBlkuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipih5X8B6VFwOS2PDe1WQ5hRJTc73YRUzcqlYKSyuXabHaRetSMxUj6swL7dnlGrZ
         TMi5UiidDrTb/jDw+N5ATMUHuCRgXrSkGISyU4LegiPqiS0ZS2GXX6yH6gtB/28rgf
         X9O5M+FV319EMC3eL8ZKfPrEYqV6kqWV3RHmmZQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 209/606] ethtool: count header size in reply size estimate
Date:   Mon,  8 Jun 2020 19:05:34 -0400
Message-Id: <20200608231211.3363633-209-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit 7c87e32d2e380228ada79d20ac5b7674718ef097 ]

As ethnl_request_ops::reply_size handlers do not include common header
size into calculated/estimated reply size, it needs to be added in
ethnl_default_doit() and ethnl_default_notify() before allocating the
message. On the other hand, strset_reply_size() should not add common
header size.

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/netlink.c | 4 ++--
 net/ethtool/strset.c  | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index fc9e0b806889..d863dffbe53c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -334,7 +334,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
 				ops->hdr_attr, info, &reply_payload);
@@ -573,7 +573,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	skb = genlmsg_new(reply_len, GFP_KERNEL);
 	if (!skb)
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 8e5911887b4c..fb7b3585458d 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -309,7 +309,6 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 	int len = 0;
 	int ret;
 
-	len += ethnl_reply_header_size();
 	for (i = 0; i < ETH_SS_COUNT; i++) {
 		const struct strset_info *set_info = &data->sets[i];
 
-- 
2.25.1

