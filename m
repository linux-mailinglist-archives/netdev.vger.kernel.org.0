Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E861A5524
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgDKXJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgDKXJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FAE21835;
        Sat, 11 Apr 2020 23:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646572;
        bh=6+bWPDXJPSzVT3DAvVk4z5aXpF04J4dNJSc3XKD31JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gq6feiTuuNwxyoBfXw4UcODxHDys6Z/1r3JiQGhhqGjrA6PqWJMwhNSUCLEpeu1Y7
         B+odTA0TqiSY1BDrmG5gyZtfYUVQuOuS6iS5n7qxgDlOjtAYc5Ln5ioEHIg6zq1lAw
         Dzh+pY9bXRygOgBgTqbW7qrTuoIIF5PnCPt9jAKo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 119/121] svcrdma: Fix leak of transport addresses
Date:   Sat, 11 Apr 2020 19:07:04 -0400
Message-Id: <20200411230706.23855-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1a33d8a284b1e85e03b8c7b1ea8fb985fccd1d71 ]

Kernel memory leak detected:

unreferenced object 0xffff888849cdf480 (size 8):
  comm "kworker/u8:3", pid 2086, jiffies 4297898756 (age 4269.856s)
  hex dump (first 8 bytes):
    30 00 cd 49 88 88 ff ff                          0..I....
  backtrace:
    [<00000000acfc370b>] __kmalloc_track_caller+0x137/0x183
    [<00000000a2724354>] kstrdup+0x2b/0x43
    [<0000000082964f84>] xprt_rdma_format_addresses+0x114/0x17d [rpcrdma]
    [<00000000dfa6ed00>] xprt_setup_rdma_bc+0xc0/0x10c [rpcrdma]
    [<0000000073051a83>] xprt_create_transport+0x3f/0x1a0 [sunrpc]
    [<0000000053531a8e>] rpc_create+0x118/0x1cd [sunrpc]
    [<000000003a51b5f8>] setup_callback_client+0x1a5/0x27d [nfsd]
    [<000000001bd410af>] nfsd4_process_cb_update.isra.7+0x16c/0x1ac [nfsd]
    [<000000007f4bbd56>] nfsd4_run_cb_work+0x4c/0xbd [nfsd]
    [<0000000055c5586b>] process_one_work+0x1b2/0x2fe
    [<00000000b1e3e8ef>] worker_thread+0x1a6/0x25a
    [<000000005205fb78>] kthread+0xf6/0xfb
    [<000000006d2dc057>] ret_from_fork+0x3a/0x50

Introduce a call to xprt_rdma_free_addresses() similar to the way
that the TCP backchannel releases a transport's peer address
strings.

Fixes: 5d252f90a800 ("svcrdma: Add class for RDMA backwards direction transport")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 908e78bb87c64..c4fb930779a92 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -250,6 +250,7 @@ xprt_rdma_bc_put(struct rpc_xprt *xprt)
 {
 	dprintk("svcrdma: %s: xprt %p\n", __func__, xprt);
 
+	xprt_rdma_free_addresses(xprt);
 	xprt_free(xprt);
 }
 
-- 
2.20.1

