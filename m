Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90DE601E7F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJRAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJRAJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0A488A28;
        Mon, 17 Oct 2022 17:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C056B612A3;
        Tue, 18 Oct 2022 00:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5D8C433D7;
        Tue, 18 Oct 2022 00:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051710;
        bh=PwiZ3RNcmlNNDBXZcrRLQQX5aRk1EaJx4/ZQ6t+xBY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPPsfnctafN+HCxtlLcMxxu+I5Y4/wJ3dRBInoIL+F+LXC6fTr09zcfo7SicCNazB
         2Oq2WWVnR9oTC0Ir55ME18wDWA4oQRK8oEYIWm62zZ5pribq253T6jRdIlbrwPRsLN
         WVhIqeI/YZ11FGtVOqMOYHIi+Ik8R5Zc0T4yVrZJbj4VrwXbT0d0xyqXi1RCofJuFP
         Gdi51xOobitotCf468N6E0Y7iD26hXTf6ubgd61bfHp/wTD+ng6cFKautFfEBsQZ9E
         yUpJbfk52N13gQbR1PT1pv6PLh1GDC27BBZiLcGf9hCAkhkrHIFGKBFqPPt3zfuXbL
         qN8g4QCCyKCFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com,
        Schspa Shi <schspa@gmail.com>, Sasha Levin <sashal@kernel.org>,
        ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/32] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
Date:   Mon, 17 Oct 2022 20:07:24 -0400
Message-Id: <20221018000729.2730519-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
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
index e758978b44be..60fcc6b30b46 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
-- 
2.35.1

