Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAFC6B9484
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCNMqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjCNMpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3F4A21B2;
        Tue, 14 Mar 2023 05:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392EE61771;
        Tue, 14 Mar 2023 12:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC2C4339B;
        Tue, 14 Mar 2023 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797818;
        bh=+c45SjTlnq+NXIqIkShpUo9G/Gb3Q2yw0iHlcuh/bBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvgZnGCmS8AUwxKFAVrPcHYr6G65PvoqWSNNYHYG3dI4mXT36w7qasGDd22FiRUQ+
         PDq/ox3djVePAT8OWHCXdVuIe3J9boHvsWynrq43UM0323vrzHYr2PaRaocmsV1Msm
         bk6wkxV+Vnwx+RBaZkEx4ISRc55qlP/XS/O2l6FrPHlpDP++JX+9f7Cp/T5lgCM9Jz
         Azj8SRvR7KTdXIYt+5495vtPt/k7tXWfKOa4ALphoUT6lUda884gnkLAmhPVnaAiD4
         wleCYG6DVqnKngUPwJPo1o/66kyEZ3iaP2h5feXGeW8KROX0Ql7gQPhg8u6/DTk+SV
         oo7rvGGQKxsaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Van Hensbergen <ericvh@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/13] net/9p: fix bug in client create for .L
Date:   Tue, 14 Mar 2023 08:43:21 -0400
Message-Id: <20230314124325.470931-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124325.470931-1-sashal@kernel.org>
References: <20230314124325.470931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 3866584a1c56a2bbc8c0981deb4476d0b801969e ]

We are supposed to set fid->mode to reflect the flags
that were used to open the file.  We were actually setting
it to the creation mode which is the default perms of the
file not the flags the file was opened with.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 554a4b11f4fec..af59c3f2ec2e7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1284,7 +1284,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
-- 
2.39.2

