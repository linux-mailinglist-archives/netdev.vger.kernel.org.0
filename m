Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7546D6A1DEA
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBXPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjBXPBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:01:45 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACECF64E16
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:43 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id e18-20020a0568301e5200b00690e6abbf3fso4177385otj.13
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0obhCuDA1PsXbdcbrvPmXpL3uFKPlbV83fHeosYiHM=;
        b=c2zjpnsxNcY7YYvaZ4hAQqbOspu7mZ7cRGzvTfaVtX++5/7IPSNNKaRUgiWhAy53oJ
         gBb8PJz6C74KUVGhFKhJK346GoGE6x/uBPNIRtEl9HGpGfWrf7ZNcEBaEw6sa9rTeJkY
         toNLpw6GLqb48e9w/EGoxZyE+CYykudt8Db+iZSqmPJveCdH4ApFJ91VDZnuQIkXnIjD
         Up7WPkaSCUXzPnj7Jxdo0HkbsTKFd8CbbiQDjuYGfrh6g7P5dCK3LciswyRszhZbu6eK
         650k9xesr/G8LvTXkk65WAkEiSsCRRlkvQkyy820irzF4m5eRkOWX4ujBopFP9bzA1vo
         WrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M0obhCuDA1PsXbdcbrvPmXpL3uFKPlbV83fHeosYiHM=;
        b=6mgAXvI0A7NIHYkkWiBKTkXwMpwmVETwhkWxuhbxH6NgBKkg4XYX+qOAs469x5vH6v
         WQf0lUseOQFrl0a0y4O1WuoeEtLuPVzOMiZG8gVG9XynKeTtnP3ODpqV0C8AAukNhLw4
         DWhnGnL88dNJydCO9L4BTXMgff5oZaB+MVeR3F8augLRJ0cKNo/YOmL4Z2fuVdMllVz5
         pYS+7l3MlNFNh/AqjXFFk7Vmd5J6wH9Gp15scP0ts78KKI86xo/WI/pEMaG0cF7/e7OF
         2aHOyhA7c/ulX5Kq0NFzTGZebqm31KQjg9hiTicVMBSXVW0C+lFU+I7kcJmPBGsBkVYP
         H1rQ==
X-Gm-Message-State: AO0yUKVgQhdrd39L4Gcfn8PCJW8cz2FbnJM8m/e6yvlD7yf7dq/D/Mtj
        9b9IwbWblNmb++7CXr37jU+eRtwqXbpnl/0A
X-Google-Smtp-Source: AK7set+831aiONqBrIVCHza5NCbJXeVTQqC38KicMSrLozGIxK/jHt+MY53vtl4X78IJE272SpYQ3Q==
X-Received: by 2002:a05:6830:1f2b:b0:66c:cb4d:3498 with SMTP id e11-20020a0568301f2b00b0066ccb4d3498mr4252733oth.27.1677250902779;
        Fri, 24 Feb 2023 07:01:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id r28-20020a05683002fc00b00686a19ffef1sm3237636ote.80.2023.02.24.07.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:01:42 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, yotamg@mellanox.com, ozsh@nvidia.com,
        paulb@nvidia.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net 3/3] net/sched: act_sample: fix action bind logic
Date:   Fri, 24 Feb 2023 12:00:58 -0300
Message-Id: <20230224150058.149505-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224150058.149505-1-pctammela@mojatatu.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action sample ... index 1
tc filter add ... action pedit index 1

In the current code for act_sample this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..29
ok 1 9784 - Add valid sample action with mandatory arguments
ok 2 5c91 - Add valid sample action with mandatory arguments and continue control action
ok 3 334b - Add valid sample action with mandatory arguments and drop control action
ok 4 da69 - Add valid sample action with mandatory arguments and reclassify control action
ok 5 13ce - Add valid sample action with mandatory arguments and pipe control action
ok 6 1886 - Add valid sample action with mandatory arguments and jump control action
ok 7 7571 - Add sample action with invalid rate
ok 8 b6d4 - Add sample action with mandatory arguments and invalid control action
ok 9 a874 - Add invalid sample action without mandatory arguments
ok 10 ac01 - Add invalid sample action without mandatory argument rate
ok 11 4203 - Add invalid sample action without mandatory argument group
ok 12 14a7 - Add invalid sample action without mandatory argument group
ok 13 8f2e - Add valid sample action with trunc argument
ok 14 45f8 - Add sample action with maximum rate argument
ok 15 ad0c - Add sample action with maximum trunc argument
ok 16 83a9 - Add sample action with maximum group argument
ok 17 ed27 - Add sample action with invalid rate argument
ok 18 2eae - Add sample action with invalid group argument
ok 19 6ff3 - Add sample action with invalid trunc size
ok 20 2b2a - Add sample action with invalid index
ok 21 dee2 - Add sample action with maximum allowed index
ok 22 560e - Add sample action with cookie
ok 23 704a - Replace existing sample action with new rate argument
ok 24 60eb - Replace existing sample action with new group argument
ok 25 2cce - Replace existing sample action with new trunc argument
ok 26 59d1 - Replace existing sample action with new control argument
ok 27 0a6e - Replace sample action with invalid goto chain control
ok 28 3872 - Delete sample action with valid index
ok 29 a394 - Delete sample action with invalid index

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_sample.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index f7416b5598e0..4c670e7568dc 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -55,8 +55,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -80,6 +80,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
-- 
2.34.1

