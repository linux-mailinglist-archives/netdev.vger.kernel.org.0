Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCA282D9C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgJDUz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 16:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgJDUz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 16:55:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E36C0613CE;
        Sun,  4 Oct 2020 13:55:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h6so3778096pgk.4;
        Sun, 04 Oct 2020 13:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdvIIyxIuMTWPTkysqTwPpBrn7TuPnPJbCEXdGhmjXA=;
        b=RXs+HjiFGShmJ1wccK4uLdFWOSKbcxMcxA8COMUvEfPHgcT97pzYi9/nO6rI1bFdIL
         hsNx3tyJbH2aofisNie/6oQSUoozVNJLaYAu6KlF7NSsjrKxUXQugtL64Ee3NOKCcGmp
         qfKroWi2W7fOgKSY6fpZlOQqccdC0kHZjW88fyhr4BULhpWTkg3etdlysXu0YW9bKl2b
         7j5Uy+FRiDQDfm9wOqF0X6O1FvVwNi7iOy2LVIBx/96MoVMYg0Nj71fy77t+L76eoX4h
         w+WU/yLoDq42JxwSKV+TJf9a8wtslAeXCns/ZHDf2h+XXL3EnBo266soKVAa5JJCYxcK
         KAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdvIIyxIuMTWPTkysqTwPpBrn7TuPnPJbCEXdGhmjXA=;
        b=Fn3vjvKA6bvkyYbtu1Zzznn3FovEMFi8S7EtZgn0m84Jf6dlV0CYbVieG3BI6JxAcz
         OerQjgOO15tthuc2CM+NgsdFGwWVHy4PqQj4aukgPMkwrNXejYnX0v/LyKu3YnBor5Q1
         W/RUECjBb+CTJLEk4D69szCaQTeL/UlMwVh6BsHVbORVQb8t065xl67NvaQG5aFX0eNx
         4IWaPg+FLfgvuBtV8E1DdNoQZP5CnszJpODqbVOuiK+T08xeckYLQKCR8wbgF6d7LvaV
         CSv4eb4YxfCfhEL47uA1Pm062nBb76lfIRIkukQnax9gzApIT49zqZWeTNHCK6n2M9Hh
         QTaw==
X-Gm-Message-State: AOAM5333wLSiovnMmRl1le83pH4E096mOx1D3KxKgTjqvHcSkVC4C1+v
        lI8uqD7kJEs3nezz2aHhmHw=
X-Google-Smtp-Source: ABdhPJwkVdTzeLRWaTwuE8jAGC/0IdkS4W0EMUIfqLH2ZZNDgkobsQUe+R2RbfrfafluMXAuq2ly8g==
X-Received: by 2002:a62:1844:0:b029:152:80d3:8647 with SMTP id 65-20020a6218440000b029015280d38647mr1751507pfy.18.1601844958883;
        Sun, 04 Oct 2020 13:55:58 -0700 (PDT)
Received: from localhost.localdomain ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id c3sm9772626pfn.23.2020.10.04.13.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 13:55:57 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: team: fix memory leak in __team_options_register
Date:   Mon,  5 Oct 2020 02:25:36 +0530
Message-Id: <20201004205536.4734-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable "i" isn't initialized back correctly after the first loop
under the label inst_rollback gets executed.

The value of "i" is assigned to be option_count - 1, and the ensuing 
loop (under alloc_rollback) begins by initializing i--. 
Thus, the value of i when the loop begins execution will now become 
i = option_count - 2.

Thus, when kfree(dst_opts[i]) is called in the second loop in this 
order, (i.e., inst_rollback followed by alloc_rollback), 
dst_optsp[option_count - 2] is the first element freed, and 
dst_opts[option_count - 1] does not get freed, and thus, a memory 
leak is caused.

This memory leak can be fixed, by assigning i = option_count (instead of
option_count - 1).

Fixes: 80f7c6683fe0 ("team: add support for per-port options")
Reported-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
Tested-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 drivers/net/team/team.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e02752ff6..8986f3ffffe4 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -287,7 +287,7 @@ static int __team_options_register(struct team *team,
 	for (i--; i >= 0; i--)
 		__team_option_inst_del_option(team, dst_opts[i]);
 
-	i = option_count - 1;
+	i = option_count;
 alloc_rollback:
 	for (i--; i >= 0; i--)
 		kfree(dst_opts[i]);
-- 
2.25.1

