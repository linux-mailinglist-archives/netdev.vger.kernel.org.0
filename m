Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971271C4FE9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgEEILY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:11:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:58253 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgEEILY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:11:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588666285; x=1620202285;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=FU1dzCHYHygobp7ZOUJYbuyukGyPWZQwj8LkP7+/P18=;
  b=CRCyc5YNHrFkenIQHcNTBtCvhwCor/7+ZW5rgO5Q5U1QbNzIAbp5vI41
   jlt4rkdgNnn2cz54BWM9s5oQ1O8ZOlVKuzAMOGeFBNtSvH9unnTMYzwEN
   3oNCuHWmDEUdkgOQfcyQtOIS6KXSEnGhTwooDPn89X6+aE/GLEeUNdvjE
   k=;
IronPort-SDR: ijxyykrLPj2+tC+QQJOq14p0raUcAvEdisOWCzxLeIumj0eKciuu2KDuCzBb4Ux9IYNnDwsm4b
 Mr/kcsSsY50Q==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="42723816"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 May 2020 08:11:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 86328A1DE7;
        Tue,  5 May 2020 08:11:19 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:18 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.92) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:13 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <sj38.park@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 10:10:33 +0200
Message-ID: <20200505081035.7436-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.92]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
deallocation of 'socket_alloc' to be done asynchronously using RCU, as
same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
socket_sq with socket itself") made those to have same life cycle.

The changes made the code much more simple, but also made 'socket_alloc'
live longer than before.  For the reason, user programs intensively
repeating allocations and deallocations of sockets could cause memory
pressure on recent kernels.

To avoid the problem, this commit reverts the changes.

SeongJae Park (2):
  Revert "coallocate socket_wq with socket itself"
  Revert "sockfs: switch to ->free_inode()"

 drivers/net/tap.c      |  5 +++--
 drivers/net/tun.c      |  8 +++++---
 include/linux/if_tap.h |  1 +
 include/linux/net.h    |  4 ++--
 include/net/sock.h     |  4 ++--
 net/core/sock.c        |  2 +-
 net/socket.c           | 23 ++++++++++++++++-------
 7 files changed, 30 insertions(+), 17 deletions(-)

-- 
2.17.1

