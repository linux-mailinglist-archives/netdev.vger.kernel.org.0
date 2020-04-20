Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C461B011E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 07:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDTFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 01:46:04 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:55920 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbgDTFqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 01:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=qrIWzL6L4fG1PLKjh4BfQqE2OBgxM/LVzA5nkNsVK8k=; b=W
        93GX35Gw3lT+tItHieWTmKDi6DEeS9tic9xj8O8QkXfKWvlfzz/qBP8PXMtCinUA
        VgCUgjx0DzVIUF6oGkmcleQJWFWmmsPYoTtf7SoPRZn/MwAvXhVs4VnV4KppbxeA
        7twC460tdpafIPIWFdSDIy3yFhfUn7/duadfCdYDRk=
Received: from localhost.localdomain (unknown [120.229.255.67])
        by app1 (Coremail) with SMTP id XAUFCgBHOHUIN51ezIQWAA--.58148S3;
        Mon, 20 Apr 2020 13:45:45 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] SUNRPC: Fix refcnt leak in rpc_clnt_test_and_add_xprt
Date:   Mon, 20 Apr 2020 13:45:19 +0800
Message-Id: <1587361519-83687-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgBHOHUIN51ezIQWAA--.58148S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4UuF1rJF43Cw13ZrW8Zwb_yoW8Ar1Dpr
        W8C3y3Cr98tr1xA3Zaya18W3WrArn3Xa13Grs0krn5Crn7ta4Iyw40grW29F48ZrWruF4U
        Zr4Yvrs8AF1Dua7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAv
        wI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYR6wDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rpc_clnt_test_and_add_xprt() invokes xprt_switch_get() and xprt_get(),
which returns a reference of the rpc_xprt_switch object to "data->xps"
and a reference of the rpc_xprt object to "data->xprt" with increased
refcount.

When rpc_clnt_test_and_add_xprt() returns, local variable "data" and its
field "xps" as well as "xprt" becomes invalid, so their refcounts should
be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling paths of
rpc_clnt_test_and_add_xprt(). When rpc_call_null_helper() returns
IS_ERR, the refcnt increased by xprt_switch_get() and xprt_get() are not
decreased, causing a refcnt leak.

Fix this issue by calling rpc_cb_add_xprt_release() to decrease related
refcounted fields in "data" and then release it when
rpc_call_null_helper() returns IS_ERR.

Fixes: 7f554890587c ("SUNRPC: Allow addition of new transports to a
struct rpc_clnt")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sunrpc/clnt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7324b21f923e..f86d9ae2167f 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2803,8 +2803,10 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 	task = rpc_call_null_helper(clnt, xprt, NULL,
 			RPC_TASK_SOFT|RPC_TASK_SOFTCONN|RPC_TASK_ASYNC|RPC_TASK_NULLCREDS,
 			&rpc_cb_add_xprt_call_ops, data);
-	if (IS_ERR(task))
+	if (IS_ERR(task)) {
+		rpc_cb_add_xprt_release(data);
 		return PTR_ERR(task);
+	}
 	rpc_put_task(task);
 success:
 	return 1;
-- 
2.7.4

