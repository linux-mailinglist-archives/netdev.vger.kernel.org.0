Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC020B09
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfEPPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:23:21 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56634 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfEPPXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 11:23:20 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hRIDy-0001aO-L8 from George_Davis@mentor.com ; Thu, 16 May 2019 08:23:14 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Thu, 16 May
 2019 08:23:12 -0700
From:   "George G. Davis" <george_davis@mentor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "George G. Davis" <george_davis@mentor.com>
Subject: [PATCH] net: sysctl: cleanup net_sysctl_init error exit paths
Date:   Thu, 16 May 2019 11:23:08 -0400
Message-ID: <1558020189-16843-1-git-send-email-george_davis@mentor.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unwind net_sysctl_init error exit goto spaghetti code

Suggested-by: Joshua Frkuska <joshua_frkuska@mentor.com>
Signed-off-by: George G. Davis <george_davis@mentor.com>
---
 net/sysctl_net.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 9aed6fe1bf1a..7710a2d7f79a 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -104,14 +104,12 @@ __init int net_sysctl_init(void)
 	if (!net_header)
 		goto out;
 	ret = register_pernet_subsys(&sysctl_pernet_ops);
-	if (ret)
-		goto out1;
-out:
-	return ret;
-out1:
+	if (!ret)
+		goto out;
 	unregister_sysctl_table(net_header);
 	net_header = NULL;
-	goto out;
+out:
+	return ret;
 }
 
 struct ctl_table_header *register_net_sysctl(struct net *net,
-- 
2.7.4

