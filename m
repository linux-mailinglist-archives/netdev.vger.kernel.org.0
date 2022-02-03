Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486F84A8D60
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354276AbiBCUaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:30:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33182 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354151AbiBCUaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:30:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76091B835A2;
        Thu,  3 Feb 2022 20:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C332CC340F4;
        Thu,  3 Feb 2022 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920207;
        bh=3lBPqZPBgZcKhOtMH3BcoKZunXu8BZh01IxJQ3TGeiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAe9v1lnXlWGFqXUSaS182jnnXLr8h1nVFg1Ow9Nvnft+wWDo3pk0QmGNetizOJK4
         Nxl1sNxjXeTylg4+7lezTa48F5zAVPJ3jRRufhHmH8Fz8uPNRxU+DiLYqhQwUBjP+Q
         Ef//jBs1UQ28P+dxs2GmelCLPvNAztnwIkBfLQoKax6JfSU2X4UpebdqfqAeRkac7S
         zU2tWHIHX+45GTt0ylkyA4wGNwUUrQuANy53HBtDdOd/t2Ho5BA8s583q9cYiLvS2Y
         m2FZibVxy1oRy0fadIHFXEWdJ6y+vdIAKWA5pR6yuyjgD+D0QKcd4fiSOgA0+ccW6l
         T+OqiYI1vFy3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        davem@davemloft.net, kuba@kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 12/52] net/sunrpc: fix reference count leaks in rpc_sysfs_xprt_state_change
Date:   Thu,  3 Feb 2022 15:29:06 -0500
Message-Id: <20220203202947.2304-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index 2766dd21935b8..77e7d011c1ab1 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -295,8 +295,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
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

