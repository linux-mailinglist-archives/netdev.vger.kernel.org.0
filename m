Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB4D338F76
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCLOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCLOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:08:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6440C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z1so8134209edb.8
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=slCCywJn9yXIuJ24YMj7VPyg/9v7XJXoWgGiE31nlng=;
        b=l4KpwqpMPUUgVHB0TGKrsJyETIigzcuzVpJIjNK1xTIpzLq9tgPokDdH03y8nK4kPF
         HEyRsG3emtivx0v3vUct86pnUpw7DVLdxr0Tw55IHybaG7Fcdu2AlrNCsx3RO2verCxy
         xSlpKQPaR8KotJMwCmwRTtmnaC2ocNbcoZ9jbz2RgQkJNXD+/AcYvyKSDfrjeD6ovziV
         sLcXQsni+u8wAjD717fnNxzKHPkANGGhtPm7mGF8TB/bv7ICRb57MIyFaf+/Sn6W6PGo
         37aC89/r6BCbHU+Hrpfg3sJbzz9iQv7B8N+EUBWLYKVpdsAgJ0K75dd+UOYVFWP+dB+M
         m05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=slCCywJn9yXIuJ24YMj7VPyg/9v7XJXoWgGiE31nlng=;
        b=o0mok8w+6Q60kF+Z+oKHKpiUT0kqhBHEQjnVu7PFr9hCrTmxyagrzIKkoSuFrcA4EP
         VlJOdWUkLOItHafTKcjvOrCavK8oHCd1lumuhGxdM4XBMnhWItTVptHhOCs89GkiieBW
         gz0Ua3JDAgW93X+LorBC8deOh3E/yHpWuEUVbm19Re/rb2tTalQmPQK3w1YzUZlH6SlO
         KAeC3/ZXWl1ylCp/IRbXSv2QodLBNYYLYgLiFBA/n0whJFktJPj+GdTQsar8IwN0wVBv
         QQNLdeed36dqko3v31X4pEMY5LB1CW4PHiN8zVf3TZioOU5IVrFbtruKXKdssugY1cK0
         8WHg==
X-Gm-Message-State: AOAM5306OkRI6HgWYx/ziRgGGF53ADXHxwTPkQZ+2ksMxOsnY4VrS1td
        FFpacQPDsDxc6xikIeyVLn08Bg==
X-Google-Smtp-Source: ABdhPJzK/SLGXNz/MvKrDHOTM54tUinzB14xHTUAZp6ysjLtVV8Tx2SVmI2GUluFmoMGidkGN3PQjg==
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr13893677edu.60.1615558122369;
        Fri, 12 Mar 2021 06:08:42 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s11sm3031673edt.27.2021.03.12.06.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:08:41 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH v3 net-next 0/3] net/sched: act_police: add support for packet-per-second policing
Date:   Fri, 12 Mar 2021 15:08:28 +0100
Message-Id: <20210312140831.23346-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enhances the TC policer action implementation to allow a
policer action instance to enforce a rate-limit based on
packets-per-second, configurable using a packet-per-second rate and burst
parameters.

In the hope of aiding review this is broken up into three patches.

* [PATCH 1/3] flow_offload: add support for packet-per-second policing

  Add support for this feature to the flow_offload API that is used to allow
  programming flows, including TC rules and their actions, into hardware.

* [PATCH 2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers

  Teach all exiting users of the flow_offload API that allow offload of
  policer action instances to reject offload if packet-per-second rate
  limiting is configured: none support it at this time

* [PATCH 3/3] net/sched: act_police: add support for packet-per-second policing

  With the above ground-work in place add the new feature to the TC policer
  action itself

With the above in place the feature may be used.

As follow-ups we plan to provide:
* Corresponding updates to iproute2
* Corresponding self tests (which depend on the iproute2 changes)
* Hardware offload support for the NFP driver

Key changes since v2:
* Added patches 1 and 2, which makes adding patch 3 safe for existing
  hardware offload of the policer action
* Re-worked patch 3 so that a TC policer action instance may be configured
  for packet-per-second or byte-per-second rate limiting, but not both.
* Corrected kdoc usage

Baowen Zheng (2):
  flow_offload: reject configuration of packet-per-second policing in
    offload drivers
  net/sched: act_police: add support for packet-per-second policing

Xingfeng Hu (1):
  flow_offload: add support for packet-per-second policing

 drivers/net/dsa/sja1105/sja1105_flower.c      |  6 ++
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 11 ++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  5 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  5 ++
 drivers/net/ethernet/mscc/ocelot_flower.c     |  5 ++
 drivers/net/ethernet/mscc/ocelot_net.c        |  6 ++
 .../ethernet/netronome/nfp/flower/qos_conf.c  |  5 ++
 include/net/flow_offload.h                    |  2 +
 include/net/sch_generic.h                     | 14 ++++
 include/net/tc_act/tc_police.h                | 52 +++++++++++++
 include/uapi/linux/pkt_cls.h                  |  2 +
 net/sched/act_police.c                        | 59 +++++++++++++--
 net/sched/cls_api.c                           |  3 +
 net/sched/sch_generic.c                       | 75 ++++++++++++-------
 15 files changed, 221 insertions(+), 33 deletions(-)

-- 
2.20.1

