Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F120AD06B
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 21:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfIHTLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 15:11:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43828 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbfIHTLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 15:11:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id d15so7772450pfo.10
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 12:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lbvqfnmU1+Sd8BWq6gEXVinEXtFd5/g+iIwEjQOprAk=;
        b=KXM9zl0kFgonFvPyYfMRm0bUnaBg4u3G+XmF4TKxCZmNXVwxMdt2trjgYDrSvqOgS2
         KFtcnQR00RY44/FTapoM8Tzc5hQJO8BmKhVLvRjC3VOogk9Y2+Zj484d8BHBumAkbDvp
         XmmWbTFj7nsHSK3Bksl275PrY08wkn/b1+81M1tuGI2/ShcE3HUeEEcKNVuJe+3LTpSi
         LJhWJROh3gmZ/ZeWX5Iti15zn3yjO/qkXt7DlKqW1VdTsOFgfrZRqw4ItoA3btz4aoQn
         VPbCXEh/qHUbctr0BCiYci5AYr9rwvSf5BVtOF7KGw0q9KFi4HvOt4C+sm/DXhv4+rC7
         qj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lbvqfnmU1+Sd8BWq6gEXVinEXtFd5/g+iIwEjQOprAk=;
        b=D5wYapg/JoBJ/f+j+meBUp/4iFtXshJADBj/S/IC2p2l7OkKr5ANizKXc1YOOXtlIH
         G037SfvJ4VfHJbTCLuPHht24BPbRKImg5S56v1f4/MsBTayvSUzgcqFHZ/Pz3Om8hCcc
         q8Z8R6vH9eKWBatZj09UFEOFkMjcP+Vbl4PBE7qOeScvWkjndEtKUyxLn8IQlAuqf6UY
         MrF0lcso6QI836K8XxSHxZeRbTOH4ofLpDdO9W0Df4wJ6OfEc3EGRdAo7N8bDPSBacZY
         dEPe/8/w4Cc6kJ/nvNsDWszEjnG0889uEkDBfAVc5Dpg9HaKA9IXYWyzIKx1Q5OjCVKV
         XR4Q==
X-Gm-Message-State: APjAAAVGv2inqZoDpM+WwSc0oM5FV+0WTGbBNNG4gUGNzIlcqGfuFf52
        ZsASTUq/FcGNu8absAyLwiGD2+4j
X-Google-Smtp-Source: APXvYqzPOSWL7rjxZ0FDBcj6spJVx/NxiZ6f0IKLNKjWxQfTaOuZrQ1SqZnkYSsSdTAJqY3rrGyklw==
X-Received: by 2002:aa7:8255:: with SMTP id e21mr23591400pfn.82.1567969910085;
        Sun, 08 Sep 2019 12:11:50 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id r3sm12721654pfh.122.2019.09.08.12.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 12:11:49 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: check cops->tcf_block in tc_bind_tclass()
Date:   Sun,  8 Sep 2019 12:11:23 -0700
Message-Id: <20190908191123.31059-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least sch_red and sch_tbf don't implement ->tcf_block()
while still have a non-zero tc "class".

Instead of adding nop implementations to each of such qdisc's,
we can just relax the check of cops->tcf_block() in
tc_bind_tclass(). They don't support TC filter anyway.

Reported-by: syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 04faee7ccbce..1047825d9f48 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1920,6 +1920,8 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 	cl = cops->find(q, portid);
 	if (!cl)
 		return;
+	if (!cops->tcf_block)
+		return;
 	block = cops->tcf_block(q, cl, NULL);
 	if (!block)
 		return;
-- 
2.21.0

