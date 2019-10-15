Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60041D918A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393344AbfJPMuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43170 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391456AbfJPMut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id a2so14662169pfo.10
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kP585WOSESkrGweaLhfk1ecnyRlG66kJBicCGup0/PI=;
        b=OfZMOitLpJk4SUuFegpXZ/9eFU7GAic/3SxPx6J+HEjibshbXT8OTCdOWc/TudjP7k
         lPK2v+4R81EChyo1KNQun4/t0mSxvixcn08CScvma/DD2cJ0S6xUnuli/ctViMITZrG8
         GXXltb9Xl/hKShioJqoo5A4KpFHtslryDM6U4vXB1GNhsY3nWcs/Bm7PCu6FzK6a5F6C
         6Bfkp/4xua/dicuD1KcN0KOSXSmio25h5mamwcH95Hqib8UTk7bQI71gDUJn1Tz4iTiM
         W0DGim6UYL4uORU5lKmDRrq4DP4NLP0Yp6R2E0tPgyu9H/CKHkDoO+iszLYkQATWd2wO
         BHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kP585WOSESkrGweaLhfk1ecnyRlG66kJBicCGup0/PI=;
        b=eRYuvOeRGeTlZbQWLu8GfnmYCOS1376MUrwdL6LlkcEdoqqFk+w+bowqaDY+sWi3qi
         mgb/YfiCsTj+mj8hOOD3y4xE0z4SlG16bT4o2/RyOaak/DDzASrvjymDWJOcBd0k2cVs
         J4rqmjk9J4lHlrWwMPocQKx64phDVDDB0IdpBBrUyUxnCBwv3WF3gsZYwoAvOt038Dm6
         tybTJMe7BekQO8sBzf09BjjxMK7nJRgC1qaKsBB+CcIuH1DVS5KHhwlaHAKI8Qv6C6mx
         WJhOyHNjOxBo0nRPxcQnKMiLSMtF0tF602hKw67VsWUuZu9nwa+eR2wuUu+44M60iryO
         SgWw==
X-Gm-Message-State: APjAAAUnzKNK0X+6QSyScEr8QTdE/o8y/COnGakLTa326gUm+OXkNYRY
        hojvzQ2lMRd6NNcQ1PC4Vug=
X-Google-Smtp-Source: APXvYqzFMD474lxcczA3J3Hm1jhOpIk8wdKgQnZM0107qdECi4p6i0wWJXkWrM4Gk6uSZYLFynY+wA==
X-Received: by 2002:a17:90a:eb03:: with SMTP id j3mr4981956pjz.88.1571230248745;
        Wed, 16 Oct 2019 05:50:48 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:48 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak on destroy flow-table
Date:   Tue, 15 Oct 2019 18:30:38 +0800
Message-Id: <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When we destroy the flow tables which may contain the flow_mask,
so release the flow mask struct.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 5df5182..d5d768e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
 	}
 }
 
+static void tbl_mask_array_destroy(struct flow_table *tbl)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i;
+
+	/* Free the flow-mask and kfree_rcu the NULL is allowed. */
+	for (i = 0; i < ma->max; i++)
+		kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
+
+	kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
+}
+
 /* No need for locking this function is called from RCU callback or
  * error path.
  */
@@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
-	kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
+	tbl_mask_array_destroy(table);
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
-- 
1.8.3.1

