Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002381B0C47
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgDTNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgDTNLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:11:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4BBC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:11:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n16so5027054pgb.7
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=942F+zbC8e6GMQKweGVfAb6swdyo0fJ6thu5WV+Sg2E=;
        b=FtYdmZTZBtN7eNOghxbqB9qOC6NmXfHxKw/oxDiUU0hBWWyMTRfx9yWdM3nViycpyq
         aOrLjdUMCwevup6BDgGtlt7grgLu6gxcwxSCb6IfM4kz0M30YfHZIpYZ/Ar9Em7fCBOp
         dwGfBoSQEEV0J7KvyHCys1g6ceMwqL7FzSUdH8O9u0NYm6ujr59Yxr7yUq7fvYTfr0kr
         Bj8QD9Us+0F4qj1Z+nrBHbaFUxlJe+n1y4wnWfw8j5NCCfmq0LXl4LeMaqvqC48/+TxG
         GT8po3rqWSYo9NtLdZnJlVMJb6m9ChqcX1Ebx/N6GEKGQ1D7Hm1r2N+qJ9dgGtchhkrF
         el1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=942F+zbC8e6GMQKweGVfAb6swdyo0fJ6thu5WV+Sg2E=;
        b=LDIaWW3AfFOU9EQNFXeFEV9oQITBoaBFiwQbWKlxPReo3qf8IZc4FgWg+wXkN6rMHD
         x/SCjLtkPNqLXvT0YMKLsi2fcSMbS76adJoQ1inozHgjl2V5XVTeKVoQHZD4IideZIyj
         Em27QKCH+P7qJKBUboBjchrzADWy+Ngu4UlSbMMKN8RmasY0Ov96t7OAM8qGgJKue5Cf
         Q9OuCPxHKj0ol+Lrdx5fTQGZpCvaOe6cfLYdYYoBOxPAkyRLMMgg6ib6hc1Ld8Ds3giE
         4Sl6woEG75qGrokVa9wyIDN5mWZbsqHViOs4rywQvSw0vZh/G4P9HDYZVDa6eH6jLI4Y
         yP3g==
X-Gm-Message-State: AGi0PuaBraI+Cpf+ijYOUmbC08d0Egk5+1oSeysADF+8a/ZVh1tvlqOc
        xqKim2g80VmQg6uve3bUiwE=
X-Google-Smtp-Source: APiQypLn+xkvW74SG/J7RiHMprMviDDMAvt2VocuZDMnX5Ru+8lA+DYn5L/5VBGwNbhTpHlP0VH1zQ==
X-Received: by 2002:a62:e414:: with SMTP id r20mr16345622pfh.96.1587388312959;
        Mon, 20 Apr 2020 06:11:52 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n24sm1135975pgh.85.2020.04.20.06.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 06:11:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] team: fix hang in team_mode_get()
Date:   Mon, 20 Apr 2020 13:11:45 +0000
Message-Id: <20200420131145.20146-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When team mode is changed or set, the team_mode_get() is called to check
whether the mode module is inserted or not. If the mode module is not
inserted, it calls the request_module().
In the request_module(), it creates a child process, which is
the "modprobe" process and waits for the done of the child process.
At this point, the following locks were used.
down_read(&cb_lock()); by genl_rcv()
    genl_lock(); by genl_rcv_msc()
        rtnl_lock(); by team_nl_cmd_options_set()
            mutex_lock(&team->lock); by team_nl_team_get()

Concurrently, the team module could be removed by rmmod or "modprobe -r"
The __exit function of team module is team_module_exit(), which calls
team_nl_fini() and it tries to acquire following locks.
down_write(&cb_lock);
    genl_lock();
Because of the genl_lock() and cb_lock, this process can't be finished
earlier than request_module() routine.

The problem secenario.
CPU0                                     CPU1
team_mode_get
    request_module()
                                         modprobe -r team_mode_roundrobin
                                                     team <--(B)
        modprobe team <--(A)
            team_mode_roundrobin

By request_module(), the "modprobe team_mode_roundrobin" command
will be executed. At this point, the modprobe process will decide
that the team module should be inserted before team_mode_roundrobin.
Because the team module is being removed.

By the module infrastructure, the same module insert/remove operations
can't be executed concurrently.
So, (A) waits for (B) but (B) also waits for (A) because of locks.
So that the hang occurs at this point.

Test commands:
    while :
    do
        teamd -d &
	killall teamd &
	modprobe -rv team_mode_roundrobin &
    done

The approach of this patch is to hold the reference count of the team
module if the team module is compiled as a module. If the reference count
of the team module is not zero while request_module() is being called,
the team module will not be removed at that moment.
So that the above scenario could not occur.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Remove unnecessary #if statement and 'put' variable

 drivers/net/team/team.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 4004f98e50d9..4f1ccbafb961 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -465,8 +465,11 @@ EXPORT_SYMBOL(team_mode_unregister);
 
 static const struct team_mode *team_mode_get(const char *kind)
 {
-	struct team_mode_item *mitem;
 	const struct team_mode *mode = NULL;
+	struct team_mode_item *mitem;
+
+	if (!try_module_get(THIS_MODULE))
+		return NULL;
 
 	spin_lock(&mode_list_lock);
 	mitem = __find_mode(kind);
@@ -483,6 +486,7 @@ static const struct team_mode *team_mode_get(const char *kind)
 	}
 
 	spin_unlock(&mode_list_lock);
+	module_put(THIS_MODULE);
 	return mode;
 }
 
-- 
2.17.1

