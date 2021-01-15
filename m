Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4462F7F2C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbhAOPO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:14:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731014AbhAOPO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:14:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610723581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQwhgHnFKBM2mHwqBIlUts7RBV39XtCmJJIxmkNYk5U=;
        b=AZTJjsyycPo+7hyE1rhBEQAUW+VNHF1/VEJoSb4Q2B+1RMSFxiCrQuIgc0KzIuGmVhZocK
        Jn4qFf9XMmMrmjk6i0ZMl6dvPw8H99rIdbghhwy+Y9QoahZ0yNqjHdhKp6AUaSaxWf/bT3
        zMZLXS5SPk0waYXYDQlYU7ptgmGjQd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-wZxQBy_JOoqCyEur6zegkQ-1; Fri, 15 Jan 2021 10:12:57 -0500
X-MC-Unique: wZxQBy_JOoqCyEur6zegkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B939F806660;
        Fri, 15 Jan 2021 15:12:56 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21F52620DE;
        Fri, 15 Jan 2021 15:12:56 +0000 (UTC)
Date:   Fri, 15 Jan 2021 10:12:54 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: Re: [PATCH iproute2] bond: support xmit_hash_policy=vlan+mac
Message-ID: <20210115151254.GB1176575@redhat.com>
References: <20210113223548.1171655-1-jarod@redhat.com>
 <20210113234117.3805255-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113234117.3805255-1-jarod@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 06:41:17PM -0500, Jarod Wilson wrote:
> There's a new transmit hash policy being added to the bonding driver that
> is a simple XOR of vlan ID and source MAC, xmit_hash_policy vlan+mac. This
> trivial patch makes it configurable and queryable via iproute2.
> 
> $ sudo modprobe bonding mode=2 max_bonds=1 xmit_hash_policy=0
> 
> $ sudo ip link set bond0 type bond xmit_hash_policy vlan+mac
> 
> $ ip -d link show bond0
> 11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>     bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any
> primary_reselect always fail_over_mac none xmit_hash_policy vlan+mac resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1
> packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs
> 65535
> 
> $ grep Hash /proc/net/bonding/bond0
> Transmit Hash Policy: vlan+mac (5)
> 
> $ sudo ip link add test type bond help
> Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]
>                 [ clear_active_slave ] [ miimon MIIMON ]
>                 [ updelay UPDELAY ] [ downdelay DOWNDELAY ]
>                 [ peer_notify_delay DELAY ]
>                 [ use_carrier USE_CARRIER ]
>                 [ arp_interval ARP_INTERVAL ]
>                 [ arp_validate ARP_VALIDATE ]
>                 [ arp_all_targets ARP_ALL_TARGETS ]
>                 [ arp_ip_target [ ARP_IP_TARGET, ... ] ]
>                 [ primary SLAVE_DEV ]
>                 [ primary_reselect PRIMARY_RESELECT ]
>                 [ fail_over_mac FAIL_OVER_MAC ]
>                 [ xmit_hash_policy XMIT_HASH_POLICY ]
>                 [ resend_igmp RESEND_IGMP ]
>                 [ num_grat_arp|num_unsol_na NUM_GRAT_ARP|NUM_UNSOL_NA ]
>                 [ all_slaves_active ALL_SLAVES_ACTIVE ]
>                 [ min_links MIN_LINKS ]
>                 [ lp_interval LP_INTERVAL ]
>                 [ packets_per_slave PACKETS_PER_SLAVE ]
>                 [ tlb_dynamic_lb TLB_DYNAMIC_LB ]
>                 [ lacp_rate LACP_RATE ]
>                 [ ad_select AD_SELECT ]
>                 [ ad_user_port_key PORTKEY ]
>                 [ ad_actor_sys_prio SYSPRIO ]
>                 [ ad_actor_system LLADDR ]
> 
> BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb
> ARP_VALIDATE := none|active|backup|all
> ARP_ALL_TARGETS := any|all
> PRIMARY_RESELECT := always|better|failure
> FAIL_OVER_MAC := none|active|follow
> XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlan+mac
> LACP_RATE := slow|fast
> AD_SELECT := stable|bandwidth|count
> 
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Self-nack on this version, renaming the mode to vlan+srcmac as discussed.

-- 
Jarod Wilson
jarod@redhat.com

