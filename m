Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D739D4B709A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbiBOP3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:29:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiBOP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C44B0E81;
        Tue, 15 Feb 2022 07:27:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A1F615F6;
        Tue, 15 Feb 2022 15:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5ADC36AE2;
        Tue, 15 Feb 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938867;
        bh=hHohSxgqCDRAYo2TzGlcEJxO0dJ5McJl7zKU55IAVrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPNdT/LPaA4fq+/UKc9DlGIIhKBwyMVSZVDD3do4Mn5uqiwludwzO9lR5aIW4lQZh
         XbqIr6mlbQiL4JON/e+Ve61vY9q01u+Ceb5++ZYiA4aIanKXf8LZl2ipvZJNzmxj6q
         K9/iCE+91paGuS5VsZLFsI+g4LyrVmM+tsJge/kWDtGuK82mBFN3TJqiQJBTZiPkIK
         sq2uAk9r/lGoD6vO1waKPgMjZRJ89NLyuisG8wb3kmoS4k7FXXJBp/vasw2FAOjOke
         5EFFUswSKzeSZG4WahCawypfjktZrT+GF4mqpAAYXPGvJwMUFgmnB/eLT8fQ8fqZ5N
         pU1ZDZgzGAJ1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Aloni <dan.aloni@vastdata.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, kuba@kernel.org, tom@talpey.com,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 24/34] xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create
Date:   Tue, 15 Feb 2022 10:26:47 -0500
Message-Id: <20220215152657.580200-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit a9c10b5b3b67b3750a10c8b089b2e05f5e176e33 ]

If there are failures then we must not leave the non-NULL pointers with
the error value, otherwise `rpcrdma_ep_destroy` gets confused and tries
free them, resulting in an Oops.

Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 3d3673ba9e1e5..2a2e1514ac79a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -436,6 +436,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.send_cq)) {
 		rc = PTR_ERR(ep->re_attr.send_cq);
+		ep->re_attr.send_cq = NULL;
 		goto out_destroy;
 	}
 
@@ -444,6 +445,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.recv_cq)) {
 		rc = PTR_ERR(ep->re_attr.recv_cq);
+		ep->re_attr.recv_cq = NULL;
 		goto out_destroy;
 	}
 	ep->re_receive_count = 0;
@@ -482,6 +484,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	ep->re_pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(ep->re_pd)) {
 		rc = PTR_ERR(ep->re_pd);
+		ep->re_pd = NULL;
 		goto out_destroy;
 	}
 
-- 
2.34.1

