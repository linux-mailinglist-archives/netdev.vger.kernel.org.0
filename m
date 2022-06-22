Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56EC554219
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356293AbiFVFNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiFVFNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2A73465A
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e85-20020a25e758000000b00668ad2fcfdcso12967207ybh.8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6tVn+bdZmpST+irk9pLP9pE1A+os9sO+7MJ2fjRsRoY=;
        b=HpSiMdG2/002uclMk9/ezJNTqxIblsvVs077cvP4F7NgNFV1TuIup6Ff+LA5B/YYk/
         Lxmx/ytVP2VbBTjt8bwc28CVtlKVQA0tKgHjbF8vvc5IP9wRVgdReJDp65Wtxw/Vns1g
         1GAJzwbPXNPqe/rH/4j2eY/7mGJpxqCBwAOY5SvRal5caIG25uVZElfCE2I4yqOKRjv4
         72bYGiZ49mhRa3gVn1SDFQbtiYN/RdIBLh2Rrj5SygSTSM6YTmgHjyvMVFKcDOxhbsPx
         39qVguuFwZpOx1g7/5wUUVZYQW8vHLq1TlvqVgi7wuL1iqDYezUJkNztqo3w8rcMI7Xc
         9QOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6tVn+bdZmpST+irk9pLP9pE1A+os9sO+7MJ2fjRsRoY=;
        b=wLsEhythueZOn568P4BGvxNwQR9VfIfdMnMZcyny/pjYuRZGaATcvOr75oZB8+e7DI
         +GjzgN29FsUiw+wI3hRvPpoiJ5HkxOnuOB/TtftL+yEyUMMT1Pq+pulOY4F0zd3lIZV7
         vGmHg3HU0S4zxGK7w/w/cxRoGQhOtrafflAfRTCcZqEi68UlsyuooOJRPjnhWzufjlqC
         D+317HJ4NaTVIyb/EiYFPL00UJzXyOknqNHofmqf2VGdHuhni3ei5GpBzGaH66CHXhtN
         ec5dIXpJ9iql0FXMGpzSsTI7g/TT8QYkqOfM3LLVWvZoQ6pZYa7uX8cyO8P6y3TRnayR
         9b7w==
X-Gm-Message-State: AJIora/2Kro0HTa1/KchhJjKsZOPXfXINwH8nChLg7YAo5XEZ4INeI+r
        DjGjAxPMxgVgyAmZwCzaETQ2qYOY8XbCQQ==
X-Google-Smtp-Source: AGRyM1sGXVjWRqZmpRVscQJHAWSLv50xVPV32ZpVEYrYs/cEPD5lTqyUB9R+hG9xE9V5ErmpYRLq8dtLneoPaQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:ca8e:0:b0:317:90f2:5f2c with SMTP id
 m136-20020a0dca8e000000b0031790f25f2cmr2126679ywd.259.1655874779519; Tue, 21
 Jun 2022 22:12:59 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:36 +0000
Message-Id: <20220622051255.700309-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 00/19] ipmr: get rid of rwlocks
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to get rid of rwlocks in networking stacks,
if read_lock() is (ab)used from softirq context.

As discussed recently [1], rwlock are unfair by design in this case,
and writers can starve and trigger soft lockups.

This series convert ipmr code (both IPv4 and IPv6 families)
to RCU and spinlocks.

[1] https://lkml.org/lkml/2022/6/17/272

Eric Dumazet (19):
  ip6mr: do not get a device reference in pim6_rcv()
  ipmr: add rcu protection over (struct vif_device)->dev
  ipmr: change igmpmsg_netlink_event() prototype
  ipmr: ipmr_cache_report() changes
  ipmr: do not acquire mrt_lock in __pim_rcv()
  ipmr: do not acquire mrt_lock in ioctl(SIOCGETVIFCNT)
  ipmr: do not acquire mrt_lock before calling ipmr_cache_unresolved()
  ipmr: do not acquire mrt_lock while calling ip_mr_forward()
  ipmr: do not acquire mrt_lock in ipmr_get_route()
  ip6mr: ip6mr_cache_report() changes
  ip6mr: do not acquire mrt_lock in pim6_rcv()
  ip6mr: do not acquire mrt_lock in ioctl(SIOCGETMIFCNT_IN6)
  ip6mr: do not acquire mrt_lock before calling ip6mr_cache_unresolved
  ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()
  ip6mr: switch ip6mr_get_route() to rcu_read_lock()
  ipmr: adopt rcu_read_lock() in mr_dump()
  ipmr: conver /proc handlers to rcu_read_lock()
  ipmr: convert mrt_lock to a spinlock
  ip6mr: convert mrt_lock to a spinlock

 include/linux/mroute_base.h |  15 ++-
 net/ipv4/ipmr.c             | 215 +++++++++++++++++++-----------------
 net/ipv4/ipmr_base.c        |  53 +++++----
 net/ipv6/ip6mr.c            | 202 ++++++++++++++++-----------------
 4 files changed, 255 insertions(+), 230 deletions(-)

-- 
2.37.0.rc0.104.g0611611a94-goog

