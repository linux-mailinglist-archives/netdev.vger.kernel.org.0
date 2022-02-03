Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257F84A8E21
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355033AbiBCUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:34:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35846 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354361AbiBCUdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:33:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 331F4B835A3;
        Thu,  3 Feb 2022 20:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96361C340F0;
        Thu,  3 Feb 2022 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920386;
        bh=+NBcL0Eq3UCVybOvYfablR+3wu7sDTLFohP96udNTEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogfveCHm+8DuSQegcbzCAO0Hn5W0MvnoKnaG7vZuMjLpMEs9f780tZE6DfmdZeqqQ
         iLE6fm5fx3PB6ur4xbxuw/cKlaeZ937MlEeqiQ3QnedjAK36JVLg88t9iVKSsDrEaY
         OcIWoBFL5egAThnW9BXoAunW2BDLaiEZsOROIb7jL/CZo5d7dAtb1hoMaR6xM0ypfC
         49pU2AU7RLBRJKmptUopfHlg4Yz5DWsk4p/HXIn6/cyZQsJF2l5tQi/Y+rVP9SM6IR
         VYRsqVlMwMCasqATYuIkbj7ju49IY74ZoIzZpgz70KIvaFmxLPWgvudn+d59qJVNOq
         1TK7ZYaK7myPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/41] net/sunrpc: fix reference count leaks in rpc_sysfs_xprt_state_change
Date:   Thu,  3 Feb 2022 15:32:16 -0500
Message-Id: <20220203203245.3007-12-sashal@kernel.org>
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

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 776d794f28c95051bc70405a7b1fa40115658a18 ]

The refcount leak issues take place in an error handling path. When the
3rd argument buf doesn't match with "offline", "online" or "remove", the
function simply returns -EINVAL and forgets to decrease the reference
count of a rpc_xprt object and a rpc_xprt_switch object increased by
rpc_sysfs_xprt_kobj_get_xprt() and
rpc_sysfs_xprt_kobj_get_xprt_switch(), causing reference count leaks of
both unused objects.

Fix this issue by jumping to the error handling path labelled with
out_put when buf matches none of "offline", "online" or "remove".

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 9a6f17e18f73b..379cf0e4d965b 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -291,8 +291,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		online = 1;
 	else if (!strncmp(buf, "remove", 6))
 		remove = 1;
-	else
-		return -EINVAL;
+	else {
+		count = -EINVAL;
+		goto out_put;
+	}
 
 	if (wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_KILLABLE)) {
 		count = -EINTR;
-- 
2.34.1

