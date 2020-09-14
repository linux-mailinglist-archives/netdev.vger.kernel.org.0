Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB6A2685DA
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgINH3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINH3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:29:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B3FC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:29:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so10849480pgl.2
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvr1CXGm9d3GvtUESptg2wu3KoyaKREgc2pga/maLQk=;
        b=CowXorEXcaakAJ5A4rdxC0SDSheHxDrEuhcBjeRmmixWMGx6EQA3eobaOovwetS/yu
         A41gI065EUp9H+LHcSSBIm+Jntc1hSlYYaTx54e68Zg1KiJuGPxle4FyxL2OlQXYNwTL
         243LSb3kQ8qBjTv/Nb3vzsVS6Bifa6B/oLYr5KX1jz7eXbFIersD/jvms8VoFre8u660
         MiWOhbw6SbKRzpSxQyCorABgHdnk1o6DnUjTBumnJm1dzMpd0JuDC3PuJ/I5hHL4Bedk
         cowE2CCO105LvdHKYqcUkZlDeDhgcb7/vuUWRi0rtHjNMabPYuBkMS9vcue01oA9gA5R
         0/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvr1CXGm9d3GvtUESptg2wu3KoyaKREgc2pga/maLQk=;
        b=Gu5MPczCjN3WtNGUN02VTcVE4bLqzANN3h3Oh44qVBb5Jd1oru7RSBYLxU7w1PSPU0
         9kL9R9s+IVAaa0tRCMOVTQ2+TSYg+ClHStgyIZffJoO2o3WO64xN+/StJqm5WyoAFboT
         fJ0IPb1FkMPzTIwO2KTG6d4Sn6d1zLvzT+q9EgBN3CFzqaPb3O4jwgxrlL77t9OVT5lr
         z85aBRHUKywa+8y9MA5OaGGIijC+RhEBKOdTA1/fSBM8U8ABLgnAGr9x/wL5HzDV6qWU
         dge+pYedFNBl9zQd5IPwSGXImOZe4pcscZurjfqQvItc3EC1ZbhZN5MDze4q+xMD1a4+
         BhUA==
X-Gm-Message-State: AOAM533dJoxZAPxP8fEiLTZYRw/rC8SYJ8PCcr6AIaT/Vs5O5/8D8eNj
        +qdCAtRGWnX4rhreo9DGtqk=
X-Google-Smtp-Source: ABdhPJyMATb8pinaedE3WL46H2jHR9KWyW0BwqUq7xGahWCURxd4Xjta7v/x5BP/4RZ0Kuxl97cn4Q==
X-Received: by 2002:a17:902:bc87:: with SMTP id bb7mr13070532plb.146.1600068592567;
        Mon, 14 Sep 2020 00:29:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:29:51 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [net-next v3 00/20]  ethernet: convert tasklets to use new tasklet_setup API
Date:   Mon, 14 Sep 2020 12:59:19 +0530
Message-Id: <20200914072939.803280-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the crypto modules to use the new tasklet_setup() API

This series is based on v5.9-rc5

v3:
  fix subject prefix
  use backpointer instead of fragile priv to netdev.

v2:
  fix kdoc reported by Jakub Kicinski.

Allen Pais (20):
  net: alteon: convert tasklets to use new tasklet_setup() API
  net: amd-xgbe: convert tasklets to use new tasklet_setup() API
  cnic: convert tasklets to use new tasklet_setup() API
  net: macb: convert tasklets to use new tasklet_setup() API
  liquidio: convert tasklets to use new tasklet_setup() API
  chelsio: convert tasklets to use new tasklet_setup() API
  net: sundance: convert tasklets to use new tasklet_setup() API
  net: hinic: convert tasklets to use new tasklet_setup() API
  net: ehea: convert tasklets to use new tasklet_setup() API
  ibmvnic: convert tasklets to use new tasklet_setup() API
  net: jme: convert tasklets to use new tasklet_setup() API
  net: skge: convert tasklets to use new tasklet_setup() API
  net: mlx: convert tasklets to use new tasklet_setup() API
  net: micrel: convert tasklets to use new tasklet_setup() API
  net: natsemi: convert tasklets to use new tasklet_setup() API
  nfp: convert tasklets to use new tasklet_setup() API
  net: nixge: convert tasklets to use new tasklet_setup() API
  qed: convert tasklets to use new tasklet_setup() API
  net: silan: convert tasklets to use new tasklet_setup() API
  net: smc91x: convert tasklets to use new tasklet_setup() API

 drivers/net/ethernet/alteon/acenic.c          |  9 +++--
 drivers/net/ethernet/alteon/acenic.h          |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 19 +++++----
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c      | 11 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c     | 11 +++--
 drivers/net/ethernet/broadcom/cnic.c          | 18 ++++-----
 drivers/net/ethernet/cadence/macb_main.c      |  7 ++--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 12 +++---
 .../ethernet/cavium/liquidio/octeon_main.h    |  1 +
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  8 ++--
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 10 ++---
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +-
 .../ethernet/cavium/thunder/nicvf_queues.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       | 12 ++++--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      | 18 ++++-----
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 16 ++++----
 drivers/net/ethernet/dlink/sundance.c         | 21 +++++-----
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  7 ++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  7 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  7 ++--
 drivers/net/ethernet/jme.c                    | 40 ++++++++-----------
 drivers/net/ethernet/marvell/skge.c           |  6 +--
 drivers/net/ethernet/mellanox/mlx4/cq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c       |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  7 ++--
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 12 +++---
 drivers/net/ethernet/micrel/ks8842.c          | 17 ++++----
 drivers/net/ethernet/micrel/ksz884x.c         | 14 +++----
 drivers/net/ethernet/natsemi/ns83820.c        |  8 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 ++--
 drivers/net/ethernet/ni/nixge.c               |  7 ++--
 drivers/net/ethernet/qlogic/qed/qed.h         |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 27 ++-----------
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 14 +++----
 drivers/net/ethernet/silan/sc92031.c          | 12 +++---
 drivers/net/ethernet/smsc/smc91x.c            | 10 ++---
 41 files changed, 183 insertions(+), 223 deletions(-)

-- 
2.25.1

