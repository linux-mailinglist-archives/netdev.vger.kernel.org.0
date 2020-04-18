Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAF1AF232
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgDRQRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726307AbgDRQRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:17:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EB8C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:17:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r20so2676993pfh.9
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/ZvgAOLu1+upmn3VldR1SsZE4ium+P8hky5BwRUWNKM=;
        b=tLxYyzwTWsC9nDR4s0F+ZrfImnKDegm+mdbjJXwmjjxE8H+pw3BAKuLcxduNpwij/N
         5fZOfTSw3OcV2uwDX8ri6RsoMSxrYyDxgSYe5eZa9GWErAg/gatFiG5+VyrSIBI3tZlP
         DUZEoeyqXDzqSDxeQGi74IUJg/FEi86MM/1awp3A6mn9ZZN3sPunUYoraJkDshbHspgj
         WxIY5Fs5yNu7CzGaIVEzqDu36IgK1mqDHgFbNngtLJF0NdYhCqjERCIz2MXABFmBN1U+
         LFQOOTQbD2heBcfwZuaZzSSO0ye+NH6V1gPDd5R5wMXNNASOo3uu2Uxuiw2pkAXvLQfR
         ZI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/ZvgAOLu1+upmn3VldR1SsZE4ium+P8hky5BwRUWNKM=;
        b=CwtuP0UECLw0boRlS5oiVVO9CXhW87+UgbXkXwbMAHO6wdk+kXgcwN4PLn4t/uqwuB
         bJOcWjrx5n3U9x+WsP3KOK1YeLSMVCAQAIVRSGBJf2/d8M03RmA+bIbTZqCS4Cp0tBOB
         LTLRpz78hLiPe1aE6z+NrdoaIkoCIIviB/re3ECh3JLU1Fc0AZ9AIA7wMT8Ch/7y9JPp
         p2gkcOOJhdgTBS4UUR+vus9I349wFQDY5EHT8xKDmsmvKWUVhifg2h3jS5nSIM04OU5k
         CPewhG0/wIK50qfOeJi/tsfmYTnPY1c5ha7tM+foXEbH/pYuB9F3YxLQRNBNF10r4vG/
         y6xQ==
X-Gm-Message-State: AGi0PubQ0hCWyUuzNCQwsG72k6Nai15VRJavVoAwWntG4sdIlpxkKxup
        Zfw4/ukJ3yGhX6wiwYQwqrA=
X-Google-Smtp-Source: APiQypIh7z43/uTi0HTB7Qnsqv7OoIbQuHXrxIYnx453Brg6+9BfOCbbomAdoFoqHkJycfShpQL0BQ==
X-Received: by 2002:a63:7f5d:: with SMTP id p29mr8180842pgn.96.1587226658535;
        Sat, 18 Apr 2020 09:17:38 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id z6sm20899662pgg.39.2020.04.18.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 09:17:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] team: fix hang in team_mode_get()
Date:   Sat, 18 Apr 2020 16:17:29 +0000
Message-Id: <20200418161729.14422-1-ap420073@gmail.com>
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
 drivers/net/team/team.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 4004f98e50d9..21702bc23705 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -465,9 +465,15 @@ EXPORT_SYMBOL(team_mode_unregister);
 
 static const struct team_mode *team_mode_get(const char *kind)
 {
-	struct team_mode_item *mitem;
 	const struct team_mode *mode = NULL;
+	struct team_mode_item *mitem;
+	bool put = false;
 
+#if IS_MODULE(CONFIG_NET_TEAM)
+	if (!try_module_get(THIS_MODULE))
+		return NULL;
+	put = true;
+#endif
 	spin_lock(&mode_list_lock);
 	mitem = __find_mode(kind);
 	if (!mitem) {
@@ -483,6 +489,8 @@ static const struct team_mode *team_mode_get(const char *kind)
 	}
 
 	spin_unlock(&mode_list_lock);
+	if (put)
+		module_put(THIS_MODULE);
 	return mode;
 }
 
-- 
2.17.1

