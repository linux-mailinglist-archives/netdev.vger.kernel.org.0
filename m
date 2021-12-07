Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8198046AFCB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhLGBfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351599AbhLGBeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EBEC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:30:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gt5so9105774pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMYUDmhw4gQhOa5Bd1qlZd65d51RMCqkMUBwDtWBbOI=;
        b=cXD6Go5v72vWTr88H7VKFnc9VdFE2l5HMj9DKeYXzT+Y3XMBnFiKy8GZdDbCif0G+b
         uPdA0mAUhfeBcWdsGE6uwdtj2ARTZTbzTYLTxlESnQdpCduem6cczmc31cuQZ7wklX1e
         RwwfWZ4sYoLn4cjJ1ydxNWEvyEHC7FEFWmVtu2GHGF8NUOeGSL0kOXTkDvmw4OGSrNX8
         2c3f54mDgoHsafN5ZLNsQtiWNnTJzBf2Pv/Fcr2YC49YvNco+w9cmveXHnA78crePyMS
         sMp+E3pYLzIrjb8A20GvxlJw9V/Ppw3w2Adt3uxFy1eHe2juxK5baeTYkkcZlGc7ltrs
         Ly3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMYUDmhw4gQhOa5Bd1qlZd65d51RMCqkMUBwDtWBbOI=;
        b=glRPJxDmuz/8FeOdIWiIIvaiEStIB4rdrJm8fxJ95Jpe38ABaNZ9fbA98wiUXTG5N9
         ZcmI6XC497Bpk8CJ/DP/vhBFuia32owQXa0Tp6H8VLOMSmhZLoeFwyRR1FhVyuIedXLh
         MRgvdgA27uoapdN/t3EXCsRPlWTK0eSFvoW77tS/JUA8x1UZ60mGl1No2lIDC6D5iy2m
         oZoYD+O2nNjRGJpz3kWVG4y3mq5R2IpVGYQqrMEvjbdLCa/pcO5mlVFRoHmgTmd5MW6M
         nzhkXss9NlIsKYIVALESaenDCxQI7XqxLoylwzlJBzw6V4FUVct+2mZ+Qugd56BxxNXQ
         2CfQ==
X-Gm-Message-State: AOAM531zWVMnrCmsT/9SyK/KnO4Y+jUW1PUzGTNYzkTT5DLyfqkGh0W2
        zAJeV5nYZqxM2CSmCgFhc+VLOGQSK70=
X-Google-Smtp-Source: ABdhPJx4KrKvmkrO+NIFw66S3ButwJX72V+tF5AB6qwuugG56slZrvpHS0TwmGT8Rieili7vekMsRw==
X-Received: by 2002:a17:902:b712:b0:143:72b7:4096 with SMTP id d18-20020a170902b71200b0014372b74096mr47655041pls.25.1638840655959;
        Mon, 06 Dec 2021 17:30:55 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:30:55 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/13] net: second round of netdevice refcount tracking
Date:   Mon,  6 Dec 2021 17:30:26 -0800
Message-Id: <20211207013039.1868645-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

The most interesting part of this series is probably
("inet: add net device refcount tracker to struct fib_nh_common")
but only future reports will confirm this guess.

Eric Dumazet (13):
  net: eql: add net device refcount tracker
  vlan: add net device refcount tracker
  net: bridge: add net device refcount tracker
  net: watchdog: add net device refcount tracker
  net: switchdev: add net device refcount tracker
  inet: add net device refcount tracker to struct fib_nh_common
  ax25: add net device refcount tracker
  llc: add net device refcount tracker
  pktgen add net device refcount tracker
  net/smc: add net device tracker to struct smc_pnetentry
  netlink: add net device refcount tracker to struct ethnl_req_info
  openvswitch: add net device refcount tracker to struct vport
  net: sched: act_mirred: add net device refcount tracker

 drivers/net/eql.c              |  4 ++--
 include/linux/if_eql.h         |  1 +
 include/linux/if_vlan.h        |  3 +++
 include/linux/netdevice.h      |  2 ++
 include/net/ax25.h             |  3 +++
 include/net/ip_fib.h           |  2 ++
 include/net/llc_conn.h         |  1 +
 include/net/tc_act/tc_mirred.h |  1 +
 net/8021q/vlan_dev.c           |  4 ++--
 net/ax25/ax25_dev.c            |  8 ++++----
 net/bridge/br_if.c             |  6 +++---
 net/bridge/br_private.h        |  1 +
 net/core/pktgen.c              |  8 +++++---
 net/ethtool/netlink.c          |  8 +++++---
 net/ethtool/netlink.h          |  2 ++
 net/ipv4/fib_semantics.c       | 12 +++++++-----
 net/ipv6/route.c               |  2 ++
 net/llc/af_llc.c               |  5 +++--
 net/openvswitch/vport-netdev.c |  8 ++++----
 net/openvswitch/vport.h        |  2 ++
 net/sched/act_mirred.c         | 18 ++++++++++--------
 net/sched/sch_generic.c        | 10 ++++++----
 net/smc/smc_pnet.c             |  9 +++++----
 net/switchdev/switchdev.c      |  5 +++--
 24 files changed, 79 insertions(+), 46 deletions(-)

-- 
2.34.1.400.ga245620fadb-goog

