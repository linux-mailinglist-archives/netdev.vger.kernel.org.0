Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAE31C2A16
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 07:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgECFWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 01:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgECFWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 01:22:30 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF8C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 22:22:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s10so5461753plr.1
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 22:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vSUMl5+rmIjYKcblx58SaX02yQIi0h9MIrtoTul26YE=;
        b=KkRWOJtHvU7d9UM1zC4z395e8hpdVnIOt6AdmjxbY16AP8ACt8vMw+l022aT6+UwH5
         5/x09NAuvq2CATg7FaiwogREtJVMtxWhUTMsk0d1/dV9r8EVSpu8ua/MAfWDWbiZdKqK
         rRvgl1k/47bqdqxHQQE/zRm5Jf7gdzBTfQs1vmM5QosUi4LSzOvzOSPU7lYbtYjLNhn0
         caWtpnQ2wZYmLA/BTncj7i3zYNFOVr1ULf7aa33Fz3kNVEhJgJ1kCvy3NBt3N9iofEQo
         LVGZithykJ8zenxd6EanMhGQSY6NjVjAJCw/t65RfFxjs46fFVW4/SiILewgNwU26axx
         POvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vSUMl5+rmIjYKcblx58SaX02yQIi0h9MIrtoTul26YE=;
        b=NGD5yC3+EFZZ56MY1cO2vFVzap2u1sjZ7o8zGt8Ku3iLWZhf7ulfAvXKBn+KyRTgFn
         0cpZdy4ZW15ip9YXpaZ1bZQIVnbT+m2X+/AD6a2hx+4JTdk4h7QdMq7B4vlid4sg4hP0
         fTqDfrqq+tbtYAk+nv+VSb4VxWq6Yq+Jz18qZMGTqwfRs7pJP4bgMztA3XYGOH7YLaJ5
         KUpE5DTUd95lLkR/jfDVoSer00K5bxWbJNIkKCEN4OG01tivTEtfOIwpjXQDE5Bya3WU
         UyFWkNCj6HOJwP1b8B8fxZ39l4C5DUgTQCZnftdkPy2KDV5pBuoP4ATBGHkG/hz3631s
         lwqQ==
X-Gm-Message-State: AGi0PuaBULa76/NTB11OLaDHvNWocCM+Y0fpFi6Z9TULZ6o9ISRiQf3p
        oU3TDxMyp0wM7xtDCQTG9BNGBKxwaHU=
X-Google-Smtp-Source: APiQypLvipvY9dRmNY3+2rn57mi57siTOdYtDm6ezivZ3dbiH/5MLxsUqpM2uvB1n8VVZI7SY2Xzqw==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr9671315pjq.26.1588483349586;
        Sat, 02 May 2020 22:22:29 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id y3sm3499597pjb.41.2020.05.02.22.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 22:22:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next v2 0/2] net: reduce dynamic lockdep keys
Date:   Sat,  2 May 2020 22:22:18 -0700
Message-Id: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
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

