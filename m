Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41E0267F5A
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgIMLog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgIMLnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:43:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9C7C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:43:21 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so9372487pgl.2
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8G3N7gly8EOgI3ZN3conn825fl8Cc8rTK+sJjHraZv4=;
        b=qiWg8QuPKP5iaF9uKiCvtz5UbMW5/7q1Zx+jb28i9vLfuiJCwsfbcU2/TbNAApmQbi
         zYq20mDdxfZ/tzyxrK2yBZyIDzJBSIAE4oi2x+2RUm7j+ZL6fljBSGDxTM5k7XhxdBww
         QaEbLao/htW1QQpFWkKpldib35/YsuHHqWaP6PkE5JBYFzs7EC5bVevYpLohtuIrngWu
         pTAzvefqs9qNC5dYvygiEUN78CbqTmXhYUylAdT9XCQvhXyQp+e5hihuQu07Z7sl37HZ
         GLn8DjzoJpVY0j1FmwGImRoOH6SOGsw0Xy5k5wVNSoeaeQ93aJZcNm0iqBZxj9R8Bbv9
         U7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8G3N7gly8EOgI3ZN3conn825fl8Cc8rTK+sJjHraZv4=;
        b=fqOagr3R4dwV7VEUpp+sojpBwFzhgUKQJqxA9OAlVQBOTzYnLxDD9Y/SULR3rhKy3y
         Yr/9R4wCg6yf5TfIvOQcn7ZSYk6uSTJ/M38FnuMbAXVauHNSuJI0nNjEX9Z/v+xsOYbW
         oG8SoCpAvdiHINxB8IFnj6A8NIBFcBh1aOmnc2sfDtIdETUFkiOdvB+MXdzRyRI/oKE6
         LU+2B9F7MAYZlp+jr6DlelZYNu/NiXywyP61TWvx2Mbso3PU8l5pggI2Pr7jKHSkQHmp
         sBKZC11m0Tdk8wLDxwGSpNwMlilYaCs8okhJ+hw5pGSX9K9+d4B/L544iX5pndEMEmH2
         Uxtg==
X-Gm-Message-State: AOAM530vSiJGTEPf2TxL/TaOQ7p5iB1+lktV5ZVxnjIGNKaY0CPXblS1
        zZB2iRFEGnO5cpFEP5vnmk+3uuvAovo=
X-Google-Smtp-Source: ABdhPJwCRp1CYPsKoDW7SIAGk/HGtUBye+A1zAOxy287fjiUt45SISdueiJBnCZU3+Qu1kui+dwgkQ==
X-Received: by 2002:a63:6cc4:: with SMTP id h187mr7479663pgc.129.1599997391663;
        Sun, 13 Sep 2020 04:43:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q7sm5874536pgg.10.2020.09.13.04.43.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 04:43:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net] net: sched: initialize with 0 before setting erspan md->u
Date:   Sun, 13 Sep 2020 19:43:03 +0800
Message-Id: <cf5da3ba7ceb318ced1555f42795fcebfb0b870f.1599997383.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In fl_set_erspan_opt(), all bits of erspan md was set 1, as this
function is also used to set opt MASK. However, when setting for
md->u.index for opt VALUE, the rest bits of the union md->u will
be left 1. It would cause to fail the match of the whole md when
version is 1 and only index is set.

This patch is to fix by initializing with 0 before setting erspan
md->u.

Reported-by: Shuang Li <shuali@redhat.com>
Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/cls_flower.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index a4f7ef1..19a8fa2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1221,6 +1221,7 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 		}
 		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
 			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
+			memset(&md->u, 0x00, sizeof(md->u));
 			md->u.index = nla_get_be32(nla);
 		}
 	} else if (md->version == 2) {
-- 
2.1.0

