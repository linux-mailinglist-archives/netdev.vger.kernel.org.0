Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBEF48095E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhL1NHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:07:07 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:38929 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231977AbhL1NHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:07:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V06pjRK_1640696822;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V06pjRK_1640696822)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 21:07:03 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 0/4] RDMA device net namespace support for SMC
Date:   Tue, 28 Dec 2021 21:06:08 +0800
Message-Id: <20211228130611.19124-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces net namespace support for linkgroups.

Path 1 is the main approach to implement net ns support.

Path 2 - 4 are the additional modifications to let us know the netns.
Also, I will submit changes of smc-tools to github later.

Currently, smc doesn't support net namespace isolation. The ibdevs
registered to smc are shared for all linkgroups and connections. When
running applications in different net namespaces, such as container
environment, applications should only use the ibdevs that belongs to the
same net namespace.

This adds a new field, net, in smc linkgroup struct. During first
contact, it checks and find the linkgroup has same net namespace, if
not, it is going to create and initialized the net field with first
link's ibdev net namespace. When finding the rdma devices, it also checks
the sk net device's and ibdev's net namespaces. After net namespace
destroyed, the net device and ibdev move to root net namespace,
linkgroups won't be matched, and wait for lgr free.

If rdma net namespace exclusive mode is not enabled, it behaves as
before.

Steps to enable and test net namespaces:

1. enable RDMA device net namespace exclusive support
	rdma system set netns exclusive # default is shared

2. create new net namespace, move and initialize them
	ip netns add test1 
	rdma dev set mlx5_1 netns test1
	ip link set dev eth2 netns test1
	ip netns exec test1 ip link set eth2 up
	ip netns exec test1 ip addr add ${HOST_IP}/26 dev eth2

3. setup server and client, connect N <-> M
	ip netns exec test1 smc_run sockperf server --tcp # server
	ip netns exec test1 smc_run sockperf pp --tcp -i ${SERVER_IP} # client

4. netns isolated linkgroups (2 * 2 mesh) with their own linkgroups
  - server
LG-ID    LG-Role  LG-Type  VLAN  #Conns  PNET-ID
00000100 SERV     SINGLE      0       0
00000200 SERV     SINGLE      0       0
00000300 SERV     SINGLE      0       0
00000400 SERV     SINGLE      0       0

  - client
LG-ID    LG-Role  LG-Type  VLAN  #Conns  PNET-ID
00000100 CLNT     SINGLE      0       0
00000200 CLNT     SINGLE      0       0
00000300 CLNT     SINGLE      0       0
00000400 CLNT     SINGLE      0       0

Tony Lu (4):
  net/smc: Introduce net namespace support for linkgroup
  net/smc: Add netlink net namespace support
  net/smc: Print net namespace in log
  net/smc: Add net namespace for tracepoints

 include/uapi/linux/smc.h      |  2 ++
 include/uapi/linux/smc_diag.h | 11 ++++++-----
 net/smc/smc_core.c            | 31 ++++++++++++++++++++++---------
 net/smc/smc_core.h            |  2 ++
 net/smc/smc_diag.c            | 16 +++++++++-------
 net/smc/smc_ib.h              |  7 +++++++
 net/smc/smc_llc.c             | 19 ++++++++++++-------
 net/smc/smc_pnet.c            | 21 ++++++++++++++++-----
 net/smc/smc_tracepoint.h      | 23 ++++++++++++++++-------
 9 files changed, 92 insertions(+), 40 deletions(-)

-- 
2.32.0.3.g01195cf9f

