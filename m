Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1659325E662
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIEIYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEIYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1307C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so8811973wmb.4
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lG2pvPc4SHgc6L+ln3Njda4OcYlOBObAxxS4WHFU3Us=;
        b=clpfeJtlKoezTjqlV9J1IoR5sz/x3n4+cCE4+E9z+pLIVo6zR88gVfdOKy4Ma0SA2y
         f9v4zjDBl5a37aWPzpZqUYbWYhqw6ZjgfLfvgJHu7wrojE6sv5JQjk1HK7F8hicbWBkP
         KY0VIcBOdy3frS+470Uc236hFzZquUdvPCTr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lG2pvPc4SHgc6L+ln3Njda4OcYlOBObAxxS4WHFU3Us=;
        b=kOUXBH7RRi7+Xb6tBvX4InWUgPQTCo47hDvYO0vNsvaHwFCcU4CCoFcwkXn5w/hWvz
         jTFVgx9j/2PyJifgbd3eItJbOxRBlSBZAZnASjmVGXloKnaBwI05MPH/XYtEwyicH01u
         wdgto4HxelkKY0EHERYBWU7YesyFnzbTv6KgFC8+UtxgvdgfTeOkdz5yd1OjH/Qa2NcM
         NseGCe+1dVo+vHEbdhp0dRuePbJU1UiR4ixn+js/sy8DRQRMB3UKGo+hPfXxtLdb45y/
         kU39f7yfjPvWfbF7HK1UUNbkIWuMVNxl99GeHNdFsKSfSPYQ0LB5/nqB64quzl5aHr2S
         d0xQ==
X-Gm-Message-State: AOAM531DCjAH/FEKkKEmsCZ49c5O/HGcPo1ppTi6bPuDsmh+fnyL+OY/
        736e5O2+dnJ/aARWKsptuu9grQbDzTxiMUto
X-Google-Smtp-Source: ABdhPJw9dHmLvHWhz2xA/KF16en82qD1kIWqXJ2SZF+waobFp2ITl88BdkmYYalIkxE3/asXjY3gkQ==
X-Received: by 2002:a05:600c:1293:: with SMTP id t19mr11521708wmd.34.1599294279969;
        Sat, 05 Sep 2020 01:24:39 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:39 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 00/15] net: bridge: mcast: initial IGMPv3/MLDv2 support (part 1)
Date:   Sat,  5 Sep 2020 11:23:55 +0300
Message-Id: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This patch-set implements the control plane for initial IGMPv3/MLDv2
support which takes care of include/exclude sets and state transitions
based on the different report types.
Patch 01 arranges the structure better by moving the frequently used
fields together, patches 02 and 03 add support for source lists and group
modes per port group which are dumped. Patch 04 adds support for
group-and-source specific queries required for IGMPv3/MLDv2. Patch 05
factors out the port group deletion code which is used in a few places,
then patch 06 adds support for group and group-and-source query
retransmissions via a new rexmit timer. Patches 07 and 08 make use of
the already present mdb fill functions when sending notifications so we
can have the full mdb entries' state filled in (with sources, mode etc).
Patch 09 takes care of port group expiration, it switches the group mode
to include and deletes it if there are no sources with active timers.
Patches 10-13 are the core changes which add support for IGMPv3/MLDv2
reports and handle the source list set operations as per RFCs 3376 and
3810, all IGMPv3/MLDv2 report types with their transitions should be
supported after these patches. I've used RFCs 3376, 3810 and FRR as a
reference implementation. The source lists are capped at 32 entries, we can
remove that limitation at a later point which would require a better data
structure to hold them. IGMPv3 processing is hidden behind the bridge's
multicast_igmp_version option which must be set to 3 in order to enable it.
MLDv2 processing is hidden behind the bridge's multicast_mld_version
which must be set to 2 in order to enable it.
Patch 14 improves other querier processing a bit (more about this below).
And finally patch 15 transform the src gc so it can be used with all mcast
objects since now we have multiple timers that can be running and we
need to make sure they have all finished before freeing the objects.
This is part 1, it only adds control plane support and doesn't change
the fast path. A following patch-set will take care of that.

Here're the sets that will come next (in order):
 - Fast path patch-set which adds support for (S, G) mdb entries needed
   for IGMPv3/MLDv2 forwarding, entry add source (kernel, user-space etc)
   needed for IGMPv3/MLDv2 entry management, entry block mode needed for
   IGMPv3/MLDv2 exclude mode. This set will also add iproute2 support for
   manipulating and showing all the new state.
 - Selftests patches which will verify all state transitions and forwarding
 - Explicit host tracking patch-set, needed for proper fast leave and
   with it fast leave will be enabled for IGMPv3/MLDv2

Not implemented yet:
 - Host IGMPv3/MLDv2 filter support (currently we handle only join/leave
   as before)
 - Proper other querier source timer and value updates
 - IGMPv3/v2 MLDv2/v1 compat (I have a few rough patches for this one)

v3: add IPv6/MLDv2 support, most patches are changed
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
  net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
  net: bridge: mcast: support for IGMPV3/MLDv2 MODE_IS_INCLUDE/EXCLUDE
    report
  net: bridge: mcast: support for IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUDE
    report
  net: bridge: mcast: support for IGMPV3/MLDv2 BLOCK_OLD_SOURCES report
  net: bridge: mcast: improve IGMPv3/MLDv2 query processing
  net: bridge: mcast: destroy all entries via gc

 include/uapi/linux/if_bridge.h |   21 +
 net/bridge/br_mdb.c            |  256 +++++--
 net/bridge/br_multicast.c      | 1289 ++++++++++++++++++++++++++++----
 net/bridge/br_private.h        |   70 +-
 4 files changed, 1415 insertions(+), 221 deletions(-)

-- 
2.25.4

