Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6237F893
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhEMNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:22:15 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:52598 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhEMNWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:22:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D00A53E8F5;
        Thu, 13 May 2021 15:20:56 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 00/11] net: bridge: split IPv4/v6 mc router state and export for batman-adv
Date:   Thu, 13 May 2021 15:20:42 +0200
Message-Id: <20210513132053.23445-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patches are splitting the so far combined multicast router
state in the Linux bridge into two ones, one for IPv4 and one for IPv6,
for a more fine-grained detection of multicast routers. This avoids
sending IPv4 multicast packets to an IPv6-only multicast router and
avoids sending IPv6 multicast packets to an IPv4-only multicast router.
This also allows batman-adv to make use of the now split information in
the final patch.

The first eight patches prepare the bridge code to avoid duplicate
code or IPv6-#ifdef clutter for the multicast router state split. And 
contain no functional changes yet.

The ninth patch then implements the IPv4+IPv6 multicast router state
split.

Patch number ten adds IPv4+IPv6 specific timers to the mdb netlink
router port dump, so that the timers validity can be checked
individually
from userspace.

The final, eleventh patch exports this now per protocol family multicast
router state so that batman-adv can then later make full use of the 
Multicast Router Discovery (MRD) support in the Linux bridge. The 
batman-adv protocol format currently expects separate multicast router
states for IPv4 and IPv6, therefore it depends on the first patch.
batman-adv will then make use of this newly exported functions like
this[0].

Regards, Linus

[0]:
https://git.open-mesh.org/batman-adv.git/shortlog/refs/heads/linus/multicast-routeable-mrd
     ->
https://git.open-mesh.org/batman-adv.git/commit/d4bed3a92427445708baeb1f2d1841c5fb816fd4

Changelog v4: 

* Patch 01/11:
  * unchanged
* Patch 02/11:
  * renaming br_multicast_rport_from_node() to
    br_multicast_rport_from_node() to be able to use the name of
    the former later in Patch 7 in br_multicast.c
* Patch 03/11 to 06/11:
  * unchanged
* Patch 07/11:
  * fixing >80 characters line length of
    br_ip4_multicast_get_rport_slot()
  * restructuring br_(ip4_)multicast_get_rport_slot() and 
    br_(ip4_)multicast_mark_router() to reduce duplicate code,
    br_multicast_get_rport_slot() is moved into
    br_multicast_add_router() and uses hlist_for_each() instead of
    hlist_for_each_entry() and a helper function to be protocol
    independent
  * removed redundant hlist_unhashed(&port->ip4_rlist)) check in
    __br_multicast_enable_port(), br_ip4_multicast_add_router() already
    checks this
* Patch 08/11:
  * unchanged
* Patch 09/11:
  * fixing >80 characters line length of
    br_ip6_multicast_get_rport_slot()
  * removed inline attribute from br_ip6_multicast_add_router()
    and br_ip6_multicast_mark_router() in the !IS_ENABLED(CONFIG_IPV6)
    case
  * removed redundant hlist_unhashed(&port->ip6_rlist)) check in
    __br_multicast_enable_port(), br_ip6_multicast_add_router() already
    checks this, which removes some IPv6 ifdef clutter in
     __br_multicast_enable_port()
* Patch 10/11 + 11/11:
  * unchanged

Changelog v3: 

* Patch 01/11:
  * fixed/added missing rename of br->router_list to
    br->ip4_mc_router_list in br_multicast_flood()
* Patch 02/11:
  * moved inline functions from br_forward.c to br_private.h
* Patch 03/11:
  * removed inline attribute from functions added to br_mdb.c
* Patch 04/11:
  * unchanged
* Patch 05/11:
  * converted if()'s into switch-case in br_multicast_is_router()
* Patch 06/11:
  * removed inline attribute from function added to br_multicast.c
* Patch 07/11:
  * added missing static attribute to function
    br_ip4_multicast_get_rport_slot() added to br_multicast.c
* Patch 08/11:
  * removed inline attribute from function added to br_multicast.c
* Patch 09/11:
  * added missing static attribute to function
    br_ip6_multicast_get_rport_slot() added to br_multicast.c
  * removed inline attribute from function added to br_multicast.c
* Patch 10/11:
  * unchanged
* Patch 11/11:
  * simplified bridge check in br_multicast_has_router_adjacent()
    by using br_port_get_check_rcu()
  * added missing declaration for br_multicast_has_router_adjacent()
    in include/linux/if_bridge.h

Changelog v2:

* split into multiple patches as suggested by Nikolay
* added helper functions to br_multicast_flood(), avoiding
  IPv6 #ifdef clutter
* fixed reverse xmas tree ordering in br_rports_fill_info() and
  added helper functions to avoid IPv6 #ifdef clutter
* Added a common br_multicast_add_router() and a helper function
  to retrieve the correct slot to avoid duplicate code for an
  ip4 and ip6 variant
* replaced the "1" and "2" constants in br_multicast_is_router()
  with the appropriate enums
* added br_{ip4,ip6}_multicast_rport_del() wrappers to reduce
  IPv6 #ifdef clutter
* added return values to br_*multicast_rport_del() to only notify
  if the port was actually removed and did not race with a readdition
  somewhere else
* added empty, void br_ip6_multicast_mark_router() if compiled
  without IPv6, to reduce IPv6 #ifdef clutter


