Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F0E69B25B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBQSY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBQSY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:24:58 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4F5F278
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:24:57 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id d15-20020ac8534f000000b003b9c1013018so1025424qto.18
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XzZ2UgQ8Zx1DAtO1SW4fK+R5vxgC4Noq7JUffkyyVg4=;
        b=IAP8LE9pjiFzN4oZ4/5ceScOHtR+G5Dd08VPTCi2qF+D+clEp05/SyiyvdFDYqK+1t
         GBEmkDgdK+7Z8tRfYuQFcDEBZqdyLz9mm3NhzSXoGis/y+vmRwqEwv1OimZpZry/axfr
         ltJw6CMBfCvbabg63rlFOyOqj3asU6mSwL2MZu7q6ICPz57p7TCwDyaVklMI2EalGdqn
         l0r75uEzDXy0ypi8JL4TMyiBYD6ZgpGIZcsGgYYYnPRketTZCAILsMNHEJX69yWvT8Bt
         //xXzBLuRI7lpNSc/b469+11znc4o8f17Rlb1U18aVnagxvrhcGmRO/IiHuq2N+17fJ9
         SyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XzZ2UgQ8Zx1DAtO1SW4fK+R5vxgC4Noq7JUffkyyVg4=;
        b=akKT9AlkPFlXGAAcH4c/GbFGn+od+oG84Xfnd1VEVGF51HbSTs29I1YPk5Fbe0ZNcF
         eefzbzvBn+Djby/38Xb9v8ufBlTdkJWQnQxkBHiPlep0bON5g52kfTSYoTGUvknNqzjk
         F5H28jirEvZ1/mxFpcRbGQpT7KRX/3DODdejL/1pctVwZ7j/dV82X+CVaedCAqWuW1p4
         TUoXhiMj0XZnzZsic9y3VkMebYiQOldSMya3I/hNEKSzMBnHBSpS6Ix5y4WfptRj1t/X
         7n1kgJ1G8wtBgysQNJv8zMypFkC1sz4/LMnJVcvhVsMCfxUdVwVvdam82WrVvFsfpm/+
         0HPg==
X-Gm-Message-State: AO0yUKXqWzDuCYd4lgmAJ7JYt1sEunCnrhHQZDtnFiF8wOY7uP5bMoPP
        bVAIvi0XSZxyPGk8VBotuCCrAoQeKNzT2w==
X-Google-Smtp-Source: AK7set/au+j8KZQ3SJ17uA5rCNIDUnPPS4CeKBZuP70PYELBzt2pB+w2HdjfRLad05Zx0br4GnU+ahH0LLu3uA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:808e:b0:721:41a:f4f8 with SMTP
 id ef14-20020a05620a808e00b00721041af4f8mr703697qkb.2.1676658296948; Fri, 17
 Feb 2023 10:24:56 -0800 (PST)
Date:   Fri, 17 Feb 2023 18:24:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217182454.2432057-1-edumazet@google.com>
Subject: [PATCH net-next] scm: add user copy checks to put_cmsg()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/scm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/scm.c b/net/core/scm.c
index 5c356f0dee30c3edaa57b49176cce021d5248cd7..acb7d776fa6ec29cdd9ae7d3a9970384c887ac75 100644
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
2.39.2.637.g21b0678d19-goog

