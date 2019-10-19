Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE84E9564
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfJ3Dsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37118 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Dst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id u9so575458pfn.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JuZtaop7gABnMtXhqDvqmuQmZHs6mxEdH0NFwZvdS20=;
        b=JKHaAcNIdgO9wrI2/vVm1f9K+ye/8DFykr/SG8E3j2dVDeXrYMawRJ95VOUyc4j/WR
         ZbDB94lqx3aFucsMELBx81V7URrGusmpxNp4Qd1Kh3wXE2pxeys6d6OcXX8bTMq1ThGs
         fTE8zjwA4AJoOo4GnutPuEG2oOiBZ1JZwyzRo3HuOTCuM5v9tpRfCFMmZbpOtALE4VKA
         7rTo2H4v3RYP06qOnVkPnpV8fAlvC+v/fOio/OLzeetuo+9VFTpxVHNmeiiBSA62igMc
         AXeFz5QgFkJHWVWsyql9HqeVRFzccbZ1PPjrrtRf865A2R5liz5g2XUlR+nJirQGP3uC
         /4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JuZtaop7gABnMtXhqDvqmuQmZHs6mxEdH0NFwZvdS20=;
        b=CCGt8KPOv9gj+StcnVGne+ySEOp6bedMVX8vNHfqsD7lte3Wbb5FpN6uWONyRaR96y
         sXPzCB+B7YY/HmAQnLqt2I/6GM9V7GXyP+f0Ax6Y2ES3wsokPp0oUer+LOGhlOLOMALZ
         HA75/OxcB4+16/OoxXVpZ69iFtFlNmO4z40XRKot/2pa6m1u+l95+c3nwQ9miLbiU66m
         gmZcgGdd8RFFnMfL4SQ33yALzyfneryetieRIG0UtK+Tr1B2uEy4pK5+N2/8wOqQW5/O
         /tzewmBuQ1mDKERViRKo/RAKE7TpyflwI9KH5frgaZWl3hNxyiK+es2Z67p0tP/Rb5IZ
         GRdg==
X-Gm-Message-State: APjAAAWqUCqOX/50ncW6JO5Tvuy5UU1Edava/6eU8vDps9HbgZEXqOS+
        +OBehemza2Rt53Z9YxALjrA=
X-Google-Smtp-Source: APXvYqx13F146PPQAB4c6mMp+7wI3g3zkmdF0tgO+o02TE8pdPbo1uWHEvnQhUroeNNILb3yCfZFeg==
X-Received: by 2002:a63:ef51:: with SMTP id c17mr23298617pgk.43.1572407328566;
        Tue, 29 Oct 2019 20:48:48 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:48 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 07/10] net: openvswitch: add likely in flow_lookup
Date:   Sat, 19 Oct 2019 16:08:41 +0800
Message-Id: <1571472524-73832-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The most case *index < ma->max, and flow-mask is not NULL.
We add un/likely for performance.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
---
 net/openvswitch/flow_table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 3e3d345..5df5182 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -518,7 +518,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->max)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
@@ -533,7 +533,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 			continue;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
-		if (!mask)
+		if (unlikely(!mask))
 			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-- 
1.8.3.1

