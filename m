Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A146A3132
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjBZO4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjBZOzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:55:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577F512F1B;
        Sun, 26 Feb 2023 06:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3E55B80C71;
        Sun, 26 Feb 2023 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA589C433D2;
        Sun, 26 Feb 2023 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423013;
        bh=Ov297IfQkyRAzBny+6tsDT3S7ysVEojlYlRPxBhLAF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERzPslgcSRrcvlVLhXyw51cnpm1J5UEeqZfnJX9o9xwMEV83k9zmitMCU3HPAcX4H
         ghnOCbgygB/hlg+FhSOZ6Zh4/Gac0udiC7Lb54P69F0/kv6x/Rw2HhhtwjMaJ6FGvR
         zbm3ucRlIJuNNoaOj79ulwpGew32UAa2LdV7DPSPe74Og+/ec5UT5gu6rBuxmY1pqC
         1iQvBfs6yyMESZ7mQdcwzAVXioqPAJxVkteMqFlGyrM5NaAR/9mt2C26qSfaFh8iy6
         D/pMc364CK8U3IUj2ni1Rf9xbRDxM4YUywOAinGWZu04OJ3nZvQNEVlTPJykaqK/J8
         D3f3Qko79FFvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/36] scm: add user copy checks to put_cmsg()
Date:   Sun, 26 Feb 2023 09:48:44 -0500
Message-Id: <20230226144845.827893-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

