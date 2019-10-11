Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78721D423D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfJKOGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:06:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39142 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJKOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:06:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id e1so5870915pgj.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m3vdikZrS9thcV45JQ2U1HH0Gpvc7JWA1zVvm4cc2XY=;
        b=upYmFXQayW+LxIr84BeJxCP7HlHmidcVMZzTB/YucXhucZLKLB9EvXjNrBNZNtgYNc
         KY0fvLZ62TWZv0h+WeUZhPPiO7vKqTG3WiZZ+3aLo9SUJEb2XQJbhmvu2lpjYZ99/2qt
         5XxbRpeC20k6pZ7q12hjipxxOEqy+tx4N0SxX19osVJ5q2PGaNulQWHIVLZY+Ot3zr5a
         w6pp65NQM1REDSJVSFBTIAclWr90UsTatQczTuoXN6jETHxtu1wSlm274gU/2ANqNv9Z
         8H0XWZOAIYGBP305mFje/5QcNJGUKsDmuR0q04ihmg3VnUmRe0gQxLhtK9CIoBfppGqH
         guNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m3vdikZrS9thcV45JQ2U1HH0Gpvc7JWA1zVvm4cc2XY=;
        b=J46oiXCW/je//R1BmJLYZM3Sdk1WdJd6cmWVnfoK0djKtN5LlVJ2vyE7E3FFRbVsJR
         VhWKHZHmUs8s5Qvvfynpy/pSrRruqYVHsjSFj5NqgI0WirwFQDBYIGJe7yiLM/g8xD+8
         hjPmvi3ULnClGZrEFA1sDnfTJCjrFn3YaUuFcydE/V7kxppMTZbN8ryV+KdmvzL/k8cd
         liFhLoSBFOCR2vUuvZEGwqS1ukCs1Yxru2o+iwAjqPqEGizc2I6f22lpaNzW4mlAbRg6
         TSh2InyyICSxy1SoI/8EkKPpKHU1rpT7mXDG1wzvnUsjRM01RnPlKM5P3TfBa/1BV+ae
         N/jg==
X-Gm-Message-State: APjAAAUm/HJBjRPwqo9Y3vIfDjEZU8WBx58ygUIzGZ7QUV1mOkja/Yg5
        oj2DZXAHtI6/m8pHJ8vtTac=
X-Google-Smtp-Source: APXvYqz0sar5a485HKdfFcuHCXRjKWXvJRpQ2VLPuulBOwzji8+QVJErVjrXj5LCQYdgMzkultyt7g==
X-Received: by 2002:a17:90a:ba83:: with SMTP id t3mr16244485pjr.139.1570802762211;
        Fri, 11 Oct 2019 07:06:02 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:06:01 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 07/10] net: openvswitch: add likely in flow_lookup
Date:   Fri, 11 Oct 2019 22:00:44 +0800
Message-Id: <1570802447-8019-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 7aba5b4..1fc6be2 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -516,7 +516,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->count)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
@@ -525,13 +525,13 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
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

