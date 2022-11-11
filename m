Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59EB62503A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiKKCeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiKKCd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:33:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5DBC18;
        Thu, 10 Nov 2022 18:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E288261E8C;
        Fri, 11 Nov 2022 02:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2440C433C1;
        Fri, 11 Nov 2022 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134031;
        bh=KqR3IwAImF6SSQJBFCNKIYOr1z71vch5MANtyqJIblM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rslz6ERswiY2L9Ag1uDQKuP/svcMiBuAuDc7hc4GkeP+QmTSWTtThHHjMdTOqygf9
         dk1+7TmopH4m5Xks4oAUCRYFoMLsZcMkGi14GUGvsfYS9zvCqkWVO5W/1lHm4ez7XF
         pzn/1paq0ScAvkAUXqth9NK9RrOzR80wUjX2PFApkk413jLWYRev11CBJ6nnTCpjpH
         EbAj3TddLV5Uexjuad630xf9SLCzzq1SVTMRUT/sk10RNBbDKua6f9R6u1D7Wc9WI4
         KcE9N8hKTmXr69Gpn7J23ZMAcojTSvgsywnf7LmI8hM15qqDjGSK9Wk0st6x9Zw3AD
         8MIgCoQK0GKWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, neilb@suse.de, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 05/30] SUNRPC: Fix crasher in gss_unwrap_resp_integ()
Date:   Thu, 10 Nov 2022 21:33:13 -0500
Message-Id: <20221111023340.227279-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8a0fa3ff3b606b55c4edc71ad133e61529b64549 ]

If a zero length is passed to kmalloc() it returns 0x10, which is
not a valid address. gss_unwrap_resp_integ() subsequently crashes
when it attempts to dereference that pointer.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index a31a27816cc0..7bb247c51e2f 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1989,7 +1989,7 @@ gss_unwrap_resp_integ(struct rpc_task *task, struct rpc_cred *cred,
 		goto unwrap_failed;
 	mic.len = len;
 	mic.data = kmalloc(len, GFP_KERNEL);
-	if (!mic.data)
+	if (ZERO_OR_NULL_PTR(mic.data))
 		goto unwrap_failed;
 	if (read_bytes_from_xdr_buf(rcv_buf, offset, mic.data, mic.len))
 		goto unwrap_failed;
-- 
2.35.1

