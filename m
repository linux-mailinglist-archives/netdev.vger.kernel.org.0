Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE85767A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfF0AjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbfF0AjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:39:22 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5515921855;
        Thu, 27 Jun 2019 00:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595961;
        bh=yso73BmTMDqJZ5UXPhwZnb/Q5o9FgmQEh5o4fbZC4Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUtqSXaYK/qCpJL1iq8CEqMs9KrHvm97Uc3baz2Xcg3kIgagbcF4M6dIN994Xc+w/
         S2WMT9F0Uf0iGKPFpTlYAv6IEsrdlbMHW0qyJF4lriEsFcGZGfEW93TRSentCRGSNF
         uNxGt4sCuoJ5y3Rxxj5q2EVALTPoQ8IPHe47K5HU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Yi <teroincn@163.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 60/60] net :sunrpc :clnt :Fix xps refcount imbalance on the error path
Date:   Wed, 26 Jun 2019 20:36:15 -0400
Message-Id: <20190627003616.20767-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Yi <teroincn@163.com>

[ Upstream commit b96226148491505318228ac52624956bd98f9e0c ]

rpc_clnt_add_xprt take a reference to struct rpc_xprt_switch, but forget
to release it before return, may lead to a memory leak.

Signed-off-by: Lin Yi <teroincn@163.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 1fc812ba9871..d568076cd573 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2714,6 +2714,7 @@ int rpc_clnt_add_xprt(struct rpc_clnt *clnt,
 	xprt = xprt_iter_xprt(&clnt->cl_xpi);
 	if (xps == NULL || xprt == NULL) {
 		rcu_read_unlock();
+		xprt_switch_put(xps);
 		return -EAGAIN;
 	}
 	resvport = xprt->resvport;
-- 
2.20.1

