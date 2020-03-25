Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2078A19BAC8
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 05:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgDBD5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 23:57:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34651 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgDBD5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 23:57:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id 23so1141210pfj.1
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 20:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Nek53JZ8+47uP1OJVYHlt2cm0INQYRclILotu8rmnus=;
        b=CR8P39YH7c4x5Ol79V3NX3kmHZUG1bIEigF0oqLv+h2daEjthsFgFQ/ckA57youVHY
         f1Mdt9J7UYPEHDS+fSrlIv1SoNLOJy1RHWSNCSb2X+OAyFENB4NYHX3M339OfBp55pAC
         Oox8K0Bv7Kq2NzYYaSXy0K3s7WjytA13UlQH10H2g1vcm5mLBU9nF1tTUHDrnxx3GXJM
         kgMO79F2TTT3nVio22HqlwLamLg6Nx9JU4P2aF1wR8U9daIC4P11TvV6Hia94IQEuxX0
         rqwzFnZrsxXTj7V51C+XPAFEj3xUK8faLc4sNGJpqaQg6ru3ZKe3P1FY0PkuKobHMf7k
         fWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Nek53JZ8+47uP1OJVYHlt2cm0INQYRclILotu8rmnus=;
        b=bKZLWMu4XvcCa2ml18zVKY56XwFXp7UhrDuN5E+SWEWcQNdPFWryiK6bUUxoSDx9O7
         VJcCPtwmqwEes+r0NevC1O94Bo93EY9cQ3KE6ol0UyHewLmmhLeC9VtleTzJqJjkKtSK
         hmOen3qvH27rSLubiZDNUyx6R3WhY3asqIJsf3jZeNQTa/ohKAPNyLXoxwKpHU/18jwa
         LOTfpQQqKgYt8SaclG+Y2PTR4vkBRuxEM++JEXvJBHRETushUcbfoktJSsWt6DvQnIec
         /nc9cl6EnbQ/RAmkA69BkIOyEQ5WdGCCRKv5RF177J2rzXUZr6LPmwBgvqYikY9fMm5c
         3/5g==
X-Gm-Message-State: AGi0PuZSR05i9RRVviWkF4z8gDcXDzTejduY3fQ0Rmp6J5Z+bhKP9DwC
        tk5zqSYv8O2soO4Y+a/ZqDxAvRd6
X-Google-Smtp-Source: APiQypKpjx58HoA+HWgCsUvIlkFLJ7p0BrfP4UZoFHVRR9YzJTv8DDoaTKXVqPNw0BdtBSxUeln77g==
X-Received: by 2002:a65:5881:: with SMTP id d1mr1490695pgu.378.1585799829980;
        Wed, 01 Apr 2020 20:57:09 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t3sm2589823pfl.26.2020.04.01.20.57.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 20:57:09 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net: openvswitch: use hlist_for_each_entry_rcu instead of hlist_for_each_entry
Date:   Thu, 26 Mar 2020 04:27:24 +0800
Message-Id: <1585168044-102049-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The struct sw_flow is protected by RCU, when traversing them,
use hlist_for_each_entry_rcu.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index fd8a01c..b7b5744 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -462,12 +462,14 @@ static void flow_table_copy_flows(struct table_instance *old,
 		struct hlist_head *head = &old->buckets[i];
 
 		if (ufid)
-			hlist_for_each_entry(flow, head,
-					     ufid_table.node[old_ver])
+			hlist_for_each_entry_rcu(flow, head,
+						 ufid_table.node[old_ver],
+						 lockdep_ovsl_is_held())
 				ufid_table_instance_insert(new, flow);
 		else
-			hlist_for_each_entry(flow, head,
-					     flow_table.node[old_ver])
+			hlist_for_each_entry_rcu(flow, head,
+						 flow_table.node[old_ver],
+						 lockdep_ovsl_is_held())
 				table_instance_insert(new, flow);
 	}
 
-- 
1.8.3.1

