Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F5921CB7B
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 23:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgGLVEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 17:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbgGLVEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 17:04:50 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3809CC061794;
        Sun, 12 Jul 2020 14:04:50 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j80so10454800qke.0;
        Sun, 12 Jul 2020 14:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xB9P1wmbKeeyGS/z1ZCD7IZWuMRQKqcVFyeZviDeTF0=;
        b=NiNxFzwnf3pELLNi+/CIlQqfbXNr7H16z5BHXH5kkodlEvROo9/iAZifwe7BThm76S
         kNWGhLJ89ZIiRt5B51xcNkA4HsHsonTugEyfCteaEqYygkwKlb4Yd69yqM7QzJ6Nd62m
         xAi565EnbbOZpGsoBheMv/zziCII/fnv5JJD6aOylOESlvh0+Vc+XKolg0eY9ZPukpbl
         Mj1m9TgCYE9ljDUV2gQSxvynT6+6DTIT2iSAoRH7D8nq1LiRYNSMLMhLskRjP5En+QA6
         OtFmHw9QgtvY/3Ry0jAhQdugFkiZ06/u9tnQ1QZpnGCNv6qIomrefuf4HF19KupReuWV
         029Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xB9P1wmbKeeyGS/z1ZCD7IZWuMRQKqcVFyeZviDeTF0=;
        b=imED+U6SzL8oif/v5sP1sfBzRcnCj5nA57LPw5D8ZVXiN9qufeGKAfVCBIubOaJ5Yl
         Rajs5noZItxZuLOnaMcT5Sqr1flb2OPF4Rczk+CQw4UEd3pfmZHrqbtdC08yXo+0PhPv
         ot4M6jKpTZN9BaRvjmDl1o1LXpcU/H5AHqLsZD5BvaGBGm5yIhXVgHDnoL7UUv3wNlIh
         LnP0HmD5SzU5PXME2weS5FZyztK9jzDZmMXNwSeRC1SA20joXZLKvfSA7MjNAjowQnuD
         wwBlfKoZGDLMg64RQwwnonJkzEUNNpbGQMYeTRzUda0gpYfboXGDh5R3oC2JfY4MM+Sw
         bt1Q==
X-Gm-Message-State: AOAM530IL2EhTRCaanciOTO9QVYl8XuIHWAUgj4WIOOKJselti9ETeDl
        QkFJo8S7oEcuE5tA1WoJKg==
X-Google-Smtp-Source: ABdhPJz3KAfgxTv/Jz3QogwquKWxsuDv4eP6g8PYHyijMocJTXCI97XiB2Jnvi12qsq3mYhdkvAqOA==
X-Received: by 2002:a37:7b83:: with SMTP id w125mr76348212qkc.6.1594587889513;
        Sun, 12 Jul 2020 14:04:49 -0700 (PDT)
Received: from localhost.localdomain ([209.94.141.207])
        by smtp.gmail.com with ESMTPSA id o21sm16894766qtt.25.2020.07.12.14.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 14:04:48 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] qrtr: Fix ZERO_SIZE_PTR deref in qrtr_tun_write_iter()
Date:   Sun, 12 Jul 2020 17:03:00 -0400
Message-Id: <20200712210300.200399-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qrtr_tun_write_iter() is dereferencing `ZERO_SIZE_PTR`s when `from->count`
equals to zero. Fix it by rejecting zero-length kzalloc() requests.

This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=f56bbe6668873ee245986bbd23312b895fa5a50a

Reported-by: syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 net/qrtr/tun.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index 15ce9b642b25..5465e94ba8e5 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -80,6 +80,9 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	void *kbuf;
 
+	if (!len)
+		return -EINVAL;
+
 	kbuf = kzalloc(len, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
-- 
2.25.1

