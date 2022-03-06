Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F121A4CED4F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 20:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiCFTQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 14:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiCFTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 14:16:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E3855492
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 11:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Disposition:Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ERk0ORocA0dpB0tkalox9EV5Dcjc4+r0waMjYhuRrVQ=; b=ONVzFv1t+kIuxV/l4Qhp6PtOBd
        E9dIVfE2me8btSnR7wXZ5Z/czs108+oYzPllvmJom75SW/CF3pTbcUhF/yIfOViRAeR5uxwYB21VN
        X93IUniinA+Wd3z3Olquix3HP8FR23QuO+RUzzRO+X14hyE4Nz2Uq+sEPQJiMgv7ZLb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQwLa-009W8S-1v; Sun, 06 Mar 2022 20:15:14 +0100
Date:   Sun, 6 Mar 2022 20:15:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        emeric.dupont@zii.aero
Subject: Regression with improved multi chip isolation
Message-ID: <YiUIQupDTGwgHE4K@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

I just found a regression with:

d352b20f4174a6bd998992329b773ab513232880 is the first bad commit
commit d352b20f4174a6bd998992329b773ab513232880
Author: Tobias Waldekranz <tobias@waldekranz.com>
Date:   Thu Feb 3 11:16:56 2022 +0100

    net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
    
    Given that standalone ports are now configured to bypass the ATU and
    forward all frames towards the upstream port, extend the ATU bypass to
    multichip systems.


I have a ZII devel B setup:

brctl addbr br0                                                                 
brctl addif br0 lan0                                                            
brctl addif br0 lan1                                                            
                                                                                
ip link set br0 up                                                              
ip link set lan0 up                                                             
ip link set lan1 up                                                             
                                                                                
ip link add link br0 name br0.11 type vlan id 11                                
ip link set br0.11 up                                                           
ip addr add 10.42.11.1/24 dev br0.11

Has it happens, lan0 has link, and i run tcpdump on the link peer. lan1
does not have link.

I then ping 10.42.11.2.

I found that the ARP Request who-has 10.42.11.2 tell 10.42.11.1 are
getting dropped. I also see:

     p06_sw_in_filtered: 122
     p06_sw_out_filtered: 90
     p06_atu_member_violation: 0
     p06_atu_miss_violation: 0
     p06_atu_full_violation: 0
     p06_vtu_member_violation: 0
     p06_vtu_miss_violation: 121

port 6 is the CPU port. Both p06_vtu_miss_violation and
p06_sw_in_filtered are incrementing with each ARP Request broadcast
from the host.

The bridge should be vlan unaware, vlan_filtering is 0.

$ ip -d link show br0
16: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode 
DEFAULT group default qlen 1000
    link/ether 8e:22:a0:47:66:f9 brd ff:ff:ff:ff:ff:ff promiscuity 0 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_
state 0 priority 32768 vlan_filtering 0 bridge_id 8000.8e:22:a0:47:66:f9 designa
ted_root 8000.8e:22:a0:47:66:f9 root_port 0 root_path_cost 0 topology_change 0 t
opology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_
timer    0.00 gc_timer  295.16 group_fwd_mask 0 group_address 01:80:c2:00:00:00 
mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_h
ash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_qu
ery_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast
_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval
 1000 mcast_startup_query_interval 3125 addrgenmode eui64 numtxqueues 1 gso_max_
size 65536 gso_max_segs 65535

Thanks
	Andrew
