Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F005EF243
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiI2JiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiI2JiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:38:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8559D74;
        Thu, 29 Sep 2022 02:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6564B823AB;
        Thu, 29 Sep 2022 09:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD135C433D6;
        Thu, 29 Sep 2022 09:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664444288;
        bh=QDrBceZLFCpWcKESUJre+lgPFQsOo9h2zyNFxdUY+cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbplxQUOC7Q/7W7g5WwfPoKkc32IUdmzsyoeILMSCAN2PDxSZnIx5Thy5qwd9JkBr
         cIYAMOwsFiUb12Q1/CfhAgVJ7YXHlASdLJvXciLIrVBGvtWvbcc7iq0e4gk5BgYA3a
         JuxLm4+dc3Fe72qOYrjk2rVVx8/iXm69yB6g0buDolIBhX9fXN3CEY6Ky4tN3HQXWS
         jJZYoKd7aPPD0DLFNopz9wTjEoq+25Pf1WSsfwIHqob5Rqk8Fzn6bJLwWzFlanJG7X
         kHusGKcUEOghKhK3se8dsWm/WaZd/aMuW2W8yQABZav9BFWXJWVB2YWDcKfqkQc4OP
         lErSJHgI5YfKw==
From:   Leon Romanovsky <leon@kernel.org>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux_oss@crudebyte.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org,
        syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Subject: [PATCH 2/2] 9p: destroy client in symmetric order
Date:   Thu, 29 Sep 2022 12:37:56 +0300
Message-Id: <743fc62b2e8d15c84e234744e3f3f136c467752d.1664442592.git.leonro@nvidia.com>
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

Make sure that all variables are initialized and released in correct
order.

Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 net/9p/client.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index aaa37b07e30a..8277e33506e7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -179,7 +179,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 				goto free_and_return;
 			}
 
-			v9fs_put_trans(clnt->trans_mod);
 			clnt->trans_mod = v9fs_get_trans_by_name(s);
 			if (!clnt->trans_mod) {
 				pr_info("Could not find request transport: %s\n",
@@ -187,7 +186,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 				ret = -EINVAL;
 			}
 			kfree(s);
-			break;
+			goto free_and_return;
 		case Opt_legacy:
 			clnt->proto_version = p9_proto_legacy;
 			break;
@@ -211,9 +210,14 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 		}
 	}
 
+	clnt->trans_mod = v9fs_get_default_trans();
+	if (!clnt->trans_mod) {
+		ret = -EPROTONOSUPPORT;
+		p9_debug(P9_DEBUG_ERROR,
+			 "No transport defined or default transport\n");
+	}
+
 free_and_return:
-	if (ret)
-		v9fs_put_trans(clnt->trans_mod);
 	kfree(tmp_options);
 	return ret;
 }
@@ -956,19 +960,14 @@ static int p9_client_version(struct p9_client *c)
 
 struct p9_client *p9_client_create(const char *dev_name, char *options)
 {
-	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	int err = 0;
 
-	err = 0;
-	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
+	clnt = kzalloc(sizeof(*clnt), GFP_KERNEL);
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
-	clnt->trans_mod = NULL;
-	clnt->trans = NULL;
-	clnt->fcall_cache = NULL;
-
 	client_id = utsname()->nodename;
 	memcpy(clnt->name, client_id, strlen(client_id) + 1);
 
@@ -980,16 +979,6 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err < 0)
 		goto free_client;
 
-	if (!clnt->trans_mod)
-		clnt->trans_mod = v9fs_get_default_trans();
-
-	if (!clnt->trans_mod) {
-		err = -EPROTONOSUPPORT;
-		p9_debug(P9_DEBUG_ERROR,
-			 "No transport defined or default transport\n");
-		goto free_client;
-	}
-
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
 		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
 
@@ -1044,9 +1033,8 @@ void p9_client_destroy(struct p9_client *clnt)
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p\n", clnt);
 
-	if (clnt->trans_mod)
-		clnt->trans_mod->close(clnt);
-
+	kmem_cache_destroy(clnt->fcall_cache);
+	clnt->trans_mod->close(clnt);
 	v9fs_put_trans(clnt->trans_mod);
 
 	idr_for_each_entry(&clnt->fids, fid, id) {
@@ -1056,7 +1044,6 @@ void p9_client_destroy(struct p9_client *clnt)
 
 	p9_tag_cleanup(clnt);
 
-	kmem_cache_destroy(clnt->fcall_cache);
 	kfree(clnt);
 }
 EXPORT_SYMBOL(p9_client_destroy);
-- 
2.37.3

