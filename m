Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B59841D8F0
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350525AbhI3LlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350447AbhI3LlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60890C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b26so21118420edt.0
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KIveXak6Vojd3sokG7dlyIU3QoU8hE8FWBUOhGDGfeI=;
        b=6758ujj/xkUJlRKM/gv5jB4WFM24hg6EH55anzQh22hmdx+lue08kzniTNCCUr8xp7
         bQwU8vryKqX5/UZuO5/7z37M+5ExXFWQrh8ILEyQ3cYZfXn6Ui68bAwkDv4utS29AOz5
         cp66TosLvxcfwQ2NH+Ij4dHjV1FK0umXii0jWw9Gs5CqFJ7P22N+afnrpza+5JzNpOAL
         ledDS7pQHtSgZyu9NdHGo/8rKrKbnLzjSzXY+X4id7jJ3Or06rYWxP0FOhW4jhCvmmLD
         PZLNpxVLUaaHtqzkbrZQWg5HBqJ/UHdTGBlo0JnsxTMwAyErlZ6vNsr2pjdm4d62lLvo
         F7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KIveXak6Vojd3sokG7dlyIU3QoU8hE8FWBUOhGDGfeI=;
        b=vOm92Uk8RmHE3w+EbNjg3VOxxYNiAndQog76PED31T/yezVycMMpQEgB+0ZDzNMHRC
         sEL8/CYUSPsfCuDVigVlXGUePED5qu3ubtJkgIrkl9MkUxvSOJUjQeBBQp4TBbvx1VlA
         quHW0qzOIHy3GKpmraalqosiEHXHuJDPNkA2QksQuQeWMwbaGu/uqESkn8cs6aVjTTf2
         zr/NJzyfC9EiSs+PCWR33HIJ4dEoZOYkVkHtt5Lzl/iFqHEE1IiBIklXSUaZdrDtGoY1
         jzB0sjp2IG7/5AEyYh1w4yftoQNRSfKJQx7BibrojSpiL+pmHbz6ggzgIRDA7upoy5RH
         AVZw==
X-Gm-Message-State: AOAM532bnf0kloUj/rMNsMORxH98Ymz6WV40VFHWIltock4KamXLQRBb
        lvutEPA60YML+PmLmMChIxZEm/wUiO8/PF/k
X-Google-Smtp-Source: ABdhPJwwBHmYlwjqg8bVLV0h6zpNhXnAx47Z8yaUCvi5UcJZCrETgRI8J1TqBlLpErcDs1LDOw8Kig==
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr1260759edp.339.1633001963692;
        Thu, 30 Sep 2021 04:39:23 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 00/12] ip: nexthop: cache nexthops and print routes' nh info
Date:   Thu, 30 Sep 2021 14:38:32 +0300
Message-Id: <20210930113844.1829373-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set tries to help with an old ask that we've had for some time
which is to print nexthop information while monitoring or dumping routes.
The core problem is that people cannot follow nexthop changes while
monitoring route changes, by the time they check the nexthop it could be
deleted or updated to something else. In order to help them out I've
added a nexthop cache which is populated (only used if -d / show_details
is specified) while decoding routes and kept up to date while monitoring.
The nexthop information is printed on its own line starting with the
"nh_info" attribute and its embedded inside it if printing JSON. To
cache the nexthop entries I parse them into structures, in order to
reuse most of the code the print helpers have been altered so they rely
on prepared structures. Nexthops are now always parsed into a structure,
even if they won't be cached, that structure is later used to print the
nexthop and destroyed if not going to be cached. New nexthops (not found
in the cache) are retrieved from the kernel using a private netlink
socket so they don't disrupt an ongoing dump, similar to how interfaces
are retrieved and cached.

I have tested the set with the kernel forwarding selftests and also by
stressing it with nexthop create/update/delete in loops while monitoring.

Comments are very welcome as usual. :)

Changes since RFC:
 - reordered parse/print splits, in order to do that I have to parse
   resilient groups first, then add nh entry parsing so code has been
   reordered as well and patch order has changed, but there have been
   no functional changes (as before refactoring of old code is done in
   the first 8 patches and then patches 9-12 add the new cache and use it)
 - re-run all tests above

Patch breakdown:
Patches 1-2: update current route helpers to take parsed arguments so we
             can directly pass them from the nh_entry structure later
Patch     3: adds new nha_res_grp structure which describes a resilient
             nexhtop group
Patch     4: splits print_nh_res_group into a parse and print parts
             which use the new nha_res_grp structure
Patch     5: adds new nh_entry structure which describes a nexthop
Patch     6: factors out print_nexthop's attribute parsing into nh_entry
             structure used before printing
Patch     7: factors out print_nexthop's nh_entry structure printing
Patch     8: factors out ipnh_get's rtnl talk part and allows to use a
             different rt handle for the communication
Patch     9: adds nexthop cache and helpers to manage it, it uses the
             new __ipnh_get to retrieve nexthops
Patch    10: adds a new helper print_cache_nexthop_id that prints nexthop
             information from its id, if the nexthop is not found in the
             cache it fetches it
Patch    11: the new print_cache_nexthop_id helper is used when printing
             routes with show_details (-d) to output detailed nexthop
             information, the format after nh_info is the same as
             ip nexthop show
Patch    12: changes print_nexthop into print_cache_nexthop which always
             outputs the nexthop information and can also update the cache
             (based on process_cache argument), it's used to keep the
             cache up to date while monitoring

Example outputs (monitor):
[NEXTHOP]id 101 via 169.254.2.22 dev veth2 scope link proto unspec 
[NEXTHOP]id 102 via 169.254.3.23 dev veth4 scope link proto unspec 
[NEXTHOP]id 103 group 101/102 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
[ROUTE]unicast 192.0.2.0/24 nhid 203 table 4 proto boot scope global 
	nh_info id 203 group 201/202 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
	nexthop via 169.254.2.12 dev veth3 weight 1 
	nexthop via 169.254.3.13 dev veth5 weight 1 

[NEXTHOP]id 204 via fe80:2::12 dev veth3 scope link proto unspec 
[NEXTHOP]id 205 via fe80:3::13 dev veth5 scope link proto unspec 
[NEXTHOP]id 206 group 204/205 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
[ROUTE]unicast 2001:db8:1::/64 nhid 206 table 4 proto boot scope global metric 1024 pref medium
	nh_info id 206 group 204/205 type resilient buckets 512 idle_timer 0 unbalanced_timer 0 unbalanced_time 0 scope global proto unspec 
	nexthop via fe80:2::12 dev veth3 weight 1 
	nexthop via fe80:3::13 dev veth5 weight 1 

[NEXTHOP]id 2  encap mpls  200/300 via 10.1.1.1 dev ens20 scope link proto unspec onlink 
[ROUTE]unicast 2.3.4.10 nhid 2 table main proto boot scope global 
	nh_info id 2  encap mpls  200/300 via 10.1.1.1 dev ens20 scope link proto unspec onlink 

JSON:
 {
        "type": "unicast",
        "dst": "198.51.100.0/24",
        "nhid": 103,
        "table": "3",
        "protocol": "boot",
        "scope": "global",
        "flags": [ ],
        "nh_info": {
            "id": 103,
            "group": [ {
                    "id": 101,
                    "weight": 11
                },{
                    "id": 102,
                    "weight": 45
                } ],
            "type": "resilient",
            "resilient_args": {
                "buckets": 512,
                "idle_timer": 0,
                "unbalanced_timer": 0,
                "unbalanced_time": 0
            },
            "scope": "global",
            "protocol": "unspec",
            "flags": [ ]
        },
        "nexthops": [ {
                "gateway": "169.254.2.22",
                "dev": "veth2",
                "weight": 11,
                "flags": [ ]
            },{
                "gateway": "169.254.3.23",
                "dev": "veth4",
                "weight": 45,
                "flags": [ ]
            } ]
  }

Thank you,
 Nik


Nikolay Aleksandrov (12):
  ip: print_rta_if takes ifindex as device argument instead of attribute
  ip: export print_rta_gateway version which outputs prepared gateway
    string
  ip: nexthop: add resilient group structure
  ip: nexthop: split print_nh_res_group into parse and print parts
  ip: nexthop: add nh entry structure
  ip: nexthop: parse attributes into nh entry structure before printing
  ip: nexthop: factor out print_nexthop's nh entry printing
  ip: nexthop: factor out ipnh_get_id rtnl talk into a helper
  ip: nexthop: add cache helpers
  ip: nexthop: add a helper which retrieves and prints cached nh entry
  ip: route: print and cache detailed nexthop information when requested
  ip: nexthop: add print_cache_nexthop which prints and manages the nh
    cache

 ip/ip_common.h |   4 +-
 ip/ipmonitor.c |   3 +-
 ip/ipnexthop.c | 459 +++++++++++++++++++++++++++++++++++++++----------
 ip/iproute.c   |  32 ++--
 ip/nh_common.h |  53 ++++++
 5 files changed, 448 insertions(+), 103 deletions(-)
 create mode 100644 ip/nh_common.h

-- 
2.31.1

