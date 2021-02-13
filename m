Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24A731AD6D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBMRvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMRva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:51:30 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793BC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:50:50 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z7so1488966plk.7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 09:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vze65gS3eBQuz12A5cAfGaeighzqHNTr+QAPZyyDDdw=;
        b=r7pf1iR5Nf/jyH5LxwoeGW5gOGzykgeEr5jg5x6fkVGVT065LpBDzENwZID3O4nq/M
         B24j3XX/K/gh6exlT0LUAHylGnHuAo++UB8HkkPu0QLlzzzok2CQY4Xo2LcP0zGBqGIa
         YGBQVpkDVCpivH9WVaco4yB/jqr0tN9C0jBSl35dtI1ZF7qobsQvJjU+2x64a0Iufq8i
         zEo6wbbOwbDiHclKIukk2rXxZ/DqhVPNc/M23t8U4vEhKMiKKdxjP+E7/CVr6ehUefSC
         e1jyBHz5ZR53iVsAn22/GfzJkL9gvvQjM66obWuPBTwPfo8TQ8rKAY4QH99aTVOO8jwC
         9oAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vze65gS3eBQuz12A5cAfGaeighzqHNTr+QAPZyyDDdw=;
        b=je8qoAfWAq0In92tphaCu9B6ujiv4DNKUQgqm9NX0/GX1H/rrP2ZXp+kOS5AB1VGq8
         u8GHApa158aFKA+2vR35XB8liu6MGt9WgR7tCY7c8YY3uwlLhkVO/OXj3nizVzo0IQD4
         mR6XnLbJ8X/koRa5ZZXRHWL2yFD2VYebWgmYi1qtUGt0ujZIGI1yDxXwbBd1FgizkQBC
         DU9Aj5h1zz4ZShAobTv4h/fN60IOSizG2asPstXbFHmzgVWLjgnvPX0kgqTHOWxUUTB9
         DQY6BagGlZqLO4bQTmF42b1wQBBdYo3UTNzf/A0TYZWX7gjoCCbioU0S63QGmGGoESa0
         LOWg==
X-Gm-Message-State: AOAM532DHMLtTDk/lE4yr6QJVOzyaCaRMKuQ4Vqz76YUzJWEpcw8GfZD
        rJlx1bBw66juzHRh64ZfZmo=
X-Google-Smtp-Source: ABdhPJyZ81LtRTQVadwuSKpaeliEU8Hm6ZWrwd/sCrFaetinBSmPRoHxcCUj1T7Y/Ns3ihMMkc3XHQ==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr7961898pjm.28.1613238649543;
        Sat, 13 Feb 2021 09:50:49 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id t17sm14413724pgk.25.2021.02.13.09.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 09:50:48 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH net-next v2 0/7] mld: change context from atomic to sleepable
Date:   Sat, 13 Feb 2021 17:50:38 +0000
Message-Id: <20210213175038.28171-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset changes the context of MLD module.
Before this patchset, MLD functions are atomic context so it couldn't use
sleepable functions and flags.

There are several reasons why MLD functions are under atomic context.
1. It uses timer API.
Timer expiration functions are executed in the atomic context.
2. atomic locks
MLD functions use rwlock and spinlock to protect their own resources.

So, in order to switch context, this patchset converts resources to use
RCU and removes atomic locks and timer API.
1. The first patch convert from the timer API to delayed work.
Timer API is used for delaying some works.
MLD protocol has a delay mechanism, which is used for replying to a query.
If a listener receives a query from a router, it should send a response
after some delay. But because of timer expire function is executed in
the atomic context, this patch convert from timer API to the delayed work.

2. The second patch separate flags from ifmcaddr6->mca_flags.
The context of mca_flags is atomic context and it can't be changed.
This flag includes 5 flags totally, and two of them don't need to be
protected by atomic context, which is MAF_LOADED and MAF_NOREPORT.
In order to reduce atomic context, this patch separates those flags
from mca_flags.
After this patch, mca_flags are still protected by mca_work and the
new variables are protected by RTNL.

3. The third patch adds new delayed work.
The purpose of mld_clear_delrec() function is to delete records.
But this function can be executed in the datapath.
So, resources, which are used by this function can't be protected by RTNL.
This function uses the ifmcaddr6 struct but this struct must be protected
by RTNL in order to change context. So, this patch adds a new delayed_work,
which executes the mld_clear_delrec() function so this function will be
executed in the sleepable context.

4. The fourth patch deletes inet6_dev->mc_lock.
The mc_lock has protected inet6_dev->mc_tomb pointer.
But this pointer is already protected by RTNL and it isn't be used by
datapath. So, it isn't be needed and because of this, many atomic context
critical sections are deleted.

5. The fifth patch convert ip6_sf_socklist to RCU.
ip6_sf_socklist has been protected by ipv6_mc_socklist->sflock(rwlock).
But this is already protected by RTNL So if it is converted to use RCU
in order to be used in the datapath, the sflock is no more needed.
So, its control path context can be switched to sleepable.

6. The sixth patch convert ip6_sf_list to RCU.
The reason for this patch is the same as the previous patch.

7. The seventh patch convert ifmcaddr6 to RCU.
The reason for this patch is the same as the previous patch.
And because of this conversion, all resources in the MLD modules are
finished to be converted to use RCU.
So, the locking scenario is changed to the following.
1. ifmcaddr6->mca_lock only protects following resources.
   a) ifmcaddr6->mca_flags
   b) ifmcaddr6->mca_work.
   c) ifmcaddr6->mca_sources->sf_gsresp
2. inet6_dev->lock only protects following resources.
   a) inet6_dev->mc_gq_running
   b) inet6_dev->mc_gq_work
   c) inet6_dev->mc_ifc_count
   d) inet6_dev->mc_ifc_work
   e) inet6_dev->mc_delerec_work
3. Other resources are protected by RTNL and RCU.

Changelog:
v1 -> v2:
1. Withdraw unnecessary refactoring patches.
(by Cong Wang, Eric Dumazet, David Ahern)
    a) convert from array to list.
    b) function rename.
2. Separate big one patch into small several patches.
3. Do not rename 'ifmcaddr6->mca_lock'.
In the v1 patch, this variable was changed to 'ifmcaddr6->mca_work_lock'.
But this is actually not needed.
4. Do not use atomic_t for 'ifmcaddr6->mca_sfcount' and
'ipv6_mc_socklist'->sf_count'.
5. Do not add mld_check_leave_group() function.
6. Do not add ip6_mc_del_src_bulk() function.
7. Do not add ip6_mc_add_src_bulk() function.
8. Do not use rcu_read_lock() in the qeth_l3_add_mcast_rtnl().
(by Julian Wiedmann)

Taehee Yoo (7):
  mld: convert from timer to delayed work
  mld: separate two flags from ifmcaddr6->mca_flags
  mld: add a new delayed_work, mc_delrec_work
  mld: get rid of inet6_dev->mc_lock
  mld: convert ipv6_mc_socklist->sflist to RCU
  mld: convert ip6_sf_list to RCU
  mld: convert ifmcaddr6 to RCU

 drivers/s390/net/qeth_l3_main.c |   6 +-
 include/net/if_inet6.h          |  32 +-
 net/batman-adv/multicast.c      |   6 +-
 net/ipv6/addrconf.c             |   9 +-
 net/ipv6/addrconf_core.c        |   2 +-
 net/ipv6/af_inet6.c             |   2 +-
 net/ipv6/mcast.c                | 755 +++++++++++++++++---------------
 7 files changed, 425 insertions(+), 387 deletions(-)

-- 
2.17.1

