Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2AD4AC71F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiBGRSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384206AbiBGRSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:04 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67824C0401E4
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:03 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w20so2383630plq.12
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7n5VHyt4WMlT303q4lga26xk/oZU4IsKPMUsTTqnYk=;
        b=WemAT9cyMKsNxusPHPs5e5V6mGRrWaJBUHYby+4+VOjdftbVAXIoUEL8/YnDA7Mm0I
         +KTg9KBzGKRV1tFVSG7zd6+TWjg85nkbk9+IHgqo4mSdrpZGFQcr/oQFahobe9NFLpyl
         D/7tvmjjEDr65JTBP/XBX9XJc3ZSr4bIXt6ICPP3DLpUBO1OTux7amD1E21FFoPsiJDp
         4cyTPcB76WSW8wCMK0wr1M6I0R4hfhQdgTz34NI29oNl01vPRdhSAGYdwhf8cH93JdEq
         Rc97meyqoavaJLq3YUYQ/xhzINds/I98OCwdoXUKjQ4uz2hpfvHyUGjSaA702EpfPbV5
         FkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7n5VHyt4WMlT303q4lga26xk/oZU4IsKPMUsTTqnYk=;
        b=dMHnF4adXLvwkyvjeeHSwvN5ivl8YOixihTnMhGat5SJIlNGYH+sq+wzi4vkBeWBS4
         H6MAIA6sEi8f9nfQgusPTUpRRYUdPLENwZ4sG8tfm/CXNvKJgDp4oi6CECeMF9hMQIMb
         Hbf1qfQfn9SQgJjVbqu90hvIvxZIcgp6WJm/6mMoMxAXvhfQPopU4+UvuKhMcthFQF5+
         MrOydYSue8qfamCLvs0ZyHJyaj9v1nD8NXVHstLjRhb45Ovi1AuZ1A0hqqSF8Pv6MUpR
         9Y6d/I4P/Xpifejkj2tmAsFSB3DQfoYoVohCK1hLz/5rUIhoOjAvErbaaPQzutHlNWnO
         oAKQ==
X-Gm-Message-State: AOAM530JOWyAIOfRlY32bOeAWVpGu5py4eRBO3k22ND5mSb44XAvSg0G
        KhVlWkGmaFcSo+EMQ0fxwEuLCgQtCCE=
X-Google-Smtp-Source: ABdhPJwHyVESzcJ8irJeNHcrwq/PxANGGYhVUtibPD+/JvR0R+sYgKpKqvZW3ZybcNldyc9zDlrrpA==
X-Received: by 2002:a17:902:6b0b:: with SMTP id o11mr275488plk.169.1644254282859;
        Mon, 07 Feb 2022 09:18:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/11] net: speedup netns dismantles
Date:   Mon,  7 Feb 2022 09:17:45 -0800
Message-Id: <20220207171756.1304544-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In this series, I made network namespace deletions more scalable,
by 4x using the benchmark described in this cover letter.

- Remove bottleneck on ipv6 addrconf, by replacing a global
  hash table to a per netns one.

- rtnl mutex can be heavily contended, and is a blocker for
  the specialized kernel thread responsible for cleaning and
  freeing network namespaces.
  Rework eight (struct pernet_operations *)->exit() handlers to
  exit_batch() ones. This removes many rtnl acquisitions,
  and gives to cleanup_net() kind of a priority over rtnl
  ownership, when processing batches.

Tested on a host with 24 cpus (48 HT)

Test script:

for nr in {1..10}
do
  (for i in {1..10000}; do unshare -n /bin/bash -c "ifconfig lo up"; done) &
done
wait

for i in {1..10}
do
  sleep 1 
  echo 3 >/proc/sys/vm/drop_caches
  grep net_namespace /proc/slabinfo
done

Before this series:
We can see host struggles to clean the netns, even after there are
no new creations. Memory cost is high, because each netns consumes
a good amount of memory.

time ./unshare10.sh
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      82634  82634   3968    1    1 : tunables   24   12    8 : slabdata  82634  82634      0
net_namespace      37214  37792   3968    1    1 : tunables   24   12    8 : slabdata  37214  37792    192

real	6m57.766s
user	3m37.277s
sys	40m4.826s

After this series:
We can see the script completes much faster, the kernel thread
doing the cleanup_net() keeps up just fine.
Memory cost is not too big.

time ./unshare10.sh
net_namespace       9945   9945   4096    1    1 : tunables   24   12    8 : slabdata   9945   9945      0
net_namespace       4087   4665   4096    1    1 : tunables   24   12    8 : slabdata   4087   4665    192
net_namespace       4082   4607   4096    1    1 : tunables   24   12    8 : slabdata   4082   4607    192
net_namespace        234    761   4096    1    1 : tunables   24   12    8 : slabdata    234    761    192
net_namespace        224    751   4096    1    1 : tunables   24   12    8 : slabdata    224    751    192
net_namespace        218    745   4096    1    1 : tunables   24   12    8 : slabdata    218    745    192
net_namespace        193    667   4096    1    1 : tunables   24   12    8 : slabdata    193    667    172
net_namespace        167    609   4096    1    1 : tunables   24   12    8 : slabdata    167    609    152
net_namespace        167    609   4096    1    1 : tunables   24   12    8 : slabdata    167    609    152
net_namespace        157    609   4096    1    1 : tunables   24   12    8 : slabdata    157    609    152

real    1m43.876s
user    3m39.728s
sys 7m36.342s


Eric Dumazet (11):
  ipv6/addrconf: allocate a per netns hash table
  ipv6/addrconf: use one delayed work per netns
  ipv6/addrconf: switch to per netns inet6_addr_lst hash table
  nexthop: change nexthop_net_exit() to nexthop_net_exit_batch()
  ipv4: add fib_net_exit_batch()
  ipv6: change fib6_rules_net_exit() to batch mode
  ip6mr: introduce ip6mr_net_exit_batch()
  ipmr: introduce ipmr_net_exit_batch()
  can: gw: switch cangw_pernet_exit() to batch mode
  bonding: switch bond_net_exit() to batch mode
  net: remove default_device_exit()

 drivers/net/bonding/bond_main.c   |  27 ++++--
 drivers/net/bonding/bond_procfs.c |   1 -
 include/net/netns/ipv6.h          |   5 ++
 net/can/gw.c                      |   9 +-
 net/core/dev.c                    |  22 +++--
 net/ipv4/fib_frontend.c           |  19 +++-
 net/ipv4/ipmr.c                   |  20 +++--
 net/ipv4/nexthop.c                |  12 ++-
 net/ipv6/addrconf.c               | 139 ++++++++++++++----------------
 net/ipv6/fib6_rules.c             |  11 ++-
 net/ipv6/ip6mr.c                  |  20 +++--
 11 files changed, 172 insertions(+), 113 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

