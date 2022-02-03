Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C64A8E11
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355148AbiBCUfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352611AbiBCUde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5692C06174E;
        Thu,  3 Feb 2022 12:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D0361ACF;
        Thu,  3 Feb 2022 20:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63B9C340E8;
        Thu,  3 Feb 2022 20:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920384;
        bh=gGkLfyr40uJZuMOzHhJ5bCp3liAMaPtfJXeg3XdSmYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbaF1adnFc+miLSnZCqZLRSjempgAWne6VimYbPmCCcDFBkA439R51AB+pfdWZp5W
         Td0LluLIRIyonX77Q015Ycj5sKQOeDUiCmi/cBKPLXD7x+d4+nxr7oIzMikjM61qE4
         MSr8CCvT7CC2hv4wI2DmQJLrZaTOPTu0rZg+b2PQ0hm85HRX2A9sCoCiTAwRq8DS3i
         BT9+g6IzWwuGWa0uOL3bILy/a2ILVHsENZQovFPmqaUTRz55tOn7E4Sgz/CP7UYFns
         xug5FPs8M9e57rAOoi3RT8tfd6DvXfbnQd3gI8Zkcowy3SVi9tpAFO6Ae4UH9ceFSe
         NIkjk6c5Mh9GA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/41] SUNRPC allow for unspecified transport time in rpc_clnt_add_xprt
Date:   Thu,  3 Feb 2022 15:32:15 -0500
Message-Id: <20220203203245.3007-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit b8a09619a56334414cbd7f935a0796240d0cc07e ]

If the supplied argument doesn't specify the transport type, use the
type of the existing rpc clnt and its existing transport.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f056ff9314442..5da1d7e8468a5 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2903,7 +2903,7 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	unsigned long connect_timeout;
 	unsigned long reconnect_timeout;
 	unsigned char resvport, reuseport;
-	int ret = 0;
+	int ret = 0, ident;
 
 	rcu_read_lock();
 	xps = xprt_switch_get(rcu_dereference(clnt->cl_xpi.xpi_xpswitch));
@@ -2917,8 +2917,11 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	reuseport = xprt->reuseport;
 	connect_timeout = xprt->connect_timeout;
 	reconnect_timeout = xprt->max_reconnect_timeout;
+	ident = xprt->xprt_class->ident;
 	rcu_read_unlock();
 
+	if (!xprtargs->ident)
+		xprtargs->ident = ident;
 	xprt = xprt_create_transport(xprtargs);
 	if (IS_ERR(xprt)) {
 		ret = PTR_ERR(xprt);
-- 
2.34.1

