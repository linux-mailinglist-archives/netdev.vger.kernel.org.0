Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711D12F8553
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbhAOTXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:23:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbhAOTXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610738525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PyUOB7BV9cF0PpC1Vxob1VqiI/JkyrhToZw3I9DDzXc=;
        b=PwKY/VnrcYDYYl6v5MsG7PtDu6qvHG9w2Y6RqqJY36LVXHO/vmXMXMjGVQZRg8TJsPNUZr
        ts5iLhDxrnC6FlrilaOTpxPagXIuUmkgOZ/SLIRWSkd6TTJ6CbOuzSieTG3Ithr1ZFb2B/
        wm7QV5/OtUNdExbnDdmB/DhOeFkNglY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-XhF2DwehNaGaV7CkGN4EkQ-1; Fri, 15 Jan 2021 14:22:03 -0500
X-MC-Unique: XhF2DwehNaGaV7CkGN4EkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F39A107ACFC;
        Fri, 15 Jan 2021 19:22:02 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2194A63746;
        Fri, 15 Jan 2021 19:21:59 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [PATCH iproute2 v2] bond: support xmit_hash_policy=vlan+srcmac
Date:   Fri, 15 Jan 2021 14:21:37 -0500
Message-Id: <20210115192137.1878336-1-jarod@redhat.com>
In-Reply-To: <20210113234117.3805255-1-jarod@redhat.com>
References: <20210113234117.3805255-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a new transmit hash policy being added to the bonding driver that
is a simple XOR of vlan ID and source MAC, xmit_hash_policy vlan+srcmac.
This trivial patch makes it configurable and queryable via iproute2.

$ sudo modprobe bonding mode=2 max_bonds=1 xmit_hash_policy=0

$ sudo ip link set bond0 type bond xmit_hash_policy vlan+srcmac

$ ip -d link show bond0
11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
    bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any
primary_reselect always fail_over_mac none xmit_hash_policy vlan+srcmac resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1
packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs
65535

$ grep Hash /proc/net/bonding/bond0
Transmit Hash Policy: vlan+srcmac (5)

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
XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+srcmac
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
+	"vlan+srcmac",
 	NULL,
 };
 
@@ -148,7 +149,7 @@ static void print_explain(FILE *f)
 		"ARP_ALL_TARGETS := any|all\n"
 		"PRIMARY_RESELECT := always|better|failure\n"
 		"FAIL_OVER_MAC := none|active|follow\n"
-		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4\n"
+		"XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+srcmac\n"
 		"LACP_RATE := slow|fast\n"
 		"AD_SELECT := stable|bandwidth|count\n"
 	);
-- 
2.27.0

