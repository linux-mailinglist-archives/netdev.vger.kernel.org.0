Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D56B9466
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjCNMpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCNMo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B402199BFA;
        Tue, 14 Mar 2023 05:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2A161768;
        Tue, 14 Mar 2023 12:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F22C4339C;
        Tue, 14 Mar 2023 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797799;
        bh=VCoUk9Py4cE0Vx0q2TgkNuGt9UilbNTVdSBJTBikMuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+MD3moA9XMeXRSDQSwHZE3/+Lr+/G77pCO0WoixjaBgjFX/s6eKFZaKr6STNrM/T
         kgE/Oq77TndFpmg3/TzWW/Ko/z+tqTWPyxXnsaw4SVjtBaYTU+U6nqgOZByK4XXkKT
         izUbSPfZ4CzbmwQd8KQ0ZPs7uac1L7ufRFZpNyYgrT45LR3cJf8youw+GWpwsRro1X
         QtycQVCNmELYNoCKQItyuoMOcEHHMMke2DEPnD6sVsInk794qTF0xl8OAWHUd4JPNQ
         4zx7fm/wBWpub08ML9LYpzdnTXXUZdPBi4uVuKeyYfH4LqcgiR7A/JrVd8IxkopNZK
         FP3GK8EmsnAvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Van Hensbergen <ericvh@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 09/13] net/9p: fix bug in client create for .L
Date:   Tue, 14 Mar 2023 08:43:01 -0400
Message-Id: <20230314124305.470657-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124305.470657-1-sashal@kernel.org>
References: <20230314124305.470657-1-sashal@kernel.org>
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
index 622ec6a586eea..00a6d1e348768 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1289,7 +1289,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
-- 
2.39.2

