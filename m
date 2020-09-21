Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B910272189
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUK4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIUK4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A734FC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:10 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so12259601wrn.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0R6k+8b8StK/+n7KKYMC6z90s2eshE0aKY/OXsuoXd4=;
        b=zfs5YRBd++OOOPCeNE9fYzuJJM4n4LmfgBVv7sbWv2zFh87HMpthYka3RjMNcc+smd
         lZyGyLScpcN03mDygHzGXKEGjFaZAhRHpG+2Nf0WVPzOZv3eMf6bKwTEtqEfwP1mLZQi
         W3k4GzHZyzicbKVPmElmjKP7BQ+/Lw8MT/8Iy8UAXoW/CgSQJRsJCG6C9GqAs4ObU20i
         qWWTQ3Xw0YfGgeItUG+BQn8CxeEAzXbyr7XQ2ZqyStViwq/8BHff6QP8apbZ91qKH1Qe
         a21HRgSm0zlesqWy6p0vjHj4miAqp86YgFQAveaj7ARBOxJpeo86LizAHOrg3V9kXtrj
         3oiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0R6k+8b8StK/+n7KKYMC6z90s2eshE0aKY/OXsuoXd4=;
        b=F5jnlCe1RjowDBSCeVybtklWLuvyjcT+cSVwmohROQ4vJFE9DtglzVXwu7esAMH4aG
         x4wPvlHl2jMlj+L2vnBcvhcwggWw9rwyWsAEemrk2bAKQvs7fjxgI8evOkNdx5NajZP0
         SUKYTwWLjer9u+zeTgmY7numP9o1St17ikkQH5O+c6sCMfcVw2Wvwwa7Fj4FuK1U3u1K
         0cVlijLEdsCxhHJ11smymsld1JlQqWOE5T6DvgMFHk3CVvbtTKZeSWbTI4GnQfWRp4k0
         q0MUJr5gZqrdbtPjPisJUKfj3h6UpyQI9OerOC9d8RYEI0QSZRblDWCQOBmoj2wPsrdd
         mHpw==
X-Gm-Message-State: AOAM5323v0Av/G+DnkwTMGJiWK6GONc/ItweL9PC2DBzbpVI1yq4UOXN
        06QcB3F/LgSkGwGrHLPMgCD8MFzLGoxqjgqjPHI=
X-Google-Smtp-Source: ABdhPJxg97dhWe7E2KrO/qGEsWQ3btR78moQaAFtgJdbP5KTzMR9fyzt7NoiVv+cpvDmj03ZRfB0wg==
X-Received: by 2002:adf:ee8d:: with SMTP id b13mr56080010wro.249.1600685769012;
        Mon, 21 Sep 2020 03:56:09 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:08 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/16] net: bridge: mcast: IGMPv3/MLDv2 fast-path (part 2)
Date:   Mon, 21 Sep 2020 13:55:10 +0300
Message-Id: <20200921105526.1056983-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This is the second part of the IGMPv3/MLDv2 support which adds support
for the fast-path. In order to be able to handle source entries we add
mdb support for S,G entries (i.e. we add source address support to
br_ip), that requires to extend the current mdb netlink API, fortunately
we just add another attribute which will contain nested future mdb
attributes, then we use it to add support for S,G user- add, del and
dump. The lookup sequence is simple: when IGMPv3/MLDv2 are enabled do
the S,G lookup first and if it fails fallback to *,G. The more complex
part is when we begin handling source lists and auto-installing S,G entries
and *,G filter mode transitions. We have the following cases:
 1) *,G INCLUDE -> EXCLUDE transition: we need to install the port in
    all of *,G's installed S,G entries for proper replication (except
    the ones explicitly blocked), this is also necessary when adding a
    new *,G EXCLUDE port group

 2) *,G EXCLUDE -> INCLUDE transition: we need to remove the port from
    all of *,G's installed S,G entries, this is also necessary when
    removing a *,G port group

 3) New S,G port entry: we need to install all current *,G EXCLUDE ports

 4) Remove S,G port entry: if all other port groups were auto-installed we
    can safely remove them and delete the whole S,G entry

Currently we compute these operations from the available ports, their
source lists and their filter mode. In the future we can extend the port
group structure and reduce the running time of these ops. Also one
current limitation is that host-joined S,G entries are not supported.
I.e. one cannot add "dev bridge port bridge" mdb S,G entries. The host
join is currently considered an EXCLUDE {} join, so it's reflected in
all of *,G's installed S,G entries. If an S,G,port entry is added as
temporary then the kernel can take it over if a source shows up from a
report, permanent entries are skipped. In order to properly handle
blocked sources we add a new port group blocked flag to avoid forwarding
to that port group in the S,G. Finally when forwarding we use the port
group filter mode (if it's INCLUDE and the port group is from a *,G then
don't replicate to it, respectively if it's EXCLUDE then forward) and the
blocked flag (obviously if it's set - skip that port unless it's a
router port) to decide if the port should be skipped. Another limitation
is that we can't do some of the above transitions without small traffic
drop while installing/removing entries. That will be taken care of when
we add atomic swap of port replication lists later.

Patch break down:
 patches 1-3: prepare the mdb code for better extack support which is
              used in future patches to return a more meaningful error
 patches 4-6: add the source address field to struct br_ip, and do minor
              cleanups around it
 patches 7-8: extend the mdb netlink API so we can send new mdb
              attributes and uses the new API for S,G entry add/del/dump
              support
 patch     9: takes care of S,G entries when doing a lookup (first S,G
              then *,G lookup)
 patch    10: adds a new port group field and attribute for origin protocol
              we use the already available RTPROT_ definitions,
              currently user-space entries are added as RTPROT_STATIC and
              kernel entries are added as RTPROT_KERNEL, we may allow
              user-space to set custom values later (e.g. for FRR, clag)
 patch    11: adds an internal S,G,port rhashtable to speed up filter
              mode transitions
 patch    12: initial automatic install of S,G entries based on port
              groups' source lists
 patch    13: handles port group modes on transitions or when new
              port group entries are added
 patch    14: self-explanatory - adds support for blocked port group
              entries needed to stop forwarding to particular S,G,port
              entries
 patch    15: handles host-join/leave state changes, treats host-joins
              as EXCLUDE {} groups (reflected in all *,G's S,G entries)
 patch    16: finally adds the fast-path filter mode and block flag
              support

Here're the sets that will come next (in order):
 - iproute2 support for IGMPv3/MLDv2
 - selftests for all mode transitions and group flags
 - explicit host tracking for proper fast-leave support
 - atomic port replication lists (these are also needed for broadcast
   forwarding optimizations)
 - mode transition optimization and removal of open-coded sorted lists

Not implemented yet:
 - Host IGMPv3/MLDv2 filter support (currently we handle only join/leave
   as before)
 - Proper other querier source timer and value updates
 - IGMPv3/v2 MLDv2/v1 compat (I have a few rough patches for this one)

Thanks,
 Nik

Nikolay Aleksandrov (16):
  net: bridge: mdb: use extack in br_mdb_parse()
  net: bridge: mdb: move all port and bridge checks to br_mdb_add
  net: bridge: mdb: use extack in br_mdb_add() and br_mdb_add_group()
  net: bridge: add src field to br_ip
  net: bridge: mcast: use br_ip's src for src groups and querier address
  net: bridge: mcast: rename br_ip's u member to dst
  net: bridge: mdb: add support to extend add/del commands
  net: bridge: mdb: add support for add/del/dump of entries with source
  net: bridge: mcast: when igmpv3/mldv2 are enabled lookup (S,G) first,
    then (*,G)
  net: bridge: mcast: add rt_protocol field to the port group struct
  net: bridge: mcast: add sg_port rhashtable
  net: bridge: mcast: install S,G entries automatically based on reports
  net: bridge: mcast: handle port group filter modes
  net: bridge: mcast: add support for blocked port groups
  net: bridge: mcast: handle host state
  net: bridge: mcast: when forwarding handle filter mode and blocked
    flag

 include/linux/if_bridge.h      |   8 +-
 include/uapi/linux/if_bridge.h |  17 +
 net/batman-adv/multicast.c     |  10 +-
 net/bridge/br_forward.c        |  17 +-
 net/bridge/br_mdb.c            | 371 +++++++++++++-----
 net/bridge/br_multicast.c      | 678 +++++++++++++++++++++++++++------
 net/bridge/br_private.h        |  49 ++-
 7 files changed, 914 insertions(+), 236 deletions(-)

-- 
2.25.4

