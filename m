Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1EFD9183
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405243AbfJPMuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33011 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfJPMui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so14257341pgc.0
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xAh941DP8ktiR8TpFB5IyyTU3oV8SSbRbt7KFFTU170=;
        b=YHcd8Je5jfDScjM7MpP5DIm+v4932NM23bGdn0wJPAA95WoYwuOQiSyaJxyJgYE/n0
         +OiNDZNLYmJgLwajzn/rSNluKVNejHhDsoKqsUCWRDq0Oouxuzk7HA81RR121uT7z4mq
         bT4JErNuIMxzwHuxQ6vlH/yK4RJ6+SIPWfaphjWDOI238R5tdxZjjkZwi+KaGG0XzntD
         DmQSn8Q0vo8UK6pDHXWashqDo8A/I7SaxBFQJf9KBFTGuHtuFN5SVj8J2przkAVGaQAi
         uUuwIFh/vu70zGV60lPH6SxEv4JlZ19S184EopNP311OCy6bZTMFen1fXAWe+2qBt3wB
         FliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xAh941DP8ktiR8TpFB5IyyTU3oV8SSbRbt7KFFTU170=;
        b=EBG0Fgv6otlYUepXQD6YAC1iy7efEKAZ488hwC4CeAJ+z90z0ItWhPdgwWMM561EHb
         /UTiShNsEIqpgsUKviDNXO/LW+Yx0nZRLYuQtC8btqtSqG4ppPn+taCOBXQ2WgNdBjoB
         iICZ6bK0FLoJCAZfAY/RyvGvAzVp7Q8NPlEaI4KhhYL/JOW+ozzWtY/ErKrzyQTmxFmy
         xb2mhTItJwRLaGsX3i+TPo3q8B2XXiU5kHju6LVyYjqE5hYdgE0ULg8OZhdTOj/3ln+9
         tku1I43PD8D3q9lbuvwY7Rm+XlBH+zEneYQ/iG5dGVfMUDI71wiqQNxH5/CJv7b9PelW
         54sg==
X-Gm-Message-State: APjAAAVfXJAzxltMBZGtGtica2MvweU23x9w90ZXJnzCgRt+U5MyB2cU
        /vY/d/unT05rpd322eCDbL0=
X-Google-Smtp-Source: APXvYqw9F+02HcHW2ZsEjmJsdxybp4Mwgu+NFHMH6TRsjFpW/Lek7ziWK+WUzlzobPxNw1HJ8lwh+g==
X-Received: by 2002:aa7:86d6:: with SMTP id h22mr45053719pfo.72.1571230237633;
        Wed, 16 Oct 2019 05:50:37 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:37 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 03/10] net: openvswitch: shrink the mask array if necessary
Date:   Tue, 15 Oct 2019 18:30:33 +0800
Message-Id: <1571135440-24313-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When creating and inserting flow-mask, if there is no available
flow-mask, we realloc the mask array. When removing flow-mask,
if necessary, we shrink mask array.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0d1df53..237cf85 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -693,6 +693,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
 	return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }
 
+static void tbl_mask_array_delete_mask(struct mask_array *ma,
+				       struct sw_flow_mask *mask)
+{
+	int i;
+
+	/* Remove the deleted mask pointers from the array */
+	for (i = 0; i < ma->max; i++) {
+		if (mask == ovsl_dereference(ma->masks[i])) {
+			RCU_INIT_POINTER(ma->masks[i], NULL);
+			ma->count--;
+			kfree_rcu(mask, rcu);
+			return;
+		}
+	}
+	BUG();
+}
+
 /* Remove 'mask' from the mask list, if it is not needed any more. */
 static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 {
@@ -706,18 +723,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 
 		if (!mask->ref_count) {
 			struct mask_array *ma;
-			int i;
 
 			ma = ovsl_dereference(tbl->mask_array);
-			for (i = 0; i < ma->max; i++) {
-				if (mask == ovsl_dereference(ma->masks[i])) {
-					RCU_INIT_POINTER(ma->masks[i], NULL);
-					ma->count--;
-					kfree_rcu(mask, rcu);
-					return;
-				}
-			}
-			BUG();
+			tbl_mask_array_delete_mask(ma, mask);
+
+			/* Shrink the mask array if necessary. */
+			if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+			    ma->count <= (ma->max / 3))
+				tbl_mask_array_realloc(tbl, ma->max / 2);
 		}
 	}
 }
-- 
1.8.3.1

