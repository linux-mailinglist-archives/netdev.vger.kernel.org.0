Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB37FC1A20
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfI3CJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38448 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbfI3CJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so2819359plq.5
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fKkPfxwPiJP7/KUjVDqoH89/DSdrM52RI3ZG4KqqgR0=;
        b=nFvSJ9HncOZA5a0j+1cvjbI0qLxOX69Lswb17JlfcN2UUfYO9pwD7FE2q40PBwKWri
         px9e76s2lCeVuReq339dI0btYP0hdXQ/wODmig2J/U3OcaTJqjNIjdT/cEKyvBiAVh/3
         Ml5hYEBARUbtKbHL9xru1+466TRTEzq832Uhj0Vya49pKWPAeOqCk822SMyGE3MFesuq
         J4pnXR3HKvbYM+bYgk74Q0RmHlW/2ve6qknG1u6AeeSNc2pS649cT0qCkAywhsKfJ0Df
         v/XYgnNyNWrODIqYerdyK5U7ydVEXoliCExM5y6WtC9pcQ1cAph6jhKca9YqxaNaAfs8
         a0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fKkPfxwPiJP7/KUjVDqoH89/DSdrM52RI3ZG4KqqgR0=;
        b=hNanipXbRDCPHQK55qDRRZ42oB703WV+cRIqzd1vyuMBVkzfwFLb+lZF6CmEUjIxoJ
         gudAH0/EhsOGwo6D8cCdh4046AvxlCKvL7FiKdC45OMpN/CcuWIYWYXZDfK+3iLj1I7c
         jffxlxFMAWv1UaJXRa6TsAwwfcN3Emv2waEJy3qgMvfG3H1xokUZkxiOEMcxc0UbhVDl
         pIEq7DPrJCFC3hrJImaF24O5TpExEvLZZI9ZFYSGGBGjmyEgWq1S37HLaGO/CFsjf0tN
         i+Hm124/sXV7zYol81RVC95T4zaWp5s68xS83tqOcqpcFsY+RNraAdNHEr08BF3mFF3z
         XGQA==
X-Gm-Message-State: APjAAAVgUL7ICto3Fyx93OEug3/VBHucCMSdU0IoGl01H66O6l9G/fR9
        OVAreuD8fWQYQFGieVH1k+c=
X-Google-Smtp-Source: APXvYqyFNSyPPymBRtoeW3Z25Tcv0q5SO/V+arKJwS1SAcpfyugHLhvVzxDATArHlvi/71QH5i3jkg==
X-Received: by 2002:a17:902:b08f:: with SMTP id p15mr17970210plr.158.1569809355099;
        Sun, 29 Sep 2019 19:09:15 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:14 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 8/9] net: openvswitch: fix possible memleak on destroy flow table
Date:   Mon, 30 Sep 2019 01:10:05 +0800
Message-Id: <1569777006-7435-9-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When we destroy the flow tables which may contain the flow_mask,
so release the flow mask struct.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index c21fd52..a2e0cb1 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -218,6 +218,18 @@ static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
        return 0;
 }
 
+static void tbl_mask_array_destroy(struct flow_table *tbl)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i;
+
+	/* Free the flow-mask and kfree_rcu the NULL is allowed. */
+	for (i = 0; i < ma->count; i++)
+		kfree_rcu(ma->masks[i], rcu);
+
+	kfree_rcu(tbl->mask_array, rcu);
+}
+
 int ovs_flow_tbl_init(struct flow_table *table)
 {
 	struct table_instance *ti, *ufid_ti;
@@ -312,7 +324,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
-	kfree(rcu_dereference_raw(table->mask_array));
+	tbl_mask_array_destroy(table);
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
-- 
1.8.3.1

