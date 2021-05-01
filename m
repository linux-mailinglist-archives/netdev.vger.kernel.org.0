Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E737053C
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 06:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhEAEMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 00:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhEAEMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 00:12:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81CDC06174A;
        Fri, 30 Apr 2021 21:11:11 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id v191so471068pfc.8;
        Fri, 30 Apr 2021 21:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hVGtcaN7IxhSF58aBPwgD0NHN6yjMWXDQ72QVDTqI/k=;
        b=QHNtUvWtzzcnGeXw15lvCryEF/SjMqI1wdcbsphejH2mQ0bjIRQGGRiGdDJHSJrmoP
         czbGI3ej14ezc3f93p8VDYApXMP2M1YZR146m2Bi2x5J99y+/4zJWV+qqIiMxVR3CYnn
         jhqHffYHfsEQvXtovXBPDY2oOjibtTb7v1A3lMwlkdkt2OYD5XlBZu1NOpbQc1qKu8Iq
         Ig9iBgjWwHNbVjHmMuDXFqWEii6mHzJE7kxg/s6g5RgLiaasx4v0MijRZ78Xk5pIkFqP
         PnVBYz8upOtC+FTNQvA6bsxEGIE6PeFnde9qay83MeHF/YYZpNqfgnIJRxZkuTjrgfAw
         leyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hVGtcaN7IxhSF58aBPwgD0NHN6yjMWXDQ72QVDTqI/k=;
        b=fjhDHonnoJFqx0IWfqahXK8E43AOOKnZbWybrbJg0dyzLmHM4SromaHSUg91moRsMj
         B3kbiUIF4i3aNxrOqaaMzDnHN7P6qxTK29dkOmw+ma/EKGsBSoNNmCB9py/+MgT6E22F
         HhQWoF5Cd9Glujij5+Bj6r59ykJiSkTBvWrkTr+Gf9Y5IR23MQVbv5JalNFLQ0Kv/++p
         Uui3EIpDROTLifKs54vm63Z8y4kr8Ms86t3MY2ZB9fOnF68fwkMMSRfF0DTCnhcWYEV9
         CUf1iIutlQseKh3cYMttIpUKKnHNoX0wjVDCGVRmth00PhVtTPwTXn2YlqnDdv3Qd/qF
         zTTQ==
X-Gm-Message-State: AOAM5313D79kjaefMx1SUharDIxcjJ/9N+mEPqBdaAmJr4QbYa4pqdWx
        aJsip2fvjk/XmT9QoR7gZLQXMBdhEv1KYw==
X-Google-Smtp-Source: ABdhPJxrlWNT/b7l1xZrUndeHP7fvV7R93rnZowYHTeBwkUdkmqsnp7ef384NvGLyrKvEl9ZAmw/aA==
X-Received: by 2002:a65:52c3:: with SMTP id z3mr7782350pgp.338.1619842270283;
        Fri, 30 Apr 2021 21:11:10 -0700 (PDT)
Received: from localhost (natp-s01-129-78-56-229.gw.usyd.edu.au. [129.78.56.229])
        by smtp.gmail.com with ESMTPSA id i62sm3520547pfc.162.2021.04.30.21.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 21:11:10 -0700 (PDT)
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     Baptiste Lepers <baptiste.lepers@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] sunrpc: Fix misplaced barrier in call_decode
Date:   Sat,  1 May 2021 14:10:51 +1000
Message-Id: <20210501041051.8920-1-baptiste.lepers@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a misplaced barrier in call_decode. The struct rpc_rqst is modified
as follows by xprt_complete_rqst:

req->rq_private_buf.len = copied;
/* Ensure all writes are done before we update */
/* req->rq_reply_bytes_recvd */
smp_wmb();
req->rq_reply_bytes_recvd = copied;

And currently read as follows by call_decode:

smp_rmb(); // misplaced
if (!req->rq_reply_bytes_recvd)
   goto out;
req->rq_rcv_buf.len = req->rq_private_buf.len;

This patch places the smp_rmb after the if to ensure that
rq_reply_bytes_recvd and rq_private_buf.len are read in order.

Fixes: 9ba828861c56a ("SUNRPC: Don't try to parse incomplete RPC messages")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
---
 net/sunrpc/clnt.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 612f0a641f4c..77c4bb8816ed 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2457,12 +2457,6 @@ call_decode(struct rpc_task *task)
 		task->tk_flags &= ~RPC_CALL_MAJORSEEN;
 	}
 
-	/*
-	 * Ensure that we see all writes made by xprt_complete_rqst()
-	 * before it changed req->rq_reply_bytes_recvd.
-	 */
-	smp_rmb();
-
 	/*
 	 * Did we ever call xprt_complete_rqst()? If not, we should assume
 	 * the message is incomplete.
@@ -2471,6 +2465,11 @@ call_decode(struct rpc_task *task)
 	if (!req->rq_reply_bytes_recvd)
 		goto out;
 
+	/* Ensure that we see all writes made by xprt_complete_rqst()
+	 * before it changed req->rq_reply_bytes_recvd.
+	 */
+	smp_rmb();
+
 	req->rq_rcv_buf.len = req->rq_private_buf.len;
 	trace_rpc_xdr_recvfrom(task, &req->rq_rcv_buf);
 
-- 
2.17.1

