Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0224D1B0F25
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgDTPBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgDTPBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:01:41 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB72C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:01:41 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ng8so4706184pjb.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zHIe8M8JN9gqsyMMwbv/+LEuDtpekvLpYveTLe51DsA=;
        b=qRHeur4Hf/KS5TtyIVaaW3qi7aswzsVX7QoYC1Ft1IEGIlpw1lku7nxquomjqSiuNE
         DvWpybz2w7+e5XhsXi3eVMaMfoHHWGjlYGwcrpD3BKX+brHL0rzr7RiyNMq4S94dfVfu
         Q3RrID6pidIs5Q0Z481k3hVEoqHIdv+FpTVywqJDsGw28CU2otT8eFL5QTlVrPVj6lTN
         EymwAo8sHpRTcDfizPxA3mHT55GeceeW1fK8pzecMB3dckMCR6SYk1ud0PCv3aILfqIj
         b5rdN3GaTjJvf/yaSwAqCrif3nnO2NV5gJDI0RfOlwX0VxODdbuHJTHCrCAixyqrgep8
         HVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zHIe8M8JN9gqsyMMwbv/+LEuDtpekvLpYveTLe51DsA=;
        b=RBLBMUZ8kEwdX1TiVzgf9Ym4ys7fmlqxTxWoWGCkNXLOZlALOGzEvuHrjd7cPJ/P7m
         JNxhGamgXw/2rm/rmVoq3cbGzd7mckzM0IEvtht7JIjXzu36OWk8PhTlZtmDemWhx0po
         zkWzZc+DRF6FVbwKNZ+1WZhZDaMG6XvHLpYBUElRqJBzy0pljXjAAK7DXbTiAn1DyvTg
         5zNq/8EnuDitsM6paI1gkEjmSqcsQY5RpUwTKO1KwIsz4yDEE9yW6VfSHxFlaiFuPFF5
         Jr6H6KQE7nPFzMF6NjjhAgJWOkahU2VgvQjxH6EGyn3/aOSesfbPYvgeOrrFci0fSYDP
         R7wg==
X-Gm-Message-State: AGi0PuaDTX2hxEe6o5SutIjsR3kqSj/mC/qRSiRPYe7Wf2mexW5Xqznu
        ILR2stTwazfKgKFYs70L1xc=
X-Google-Smtp-Source: APiQypILRkON8LeZ+hEOiV3hido54MCqLCeUAzvtY/cUUeVrgofWVw3PoXEOHfXB80vAJ7/1U4biaQ==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr22531648pju.144.1587394900376;
        Mon, 20 Apr 2020 08:01:40 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 13sm1340526pfv.95.2020.04.20.08.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 08:01:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3] team: fix hang in team_mode_get()
Date:   Mon, 20 Apr 2020 15:01:33 +0000
Message-Id: <20200420150133.2586-1-ap420073@gmail.com>
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

v2 -> v3:
 - Remove unrelated change

v1 -> v2:
 - Remove unnecessary #if statement and 'put' variable

 drivers/net/team/team.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 4004f98e50d9..04845a4017f9 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -468,6 +468,9 @@ static const struct team_mode *team_mode_get(const char *kind)
 	struct team_mode_item *mitem;
 	const struct team_mode *mode = NULL;
 
+	if (!try_module_get(THIS_MODULE))
+		return NULL;
+
 	spin_lock(&mode_list_lock);
 	mitem = __find_mode(kind);
 	if (!mitem) {
@@ -483,6 +486,7 @@ static const struct team_mode *team_mode_get(const char *kind)
 	}
 
 	spin_unlock(&mode_list_lock);
+	module_put(THIS_MODULE);
 	return mode;
 }
 
-- 
2.17.1

