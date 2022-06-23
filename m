Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07A55571A9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiFWEkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347294AbiFWEe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:34:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F0030F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:34:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h82-20020a25d055000000b00668b6a4ee32so14237148ybg.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QSDlsc5UXnSdWWDeGFSK6eE1vvN88jA3TNSNM9+wjBE=;
        b=l1pTu7iFtJKWY5F41oGRuTA68hYV6iPjaIsN2nKjA4GcpU3fIWYuygJs2Mi7atj7fm
         9FyGQL1evYZ/zDpMBd5Z72cgHE4Vjr6CGsP/5wXGMIZmTTliAI3fNwujTNM49OONGnfE
         DXXXjLDXaEAVZRHkjqOhrCDFoJnQPGHD11MxxLXOarjWNLayDwAebedlmHD8ChuPGWso
         H35obBeiMtUkYTt4/eP5W+DR9VHkG+31DecCOTJgVzn0NYSsnYZa1/jD7q0il4l8HlzJ
         Do6PKWin9vKUTYzmWUVLHiOWTvcdurHcT9ov0ChTRalP1wMVrA2RnImHzHl9ch36OFOQ
         V81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QSDlsc5UXnSdWWDeGFSK6eE1vvN88jA3TNSNM9+wjBE=;
        b=Z0D4tCOg5yCHO60vtxkUAAcohU8WUxLCGJC7A5mieiTSKt2t61+lcx2beePcliAzSH
         Y0MU1wuZN9mlGFw4Y6TvrP6othtNXznYNnMQg52m5x52TiFG/rSqPCzI3luqiFpNnTaL
         CwTeLKbLk8XhFg4+65mN5ONIJ61w7dAM6uNGHwv4cZQqlWAwMv9XYCFCy/eeW+jc5PCw
         9xlXIgN9TyDzl4hTqXbuZ7ueJD2EPH95in07J4c+jytxBFHtVQdJlUS4T0dSA7omiPs+
         ITZ2s3VpUbESuCKSRGkTlv/8JpQkCYnDZHS5gN/I6Mb8IrX/gXNuQERzYuwyBYxvI0lY
         sjuQ==
X-Gm-Message-State: AJIora8oyhOTPB7DMaUlamwAas7Wtt1ektiApKIZTt8LAydYc9pdXvi8
        C13m4OqynXcmB6NtlFQd/Niog4NjBwGqNQ==
X-Google-Smtp-Source: AGRyM1sexi7Ti5BBJvAdDldD/cgbS692/J5asgjF50EUYD2vCbTyL+SX8uGlo3Mo46xBQO7yA11f+ZxWg/sN4g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:2309:0:b0:668:a570:f69a with SMTP id
 j9-20020a252309000000b00668a570f69amr7701695ybj.554.1655958895945; Wed, 22
 Jun 2022 21:34:55 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:30 +0000
Message-Id: <20220623043449.1217288-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 00/19] ipmr: get rid of rwlocks
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

v2: fixed two typos, and resent because patch 19/19
    did not make it to patchwork.

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
  ipmr: convert /proc handlers to rcu_read_lock()
  ipmr: convert mrt_lock to a spinlock
  ip6mr: convert mrt_lock to a spinlock

 include/linux/mroute_base.h |  15 ++-
 net/ipv4/ipmr.c             | 215 +++++++++++++++++++-----------------
 net/ipv4/ipmr_base.c        |  53 +++++----
 net/ipv6/ip6mr.c            | 202 ++++++++++++++++-----------------
 4 files changed, 255 insertions(+), 230 deletions(-)

-- 
2.37.0.rc0.104.g0611611a94-goog

