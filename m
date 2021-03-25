Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2434134968B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCYQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCYQRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:17:12 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67F1C06174A;
        Thu, 25 Mar 2021 09:17:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m11so2541974pfc.11;
        Thu, 25 Mar 2021 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BSzjAGgCw63gBBm4851CZ2FBYt1vflt0KQxjA+y8wUo=;
        b=lcVi/cV2vXS+/+f3hRNhK81O78ARTTqAuWrWGAMkiOCwQYEdjy+xlqmd5vuG5K/GA/
         XpKacLB/fMoDNJphO5CchycguOUi/UNlWMhmVH8It0j7KyrxeN/EIdfZyX23JDcvgx0I
         3kV7LHka8Ieluffj8mTZVnMixvKoPjRnfQJLf4/yrfp30LAzQWE3bZ2MfM1OZ1cMXWcI
         vVTDwy2jWB0p3U04mTEQlAM613XnmZ+JnArZCqyPdrhy8r3yU4Yh42K0wv67z5L2UghM
         eqdTpCRMFhoIS+5qdWwmALYz5xTchZ8e0H98XvkDb32VutJwKDQzV7bp5V9E90JKUj1m
         /b+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BSzjAGgCw63gBBm4851CZ2FBYt1vflt0KQxjA+y8wUo=;
        b=jlO38IxR4Hfq5V2CnA9e2Uzy/YSsTT+y03lkIjCOuLnuvTqe0+FK8KAgrNLkw1Wn98
         Cw0q+DibYXm6r9IKm+p+GExqXGdGA+PgJQl2f8uFePoJ9Lvl19BgRYsOnX5JCoQMa0KY
         PuUfXGceSdeIr+Quw2/ogMdeLUFxLqmQyGfTJgWTIZ1oLc4DAdKuo6xaHLJ0M6GYb7CR
         8I4YhBQhl8cOtllixpCn/aqm5HsqZqkbGwi68TmFE47mfJ+wKRBQOPpBNlJOiSx4y+yB
         f4jsQegggU+v8WZ6DPQ4+gIWpe+e6Aasyt25L9n6sDQSy13OpKF/OlfSDT3vjWz43AH1
         Z0fw==
X-Gm-Message-State: AOAM53193JfeKzAvYGEayxK66i+L5KpOeSTUHVYc8HYIipKSekmFrL5i
        jvjPmZYtXyVp+XvGs32Edzljp1jMmGWVLw==
X-Google-Smtp-Source: ABdhPJxUN5QK9MbeZl03qj8GTUvsg+nKRCCQ4r8AhliZsCKa7Xp2xRICo0IQVMfx1mXyi/pqhXLMsg==
X-Received: by 2002:a17:902:da81:b029:e5:de44:af5b with SMTP id j1-20020a170902da81b02900e5de44af5bmr10472610plx.27.1616689031898;
        Thu, 25 Mar 2021 09:17:11 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id s15sm6416917pgs.28.2021.03.25.09.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:17:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     ap420073@gmail.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next v3 0/7] mld: change context from atomic to sleepable
Date:   Thu, 25 Mar 2021 16:16:50 +0000
Message-Id: <20210325161657.10517-1-ap420073@gmail.com>
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

2. The fourth patch deletes inet6_dev->mc_lock.
The mc_lock has protected inet6_dev->mc_tomb pointer.
But this pointer is already protected by RTNL and it isn't be used by
datapath. So, it isn't be needed and because of this, many atomic context
critical sections are deleted.

3. The fifth patch convert ip6_sf_socklist to RCU.
ip6_sf_socklist has been protected by ipv6_mc_socklist->sflock(rwlock).
But this is already protected by RTNL So if it is converted to use RCU
in order to be used in the datapath, the sflock is no more needed.
So, its control path context can be switched to sleepable.

4. The sixth patch convert ip6_sf_list to RCU.
The reason for this patch is the same as the previous patch.

5. The seventh patch convert ifmcaddr6 to RCU.
The reason for this patch is the same as the previous patch.

6. Add new workqueues for processing query/report event.
By this patch, query and report events are processed by workqueue
So context is sleepable, not atomic.
While this logic, it acquires RTNL.

7. Add new mc_lock.
The purpose of this lock is to protect per-interface mld data.
Per-interface mld data is usually used by query/report event handler.
So, query/report event workers need only this lock instead of RTNL.
Therefore, it could reduce bottleneck.

Changelog:
v2 -> v3:
1. Do not use msecs_to_jiffies().
(by Cong Wang)
2. Do not add unnecessary rtnl_lock() and rtnl_unlock().
(by Cong Wang)
3. Fix sparse warnings because of rcu annotation.
(by kernel test robot)
   - Remove some rcu_assign_pointer(), which was used for non-rcu pointer.
   - Add union for rcu pointer.
   - Use rcu API in mld_clear_zeros().
   - Remove remained rcu_read_unlock().
   - Use rcu API for tomb resources.
4. withdraw prevopus 2nd and 3rd patch.
   - "separate two flags from ifmcaddr6->mca_flags"
   - "add a new delayed_work, mc_delrec_work"
5. Add 6th and 7th patch.

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
  mld: get rid of inet6_dev->mc_lock
  mld: convert ipv6_mc_socklist->sflist to RCU
  mld: convert ip6_sf_list to RCU
  mld: convert ifmcaddr6 to RCU
  mld: add new workqueues for process mld events
  mld: add mc_lock for protecting per-interface mld data

 drivers/s390/net/qeth_l3_main.c |    6 +-
 include/net/if_inet6.h          |   37 +-
 include/net/mld.h               |    3 +
 net/batman-adv/multicast.c      |    6 +-
 net/ipv6/addrconf.c             |    9 +-
 net/ipv6/addrconf_core.c        |    2 +-
 net/ipv6/af_inet6.c             |    2 +-
 net/ipv6/icmp.c                 |    4 +-
 net/ipv6/mcast.c                | 1080 ++++++++++++++++++-------------
 9 files changed, 678 insertions(+), 471 deletions(-)

-- 
2.17.1

