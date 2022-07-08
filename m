Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16B56C321
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiGHSmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbiGHSmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:42:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3CA01EAC3
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 11:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657305729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1Fa11yvH3zHSAbXYwOqWzVpwYwysHK4A0l1MnClKws=;
        b=Y1VE5ebFsNdqrELsGF2HuKr/1DjrQ5vnOdnwj5ei+s+KrtKFCv8/SZMpeSLUe0GfdhNg0C
        eiUWXTWSFF3i6RMmwKrHi3+kH3JQqjfbQXfVn6SXx00PhFpzhYUUc+eVnB507UQKXMOJ1P
        FygAvILwofw7BcrzUo2zrhvR8Fy2f0o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-x6XNsB5YPlejLLtztiKp4A-1; Fri, 08 Jul 2022 14:42:08 -0400
X-MC-Unique: x6XNsB5YPlejLLtztiKp4A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01EA21C05130;
        Fri,  8 Jul 2022 18:42:08 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F008492C3B;
        Fri,  8 Jul 2022 18:42:07 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, razor@blackwall.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH iproute2 next v4 2/2] bond: add mac_filter option
Date:   Fri,  8 Jul 2022 14:41:57 -0400
Message-Id: <3c7a89f9a92c41847a1b643c9db5c0a601e95d66.1657303056.git.jtoppins@redhat.com>
In-Reply-To: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
References: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Notes:
    v4:
     * rebase onto latest next branch

 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e0fbbfeeb3a1..529ae4faa7e2 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -934,6 +934,7 @@ enum {
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
+	IFLA_BOND_MAC_FILTER,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 7943499e0adf..fb7236c58253 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -157,6 +157,7 @@ static void print_explain(FILE *f)
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
 		"                [ ad_actor_system LLADDR ]\n"
 		"                [ arp_missed_max MISSED_MAX ]\n"
+		"                [ mac_filter HASH_SIZE ]\n"
 		"\n"
 		"BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb\n"
 		"ARP_VALIDATE := none|active|backup|all|filter|filter_active|filter_backup\n"
@@ -410,6 +411,14 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
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
@@ -491,6 +500,12 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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
2.31.1

