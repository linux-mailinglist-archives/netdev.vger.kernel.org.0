Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01E91BB621
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD1GCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1GCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:02:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C593DC03C1A9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:02:10 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so10178147pfa.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vSUMl5+rmIjYKcblx58SaX02yQIi0h9MIrtoTul26YE=;
        b=RQcaP3xuoZYVd93kfTuozb46dnacW//zQYKm/WkKl/9OdmS0WHGCAj41CObWTH8r/6
         44pY3H7eFiKl/njeCBVVBJKOL5dH22OLykwBPQTKVSc8Ox5ijdoj2iNcHD60ktWRvLej
         MWHPJ+dwdgqfK7NXRPnvAgKQ1X/6IbwLv4Z52C7x0DutPRgS2TH6YyH5Ht5Bb0UvqXoK
         /+DTjHCthG5i4uUeSj6dDpVo4Z8NRjF1eJgxG3qh8bDAfw99r4CTuIZEuuSYdvlNrgDI
         kkijf3EtnI88Z4Nuhp2pMZRiLzeTM9LCkfpff+etiwMGzwp2oOP1cuscohXHo+MrX/8q
         dB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vSUMl5+rmIjYKcblx58SaX02yQIi0h9MIrtoTul26YE=;
        b=mOvlmBeCDEs+BXEhlO1hEMCJweMrRRdv+WHQDIcBDQpWsgPqTVDo5DJDqPAF3wo+ah
         nuGoldC+FUq+7iroSeYImjToYaW0KSS/+W+hF3SaWJxGBVQOhg5Zbg4JN0eeDzuNzjw1
         As0LEVmXFCRn2Ao4J+5SILTJzYh6OUvMq/t7Y7wZMeTWqZfz/CyANZMqxtF32j/51QmH
         mOdoMtTc7cj/kjd13YdKdHc55y96bbnCb6gqj+uGP+NlUIZrPGtFiPB4/zSvOvak2o0d
         YRLCAxvRKMZEaTCxCnF01uuT4trDZjWgRRgEz29+V9PUydQv56EUNGko0hZu839XBAS7
         lH2w==
X-Gm-Message-State: AGi0Puam/AaedjouVS7an0q0Sj3FGKud9MlrOJK7KbJAm5Er+kHCtssF
        1crqlhSThbjjtlxdzTL4iKTloHv6wjE=
X-Google-Smtp-Source: APiQypKDjSJsHjJXlx9mr7iVU8m2HEEHu682AYqjWVRvBTjq5yX+smzP6lFirIEecJjLBKb+qAVKYQ==
X-Received: by 2002:a62:e113:: with SMTP id q19mr27457405pfh.107.1588053730050;
        Mon, 27 Apr 2020 23:02:10 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id a12sm14006751pfr.28.2020.04.27.23.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 23:02:09 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 0/2] net: reduce dynamic lockdep keys
Date:   Mon, 27 Apr 2020 23:02:04 -0700
Message-Id: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has been complaining about low MAX_LOCKDEP_KEYS for a
long time, it is mostly because we register 4 dynamic keys per
network device.

This patchset reduces the number of dynamic lockdep keys from
4 to 1 per netdev, by reverting to the previous static keys,
except for addr_list_lock which still has to be dynamic.
The second patch removes a bonding-specific key by the way.

Cong Wang (2):
  net: partially revert dynamic lockdep key changes
  bonding: remove useless stats_lock_key

---
 drivers/net/bonding/bond_main.c               |  4 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 16 ++++
 drivers/net/hamradio/bpqether.c               | 20 +++++
 drivers/net/hyperv/netvsc_drv.c               |  2 +
 drivers/net/ipvlan/ipvlan_main.c              |  2 +
 drivers/net/macsec.c                          |  2 +
 drivers/net/macvlan.c                         |  2 +
 drivers/net/ppp/ppp_generic.c                 |  2 +
 drivers/net/team/team.c                       |  1 +
 drivers/net/vrf.c                             |  1 +
 .../net/wireless/intersil/hostap/hostap_hw.c  | 22 +++++
 include/linux/netdevice.h                     | 27 ++++--
 include/net/bonding.h                         |  1 -
 net/8021q/vlan_dev.c                          | 23 +++++
 net/batman-adv/soft-interface.c               | 30 +++++++
 net/bluetooth/6lowpan.c                       |  8 ++
 net/core/dev.c                                | 90 +++++++++++++++----
 net/dsa/slave.c                               | 12 +++
 net/ieee802154/6lowpan/core.c                 |  8 ++
 net/l2tp/l2tp_eth.c                           |  1 +
 net/netrom/af_netrom.c                        | 21 +++++
 net/rose/af_rose.c                            | 21 +++++
 net/sched/sch_generic.c                       | 17 ++--
 23 files changed, 296 insertions(+), 37 deletions(-)

-- 
2.26.1

