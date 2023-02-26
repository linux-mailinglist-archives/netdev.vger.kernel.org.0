Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18A16A326E
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBZPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBZPiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:38:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015CE26BC;
        Sun, 26 Feb 2023 07:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A642B80BE7;
        Sun, 26 Feb 2023 14:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1CEC4339C;
        Sun, 26 Feb 2023 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422922;
        bh=Ov297IfQkyRAzBny+6tsDT3S7ysVEojlYlRPxBhLAF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o31J/aCUJGSQ1x0Lb3F0XvBxZOPK52Az69nQObaNrdyzFuZQAjp56Zs+vNIUQphC0
         lCRsO7Z6Ryhx04Bw3SrWz97vcGM4DjEqtGoe2iuWtlcM5YTNdEZMmVL+OYzA1vKelB
         tqtbfdcBelD2nft93PKGyJabK4ia1CVjWfmzm+67b9Nf4nddTCOFoDiVPNPHlWPJx3
         KGTrj9tU1OOan6wFtpayWPhrbtVPsnrDPLcTfXf83pzMK+4T7d5iAwztY+RjkCo6ib
         WH5EVr2iPt9BztLX0Gcj5p5STfHje+Hyl6ft6oUwyqZ1rYv8tVrROWROBhHCeeYqCJ
         0b/5xLtWb8s5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 49/49] scm: add user copy checks to put_cmsg()
Date:   Sun, 26 Feb 2023 09:46:49 -0500
Message-Id: <20230226144650.826470-49-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f1eb1ff58ea122e24adf0bc940f268ed2227462 ]

This is a followup of commit 2558b8039d05 ("net: use a bounce
buffer for copying skb->mark")

x86 and powerpc define user_access_begin, meaning
that they are not able to perform user copy checks
when using user_write_access_begin() / unsafe_copy_to_user()
and friends [1]

Instead of waiting bugs to trigger on other arches,
add a check_object_size() in put_cmsg() to make sure
that new code tested on x86 with CONFIG_HARDENED_USERCOPY=y
will perform more security checks.

[1] We can not generically call check_object_size() from
unsafe_copy_to_user() because UACCESS is enabled at this point.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/scm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/scm.c b/net/core/scm.c
index 5c356f0dee30c..acb7d776fa6ec 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -229,6 +229,8 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	if (msg->msg_control_is_user) {
 		struct cmsghdr __user *cm = msg->msg_control_user;
 
+		check_object_size(data, cmlen - sizeof(*cm), true);
+
 		if (!user_write_access_begin(cm, cmlen))
 			goto efault;
 
-- 
2.39.0

