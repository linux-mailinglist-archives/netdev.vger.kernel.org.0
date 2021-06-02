Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F4739937B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFBT2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 15:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBT2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:28:42 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A121C061756;
        Wed,  2 Jun 2021 12:26:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id r198so1733278lff.11;
        Wed, 02 Jun 2021 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3eTcKsWffVVKPjZgROWnlvuBXI7UvAVKKPxxp+2QZlg=;
        b=VmSDYsE6qXuKdsNbzP+1a5Fb8IMfzB8xg1zz8XrQUtTPsSJ0dtdnWLdzLGjyA0TyE0
         j6Xut2notzCNhkZh2rfcRhfS8LN26+woBgoMQ30tkSBhROLRxFR4InBS4hjHfyOxKILg
         r9SaIhBCh482gLYqcu2pDrPnU/694khEiv6VwzIw+arNZERh1KQ+lHOU6IVlf2EZRE7g
         Z/XzZeaaG6NdLGXyh97u7Bd+AMljVPkcRa8UF1PCvZsB66/uRPHFLhyVUOso0GEhnbEC
         pmR72bsDROB1ke0GZf7tWT2y7N15abAI3VFKVbiMt3nQXvRSUPsXILJ2yTS/emKYkyjA
         ueZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3eTcKsWffVVKPjZgROWnlvuBXI7UvAVKKPxxp+2QZlg=;
        b=hlmc/Rp5kWR0wxSjYxb5k0/2631IqzIt82nID7V2N0AIpvxPHVA9nwRYwfpULA4vHy
         RQjKJm68H9ZgE7ke6NpbdI5Lkt24c7Y7UTKmPYhsfWTVrO2/+8tsi9tJDLukv7b46KpD
         p1KqJQU3xYxG5i0nraRE+7eRv+0zhjls3cVy5yLMgb98iSi7fLm0Jd5U8EJpwZ9OCyh+
         EEnvqS4e1IBGy8e5spVu7VdysaK0jBFF/69EGvdzwG0/1zK3d97sXJ3jEL/7Gv4/8mFS
         ekqF/3PPPA1WtQo1Xk9UuRtGxOBN7ZEmM8fSaEBK0gnKt02JUPqa84J+4W8kMaB/lr4V
         uuGQ==
X-Gm-Message-State: AOAM530H0ex3/nA1hQvr1WKSndD7NI/WGg0jIu0GmsnqT1qqrgn2TbKR
        4HrJtMSAPQdq7ezEpwvkvfw=
X-Google-Smtp-Source: ABdhPJw7BLv63SqhnBYy0dv4fOThx1h0GBRVTPJ5dZ1FRG00zjHtGJK6dX7HUPLtFXA8dJX7oVIZFg==
X-Received: by 2002:ac2:5d6c:: with SMTP id h12mr24423879lft.354.1622662009569;
        Wed, 02 Jun 2021 12:26:49 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id w21sm76683lfu.174.2021.06.02.12.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 12:26:49 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] net: kcm: fix memory leak in kcm_sendmsg
Date:   Wed,  2 Jun 2021 22:26:40 +0300
Message-Id: <20210602192640.13597-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in kcm_sendmsg()[1].
The problem was in non-freed frag_list in case of error.

In the while loop:

	if (head == skb)
		skb_shinfo(head)->frag_list = tskb;
	else
		skb->next = tskb;

frag_list filled with skbs, but nothing was freeing them.

backtrace:
  [<0000000094c02615>] __alloc_skb+0x5e/0x250 net/core/skbuff.c:198
  [<00000000e5386cbd>] alloc_skb include/linux/skbuff.h:1083 [inline]
  [<00000000e5386cbd>] kcm_sendmsg+0x3b6/0xa50 net/kcm/kcmsock.c:967 [1]
  [<00000000f1613a8a>] sock_sendmsg_nosec net/socket.c:652 [inline]
  [<00000000f1613a8a>] sock_sendmsg+0x4c/0x60 net/socket.c:672

Reported-and-tested-by: syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com
Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/kcm/kcmsock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 6201965bd822..1c572c8daced 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1066,6 +1066,11 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto partial_message;
 	}
 
+	if (skb_has_frag_list(head)) {
+		kfree_skb_list(skb_shinfo(head)->frag_list);
+		skb_shinfo(head)->frag_list = NULL;
+	}
+
 	if (head != kcm->seq_skb)
 		kfree_skb(head);
 
-- 
2.31.1

