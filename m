Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C938ECF8FF
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbfJHL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38233 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so8358513plq.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZDaNu1UJOIWG3UPQhPVQwUn1xUPnOJrO+o80ridJwGY=;
        b=vAlkPtwo+HZOJKhbOlqgVYl9DPyGlkbJEBReEYQzGN4x20qWPnqARLx4CdtSdEarCc
         Zbml+f9Bvw8pmDxfnz3WGIA4Esg2TkQ2c4J9u3ngbRzgQEcqIzF1LUH0QWfxLzK4P+7x
         sJceP8ElVxJKByAFc0Ju+LSNrIr2dMIMdSENgADJhE0/42/F42i4bdOdSK4hBw7DjcRl
         JCA/CnzD2OljiODHPePHmJJnR+OpXpIfDAkPKtI46NGPToFX6QNpGYjdIq6j/zIzlkhN
         o7oilEe8QbPjPLMgtf6nEcI1WClZxMKhV2dd3sVDFIUvpI1UriWwPV/XsPMdjlMm1roD
         lBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZDaNu1UJOIWG3UPQhPVQwUn1xUPnOJrO+o80ridJwGY=;
        b=I50+OndROQ1nnj+A/UCTxIpLEtfciZetjfw7JvCFg9cxA02w7NldJ/xA5eqszeKRoG
         1RyU4kyTzltIh8+P8NwCmiim+yTn7ZaktW8BEMS4lcKPVZc3sekfna45YMOtMLDop43i
         fgix0PBkCESZKUHsGgsvJIB5Etauj6O9XBj+dg194Sb9Mp+E5aRGZsDyElaKMGt+3eTa
         o3AWo21on2nVSoCmPaxwaUVa3qoQMaISehNHgy+k6uMZwbIEKd0fCLt4zeDR0DpYJro0
         D5HhWIfO2izpKSIFd/vz/O5R79CYSYbm0QKiz6RCiKxjSiAxJWJ7cbQIjX2nl/USEBYL
         NCCA==
X-Gm-Message-State: APjAAAUnRYIUmLJqbzg8Yn3ZQ8YO2nrzb4GPCRzAJYH+9TPfyj0fKYrF
        z0k0O28z3WM0rR8P24nMIgE=
X-Google-Smtp-Source: APXvYqyfsvOejdxnpc7T5NU6erTE/oscHCAWzYUqhMM9OFSwHbN0oyvkJzp00KOopDJ5UtqaUWvLeg==
X-Received: by 2002:a17:902:8691:: with SMTP id g17mr34052513plo.141.1570535828197;
        Tue, 08 Oct 2019 04:57:08 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.57.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:07 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 07/10] net: openvswitch: add likely in flow_lookup
Date:   Tue,  8 Oct 2019 09:00:35 +0800
Message-Id: <1570496438-15460-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The most case *index < ma->count, and flow-mask is not NULL.
We add un/likely for performance.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 667f474..007f7cd 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -518,7 +518,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->count)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
@@ -527,13 +527,13 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 		}
 	}
 
-	for (i = 0; i < ma->max; i++)  {
+	for (i = 0; i < ma->count; i++)  {
 
 		if (i == *index)
 			continue;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
-		if (!mask)
+		if (unlikely(!mask))
 			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-- 
1.8.3.1

