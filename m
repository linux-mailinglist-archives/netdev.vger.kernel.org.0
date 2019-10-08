Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA05CF830
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfJHLat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:30:49 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:44566 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730609AbfJHLat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:30:49 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2019 07:30:49 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2324; q=dns/txt; s=iport;
  t=1570534249; x=1571743849;
  h=from:to:cc:subject:date:message-id;
  bh=vW8YRJ7S7+R43Fy2CHGt7wIdHKk2IzF2tqMCuoKtmaw=;
  b=GyjKmi4ZDSc19SOyEE4Ox0h3OM0mAlJ9WdT+qNrd/XxYCcA5QEQhvLW1
   jXl6x9XkONFtexUeJrt/299W5djtZidVESacnH92qMgGjikqjcMVsHV/L
   K9d6EK2KJirQ7dtsGFutM4Kp7VxUXLUhsKpm3ycqTMHElLC+DqraRSbrQ
   4=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17754313"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:41 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe4w031991;
        Tue, 8 Oct 2019 11:23:40 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH 4.4 stable 00/10] net: ip6 defrag: backport fixes 
Date:   Tue,  8 Oct 2019 13:22:59 +0200
Message-Id: <20191008112309.9571-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a backport of a 5.1rc patchset:
  https://patchwork.ozlabs.org/cover/1029418/

Which was backported into 4.19:
  https://patchwork.ozlabs.org/cover/1081619/

and into 4.14:
  https://patchwork.ozlabs.org/cover/1089651/

and into 4.9:
  https://www.spinics.net/lists/netdev/msg567087.html 

This patchset for 4.4 is based on Peter Oskolkov's patchsets above.
5 additional patches has been added to make it all apply, build
and pass TAHI IPv6 Ready test with the IOL INTACT test tool.
Without this patchset 2 extension header tests and 12 fragmentation
tests fail to pass. The previous attempt to fix this seamed to end
here: https://www.spinics.net/lists/netdev/msg567728.html
It would be nice if someone with more netfilter
and fragmentation knowledge than me could review it.

Florian Westphal (3):
  netfilter: ipv6: nf_defrag: avoid/free clone operations
  netfilter: ipv6: avoid nf_iterate recursion
  netfilter: ipv6: nf_defrag: fix NULL deref panic
  ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module

Jason A. Donenfeld (1):
  ipv6: do not increment mac header when it's unset

Subash Abhinov Kasiviswanathan (1):
  netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460

Eric Dumazet (1):
  ipv6: frags: fix a lockdep false positive

Peter Oskolkov (3):
  net: IP defrag: encapsulate rbtree defrag code into callable functions
  net: IP6 defrag: use rbtrees for IPv6 defrag
  net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c

 include/net/inet_frag.h                     |  16 +-
 include/net/ipv6.h                          |  29 ---
 include/net/ipv6_frag.h                     | 111 +++++++++
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |   3 +-
 net/ieee802154/6lowpan/reassembly.c         |   2 +-
 net/ipv4/inet_fragment.c                    | 293 ++++++++++++++++++++++
 net/ipv4/ip_fragment.c                      | 295 +++--------------------
 net/ipv6/netfilter/nf_conntrack_reasm.c     | 344 ++++++++------------------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  23 +-
 net/ipv6/reassembly.c                       | 360 +++++++---------------------
 net/openvswitch/conntrack.c                 |  26 +-
 11 files changed, 664 insertions(+), 838 deletions(-)
 create mode 100644 include/net/ipv6_frag.h

-- 
2.10.2

