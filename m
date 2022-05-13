Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABDD5268AC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383160AbiEMRnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383158AbiEMRno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AED9066C8C
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652463821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXreywmraN07sQoFTw61NbzPUPErvjTUVk4wsqfJz1c=;
        b=NRpPfk4wjxuG6fN6OJti8MmQ0ZfxAfNG85bMPmQR4yK2/WY3vQj7FoXqNnVdwCKTYTe75x
        ZnnWa8Q+n0IcQf75vGKn2U0BK6S9MUXilzvO8xG8Hw1kLrZTrKRWYPbvZqY8bLf7bDCu38
        Ko41vCvh2ytyGZbo7pv9rZDjSyURkjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-MzY9_L0SMRaXot0Fjusv-w-1; Fri, 13 May 2022 13:43:37 -0400
X-MC-Unique: MzY9_L0SMRaXot0Fjusv-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3750E803B42;
        Fri, 13 May 2022 17:43:37 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4B4640D2822;
        Fri, 13 May 2022 17:43:36 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     razor@blackwall.org, toke@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH iproute2 next v3] bond: add mac_filter option
Date:   Fri, 13 May 2022 13:43:29 -0400
Message-Id: <b73418008f21005e09a40658314a184f275fcd1a.1652456347.git.jtoppins@redhat.com>
In-Reply-To: <6e428398c79a2498b4ebabab0e6c388247fb5fc3.1652456164.git.jtoppins@redhat.com>
References: <6e428398c79a2498b4ebabab0e6c388247fb5fc3.1652456164.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v3: refresh patch to keep in-sync with next/master, no other changes
    since v1.

 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 34002e72d10a..85f5f07f5153 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -932,6 +932,7 @@ enum {
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
 	IFLA_BOND_NS_IP6_TARGET,
+	IFLA_BOND_MAC_FILTER,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 15db19a3d3c2..07c823329a91 100644
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
2.27.0

