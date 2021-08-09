Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6F3E3E12
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhHIDCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 23:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhHIDCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 23:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628478150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uzJfGi+bn65wQAzcYSyrR66QtQeU9ro2TX6RJdvd7hI=;
        b=dowr7nn4xo7ZJMn2kyX0/34pfaQByGjXzfgNIob6DdfmUZ6NmW6EHH/DcWpF+9//tmYi/g
        NhB4KORPH7E3eGStuWl/DEcFzBzsQjtHgqWkrCo4bMDuYNJjfh0IORY64NTtAq3fWvY2lK
        IX2VyB/jNM47qcykMKuQhTxLKp/ab58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-T1frE71cOmGJGIlGDrh5mw-1; Sun, 08 Aug 2021 23:02:27 -0400
X-MC-Unique: T1frE71cOmGJGIlGDrh5mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 146AD18C8C00;
        Mon,  9 Aug 2021 03:02:25 +0000 (UTC)
Received: from Laptop-X1.redhat.com (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A86C910016F8;
        Mon,  9 Aug 2021 03:02:20 +0000 (UTC)
From:   Hangbin Liu <haliu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next] ip/bond: add lacp active support
Date:   Mon,  9 Aug 2021 11:01:53 +0800
Message-Id: <20210809030153.10851-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

lacp_active specifies whether to send LACPDU frames periodically.
If set on, the LACPDU frames are sent along with the configured lacp_rate
setting. If set off, the LACPDU frames acts as "speak when spoken to".

v2: use strcmp instead of match for new options.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_bond.c             | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5195ed93..a60dbb96 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -853,6 +853,7 @@ enum {
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
+	IFLA_BOND_AD_LACP_ACTIVE,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index d45845bd..b01f69a5 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -74,6 +74,12 @@ static const char *xmit_hash_policy_tbl[] = {
 	NULL,
 };
 
+static const char *lacp_active_tbl[] = {
+	"off",
+	"on",
+	NULL,
+};
+
 static const char *lacp_rate_tbl[] = {
 	"slow",
 	"fast",
@@ -139,6 +145,7 @@ static void print_explain(FILE *f)
 		"                [ packets_per_slave PACKETS_PER_SLAVE ]\n"
 		"                [ tlb_dynamic_lb TLB_DYNAMIC_LB ]\n"
 		"                [ lacp_rate LACP_RATE ]\n"
+		"                [ lacp_active LACP_ACTIVE]\n"
 		"                [ ad_select AD_SELECT ]\n"
 		"                [ ad_user_port_key PORTKEY ]\n"
 		"                [ ad_actor_sys_prio SYSPRIO ]\n"
@@ -150,6 +157,7 @@ static void print_explain(FILE *f)
 		"PRIMARY_RESELECT := always|better|failure\n"
 		"FAIL_OVER_MAC := none|active|follow\n"
 		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+srcmac\n"
+		"LACP_ACTIVE := off|on\n"
 		"LACP_RATE := slow|fast\n"
 		"AD_SELECT := stable|bandwidth|count\n"
 	);
@@ -165,7 +173,7 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	__u8 mode, use_carrier, primary_reselect, fail_over_mac;
 	__u8 xmit_hash_policy, num_peer_notif, all_slaves_active;
-	__u8 lacp_rate, ad_select, tlb_dynamic_lb;
+	__u8 lacp_active, lacp_rate, ad_select, tlb_dynamic_lb;
 	__u16 ad_user_port_key, ad_actor_sys_prio;
 	__u32 miimon, updelay, downdelay, peer_notify_delay, arp_interval, arp_validate;
 	__u32 arp_all_targets, resend_igmp, min_links, lp_interval;
@@ -323,6 +331,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
 
 			lacp_rate = get_index(lacp_rate_tbl, *argv);
 			addattr8(n, 1024, IFLA_BOND_AD_LACP_RATE, lacp_rate);
+		} else if (strcmp(*argv, "lacp_active") == 0) {
+			NEXT_ARG();
+			if (get_index(lacp_active_tbl, *argv) < 0)
+				invarg("invalid lacp_active", *argv);
+
+			lacp_active = get_index(lacp_active_tbl, *argv);
+			addattr8(n, 1024, IFLA_BOND_AD_LACP_ACTIVE, lacp_active);
 		} else if (matches(*argv, "ad_select") == 0) {
 			NEXT_ARG();
 			if (get_index(ad_select_tbl, *argv) < 0)
@@ -561,6 +576,15 @@ static void bond_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "packets_per_slave %u ",
 			   rta_getattr_u32(tb[IFLA_BOND_PACKETS_PER_SLAVE]));
 
+	if (tb[IFLA_BOND_AD_LACP_ACTIVE]) {
+		const char *lacp_active = get_name(lacp_active_tbl,
+						   rta_getattr_u8(tb[IFLA_BOND_AD_LACP_ACTIVE]));
+		print_string(PRINT_ANY,
+			     "ad_lacp_active",
+			     "lacp_active %s ",
+			     lacp_active);
+	}
+
 	if (tb[IFLA_BOND_AD_LACP_RATE]) {
 		const char *lacp_rate = get_name(lacp_rate_tbl,
 						 rta_getattr_u8(tb[IFLA_BOND_AD_LACP_RATE]));
-- 
2.31.1

