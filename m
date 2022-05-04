Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5491C51AD42
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377308AbiEDSvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355586AbiEDSvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 14:51:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06EEC165B1
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 11:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651690086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=isyJXjX8ZlcuSFyFP6cYiy/Ir8zd1vsMPiOsVFDMplU=;
        b=Xg4BSHwFjoD3vqpDfsiljT2zwMC8IcIlQVPD4zOGYzc509E5BTEDi2PlYASTo5iZt6ugxw
        qBIIhMl2xxWpsrhskqf6g2BmlRLJ/OHefOR7Qhqt1TbFZdHACZ4gpuAOQSPAJvklOeQI+P
        JBLGdLgvc7s26bJd24eOSqoGHVTmX7o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-YkUybQACOXSjzvT6LcABzg-1; Wed, 04 May 2022 14:48:04 -0400
X-MC-Unique: YkUybQACOXSjzvT6LcABzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3921829ABA06;
        Wed,  4 May 2022 18:48:04 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E08FA2166B17;
        Wed,  4 May 2022 18:48:03 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH iproute2 next v2] bond: add mac_filter option
Date:   Wed,  4 May 2022 14:47:51 -0400
Message-Id: <1cdf3438ed17d6aaab1a21ef1aa8f282f752a810.1651689818.git.jtoppins@redhat.com>
In-Reply-To: <6227427ef3b57d7de6d4d95e9dd7c9b222a37bf6.1651689665.git.jtoppins@redhat.com>
References: <6227427ef3b57d7de6d4d95e9dd7c9b222a37bf6.1651689665.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

