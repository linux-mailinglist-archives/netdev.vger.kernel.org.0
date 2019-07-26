Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A8E75CF6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 04:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfGZCZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 22:25:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42055 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGZCZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 22:25:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so23965171pgb.9;
        Thu, 25 Jul 2019 19:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cepRcJFNdm0krVpqW6DO9gzxmkMHHb5KLKaLQ5UTyH8=;
        b=K78OYLh7hUM7NYoZlo/ezQ8HwVYNuZ61/Z8S429pPWg2irUhbSOVqUUuYzp0iDX/Jd
         SncaE1JfEm6w2nKX30MTCp2iB1qlc6jyMuC0mIdjxhyX9m6/bDQuw8yvcaxZ00FcsxWk
         TFFsS2LQu9a0+UjbnUZl158jxLGPfyCZ3qP6qCANivPuDH78rKV8ktA005lROQE7CivA
         LOrzulfln+8JlKG7CNh8GORqQm+HdccEOqfPjzCDIleG9VVUH9iNyTJp0oHRBXy9pAla
         2rcmQkH1UVrSmTFXIFFpTjeKXFjn0OjS12hS+LvhH8Fq1Np5FeiOpxKx/4yT2p5sX2UK
         sxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cepRcJFNdm0krVpqW6DO9gzxmkMHHb5KLKaLQ5UTyH8=;
        b=monhcPQKIzzLrsTTZj0udcDTmNK6qxs8Yc47De8LUS78h4T6/jSwFYx0W6qN5Amt7T
         7pT+qsmboL7NhFk2WAUZwQdMG+7DEegaffbmdV6n1sO0/qoRZ4ocBs2/p97O5DLH0UTW
         /rg7EzJ0QhPl0b7IV6D753LqI5m0LD3X1W2IOl4eETY0TUAVKecl3NQAH+gk5Xmu2nb3
         uaiH/IdwbF8IBn3zDdylC8etWYnZSV2e4jhKbehgcytkKFzfnhDggQZ/Tsa1ntllC9Gq
         E+i46z/ckTd3ziZrYGbC8eJ6uzs7UwytDzClQyIXC1DHfgaEhhZ0mpko5N55B6b0iSA7
         0EwQ==
X-Gm-Message-State: APjAAAUiHlZZc6HYsW+JRbToTytAya2wAQaAV8fLKJyIDC3WVlA0TU2+
        cICwsfJwWLyuy67JqKNavR4=
X-Google-Smtp-Source: APXvYqwddfnRUFydPWyno5YZy5rQ1pjR4IqwuenUrgipK7tkpaYpG4nj7WWBYt+b+SecaStfn6MvUw==
X-Received: by 2002:a62:fb15:: with SMTP id x21mr11759590pfm.233.1564107911329;
        Thu, 25 Jul 2019 19:25:11 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id w18sm64658103pfj.37.2019.07.25.19.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 19:25:10 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] net: ipv4: Fix a possible null-pointer dereference in fib4_rule_suppress()
Date:   Fri, 26 Jul 2019 10:25:04 +0800
Message-Id: <20190726022505.24938-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fib4_rule_suppress(), there is an if statement on line 145 to check
whether result->fi is NULL:
    if (result->fi)

When result->fi is NULL, it is used on line 167:
    fib_info_put(result->fi);

In fib_info_put(), the argument fi is used:
    if (refcount_dec_and_test(&fi->fib_clntref))

Thus, a possible null-pointer dereference may occur.

To fix this bug, result->fi is checked before calling fib_info_put().

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ipv4/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index b43a7ba5c6a4..daedce293aab 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -163,7 +163,7 @@ static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	return false;
 
 suppress_route:
-	if (!(arg->flags & FIB_LOOKUP_NOREF))
+	if (!(arg->flags & FIB_LOOKUP_NOREF) && result->fi)
 		fib_info_put(result->fi);
 	return true;
 }
-- 
2.17.0

