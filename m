Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8460855EBDF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiF1SF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiF1SFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963511CFE5;
        Tue, 28 Jun 2022 11:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3218361A7B;
        Tue, 28 Jun 2022 18:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4678BC3411D;
        Tue, 28 Jun 2022 18:05:53 +0000 (UTC)
Subject: [PATCH v2 01/31] NFSD: Demote a WARN to a pr_warn()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Tue, 28 Jun 2022 14:05:52 -0400
Message-ID: <165643955226.84360.8094357302840158437.stgit@manet.1015granger.net>
In-Reply-To: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
References: <165643915086.84360.2809940286726976517.stgit@manet.1015granger.net>
User-Agent: StGit/1.5.dev2+g9ce680a5
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

The call trace doesn't add much value, but it sure is noisy.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3895eb52d2b1..9366493ae849 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -630,9 +630,9 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	}
 
 	status = nfsd4_process_open2(rqstp, resfh, open);
-	WARN(status && open->op_created,
-	     "nfsd4_process_open2 failed to open newly-created file! status=%u\n",
-	     be32_to_cpu(status));
+	if (status && open->op_created)
+		pr_warn("nfsd4_process_open2 failed to open newly-created file: status=%u\n",
+			be32_to_cpu(status));
 	if (reclaim && !status)
 		nn->somebody_reclaimed = true;
 out:


