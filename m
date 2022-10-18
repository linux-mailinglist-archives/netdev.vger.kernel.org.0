Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F774601F23
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiJRAQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiJRAOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC8E89CDC;
        Mon, 17 Oct 2022 17:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DA76B81BEC;
        Tue, 18 Oct 2022 00:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61C8C4347C;
        Tue, 18 Oct 2022 00:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051904;
        bh=xx+LcD2VTLj4E8qqfW3wKAhIQGRDj3nzKhfA4ljiib0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxPEXGJ7eMV9Jm0R4dsLcg3AFA9ZJZIVUTMJr2QER04tpeygQLRRuCXgFAufTK5xN
         nftTK5+DtEVbvyMGagkCNkXzHOZxGVo25qbCFsyv6GrJ1ckq+YWXCA1GCCZHorvFGE
         tMv7arFO2tJwFtm3pVgaByrQTe8E687qOjG5goRgyPIAWHF+FP0Cxhsos6p16/GC7j
         4fDoKu48b5pmgdhxI3j8U064nGIGjJz0B2wpgUjVE+cpSQBKP3qPkuBug4fXrXhEcM
         45wzc1tm9qVxzT5m9WIeEVqlPN7p/tRxNyMrtidAltl2sz/zK1QMwZWB/NQNksoksU
         8Uc2yLbTAcX3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com,
        Schspa Shi <schspa@gmail.com>, Sasha Levin <sashal@kernel.org>,
        ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/10] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
Date:   Mon, 17 Oct 2022 20:11:26 -0400
Message-Id: <20221018001128.2732162-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001128.2732162-1-sashal@kernel.org>
References: <20221018001128.2732162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 52f1c45dde9136f964d63a77d19826c8a74e2c7f ]

syzbot reported a double-lock here and we no longer need this
lock after requests have been moved off to local list:
just drop the lock earlier.

Link: https://lkml.kernel.org/r/20220904064028.1305220-1-asmadeus@codewreck.org
Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Tested-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 9268f808afc0..7d68b4a63997 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -220,6 +220,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -227,7 +229,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
-- 
2.35.1

