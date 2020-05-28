Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7C1E5850
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgE1HQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:16:00 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:52408 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgE1HP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:15:59 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B665141FF2;
        Thu, 28 May 2020 15:15:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net/sched: act_ct: add nat attribute in ct_metadata
Date:   Thu, 28 May 2020 15:15:54 +0800
Message-Id: <1590650155-4403-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkhNQkJCQk1PTEpPS05ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdMjULOBw6IxkpEAkhGEIeTTYcCzocVlZVSUpOSUIoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PhQ6Vhw6Czg9QjhOLDNPL0tW
        HyMaCS9VSlVKTkJLTU5LSk5OQktOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLSks3Bg++
X-HM-Tid: 0a725a23332b2086kuqyb665141ff2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nat attribute in the ct_metadata action. This tell driver the offload
conntrack entry is nat one or not.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/flow_offload.h | 1 +
 net/sched/act_ct.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 95d6337..e3f09dd 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -244,6 +244,7 @@ struct flow_action_entry {
 			unsigned long cookie;
 			u32 mark;
 			u32 labels[4];
+			bool nat;
 		} ct_metadata;
 		struct {				/* FLOW_ACTION_MPLS_PUSH */
 			u32		label;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9adff83..f70ab543 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -183,6 +183,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 					     IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
+	entry->ct_metadata.nat = ct->status & IPS_NAT_MASK;
 
 	act_ct_labels = entry->ct_metadata.labels;
 	ct_labels = nf_ct_labels_find(ct);
-- 
1.8.3.1

