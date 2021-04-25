Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFF236A81C
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhDYP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 11:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 11:58:36 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D366C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:57:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b17so1471191pgh.7
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 08:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BTmvBEVXirwzpsB3Llo7a4KAUL1Zy1yuUG50mcsuR8Q=;
        b=kkbFNAFCFuVuxuYUUcVa7wDCOkZWaNs1pmjhc+TWKfjegHjlDLjeMmaBEfcq+1uyfM
         nzIaHv11oLjsuNJCv9OIZN015g7VycGZ0YzCsIMPPV8FRhbRnkf58BDJ5OTnZOlogWns
         GNNC9/8uphSOM0pTXUFRj2JFtf58qTlE1qet0+EdzFQXYak8/ysF2sYtQYaEmhQlAZNM
         71bjyNzvT5sh4EtqTv9wF+elxX7szmIMgLAQ9DWdwRV4JCdE947UVLjkZZlTML+P5UIu
         x7gyvBTsWiySQmO6HZL5AcooM4dIBadcU605HlqGHJnIHRkX+PN87bQiCOMPO61Wjmw1
         XXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BTmvBEVXirwzpsB3Llo7a4KAUL1Zy1yuUG50mcsuR8Q=;
        b=CxiveixYp0BTiYz8WYCLgu+HGNEcTG0UefN+QQz2A1v9DBWds0w0IRfwEmnnqLncwW
         DNHpP4MqdmfKo37b5B+4scYtjCVAEo2nXfeW4EeVfoHqRVAY5qNufjVAMAYAP/ctsnCl
         YgqO1ebpDXMBGa5yncudBpRVH0f6ykKplT56bAqQo13pZFkmE7JVzJz0xqrquYLaM+9k
         FALfk8lCcXvduaUkCKwrwSkEb6Lh3BhtOEtPt49gZQ/Y4oNL2Q8ifNRd9HxPLtlHgPzV
         SS31+3rLfGYtaFXHISB2Vj8urccMQYbJolfrrAubyll8fyt3UPtOvVHbbBewN36cRy0C
         0jXw==
X-Gm-Message-State: AOAM533VeWh6Qq3245bBkHEUKCt4cIFnWAogVz/mVGkZE7pF1zMayGf2
        0VUV/3C4npJFs2IzVaWFsHE=
X-Google-Smtp-Source: ABdhPJw+iqe+445qvMG06giVYEjgnSS6IJmWVJIqpzWhUZAyeexIDX+eXF292COrBG8Mc6ofj0SBLQ==
X-Received: by 2002:a62:808b:0:b029:252:eddc:afb0 with SMTP id j133-20020a62808b0000b0290252eddcafb0mr13847226pfd.41.1619366275497;
        Sun, 25 Apr 2021 08:57:55 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id j26sm8983010pfn.47.2021.04.25.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 08:57:55 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, nikolay@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/2] net: fix lockdep false positive splat
Date:   Sun, 25 Apr 2021 15:57:40 +0000
Message-Id: <20210425155742.30057-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix lockdep false positive splat in multicast part of
the bridge.

When mdb or multicast config is changed, it acquires multicast_lock,
which is a per-interface(bridge) lock.
So, spin_lock_nested() should be used instead of spin_lock() because
interfaces can be recursive.
The spin_lock_nested() needs 'subclass' parameter.

The first patch adds a new helper function, which returns the nest_level
variable under RCU. The nest_level variable can be used as 'subclass'
parameter of spin_lock_nested().
The second patch fix lockdep false positive splat in the bridge multicast
part by using netdev_get_nest_level_rcu().

v2:
 - Remove dupliate Subject

Taehee Yoo (2):
  net: core: make bond_get_lowest_level_rcu() generic
  net: bridge: fix lockdep multicast_lock false positive splat

 drivers/net/bonding/bond_main.c |  45 +---------
 include/linux/netdevice.h       |   1 +
 net/bridge/br_mdb.c             |  12 +--
 net/bridge/br_multicast.c       | 146 ++++++++++++++++++++------------
 net/bridge/br_multicast_eht.c   |  18 ++--
 net/bridge/br_private.h         |  48 +++++++++++
 net/core/dev.c                  |  44 ++++++++++
 7 files changed, 204 insertions(+), 110 deletions(-)

-- 
2.17.1

