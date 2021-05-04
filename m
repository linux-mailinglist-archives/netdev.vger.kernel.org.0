Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF637328D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhEDWxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:53:51 -0400
Received: from mx1.riseup.net ([198.252.153.129]:53100 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhEDWxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 18:53:51 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 18:53:51 EDT
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4FZZjw6bvKzDqXR;
        Tue,  4 May 2021 15:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1620168468; bh=6fTFojAa4HVkSQ5AdVgmmxqw+19KDtFUOQKk+hPV7Yo=;
        h=From:To:Cc:Subject:Date:From;
        b=KvDpw1+a7RrwjIp9LcgpDZTJZsTFdN2CCQJmSt1pENOK5Qh4v98Xw8urSYXBLJKZv
         6S29oUFGJmDWhReY4vJIzQae+9U43hJ4DaCjnaLuGieGDY1LsS2bdiNoqWWyBcvEc0
         PtYJ9jLs3WU+l5jcXiVjQeTou5LRpVY6BMMKz08w=
X-Riseup-User-ID: 130C06CDEE2A4D9ABA04CF0AC935FDFD60D088EEFD3F6B07CA5E0174C656AF32
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4FZZjv4xTxz5vNL;
        Tue,  4 May 2021 15:47:47 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netdev@vger.kernel.org, mkubecek@suse.cz, atenart@kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH net] ethtool: fix missing NLM_F_MULTI flag when dumping
Date:   Wed,  5 May 2021 00:47:14 +0200
Message-Id: <20210504224714.7632-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dumping the ethtool information from all the interfaces, the
netlink reply should contain the NLM_F_MULTI flag. This flag allows
userspace tools to identify that multiple messages are expected.

Link: https://bugzilla.redhat.com/1953847
Fixes: 365f9ae ("ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/ethtool/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 290012d0d11d..88d8a0243f35 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -387,7 +387,8 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	int ret;
 
 	ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			   &ethtool_genl_family, 0, ctx->ops->reply_cmd);
+			   &ethtool_genl_family, NLM_F_MULTI,
+			   ctx->ops->reply_cmd);
 	if (!ehdr)
 		return -EMSGSIZE;
 
-- 
2.20.1

