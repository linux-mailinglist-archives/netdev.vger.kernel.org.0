Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAE7405FDF
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348314AbhIIXL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhIIXL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 19:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCEC960ED8;
        Thu,  9 Sep 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229016;
        bh=02hu4KDDSgHjtU1tc6qac55eEQesJbg4qVB0se5ZHjg=;
        h=From:To:Cc:Subject:Date:From;
        b=K2RFWchWSmg98eAbcVnXUJJ9ytZpEJi93mHAMkoaTA7GzkBOT+M2e5ac98y0MixP9
         ngXHedbTBjmybIbeoziCWdoAv0/Rn1grN5M7LdHLE0EHgPyCqT0nruRFacjZ1dPWSG
         HkdNXFp6DPXTR6cwVT1Kw+JHc+xSBHC+GhxSYFBkm80QlfjkKoCL2naobew8ky4/Ci
         vgKAErOHq/Dw0F3NsiAnxLMlw5h/dKOuUKwQLmhZEhvGhcgtE9bXJf+t5WjJMWibnX
         zxC7qSRGxe62EoQHKArDGT0d6ISDF3F6LlZp1XikVhZN6qpN3S90sbPbc66iLmFvou
         wZHJDGYDFNC0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] net: sched: update default qdisc visibility after Tx queue cnt changes
Date:   Thu,  9 Sep 2021 16:10:01 -0700
Message-Id: <20210909231004.196905-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew noticed that number of children reported by mq does not match
number of queues on reconfigured interfaces.

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

This is long standing behavior so may as well go into net-next.

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

