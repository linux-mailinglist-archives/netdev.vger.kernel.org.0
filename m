Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2B505CEE
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346564AbiDRQyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346616AbiDRQyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675BC33A00;
        Mon, 18 Apr 2022 09:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 124DAB81047;
        Mon, 18 Apr 2022 16:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DC0C385A7;
        Mon, 18 Apr 2022 16:51:35 +0000 (UTC)
Subject: [PATCH RFC 04/15] SUNRPC: Fail faster on bad verifier
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:51:34 -0400
Message-ID: <165030069404.5246.6833136485402480106.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bad verifier is not a garbage argument, it's an authentication
failure. Retrying it doesn't make the problem go away, and delays
upper layer recovery steps.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index af0174d7ce5a..ef3d7e4a26e7 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2639,7 +2639,7 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 
 out_verifier:
 	trace_rpc_bad_verifier(task);
-	goto out_garbage;
+	goto out_err;
 
 out_msg_denied:
 	error = -EACCES;


