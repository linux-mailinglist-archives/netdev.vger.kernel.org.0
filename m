Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42ACC182887
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbgCLFmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:42:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36698 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbgCLFmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:42:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id g12so2200617plo.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 22:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TV8MdPaIq7Pp+qOxudbUEj7RwbxisBpxTv0YtNnz6I=;
        b=tfg+Bc3vC7g9dFghZOTHpNeu6WHKUI3JWBbqvFzcB5qNNMdqy45UTrtw30xi5YsTZD
         Flq+4HfGjQOlC3CitEEArdXvi+74kHqC2GpeVM/5yKpBBUg82RBH7IyMuBwtDRjuIMAM
         wU4ij7yeuV8xUAeY6bWeFqTiZfQJiW8JdOxUNEgTjiwAoRu6TaCnT/RecgUKrcXXFDJT
         HKhYdQFRHCA3mXkmDnNwcCdz67xvLxGnMvyxB1zIIhC/qd1fAEK67rvZ8bCZzloewhiY
         WRcYH8HS37zlIZITJXE4km2nw2wIB/WupMAfJBLzU64x8CN9iKyx1fLzn5JagPV02Au+
         mENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TV8MdPaIq7Pp+qOxudbUEj7RwbxisBpxTv0YtNnz6I=;
        b=nya359d3DlS48AYFmbnoEBnPG0oPlKrLLfUoj29c+luUEtackXdv2SG0Jvt50KhTtF
         AgdHY3pE+b7B9D6zDNDX11QgPEKGAVl3q9vqgsuF0C2Y6oOOM3XparfRWozZeaNArmUB
         REjchhZ6xZhUavmcVnF3lElRghxM8N7MnWQGkia8rXRvVOoy1gxPtnavluSRrcVXOZoN
         36KxAXwCjiIK2nN+ykgC/fWLRBWnmdKAKve7jYZMzXy/hDthBTomKHIeK5Rn6ZdQranC
         STAo3dpP9u9XCJ0Plzr1cfaIhgMxWfgqEcar/SBzTVX239Ru2inobSsWZ3u7S2GEgUrg
         HkoQ==
X-Gm-Message-State: ANhLgQ05Dd41tLTDF6fpuS13HpkdE7QAGaQIw8S9gQMxy8vjVe2Ue+Nh
        o578/dGjfBCDRTSD2a7t3LFM/jIBrpw=
X-Google-Smtp-Source: ADFU+vuv3aaSpb75jPBRmt2puUztLFh9d3AiQTIcGe1o7oCi0RMW2v/6pk3CozoXVDiX1+JYf8wjxw==
X-Received: by 2002:a17:902:b208:: with SMTP id t8mr6674569plr.60.1583991772083;
        Wed, 11 Mar 2020 22:42:52 -0700 (PDT)
Received: from tw-172-25-31-169.office.twttr.net ([8.25.197.25])
        by smtp.gmail.com with ESMTPSA id q21sm55226439pff.105.2020.03.11.22.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 22:42:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+653090db2562495901dc@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: hold rtnl lock in tcindex_partial_destroy_work()
Date:   Wed, 11 Mar 2020 22:42:27 -0700
Message-Id: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a use-after-free in tcindex_dump(). This is due to
the lack of RTNL in the deferred rcu work. We queue this work with
RTNL in tcindex_change(), later, tcindex_dump() is called:

        fh = tp->ops->get(tp, t->tcm_handle);
	...
        err = tp->ops->change(..., &fh, ...);
        tfilter_notify(..., fh, ...);

but there is nothing to serialize the pending
tcindex_partial_destroy_work() with tcindex_dump().

Fix this by simply holding RTNL in tcindex_partial_destroy_work(),
so that it won't be called until RTNL is released after
tc_new_tfilter() is completed.

Reported-and-tested-by: syzbot+653090db2562495901dc@syzkaller.appspotmail.com
Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 09b7dc5fe7e0..f2cb24b6f0cf 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -261,8 +261,10 @@ static void tcindex_partial_destroy_work(struct work_struct *work)
 					      struct tcindex_data,
 					      rwork);
 
+	rtnl_lock();
 	kfree(p->perfect);
 	kfree(p);
+	rtnl_unlock();
 }
 
 static void tcindex_free_perfect_hash(struct tcindex_data *cp)
-- 
2.21.1

