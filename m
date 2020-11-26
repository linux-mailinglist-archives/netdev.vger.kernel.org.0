Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF72C2C5C16
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 19:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391670AbgKZSlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 13:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391551AbgKZSlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 13:41:03 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE227C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 10:41:02 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id y11so1309426qvu.10
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 10:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3SFEGwubfMyOkGFhEqYaAJv1k3uNxPZvPp5/hsmGoM=;
        b=H/l43Nq1oqmsMaWcSZneW/UD+Mg2qdRIMfmThcSlu4bY/N4prhaC9WwuKXKZNhHr3V
         bWgg5LSsiY74y4RsEi/FR//6wzzH3xoECmGW6Xa8hgMKB3VEimKGkgukNav2mUFwQS/n
         GM8NDADi+NY0wAfT+A24lpHfcFfWU+26Ku2wQwE8ed1x0wx0kea/qsmAJfcaAXSitC2U
         HGpyPEzPnWRRPOg5HN3r5Bapn838EjiHJalYwKCQdivpmBJvOyfL70e+QgJhXFlyJ9er
         zorRG08Vnnt3DpRxdO2mqo5BtCPvAq/U4XX4veqm6RsI3XCcYtTZpNX/fQbWQg/oKui1
         ulBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3SFEGwubfMyOkGFhEqYaAJv1k3uNxPZvPp5/hsmGoM=;
        b=J1EXPvc/myEAQ3/8bWsMrzxrpxgwCn64CfLs9Iv0v1su5DNd8jsG6OYMkKplgX/ScT
         0sAa+JwgAtwdZq9499X948eKpADyxtgs6CYJK/abfs+qq9lFOw0U/Nix935iH1vfsScz
         12QINBhyLKlp+s676i/QgWtg7j0WAj1AeCk2V7PTZFzKycrVN57CSIQL6HnaghyfhRHv
         LubgK5iJvIEeSscM0BrLiTzPyy1JIa4HCEP3FLlc0dua3FmY2YECefO3Qn/X0raqWq3g
         cpocT+n9IcmuxLXJ53X6ZrykRQMBv+A/C9B5wuIOj4lp2Je7AkbYnRFmwG6zaFOhrwIq
         W/VA==
X-Gm-Message-State: AOAM5321qUSQuEpGU0ew5cS1a0N9xd9xDPtJ/TO3IzYs/ljMuVr10nmf
        L7WHd0AQ993T2AGoZRcuBSIjf7xNXgqd+A==
X-Google-Smtp-Source: ABdhPJzZP+0Oyp4QpcCyt0hg07smbbKdfcDJSErVn/egPhgEdF5ob5ZO0DofAkGDkl2psJYUoS2C9g==
X-Received: by 2002:a0c:f585:: with SMTP id k5mr4417839qvm.13.1606416061851;
        Thu, 26 Nov 2020 10:41:01 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:a9aa:d5fd:a8e2:2c56:68bf])
        by smtp.gmail.com with ESMTPSA id n41sm3347488qtb.18.2020.11.26.10.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 10:41:01 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id BCACBC3B6C; Thu, 26 Nov 2020 15:40:58 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     wenxu@ucloud.cn, paulb@nvidia.com, ozsh@nvidia.com,
        ahleihel@nvidia.com, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next] net/sched: act_ct: enable stats for HW offloaded entries
Date:   Thu, 26 Nov 2020 15:40:49 -0300
Message-Id: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
offload") are not effective when using act_ct.

While at it, now that we have the flag set, protect the call to
nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
nf_conn_acct for act_ct SW offload in flowtable") with the check on
NF_FLOWTABLE_COUNTER, as also done on other places.

Note that this shouldn't impact performance as these stats are only
enabled when net.netfilter.nf_conntrack_acct is enabled.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/act_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index aba3cd85f284f3e49add31fe65e3b791f2386fa1..bb1ef3b8e77fb6fd6a74b88a65322baea2dc1ed5 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -296,7 +296,8 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 		goto err_insert;
 
 	ct_ft->nf_ft.type = &flowtable_ct;
-	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
+	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
+			      NF_FLOWTABLE_COUNTER;
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
@@ -540,7 +541,8 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
-	nf_ct_acct_update(ct, dir, skb->len);
+	if (nf_ft->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(ct, dir, skb->len);
 
 	return true;
 }
-- 
2.25.4

