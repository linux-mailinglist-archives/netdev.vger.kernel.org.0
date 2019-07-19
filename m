Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843656D872
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfGSBfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:35:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37336 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfGSBfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 21:35:22 -0400
Received: by mail-io1-f66.google.com with SMTP id q22so55104138iog.4;
        Thu, 18 Jul 2019 18:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LFMdlVDVoG2vngqAx5KfPoDogF54JsJ1SkC8LEDmpMY=;
        b=mygJEBCqMvxFVg8D2m0rB7KCR1qmd8F6BTvw1VZK5xWWfK7xltwWqiP0CDcc3OVGy9
         sv3NszUTqD8MvwzTmRVWVq1Me3CVormUEvIuSUjyc6hUkCYWnlM78GHUC1PoDLX4DZfa
         6fWt+DYwJraq6hrtDNIx41fSIP3ITVfmIBRttkNwSqG9BDnI2sL/WOB0zMnpErQlWL5Q
         ne/UKEHp6Ad5DCqTfYWHAvwE+dB2HO5gddZJvF+SHP6hXL3mbN5RLKeUs6tsdmjBE9o9
         XOqQGFDeH29neSYSCTY/8ntijVC8K9jJoG77YA2sbfZ5FW9P3z3gHxyv3jQ3fRCEgPsX
         PyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LFMdlVDVoG2vngqAx5KfPoDogF54JsJ1SkC8LEDmpMY=;
        b=MA+iWZEENbFPhWCHUpUPF/pOGgo7HjC4B7dSnPvpRFSIXsuoXwQ0XQ9wwJx7oYVHWe
         aBPKPH2T4gWY72OB3qUknKcFbs3+jYi7rtuaSg7OR9gEgCWsKcVgcWa1Sbh+SnvB9XXY
         ykZB47zZBsa8sCZ7r45r6TIlBXdyuLfECUX6SYFtejyunipf7dbN2nKd8PywEjo5d8QV
         QTFURKB8C4k4kCeYA6Cb0nfEGE6y1wId61UNbnvDKcWThfkh1SbU61WwG80RaK0aJyAl
         29VPFi3tUySYoKjkG/rRAtMi/ENNd7+GqKrvjhsR+Tm61v4RN5BQoVcwQDj09Ttgf15i
         3XNA==
X-Gm-Message-State: APjAAAUBmMwJG+XMGLITZEOHVDqTuH1ISHMfgemBRXi0tNcHTqdBTB3O
        W7wCjlCueB47bsJVNZSvUas=
X-Google-Smtp-Source: APXvYqws5vo3/lnmqL2c42/a+WVl6Iqbf3LgBwU88DtSzzMv/mAEy+AVsDlMVGAFmM7euBxZHykjqg==
X-Received: by 2002:a5e:c70c:: with SMTP id f12mr2670082iop.293.1563500121335;
        Thu, 18 Jul 2019 18:35:21 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id k5sm33692912ioj.47.2019.07.18.18.35.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 18:35:20 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sch_gred: kzalloc needs null check
Date:   Thu, 18 Jul 2019 20:30:26 -0500
Message-Id: <20190719013026.24297-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call to kzalloc may fail and return null. So the result should be checked
against null. Added the check to cover kzalloc failure case.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/sched/sch_gred.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 8599c6f31b05..5cd0859f0274 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -697,6 +697,9 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
+	if (!prealloc)
+		return -ENOMEM;
+
 	sch_tree_lock(sch);
 
 	err = gred_change_vq(sch, ctl->DP, ctl, prio, stab, max_P, &prealloc,
-- 
2.17.1

