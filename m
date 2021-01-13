Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DBD2F570A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbhANB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729564AbhAMXm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610581291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzxCmoLFEa+lTRo7ZD3rQYtnzdqEH12roV8+19s28cQ=;
        b=b5Q1x8OW/d8h49J5vSUP+5DOQBST0vRwu+G5iR9sXPaU7Vx42lsBA1uLWayv1sM8Ckznwf
        OeVwMUruEANm5M3GZEpOk3hCuxhq+8oVQ0epV6t00LUuIftrE+d70SQP4gcmurMAlZv+yJ
        gdGE3Q3ZgfBf0kILQZl/LQFEkz0zkFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-cShvEv9GOmC9Ys-XmI4G-g-1; Wed, 13 Jan 2021 18:41:30 -0500
X-MC-Unique: cShvEv9GOmC9Ys-XmI4G-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22050107ACF7;
        Wed, 13 Jan 2021 23:41:29 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3158960938;
        Wed, 13 Jan 2021 23:41:25 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [PATCH iproute2] bond: support xmit_hash_policy=vlan+mac
Date:   Wed, 13 Jan 2021 18:41:17 -0500
Message-Id: <20210113234117.3805255-1-jarod@redhat.com>
In-Reply-To: <20210113223548.1171655-1-jarod@redhat.com>
References: <20210113223548.1171655-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a new transmit hash policy being added to the bonding driver that
is a simple XOR of vlan ID and source MAC, xmit_hash_policy vlan+mac. This
trivial patch makes it configurable and queryable via iproute2.

$ sudo modprobe bonding mode=2 max_bonds=1 xmit_hash_policy=0

$ sudo ip link set bond0 type bond xmit_hash_policy vlan+mac

$ ip -d link show bond0
11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
    bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any
primary_reselect always fail_over_mac none xmit_hash_policy vlan+mac resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1
packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs
65535

$ grep Hash /proc/net/bonding/bond0
Transmit Hash Policy: vlan+mac (5)

$ sudo ip link add test type bond help
Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]
                [ clear_active_slave ] [ miimon MIIMON ]
                [ updelay UPDELAY ] [ downdelay DOWNDELAY ]
                [ peer_notify_delay DELAY ]
                [ use_carrier USE_CARRIER ]
                [ arp_interval ARP_INTERVAL ]
                [ arp_validate ARP_VALIDATE ]
                [ arp_all_targets ARP_ALL_TARGETS ]
                [ arp_ip_target [ ARP_IP_TARGET, ... ] ]
                [ primary SLAVE_DEV ]
                [ primary_reselect PRIMARY_RESELECT ]
                [ fail_over_mac FAIL_OVER_MAC ]
                [ xmit_hash_policy XMIT_HASH_POLICY ]
                [ resend_igmp RESEND_IGMP ]
                [ num_grat_arp|num_unsol_na NUM_GRAT_ARP|NUM_UNSOL_NA ]
                [ all_slaves_active ALL_SLAVES_ACTIVE ]
                [ min_links MIN_LINKS ]
                [ lp_interval LP_INTERVAL ]
                [ packets_per_slave PACKETS_PER_SLAVE ]
                [ tlb_dynamic_lb TLB_DYNAMIC_LB ]
                [ lacp_rate LACP_RATE ]
                [ ad_select AD_SELECT ]
                [ ad_user_port_key PORTKEY ]
                [ ad_actor_sys_prio SYSPRIO ]
                [ ad_actor_system LLADDR ]

BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb
ARP_VALIDATE := none|active|backup|all
ARP_ALL_TARGETS := any|all
PRIMARY_RESELECT := always|better|failure
FAIL_OVER_MAC := none|active|follow
XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+mac
LACP_RATE := slow|fast
AD_SELECT := stable|bandwidth|count

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 ip/iplink_bond.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 585b6be1..b9470b98 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -70,6 +70,7 @@ static const char *xmit_hash_policy_tbl[] = {
 	"layer2+3",
 	"encap2+3",
 	"encap3+4",
+	"vlan+mac",
 	NULL,
 };
 
@@ -148,7 +149,7 @@ static void print_explain(FILE *f)
 		"ARP_ALL_TARGETS := any|all\n"
 		"PRIMARY_RESELECT := always|better|failure\n"
 		"FAIL_OVER_MAC := none|active|follow\n"
-		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4\n"
+		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+mac\n"
 		"LACP_RATE := slow|fast\n"
 		"AD_SELECT := stable|bandwidth|count\n"
 	);
-- 
2.27.0

