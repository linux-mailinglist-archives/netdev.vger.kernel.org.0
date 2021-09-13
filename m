Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB140A11B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344771AbhIMW5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349160AbhIMWyv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 18:54:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3BA860EB4;
        Mon, 13 Sep 2021 22:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631573615;
        bh=JhdaqFCgY4cvHJrD/ADCha6EKRsaZlvaag8rwxq0JmI=;
        h=From:To:Cc:Subject:Date:From;
        b=mslXNEmb+xqF9rHkkRamWQfPO49/b6lNPvwz/u4FPM6Qu1qD3vn1/J47tdgiAbgmC
         81JkgEUulvZBBST6l5RgHPzD0Oer3FHo4nuV2LiYB5M0xkWIWHvbP0FJkKjsQ9+eZo
         MIbN9A93AY5umA/50cmcOxlEVBolM669a9o14XLknydjTC5IrZEHRy+wSiE646y9Ve
         yKAqJwUT+ohHXDLkJyRXhpiPUVoIIYREQvE25BI+OO8lRtqD3O+CzSb6y2Ro/LMT5k
         lTLkYcz2rsrucIfKxVZqBE/6VA9umrsPJnFiHE0+nNexXU4JMI5G7es/qt33CPcU94
         AE9ZRYcmgeLOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: sched: update default qdisc visibility after Tx queue cnt changes
Date:   Mon, 13 Sep 2021 15:53:29 -0700
Message-Id: <20210913225332.662291-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew noticed that number of children reported by mq does not match
number of queues on reconfigured interfaces. For example if mq is
instantiated when there is 8 queues it will always show 8 children,
regardless of config being changed:

 # ethtool -L eth0 combined 8
 # tc qdisc replace dev eth0 root handle 100: mq
 # tc qdisc show dev eth0
 qdisc mq 100: root 
 qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...
 # ethtool -L eth0 combined 1
 # tc qdisc show dev eth0
 qdisc mq 100: root 
 qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...
 # ethtool -L eth0 combined 32
 # tc qdisc show dev eth0
 qdisc mq 100: root 
 qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
 qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...

This patchset fixes this by hashing and unhasing the default
child qdiscs as number of queues gets adjusted.

Jakub Kicinski (3):
  net: sched: update default qdisc visibility after Tx queue cnt changes
  netdevsim: add ability to change channel count
  selftests: net: test ethtool -L vs mq

 drivers/net/netdevsim/ethtool.c               | 28 +++++++
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/sch_generic.h                     |  4 +
 net/core/dev.c                                |  2 +
 net/sched/sch_generic.c                       |  9 +++
 net/sched/sch_mq.c                            | 24 ++++++
 net/sched/sch_mqprio.c                        | 23 ++++++
 .../drivers/net/netdevsim/ethtool-common.sh   |  2 +-
 .../drivers/net/netdevsim/tc-mq-visibility.sh | 77 +++++++++++++++++++
 9 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh

-- 
2.31.1

