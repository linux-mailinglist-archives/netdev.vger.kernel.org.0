Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508162E011B
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgLUTh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLUTh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:37:28 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v2 0/3] net-sysfs: fix race conditions in the xps code
Date:   Mon, 21 Dec 2020 20:36:41 +0100
Message-Id: <20201221193644.1296933-1-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

This series fixes race conditions in the xps code, where out of bound
accesses can occur when dev->num_tc is updated, triggering oops. The
root cause is linked to lock issues. An explanation is given in each of
the commit logs.

Reviews in v1 suggested to use the xps_map_mutex to protect the maps and
their related parameters instead of the rtnl lock. We followed this path
in v2 as it seems a better compromise than taking the rtnl lock.

As a result, patch 1 turned out to be less straight forward as some of
the locking logic in net/core/dev.c related to xps_map_mutex had to be
changed. Patches 2 and 3 are also larger in v2 as code had to be moved
from net/core/net-sysfs.c to net/core/dev.c to take the xps_map_mutex
(however maintainability is improved).

Also, while working on the v2 I stumbled upon another race condition. I
debugged it and the fix is the same as patch 1. I updated its commit log
to describe both races.

Thanks!
Antoine

Antoine Tenart (3):
  net: fix race conditions in xps by locking the maps and dev->tc_num
  net: move the xps cpus retrieval out of net-sysfs
  net: move the xps rxqs retrieval out of net-sysfs

 include/linux/netdevice.h |   9 ++
 net/core/dev.c            | 186 +++++++++++++++++++++++++++++---------
 net/core/net-sysfs.c      |  89 ++++--------------
 3 files changed, 171 insertions(+), 113 deletions(-)

-- 
2.29.2

