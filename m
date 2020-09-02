Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914B825AA45
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIBL3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBL3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10EDC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so4838654wrn.6
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9HJnLy8uo6++sx6Gwyqe9/p3d2QWIpPUEzDVAme086g=;
        b=EBvyNynsZNV9hWw7Qrg66swMTCGi+OhQRmfoy3/6+kce/J55tRsfjyQabyRDPHHWn+
         7FPX0we1fJiW1PKkAnnRXsMlI/aRP1UDDxDmZWdnAtj8Y91/mxsDGTgM6bK8qaNa4pKU
         mHnNUBt8uRkNKNq5Yxc73XIhLnRG9FOvigJMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9HJnLy8uo6++sx6Gwyqe9/p3d2QWIpPUEzDVAme086g=;
        b=n8plUIy6/LQNdvkezniuSq+aaMBVOz7HXKph21KbCMiy1L77HzDj53MUDkklY+XcbO
         CO9ETDyWeAO79zggddQqHw1p5uHAav4+pLzm7ZiARdRqVf/Hz7+wUYnOySi6c160hrZc
         0G9CFNtBqFbqq01sabgk5eNOQ1G/mvOwHEZ8Zr5WfBUaCasQeZdiblkouSmZenPD0kQE
         lI8iniRrjxGap1xm2vDld5vvqfFLrCWM+axvgJULEBV+0DM6AiqDw8sb/vqp5mloECFm
         TO11oYgiv2qafNj8nfSJoWJav5tpJjcNyfUn3OuGSkgSEQ50UF0EtVSn+ERX4Y1F/mYt
         kBzw==
X-Gm-Message-State: AOAM530ws1Nray0UvO3ZVHYI+MPSmFeiqou1HsTRm4d7fMqmhCck7c7E
        qOCX8RXA7whLwiDbq9ylxUgKhfVys9nHdQuk
X-Google-Smtp-Source: ABdhPJw1PdrRsOFXy7T3EvsUjjfq5MrcrggCEU+zA8CKZmBtNRLle16YOy3V02+k2Ked+NkOdrpnpw==
X-Received: by 2002:adf:90d1:: with SMTP id i75mr6432314wri.278.1599046147921;
        Wed, 02 Sep 2020 04:29:07 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:06 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 00/15] net: bridge: mcast: initial IGMPv3 support (part 1)
Date:   Wed,  2 Sep 2020 14:25:14 +0300
Message-Id: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This patch-set implements the control plane for initial IGMPv3 support
which takes care of include/exclude sets and state transitions based on
the different report types.
Patch 01 arranges the structure better by moving the frequently used
fields together, patches 02 and 03 add support for source lists and group
modes per port group which are dumped. Patch 04 adds support for
group-and-source specific queries required for IGMPv3. Patch 05 factors
out the port group deletion code which is used in a few places, then
patch 06 adds support for group and group-and-source query
retransmissions via a new rexmit timer. Patches 07 and 08 make use of
the already present mdb fill functions when sending notifications so we
can have the full mdb entries' state filled in (with sources, mode etc).
Patch 09 takes care of port group expiration, it switches the group mode
to include and deletes it if there are no sources with active timers.
Patches 10-13 are the core changes which add support for IGMPv3 reports
and handle the source list set operations as per RFC 3376, all IGMPv3
report types with their transitions should be supported after these
patches. I've used RFC 3376 and FRR as a reference implementation. The
source lists are capped at 32 entries, we can remove that limitation at
a later point which would require a better data structure to hold them.
IGMPv3 processing is hidden behind the bridge's multicast_igmp_version
option which must be set to 3 in order to enable it.
Patch 14 improves other querier processing a bit (more about this below).
And finally patch 15 transform the src gc so it can be used with all mcast
objects since now we have multiple timers that can be running and we
need to make sure they have all finished before freeing the objects.
This is part 1, it only adds control plane support and doesn't change
the fast path. A following patch-set will take care of that.

Here're the sets that will come next (in order):
 - Fast path patch-set which adds support for (S, G) mdb entries needed
   for IGMPv3 forwarding, entry add source (kernel, user-space etc)
   needed for IGMPv3 entry management, entry block mode needed for
   IGMPv3 exclude mode. This set will also add iproute2 support for
   manipulating and showing all the new state.
 - Selftests patch-set which will verify all IGMPv3 state transitions
   and forwarding
 - Explicit host tracking patch-set, needed for proper fast leave and
   with it fast leave will be enabled for IGMPv3

Not implemented yet:
 - Host IGMPv3 support (currently we handle only join/leave as before)
 - Proper other querier source timer and value updates
 - IGMPv3/v2 compat (I have a few rough patches for this one)

v2:
 patches 02-03: make src lists RCU friendly so they can be traversed
                when dumping, reduce limit to a more conservative 32
                src group entries for a start
 patches 11-13: remove helper and directly do bitops
 patch      15: force mcast gc on bridge port del to make sure port
                group timers have finished before freeing the port

Thanks,
 Nik


Nikolay Aleksandrov (15):
  net: bridge: mdb: arrange internal structs so fast-path fields are
    close
  net: bridge: mcast: add support for group source list
  net: bridge: mcast: add support for src list and filter mode dumping
  net: bridge: mcast: add support for group-and-source specific queries
  net: bridge: mcast: factor out port group del
  net: bridge: mcast: add support for group query retransmit
  net: bridge: mdb: push notifications in __br_mdb_add/del
  net: bridge: mdb: use mdb and port entries in notifications
  net: bridge: mcast: delete expired port groups without srcs
  net: bridge: mcast: support for IGMPv3 IGMPV3_ALLOW_NEW_SOURCES report
  net: bridge: mcast: support for IGMPV3_MODE_IS_INCLUDE/EXCLUDE report
  net: bridge: mcast: support for IGMPV3_CHANGE_TO_INCLUDE/EXCLUDE
    report
  net: bridge: mcast: support for IGMPV3_BLOCK_OLD_SOURCES report
  net: bridge: mcast: improve v3 query processing
  net: bridge: mcast: destroy all entries via gc

 include/uapi/linux/if_bridge.h |   21 +
 net/bridge/br_mdb.c            |  223 ++++---
 net/bridge/br_multicast.c      | 1040 +++++++++++++++++++++++++++++---
 net/bridge/br_private.h        |   67 +-
 4 files changed, 1170 insertions(+), 181 deletions(-)

-- 
2.25.4

