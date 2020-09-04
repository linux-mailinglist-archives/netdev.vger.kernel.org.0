Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E425CF4D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 04:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgIDCK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 22:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgIDCKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 22:10:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F96CC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 19:10:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls14so2339585pjb.3
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 19:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zECbT+t/mcAXqmfE8iAPF2XKZMS5eYT/uylVsys/qcs=;
        b=GZ5d5hF9qRHWmErAuGshYmqkc0ZEIq0vfRz2/hZ6d1KmfytOR4hjXr0CPaAgQU/Ygs
         9X1xvjjhRtxvg8z6ogBuJR9C1SLz7HASLY6wXpFSszj2xEL2YDZ2/aEwcoy1CmlRQem0
         9sHQxiSFTOHfhhZnz0RMZpu+sTtymfTVphveTw9v+B2PbKZIMMdcxaqIMWpThtjemO82
         J1FmvMHIh5evEYRjaf56S3cFo98LgOCcfTCyFt7TjPr8FODjfmHqSBhSGI3w+lPIbxbK
         RnCcoN59N+iQ9faeFNmyUtbQG0vuJNBq6cyH1VeLhF8NVajMKWa9MSDt7gm/AEApGy1F
         zN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zECbT+t/mcAXqmfE8iAPF2XKZMS5eYT/uylVsys/qcs=;
        b=nln/ROpOdyljQopmuFf0cmMmarW7cbUS6YaCbgVbxy1rcrF1/C9+nJOXL8Es1ii3zs
         QZOSnIMKE+JTdIsC0CaC99XdLYuFMEKb+x48HEOEz2XxZaIgEjwj0B/wcTHQdT5h/wZL
         adP1XjWN/zgH4mTjJjwwDQ3lRvCpTz7+zF6hgYyz1hFtZrNE+5IyrHZYAjYweMjzp12h
         /pi4QKcJjvo4rcwAR28NJXnfNNsLKHv3rCxugcu5CmhfXlYdMS0WlVQEoxK1e4vYqIbB
         MqW0V8jjR5lDH393uLh7qilfvH+YHg9giG4FYjsIIdY460DikdQzibyRZRTm8zTwdto7
         mIVg==
X-Gm-Message-State: AOAM53058Hs6Rk1833xaDKN9IGT0nmxhn8ZgUT+AqGZR5Zff+osnQDQ0
        hfEsJckAn41O23s6iIshv4OrAEUeEBWHQg==
X-Google-Smtp-Source: ABdhPJzf6xvHGCJvDES/VxZrfih34E7AsEqlDVlztOi+ZyY+54fdtSt86LiJVgHj2N7EOdT45XlNqw==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr6586108plo.193.1599185423785;
        Thu, 03 Sep 2020 19:10:23 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:727f::2e])
        by smtp.gmail.com with ESMTPSA id h14sm4034275pfe.67.2020.09.03.19.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 19:10:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] act_ife: load meta modules before tcf_idr_check_alloc()
Date:   Thu,  3 Sep 2020 19:10:11 -0700
Message-Id: <20200904021011.27002-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following deadlock scenario is triggered by syzbot:

Thread A:				Thread B:
tcf_idr_check_alloc()
...
populate_metalist()
  rtnl_unlock()
					rtnl_lock()
					...
  request_module()			tcf_idr_check_alloc()
  rtnl_lock()

At this point, thread A is waiting for thread B to release RTNL
lock, while thread B is waiting for thread A to commit the IDR
change with tcf_idr_insert() later.

Break this deadlock situation by preloading ife modules earlier,
before tcf_idr_check_alloc(), this is fine because we only need
to load modules we need potentially.

Reported-and-tested-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_ife.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index c1fcd85719d6..5c568757643b 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -436,6 +436,25 @@ static void tcf_ife_cleanup(struct tc_action *a)
 		kfree_rcu(p, rcu);
 }
 
+static int load_metalist(struct nlattr **tb, bool rtnl_held)
+{
+	int i;
+
+	for (i = 1; i < max_metacnt; i++) {
+		if (tb[i]) {
+			void *val = nla_data(tb[i]);
+			int len = nla_len(tb[i]);
+			int rc;
+
+			rc = load_metaops_and_vet(i, val, len, rtnl_held);
+			if (rc != 0)
+				return rc;
+		}
+	}
+
+	return 0;
+}
+
 static int populate_metalist(struct tcf_ife_info *ife, struct nlattr **tb,
 			     bool exists, bool rtnl_held)
 {
@@ -449,10 +468,6 @@ static int populate_metalist(struct tcf_ife_info *ife, struct nlattr **tb,
 			val = nla_data(tb[i]);
 			len = nla_len(tb[i]);
 
-			rc = load_metaops_and_vet(i, val, len, rtnl_held);
-			if (rc != 0)
-				return rc;
-
 			rc = add_metainfo(ife, i, val, len, exists);
 			if (rc)
 				return rc;
@@ -509,6 +524,21 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	if (!p)
 		return -ENOMEM;
 
+	if (tb[TCA_IFE_METALST]) {
+		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
+						  tb[TCA_IFE_METALST], NULL,
+						  NULL);
+		if (err) {
+			kfree(p);
+			return err;
+		}
+		err = load_metalist(tb2, rtnl_held);
+		if (err) {
+			kfree(p);
+			return err;
+		}
+	}
+
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0) {
@@ -570,15 +600,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (tb[TCA_IFE_METALST]) {
-		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
-						  tb[TCA_IFE_METALST], NULL,
-						  NULL);
-		if (err)
-			goto metadata_parse_err;
 		err = populate_metalist(ife, tb2, exists, rtnl_held);
 		if (err)
 			goto metadata_parse_err;
-
 	} else {
 		/* if no passed metadata allow list or passed allow-all
 		 * then here we process by adding as many supported metadatum
-- 
2.28.0

