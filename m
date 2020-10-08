Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406F4286D79
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 06:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgJHEM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 00:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgJHEM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 00:12:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B3EC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 21:12:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so2895976pfc.7
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 21:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDukyJf1vnIrECGggCnitSTaUfyKs5M10q768959Fr4=;
        b=Gj4Vea9fkLopFhSLRgWYWVUFdNuPHHeR4q29zqLCLXU4p7K1VTzm6RVeat3O+JqGk6
         AimFPPjx0nnOgPYuLDRvHCU1mXBqiUsecbKx7XaiHJYqPfd0v+j0giMzwR1LEVfI6SJw
         V60OxqrH+79Qb5jdtwuJdZXfk6X2n9Mu5rdGrTxti2zJrI+hKuJo4JhVZB8MZrqrMTl5
         L7b44bPnLb4R/TiFUSq1rc81mwu9LKF009VDBo6EZAsqE3Q/Jc4EOjO7bXqNL70DSXQP
         VNVOzNjOWZMQLT9OWfwRCh6jE1jmIrjqrcv79+At5M6tvX2CPvGpi9VUOGSYknK+es+P
         SwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDukyJf1vnIrECGggCnitSTaUfyKs5M10q768959Fr4=;
        b=SK4z1hYcHvxEZvuX7eZHgg2jHx4+689xEpT8ULAWknWvuiOUKPfHlVGQClTqaW7hze
         ZYhAZl2tIok9Ssglbs3A33CwWgOfTd4EkZ+5l0MlNx4eyIzsXt8oZpWqB+OGHas/ILxn
         CPy9rFrFW7aGliBeT9+fF9Esh6wNvxYxFy66XjGV5Cj26dFAsS66J6t/btN897Mqr3Eu
         i36qoWYxsfRdzjqaESWV0Xn5F0CpkU9qjWYAkhZdUmHacrjWaiHK4+YxQ09Yb4cnlRIw
         bYu7G6DQmmoFjgJ7IYC5brMHyoeSdXvjn9U1uQ6pjzgIvGIY5YZ6w53iV0saX8akvPnW
         2YVw==
X-Gm-Message-State: AOAM533a4phZu656Tgk9E63ho3TPzG++JUZ8xqiJVm3MrvDohQMnFGCS
        BMH6i9W7M9MQhB96jcGzfJy18NIHe4Et/w==
X-Google-Smtp-Source: ABdhPJyFND+2eIxiO4zxkB22M4zoRmUA/9agxvgDHDqQIQyYUL4R7Gb8rVIX+bUjEV/vsjiYgLkGuw==
X-Received: by 2002:a62:1686:0:b029:155:3b11:b454 with SMTP id 128-20020a6216860000b02901553b11b454mr2285822pfw.47.1602130378397;
        Wed, 07 Oct 2020 21:12:58 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id j5sm1217901pjb.56.2020.10.07.21.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 21:12:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [Patch net] tipc: fix the skb_unshare() in tipc_buf_append()
Date:   Wed,  7 Oct 2020 21:12:50 -0700
Message-Id: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_unshare() drops a reference count on the old skb unconditionally,
so in the failure case, we end up freeing the skb twice here.
And because the skb is allocated in fclone and cloned by caller
tipc_msg_reassemble(), the consequence is actually freeing the
original skb too, thus triggered the UAF by syzbot.

Fix this by replacing this skb_unshare() with skb_cloned()+skb_copy().

Fixes: ff48b6222e65 ("tipc: use skb_unshare() instead in tipc_buf_append()")
Reported-and-tested-by: syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/tipc/msg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 52e93ba4d8e2..681224401871 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -150,7 +150,8 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		frag = skb_unshare(frag, GFP_ATOMIC);
+		if (skb_cloned(frag))
+			frag = skb_copy(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
-- 
2.28.0

