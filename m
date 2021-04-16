Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E331C362BEB
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhDPXbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDPXbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:31:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5958BC061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 16:30:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso15434320pje.0
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KL9elqXodDr0udWoBpJkxsclxcB1V/7V0mK2vTYFkKg=;
        b=TxehKJeRkdxMRR022A5VlhX9vbQUBrbEoh35u9fPYh0NA11rQmlJpdBLgr9X1RZURc
         aUBpAKfyz+SM+dRevprZzCtRaVHrS0VlueU1L0zVYfMj/w3YnuxhGvCiXOQYt+aaqT8o
         qtMTkAgx92Gvww/SX00QpbsQDtXZCaOPLdmZ5SSdRg4iUQ/Gyk5M1irX/+iGsJduKAmx
         p281wPYoeblj9VxCS7kOdYJEqAWGeJ0vXlWS4bBv9X+VkhBTwVRhg8sOzTogRMuH7cNB
         ezg/JWHz74Ip8ut0Av5dB/6E/OTIYpGOHTRa5Ixv0baAjSzytL0RSAFCz817ipA/gVF3
         7Qug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KL9elqXodDr0udWoBpJkxsclxcB1V/7V0mK2vTYFkKg=;
        b=K21W+NFiXsNsKYxcmQf/K29S5gkFlb8Ol3TvWsHht1QkqGRy8SNvGW9dCmwzwjgeWU
         sgwDQwODdy0RKUpAbZC6STyy77M93iMmMw1gFzU/t5IGzMK6nxQtECq2/fsrfsVByPAF
         tSuiUcOuRBudqvQg5MNoMJTUa7872y0M7sYY0eccBu+bd5Fp2VenQQFoniIJ0Qw0WX9W
         gq4SzSL7lAZHq5KtWP49XGss/5Emypsb5PU9KnyoEYl+Bz2uaQx08c8FIYq2uFfW7rRq
         lHuFYBYtcXXoHMs1Jc+5sulYI7VOYs4EWZXrRgQYSJp7TASf5ZlCk4Y0ISwDQoqb+R/V
         R9sQ==
X-Gm-Message-State: AOAM533HpIjLxCUUQOGo42MX49UcjGH/jytlqngaP5m9bTa07n6b2mMs
        x4zxtwkB89hpZE4W3GTCtLk=
X-Google-Smtp-Source: ABdhPJyJr11puVNcGKCDunxKO1ECwif9HuVTgFwrPkdlRTwQxj7RvHN9dJSW5L8+0JXmlwTkEr5YJA==
X-Received: by 2002:a17:90a:c982:: with SMTP id w2mr12581135pjt.35.1618615851925;
        Fri, 16 Apr 2021 16:30:51 -0700 (PDT)
Received: from nuc.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id o127sm5858489pfd.147.2021.04.16.16.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:30:51 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com, Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: [PATCH v4] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Sat, 17 Apr 2021 07:30:46 +0800
Message-Id: <20210416233046.12399-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Catch this condition in parse_taprio_schedule to
prevent this condition.

Reported as bug on syzkaller:
https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c

Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
changelog
v1: Discussion https://lore.kernel.org/netdev/YHfwUmFODUHx8G5W@carbon/T/

v2: fix typo https://lore.kernel.org/netdev/20210415075953.83508-2-ducheng2@gmail.com/T/

v3: catch the condition in parse_taprio_schedule instead
https://lore.kernel.org/netdev/CAM_iQpWs3Z55=y0-=PJT6xZMv+Hw9JGPLFXmbr+35+70DAYsOQ@mail.gmail.com/T/

v4: add extack

 net/sched/sch_taprio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..909c798b7403 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -901,6 +901,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
+
+		if (!cycle) {
+			NL_SET_ERR_MSG(extack, "'cycle_time' can never be 0");
+			return -EINVAL;
+		}
+
 		new->cycle_time = cycle;
 	}
 
-- 
2.30.2

