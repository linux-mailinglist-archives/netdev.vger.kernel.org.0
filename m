Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449AF5EF245
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiI2Ji2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiI2JiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4D1112FEC;
        Thu, 29 Sep 2022 02:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A8860EA5;
        Thu, 29 Sep 2022 09:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C669C433C1;
        Thu, 29 Sep 2022 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664444292;
        bh=joLgN+ItAGto0LT0pRnJ9952UZWeCLPyfeuxsOlctg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hT4d1Ic+mM0ASs1jwCFUNMusqrUNNWETNw25XhksLUV4AJdePTOfRmo0oIl/YdTEu
         a0nweqq1tyuoAb4UbtLbhRqr4Z6XxJaC76w3ORiDim6m/g+oHwNJCBBx/hRtmEaCML
         Mxau8mqtwHZ0XC7FFY15L8q+EhCbad6IUooGbpeWH9mRJODY/ggTlTlJTyig5WkpTl
         6nuXqvSc3Jcy6cKAXQ4WdzgRoAKLLtboFe5crE3AZLfyc+mYze3HWcqewMeVH9xGwp
         +Uu9FaNb2ghxlQGKgleWZpDT+gI1QpFejRkh4dcYNZr9R8fKozOVFa37svai79SOOW
         MVyD1tKFIFqJA==
From:   Leon Romanovsky <leon@kernel.org>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux_oss@crudebyte.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] Revert "9p: p9_client_create: use p9_client_destroy on failure"
Date:   Thu, 29 Sep 2022 12:37:55 +0300
Message-Id: <024537aa138893c838d9cacc2e24f311c1e83d25.1664442592.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1664442592.git.leonro@nvidia.com>
References: <cover.1664442592.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on proper unwind order.

This reverts commit 3ff51294a05529d0baf6d4b2517e561d12efb9f9.

Reported-by: syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 net/9p/client.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index bfa80f01992e..aaa37b07e30a 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -961,10 +961,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	char *client_id;
 
 	err = 0;
-	clnt = kzalloc(sizeof(*clnt), GFP_KERNEL);
+	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
+	clnt->trans_mod = NULL;
+	clnt->trans = NULL;
+	clnt->fcall_cache = NULL;
+
 	client_id = utsname()->nodename;
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
 
@@ -974,7 +978,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	err = parse_opts(options, clnt);
 	if (err < 0)
-		goto out;
+		goto free_client;
 
 	if (!clnt->trans_mod)
 		clnt->trans_mod = v9fs_get_default_trans();
@@ -983,7 +987,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		err = -EPROTONOSUPPORT;
 		p9_debug(P9_DEBUG_ERROR,
 			 "No transport defined or default transport\n");
-		goto out;
+		goto free_client;
 	}
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
@@ -991,7 +995,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	err = clnt->trans_mod->create(clnt, dev_name, options);
 	if (err)
-		goto out;
+		goto put_trans;
 
 	if (clnt->msize > clnt->trans_mod->maxsize) {
 		clnt->msize = clnt->trans_mod->maxsize;
@@ -1005,12 +1009,12 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		p9_debug(P9_DEBUG_ERROR,
 			 "Please specify a msize of at least 4k\n");
 		err = -EINVAL;
-		goto out;
+		goto close_trans;
 	}
 
 	err = p9_client_version(clnt);
 	if (err)
-		goto out;
+		goto close_trans;
 
 	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
 	 * followed by data accessed from userspace by read
@@ -1023,8 +1027,12 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	return clnt;
 
-out:
-	p9_client_destroy(clnt);
+close_trans:
+	clnt->trans_mod->close(clnt);
+put_trans:
+	v9fs_put_trans(clnt->trans_mod);
+free_client:
+	kfree(clnt);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(p9_client_create);
-- 
2.37.3

