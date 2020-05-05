Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FD81C4F0E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgEEH3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:29:09 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:27293 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEH3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 03:29:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588663748; x=1620199748;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=FU1dzCHYHygobp7ZOUJYbuyukGyPWZQwj8LkP7+/P18=;
  b=TAgYbdTGCgmB4yLGQpeKEISyPaSEciibxmBkFqZWCcdVnHZAWWwc6iM9
   R9Ts+eIwYNRx7BZAyt6jaK5YfufvzAqQKJaJ10WNXUl+SLL0aNJXWc0mS
   K9vtMx7/VGm4mawXuK9jRLsti9T32zld02sWJWe+FXVcKz7Uq3xSRRdT1
   c=;
IronPort-SDR: bijuAYcu5SdtTrVAUEW6APfCXrMCAXolD1UIt9GNrg/mJvdVEnu2NoQAaQ448OBsMRiz8cWyfV
 oXigqJVuvKGA==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="32977120"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 May 2020 07:29:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 6451EA23F0;
        Tue,  5 May 2020 07:29:04 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 07:29:03 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 07:28:59 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH net 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 09:28:39 +0200
Message-ID: <20200505072841.25365-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D20UWC003.ant.amazon.com (10.43.162.18) To
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

