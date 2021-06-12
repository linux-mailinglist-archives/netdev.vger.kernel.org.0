Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C808F3A4C5C
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 05:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFLDNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 23:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhFLDNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 23:13:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD93610A2;
        Sat, 12 Jun 2021 03:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623467499;
        bh=p1LJsQX+DiQBbKyjzXJRcMhWbk4bwLC52xQG8irBJro=;
        h=From:To:Cc:Subject:Date:From;
        b=BKuHVk9Iys2INfAFEkahikbVQsNf1yF/PbUpE9JsewW8XB9PVvsT90nCmy9/e6rqH
         OaD4J5YWmvu1riZpT8Io5ZpV/8sJaD3+iY34qkhcKuPG9e8Di99r/MWvTV9bHUHhsR
         8j22Fqba/gfvoBdnGsE5Dsk5CsJ+1W/xYAlbZaY0LtErRmKPXZFXIt+T62m7v4lrNN
         t3Vtwf2zrijVZj4/K1bjM682qCgDuSLUgwUsJaP3HhbtSOdSM7Vm9ozG5NxTNvayn6
         7mfUqrlRcQI8moo2PrPBCg64WclNyDY/xGY22hpCAWeyNOKq0iiF4JdSeStiYuEXu7
         VxoChVR0t3e2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next] ethtool: add a stricter length check
Date:   Fri, 11 Jun 2021 20:11:35 -0700
Message-Id: <20210612031135.225292-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Michal, WDYT?

 net/ethtool/netlink.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 88d8a0243f35..3f9a1a96b4df 100644
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
+	WARN(rskb->len - hdr_len > reply_len,
+	     "ethnl cmd %d: calculated reply length %d, but consumed %d\n",
+	     cmd, reply_len, rskb->len - hdr_len);
 	if (ops->cleanup_data)
 		ops->cleanup_data(reply_data);
 
-- 
2.31.1

