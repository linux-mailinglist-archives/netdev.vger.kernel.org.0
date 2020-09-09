Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3E262ABC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIIIpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgIIIpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A5C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o20so1531644pfp.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/QhgFcLYKprYlDsJYZEDEtGyfltPTBsLwBa/zlFrFN8=;
        b=LK64I2b2kH50QH9TFqBZOcIDoPfJ99c5jTTfN1kPhd4Nn7f0tVHXl9ETGDJR2jkVxF
         3rvxZrrF7MFaY8CMe2XP9YOIhvILizzvESZpy0A0AYjrGg5H8/4ZOFei8Dr1VpBh1RGg
         CPDyXQ8OOJZVrdAqWfWm1xdOzRqmN6l2YddpFDXhsS6YgE96CUC+CWWnU3L8KzcmzLwi
         sYpbqquc6EBZTvN3Rh/LcN8r5dEvoWN73x9+IeszjhT81ge6kfXhjeZGsHYZZlDrI8Bm
         LchWjh2gYzn4YPE1Ao4ovZCTEla+B9X+KV6Z0pp3wCaMLxOuUT/3gr3/fEWXJnL4ADMF
         fnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/QhgFcLYKprYlDsJYZEDEtGyfltPTBsLwBa/zlFrFN8=;
        b=Yzcp+yguO3vcgLxAo6dCmFwRxPMCv3ki83PA7PV0NC3bgdsDk4krBHI2RmO87QcJM6
         7Um5m3TSQBGELd/2RF6WkYn24s0fMfudd8sMBHrGPRaCdgtdt68S4cU2OBBr3JjaI/xs
         onVaxokuOcN4Nzv927VB3zv7plO1a8HC5mRHx1vpkJ8S1NhZGWUdnEDgMcIDB/90tvfY
         NHFbz9UVl2+mK+85xlBIf4mGlbE0ae2hjrE16VR2ZcrKWny0fn4sVhgcfvoVF/8mviop
         mvZCF0H7nxYn80HVIl207L7hYEG5g0huI0ZGoRz5x2cGGM7R4dOK7rSIkeik8bN15eP6
         xLrg==
X-Gm-Message-State: AOAM533Yree5lm1zynXHh1QvnZ2oNKlbPOYBFoxsVS+oINGA8A8Gk4Ie
        ETwI82iMUzRTzfBWL514iEU=
X-Google-Smtp-Source: ABdhPJz9i0WgACn7ydKh6aO27lgdfJAWv8Xy6i7jzmDvBlcFpfHNXGELAvL6r/C7N0MBs+4Kyb/yqw==
X-Received: by 2002:a63:5b64:: with SMTP id l36mr2180939pgm.413.1599641122098;
        Wed, 09 Sep 2020 01:45:22 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:21 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH v2 00/20] ethernet: convert tasklets to use new
Date:   Wed,  9 Sep 2020 14:14:50 +0530
Message-Id: <20200909084510.648706-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the crypto modules to use the new tasklet_setup() API

This series is based on v5.9-rc4

v2:
  fix kdoc reported by Jakub Kicinski.

Allen Pais (20):
  ethernet: alteon: convert tasklets to use new tasklet_setup() API
  ethernet: amd: convert tasklets to use new tasklet_setup() API
  broadcom: cnic: convert tasklets to use new tasklet_setup() API
  ethernet: cadence: convert tasklets to use new tasklet_setup() API
  ethernet: cavium: convert tasklets to use new tasklet_setup() API
  ethernet: chelsio: convert tasklets to use new tasklet_setup() API
  ethernet: dlink: convert tasklets to use new tasklet_setup() API
  ethernet: hinic: convert tasklets to use new tasklet_setup() API
  ethernet: ehea: convert tasklets to use new tasklet_setup() API
  ethernet: ibmvnic: convert tasklets to use new tasklet_setup() API
  ethernet: jme: convert tasklets to use new tasklet_setup() API
  ethernet: marvell: convert tasklets to use new tasklet_setup() API
  ethernet: mellanox: convert tasklets to use new tasklet_setup() API
  ethernet: micrel: convert tasklets to use new tasklet_setup() API
  ethernet: natsemi: convert tasklets to use new tasklet_setup() API
  ethernet: netronome: convert tasklets to use new tasklet_setup() API
  ethernet: ni: convert tasklets to use new tasklet_setup() API
  ethernet: qlogic: convert tasklets to use new tasklet_setup() API
  ethernet: silan: convert tasklets to use new tasklet_setup() API
  ethernet: smsc: convert tasklets to use new tasklet_setup() API

 drivers/net/ethernet/alteon/acenic.c          |  9 +++--
 drivers/net/ethernet/alteon/acenic.h          |  2 +-
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
 drivers/net/ethernet/dlink/sundance.c         | 20 +++++-----
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  9 ++---
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
 drivers/net/ethernet/micrel/ks8842.c          | 19 ++++-----
 drivers/net/ethernet/micrel/ksz884x.c         | 14 +++----
 drivers/net/ethernet/natsemi/ns83820.c        |  8 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 ++--
 drivers/net/ethernet/ni/nixge.c               |  7 ++--
 drivers/net/ethernet/qlogic/qed/qed.h         |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 27 ++-----------
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 14 +++----
 drivers/net/ethernet/silan/sc92031.c          | 11 ++---
 drivers/net/ethernet/smsc/smc91x.c            | 10 ++---
 41 files changed, 183 insertions(+), 224 deletions(-)

-- 
2.25.1

