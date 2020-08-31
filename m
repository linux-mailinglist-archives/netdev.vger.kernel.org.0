Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF034257BBE
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgHaPKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgHaPJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:09:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCB2C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so6336060wrm.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9NRlvcF3T25DILTKeuqX8E3EYjoQX7UtJSzPYWLJykQ=;
        b=UIPOyV/TX/qTZ5nPyNPqNeLqqpySpB79+88G/c5/mSiypSXVyEgV5pQF598fXK/QcJ
         DVGzd/FB9W5miozlIm/H9n2/0VsiPmGWEBdSsOExlCshpOyY1TThKNK9CksFW4wAL+Xi
         aqNKWIib8mhFuKp/e6q9MRAWnrPPVlscB+O9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9NRlvcF3T25DILTKeuqX8E3EYjoQX7UtJSzPYWLJykQ=;
        b=CZGaV3WFMInNGNreNFrlDmnbS3KtqkllnS1i9Jz78caXZL1YE7kWGm0cPck2ctP+dH
         6Zre/uaK6UoSMYPzE1wrpI0SgvrZHYaaOcDHoUkDw1OZs6ELSj3EMB1QcwasctadzSEY
         0Y4SjTvsV9TVRYM6fNAZuyjgvkdILEIiapyxxwvky8HhADdYuHU+7+Hj+uPqUqB7DH3r
         nfUlGeuwbuhuxW8O9z1FMrDhFQ3Io4ZqW0cukF1sKuTne4dY3h4WamfVJMAXWabAxI2p
         XWmiVWZvrBuq7lhGY5Qi6EUhxtnsTd0EOqiOTA/pH61FiIdtpjQPvKhHFnduom5MtZeU
         cdYQ==
X-Gm-Message-State: AOAM533JBMaT4SqWSiJzgcbWiu6zbeSqZvCN2Hgj1Pj7ogZExB9arb79
        KqRKdDSNlShNid1T+JRLotaMGp3TcsK7tsvn
X-Google-Smtp-Source: ABdhPJxJGmZ6Pks4k0jiikUTCv9YL32nZcRKktFEwp4Z9bHPgq1VZqm0woD+taAUhx4CEjwz1RVQSg==
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr2060047wru.341.1598886590422;
        Mon, 31 Aug 2020 08:09:50 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:09:49 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 00/15] net: bridge: mcast: initial IGMPv3 support (part 1)
Date:   Mon, 31 Aug 2020 18:08:30 +0300
Message-Id: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This patch-set implements the control plane for initial IGMPv3 support.
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
source lists are capped at 64 entries, we can remove that limitation at
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
 - Proper other querier source timer updates
 - IGMPv3/v2 compat (I have a few rough patches for this one)

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
 net/bridge/br_mdb.c            |  222 ++++---
 net/bridge/br_multicast.c      | 1058 +++++++++++++++++++++++++++++---
 net/bridge/br_private.h        |   66 +-
 4 files changed, 1186 insertions(+), 181 deletions(-)

-- 
2.25.4

