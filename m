Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407283D3BBE
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhGWNoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235353AbhGWNnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 09:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627050264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcR4un06wz1FO+JKGHqkKYVpCaQMWUDLuPpEZmySK2A=;
        b=NhPtjZwVxgAhG/R+pnBL2bsNU9wcStU9rD8nckLJ5+yrddTfct6LbgYm050UI+dwJFVCcI
        72R6pBqy3RkmUMkTAzBas2iTiJaW3v3gmkz3FWmxFtk+MGLsT3hMmYzOexfqx21khZfmek
        oSIBWh3ai/lg4UhVdUKvpkaoTDc2uJQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-Y574glprOGiadBEMSPlp0Q-1; Fri, 23 Jul 2021 10:24:23 -0400
X-MC-Unique: Y574glprOGiadBEMSPlp0Q-1
Received: by mail-wm1-f71.google.com with SMTP id j11-20020a05600c190bb02902190142995dso1476572wmq.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jcR4un06wz1FO+JKGHqkKYVpCaQMWUDLuPpEZmySK2A=;
        b=I7kJBDejczb2/fhmQig71Gz4iEjE3itq2Kh788Yy7/cx0soZIIoMjUXTT1Ve62FnI/
         W7Vnk+dM73lnXGPJkls3+rfZPTW1zPYAyvlNfOYreCaLIHDrQAgfATflSXK3NrwG+yot
         9EA9TKaEWucG6+CrBmx71w78vzJ5QfPwZlAts9kg9sPyzb4J5sOQytlr3b4Qqqobisyz
         kWZwEBKgzI7X9IWK4y4JViERJNAwQwlhUcHAGUIB0oNC0bTRhhSptFFFGYMu0WpUe5w5
         CKPC8EFNYaZLR1nfMwusSYsysi7fFtfCAO6K8W05817XcNPwaLwXkXyOEwqk+XpL04/K
         LlpA==
X-Gm-Message-State: AOAM530+dCQ1jat2GhjpsuisrWvwfetuf1P4ynum8DhBlVGcHCjHteLw
        Zc6K94skIK3JYZcMQvOR1Ojuyt7qt9Ahh9ly1MEQMeUuLJYAsKRJvMHI/jls3q1xXNZqZuxTgkf
        UPoLwbGolEQb0G1vgZT+Sm9XkKFzv/ruImgqHXK1nxh3oLZei+NvyhyzvhyNW5SEl6jZ+PrtB
X-Received: by 2002:a1c:7d96:: with SMTP id y144mr4789336wmc.118.1627050261863;
        Fri, 23 Jul 2021 07:24:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwvz3cXBDhWNtotDGhDmDd9eDCfseyO3tG0yWRbCF+iirnMJhmxJCkaPwBRNxqGi1vyuvFKw==
X-Received: by 2002:a1c:7d96:: with SMTP id y144mr4789300wmc.118.1627050261512;
        Fri, 23 Jul 2021 07:24:21 -0700 (PDT)
Received: from wsfd-netdev76.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p2sm27182180wmg.6.2021.07.23.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 07:24:20 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org, dev@openvswitch.org
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        Mark Gray <mark.d.gray@redhat.com>
Subject: [PATCH net-next 2/3] openvswitch: fix alignment issues
Date:   Fri, 23 Jul 2021 10:24:13 -0400
Message-Id: <20210723142414.55267-3-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723142414.55267-1-mark.d.gray@redhat.com>
References: <20210723142414.55267-1-mark.d.gray@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
---
 include/uapi/linux/openvswitch.h |  4 ++--
 net/openvswitch/actions.c        |  6 ++++--
 net/openvswitch/datapath.c       | 16 ++++++++++------
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
index 0e436a3755f1..150bcff49b1c 100644
--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -89,8 +89,8 @@ enum ovs_datapath_attr {
 	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
 	OVS_DP_ATTR_PAD,
 	OVS_DP_ATTR_MASKS_CACHE_SIZE,
-	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
-				     * dispatch mode
+	OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in
+				     * per-cpu dispatch mode
 				     */
 	__OVS_DP_ATTR_MAX
 };
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index f79679746c62..076774034bb9 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -924,9 +924,11 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 			break;
 
 		case OVS_USERSPACE_ATTR_PID:
-			if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
+			if (dp->user_features &
+			    OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
 				upcall.portid =
-				   ovs_dp_get_upcall_portid(dp, smp_processor_id());
+				  ovs_dp_get_upcall_portid(dp,
+							   smp_processor_id());
 			else
 				upcall.portid = nla_get_u32(a);
 			break;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7a4edafdc685..e6f0ae5618dd 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -244,7 +244,8 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 		upcall.cmd = OVS_PACKET_CMD_MISS;
 
 		if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
-			upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
+			upcall.portid =
+			    ovs_dp_get_upcall_portid(dp, smp_processor_id());
 		else
 			upcall.portid = ovs_vport_find_upcall_portid(p, skb);
 
@@ -1636,13 +1637,16 @@ u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
 	if (dp_nlsk_pids) {
 		if (cpu_id < dp_nlsk_pids->n_pids) {
 			return dp_nlsk_pids->pids[cpu_id];
-		} else if (dp_nlsk_pids->n_pids > 0 && cpu_id >= dp_nlsk_pids->n_pids) {
-			/* If the number of netlink PIDs is mismatched with the number of
-			 * CPUs as seen by the kernel, log this and send the upcall to an
-			 * arbitrary socket (0) in order to not drop packets
+		} else if (dp_nlsk_pids->n_pids > 0 &&
+			   cpu_id >= dp_nlsk_pids->n_pids) {
+			/* If the number of netlink PIDs is mismatched with
+			 * the number of CPUs as seen by the kernel, log this
+			 * and send the upcall to an arbitrary socket (0) in
+			 * order to not drop packets
 			 */
 			pr_info_ratelimited("cpu_id mismatch with handler threads");
-			return dp_nlsk_pids->pids[cpu_id % dp_nlsk_pids->n_pids];
+			return dp_nlsk_pids->pids[cpu_id %
+						  dp_nlsk_pids->n_pids];
 		} else {
 			return 0;
 		}
-- 
2.27.0

