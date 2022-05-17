Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB341529D3B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbiEQJFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbiEQJEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:52 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 545103F316;
        Tue, 17 May 2022 02:04:44 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 012E920F32C6; Tue, 17 May 2022 02:04:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 012E920F32C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778284;
        bh=ojA9Vp3b1/V9h3FkXwTJNt9d/ThwRugOJ3+/bcYv0TQ=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=DJqd5IdhkvSx7eWgpVps6BFS03s780foB6vAch5Lq68bOR5JaH2Bc2UxOUSTaW9lZ
         sNJLXccvW4G8sHUnTM5EnhNPHPLFswBrr1TytSzIP1FKytqekMKpnpBIH7EVRSFo9W
         n9vqSfe7qjo1y9HrCt3VdPZGIzgx6rvsCAxbu4nI=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [PATCH 00/12] Introduce Microsoft Azure Network Adapter (MANA) RDMA driver
Date:   Tue, 17 May 2022 02:04:24 -0700
Message-Id: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patchset implements a RDMA driver for Microsoft Azure Network
Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary device
to the Ethernet device.

The first 11 patches modify the MANA Ethernet driver to support RDMA driver.
The last patch implementes the RDMA driver.

Long Li (12):
  net: mana: Add support for auxiliary device
  net: mana: Record the physical address for doorbell page region
  net: mana: Handle vport sharing between devices
  net: mana: Add functions for allocating doorbell page from GDMA
  net: mana: Set the DMA device max page size
  net: mana: Define data structures for protection domain and memory
    registration
  net: mana: Export Work Queue functions for use by RDMA driver
  net: mana: Record port number in netdev
  net: mana: Move header files to a common location
  net: mana: Define max values for SGL entries
  net: mana: Define and process GDMA response code
    GDMA_STATUS_MORE_ENTRIES
  RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter

 MAINTAINERS                                   |   4 +
 drivers/infiniband/Kconfig                    |   1 +
 drivers/infiniband/hw/Makefile                |   1 +
 drivers/infiniband/hw/mana/Kconfig            |   7 +
 drivers/infiniband/hw/mana/Makefile           |   4 +
 drivers/infiniband/hw/mana/cq.c               |  74 ++
 drivers/infiniband/hw/mana/main.c             | 679 ++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          | 145 ++++
 drivers/infiniband/hw/mana/mr.c               | 133 ++++
 drivers/infiniband/hw/mana/qp.c               | 466 ++++++++++++
 drivers/infiniband/hw/mana/wq.c               | 111 +++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  94 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |   6 +-
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 139 +++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |   2 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |   2 +-
 .../microsoft => include/linux}/mana/gdma.h   | 191 ++++-
 .../linux}/mana/hw_channel.h                  |   0
 .../microsoft => include/linux}/mana/mana.h   |  26 +-
 .../linux}/mana/shm_channel.h                 |   0
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 include/uapi/rdma/mana-abi.h                  |  68 ++
 23 files changed, 2111 insertions(+), 45 deletions(-)
 create mode 100644 drivers/infiniband/hw/mana/Kconfig
 create mode 100644 drivers/infiniband/hw/mana/Makefile
 create mode 100644 drivers/infiniband/hw/mana/cq.c
 create mode 100644 drivers/infiniband/hw/mana/main.c
 create mode 100644 drivers/infiniband/hw/mana/mana_ib.h
 create mode 100644 drivers/infiniband/hw/mana/mr.c
 create mode 100644 drivers/infiniband/hw/mana/qp.c
 create mode 100644 drivers/infiniband/hw/mana/wq.c
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/gdma.h (77%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/hw_channel.h (100%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/mana.h (94%)
 rename {drivers/net/ethernet/microsoft => include/linux}/mana/shm_channel.h (100%)
 create mode 100644 include/uapi/rdma/mana-abi.h

-- 
2.17.1

