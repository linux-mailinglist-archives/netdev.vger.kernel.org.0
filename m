Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D87D3A8F6A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 05:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFPDfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 23:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFPDft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 23:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 277016024A;
        Wed, 16 Jun 2021 03:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623814424;
        bh=KbATIrDDRnnH6wHokxAEGf6Fqe6RvljtDg9WdfVQk5c=;
        h=From:To:Cc:Subject:Date:From;
        b=ApLBSihNss8bud+yeNfHYcw+kxEswIm9lxsJlnfBk0hslrMfUYcF6ZIK4WaLsOGPP
         b2Xir85gR5tb9QE8qek7Lybavw+EtHKJBCa8/Ke0fpQa4zYB4C8Vy6GoqqL3kn6Q14
         buRNBfJ5G/zYiDloH96w5KLckZVzs09/4ssJsKRxsLJvepbyN/dUnJQy5hunCVDz4k
         k/V9Ui+XpIctLHIy8vB1DdvXi6gHFUX28l4VTYmA6tG1yzyNtX7Na68i8aatow08y3
         9Vc6M2MyL9YWmEf9zEBfcC7vWG22yaOBzniMy4s4JeFXhOWZYp2aeX8hpnOVJtTlZ0
         x55SbeNZqTm+A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethtool: add a stricter length check
Date:   Tue, 15 Jun 2021 20:33:38 -0700
Message-Id: <20210616033338.616576-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been a few errors in the ethtool reply size calculations,
most of those are hard to trigger during basic testing because of
skb size rounding up and netdev names being shorter than max.
Add a more precise check.

This change will affect the value of payload length displayed in
case of -EMSGSIZE but that should be okay, "payload length" isn't
a well defined term here.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 88d8a0243f35..a7346346114f 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -315,9 +315,9 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	struct ethnl_req_info *req_info = NULL;
 	const u8 cmd = info->genlhdr->cmd;
 	const struct ethnl_request_ops *ops;
+	int hdr_len, reply_len;
 	struct sk_buff *rskb;
 	void *reply_payload;
-	int reply_len;
 	int ret;
 
 	ops = ethnl_default_requests[cmd];
@@ -346,15 +346,20 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret + ethnl_reply_header_size();
+	reply_len = ret;
 	ret = -ENOMEM;
-	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
+	rskb = ethnl_reply_init(reply_len + ethnl_reply_header_size(),
+				req_info->dev, ops->reply_cmd,
 				ops->hdr_attr, info, &reply_payload);
 	if (!rskb)
 		goto err_cleanup;
+	hdr_len = rskb->len;
 	ret = ops->fill_reply(rskb, req_info, reply_data);
 	if (ret < 0)
 		goto err_msg;
+	WARN_ONCE(rskb->len - hdr_len > reply_len,
+		  "ethnl cmd %d: calculated reply length %d, but consumed %d\n",
+		  cmd, reply_len, rskb->len - hdr_len);
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
 
-- 
2.31.1

