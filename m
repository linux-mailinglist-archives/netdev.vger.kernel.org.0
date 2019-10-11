Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB8D423F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfJKOGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:06:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39645 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJKOGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:06:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so4522655plp.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zlncg77ADu0xAcw2vtCSP/bdmGQFS+owGP7y9buZ2oo=;
        b=XNrlUpRldNYuMPajsX1IuRPts03eEc70J/gKHCs7BLn8fTVGI7qtbLpyDQqafwYXcB
         ADBvUOn3ZnDg5fJxwX3ftDeUMNUTc+kJiEmMd0FCuAe22ZTA8ScImx4eTBZVwj8PWgtY
         0FRBL5X+GaxsoiN2zoV/6U3WULKJdhH5WTDIv6mCFg2PMvOgOVf+hLCELZeRFKjr5ZLs
         5MlFQwYQsKNvEyB6NAtht2tLGvwCvG2sJ+0bppNwE6ncXSed0t731NW5spXQD6J3trhn
         DjcI3uZqTv/zyfl62kbsGtkamjUU0Q3hpjaADtXprKSS6j3csWVpZOIFUVwMK+jJ26GZ
         KYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zlncg77ADu0xAcw2vtCSP/bdmGQFS+owGP7y9buZ2oo=;
        b=JbHV79Xy+Ff36m/Ir11NL5kE/8w7j62PkTFVRXb1pc8tzajqDNSfGb9hb8DjU1638G
         dh3l+tTo9LT87piLSr+brldKGp25/6afFAmZlQRep2LpnBapUbrAxMo+wFONMYjkJ6kL
         wXFMqiUb028GiMvCGwdmJ1UFEblPXSD77/Bpe6NO7oamMgp2gooeT+N04fHjbTJJ7Ou9
         M0hk7Xp1/QzvIBG5+zw6CL0sY8kvdUB/ihDE7yYRXQT1M1zBZm7wdDNirxTj6ldxLM99
         6kNfllK3OgDbXbgVLdBk5pXECrGy5oEImt33CM+2K/8hh8E0EXFr/8RBYrr6n/1p66VZ
         D20A==
X-Gm-Message-State: APjAAAUDIaXhztZjPexz1X05pUNI109HmeTczH0Zfvb+dzFObMFlLJr5
        6FlJnA4B2yFSR15IPPW6gWI=
X-Google-Smtp-Source: APXvYqxyCS4MO4gaF667vO/TXWgHomaVa0gQYRgh++EfEFtPjTNMZk73bdl44ZhY3R/oD842OapTCw==
X-Received: by 2002:a17:902:8b83:: with SMTP id ay3mr15031786plb.269.1570802766522;
        Fri, 11 Oct 2019 07:06:06 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.06.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:06:05 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 08/10] net: openvswitch: fix possible memleak on destroy flow-table
Date:   Fri, 11 Oct 2019 22:00:45 +0800
Message-Id: <1570802447-8019-9-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 1fc6be2..0317f1c 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -293,6 +293,18 @@ static void table_instance_destroy(struct table_instance *ti,
 	}
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
 /* No need for locking this function is called from RCU callback or
  * error path.
  */
@@ -302,7 +314,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
-	kfree_rcu(table->mask_array, rcu);
+	tbl_mask_array_destroy(table);
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
-- 
1.8.3.1

