Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342475571B5
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiFWEke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345891AbiFWEVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:21:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CDE2D1E9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B894B821A7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 04:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB0FC3411B;
        Thu, 23 Jun 2022 04:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655958067;
        bh=kgguCi6eHaF3p1kHMeFh8B9q2XqrcFVvsUiLk2bboJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=YdGjo/oYXuSa16BnQe7zFpKJXvAJLt6Q1PYdM/81sCpjA301l2LYT6QWnln3pqR1O
         yot40ftEHUdOkWuJBebfGFEzz4Klhn+yxmQHRHJkwnqWahB6hU3EeM8ky4Bt/fOGwj
         5v70MGT7qTmRQAfKL+rKOYXE+QtSfcdNiHOqv4wlmMy1wHkLLBFm5hkX/tUm0l57GQ
         6vQ9dXVhps9qRWzYTNAHapi2rleO8mBKEv1i+4SZzpB4A2ZZ20qBVEpPpv6J9cNe37
         z6p3q/6LfZE/UoSF1YcGxKGMbluPXXNhHjxrWPREoIBCjimebtbUKFmxY342MHXC3g
         HW72L526aL3Xg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, maheshb@google.com,
        peterpenkov96@gmail.com
Subject: [PATCH net] net: tun: stop NAPI when detaching queues
Date:   Wed, 22 Jun 2022 21:21:05 -0700
Message-Id: <20220623042105.2274812-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While looking at a syzbot report I noticed the NAPI only gets
disabled before it's deleted. I think that user can detach
the queue before destroying the device and the NAPI will never
be stopped.

Compile tested only.

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: maheshb@google.com
CC: peterpenkov96@gmail.com
---
 drivers/net/tun.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7fd0288c3789..e2eb35887394 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -273,6 +273,12 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	}
 }
 
+static void tun_napi_enable(struct tun_file *tfile)
+{
+	if (tfile->napi_enabled)
+		napi_enable(&tfile->napi);
+}
+
 static void tun_napi_disable(struct tun_file *tfile)
 {
 	if (tfile->napi_enabled)
@@ -653,8 +659,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (clean) {
 			RCU_INIT_POINTER(tfile->tun, NULL);
 			sock_put(&tfile->sk);
-		} else
+		} else {
 			tun_disable_queue(tun, tfile);
+			tun_napi_disable(tfile);
+		}
 
 		synchronize_net();
 		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
@@ -808,6 +816,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 	if (tfile->detached) {
 		tun_enable_queue(tfile);
+		tun_napi_enable(tfile);
 	} else {
 		sock_hold(&tfile->sk);
 		tun_napi_init(tun, tfile, napi, napi_frags);
-- 
2.36.1

