Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA63B3615FE
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhDOXSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOXSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:18:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD053C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 16:17:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso13562873pjh.2
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 16:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wP/QU0/zKQlRBFRQMpbxzixxwIL3kjPTqa4L7CrPMQ=;
        b=CrViFpiTiifoMjo+Wkz33IlK1rMzyweMfBcT69b7ChfG99FJX4OmVu0y32c+FkIxWv
         D/CFRui3h53E0ywSnUpVnUQTF7QBJyaixQh0kNOh+NDiOSa/ljxNOCVI+OdyR9ER0G2x
         W+OJai/3UYflHmP2pg/luXp82QJiWzENSfW1Zx4nkgsB2zqsysoYwas8spW7LKADrSv2
         vzw/eAN6oncwn70LzkSjlQwWX+omgP+REsnpscaEXE3AkUxMrmiIghCsZxLmMhKQ7wPt
         zmyu950146UAQWhiYQq6qeN2oxeflalfeB3QKlDF8Ot7yPm8Cx8YiYIq+Q3a4HWz4ayN
         ae2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2wP/QU0/zKQlRBFRQMpbxzixxwIL3kjPTqa4L7CrPMQ=;
        b=a97dxtW4kZXIsbjFrvYiarTLeXZPRXtPCbjHl114GIRoFk1oWeyYuOptBbzgmT/U9H
         HUuaUYpkOffaEFL6wo7SoNUs56LzmHsjXp97l/VfJmH6lIBl1Tg8pbltoUMnbty0oGt4
         a0dtuaBh7SBCbKoWNZQGHnJOw41+lZ1+/Yw7+vzU+viMDz8mNDS3qNYJGcX2J9zY8Wms
         cRxVfxaBEy+0gkhwyPepyW8hxVJDlCQhAqk1TYGF/ySL5fmKcIK9j85oUXFnskOV3yjH
         v6zX3BS3F5cSBc29XJSI7CJrb8sK6u0WwrjA+2zqz6IORxiccFp4NAoV+v1XywuMTaxS
         QcQA==
X-Gm-Message-State: AOAM530JKXkqyeQ/zdO7pNVQiMpy6vlyE9FN+sZ7jqz1uic6lc9lLZTy
        unKMKMu2nWDeSZQGGMJ+FJg=
X-Google-Smtp-Source: ABdhPJyMIEcapySXUtRIc2gQ8VyM9tCygk/vlcqVghz1mZFWpDP/NE2sQeq3qTN0lSdljKwXw1h0Cw==
X-Received: by 2002:a17:90b:1198:: with SMTP id gk24mr6458448pjb.73.1618528668347;
        Thu, 15 Apr 2021 16:17:48 -0700 (PDT)
Received: from nuc.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id a6sm3225936pfc.61.2021.04.15.16.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 16:17:47 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com, Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: [PATCH v3] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Fri, 16 Apr 2021 07:17:42 +0800
Message-Id: <20210415231742.12952-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Catch this during initialisation in parse_taprio_schedule to
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

 net/sched/sch_taprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..abd6b176383c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -901,6 +901,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
+
+		if (!cycle)
+			return -EINVAL;
+
 		new->cycle_time = cycle;
 	}
 
-- 
2.30.2

