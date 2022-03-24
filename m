Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF14E665A
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351414AbiCXP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351381AbiCXP4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6545AC93C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648137307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qhk/cSlBhu9FyIQHni5JTdj5gaUuouDSx4dOdLvCXlU=;
        b=GTj7+ZaE++yKbztKl/UsZ0PvVDzOHG/NJOtznfL8UhNbwitPCCG2mfVCm5Kzh1XaXYce25
        QKum/nKFqw0e1NZpeh9XTwhCTf8skt+YwCVw633XTFQNM761tdefYVWcZdS30jgI7WXBqS
        ogi3aEtZTSxxI1jnDrID8ahC6OKTkLE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-XGELB1YLM0WwMYKHKCvZHg-1; Thu, 24 Mar 2022 11:55:03 -0400
X-MC-Unique: XGELB1YLM0WwMYKHKCvZHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68C2E892D1A;
        Thu, 24 Mar 2022 15:54:57 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.17.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3144740146E;
        Thu, 24 Mar 2022 15:54:57 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH iproute2 next] bond: add mac_filter option
Date:   Thu, 24 Mar 2022 11:54:42 -0400
Message-Id: <2d08b009c8a66524609902d3707bf325f7905691.1648136550.git.jtoppins@redhat.com>
In-Reply-To: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
References: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to set bonding option `mac_filter`. Values greater than zero
represent the maximum hashtable size the mac filter is allowed to grow
to, zero disables the filter.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 22e21e57afc9..23b61679b4ff 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -927,6 +927,7 @@ enum {
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
+	IFLA_BOND_MAC_FILTER,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 650411fc7de1..64f910e2b4cc 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -156,6 +156,7 @@ static void print_explain(FILE *f)
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
 		"                [ ad_actor_system LLADDR ]\n"
 		"                [ arp_missed_max MISSED_MAX ]\n"
+		"                [ mac_filter HASH_SIZE ]\n"
 		"\n"
 		"BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb\n"
 		"ARP_VALIDATE := none|active|backup|all|filter|filter_active|filter_backup\n"
@@ -409,6 +410,14 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 			}
 			addattr8(n, 1024, IFLA_BOND_TLB_DYNAMIC_LB,
 				 tlb_dynamic_lb);
+		} else if (matches(*argv, "mac_filter") == 0) {
+			__u8 mac_filter;
+			NEXT_ARG();
+			if (get_u8(&mac_filter, *argv, 0)) {
+				invarg("invalid mac_filter", *argv);
+				return -1;
+			}
+			addattr8(n, 1024, IFLA_BOND_MAC_FILTER, mac_filter);
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -490,6 +499,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "arp_missed_max %u ",
 			   rta_getattr_u8(tb[IFLA_BOND_MISSED_MAX]));
 
+	if (tb[IFLA_BOND_MAC_FILTER])
+		print_uint(PRINT_ANY,
+			   "mac_filter",
+			   "mac_filter %u ",
+			   rta_getattr_u8(tb[IFLA_BOND_MAC_FILTER]));
+
 	if (tb[IFLA_BOND_ARP_IP_TARGET]) {
 		struct rtattr *iptb[BOND_MAX_ARP_TARGETS + 1];
 
-- 
2.27.0

