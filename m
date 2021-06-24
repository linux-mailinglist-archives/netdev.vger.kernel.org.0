Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CC3B3538
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFXSJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhFXSJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:09:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B42BC061760
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g3-20020a256b030000b0290551bbd99700so498532ybc.6
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dvSNeM/HuzCD6/qY5AxiHJaWaTF4pUpRkK3BjwaDzSk=;
        b=V69RgEAgIDscZEILB2M/mAFVLBwq676N7FZ8qp5pjCLn5fBjFPSmQaAHBuIcDKy7A/
         DjHnCVA65ZB+FMgpVozpMwhL0fvNi+5+ym6ykkLJ2mZF+dm1Bi1h+vdcjkx4rkIUUIS6
         pWQSCEqd04iyeh0L6dq+E9hE/+jiCt0fxvVjdk+qAvx5COtMFsjWE9b5V5clzSWFUB1K
         lhMln+NyiUS9/gVYgZXI+k/shoveeNmJbTzg2L3P8rQqSHqxj/Yo+TuWtpmuNvvZpsVj
         AG9/0IBFKpqB+E4E7vnT6PJcGhURSzpUCkP6XCgb0x/mLU4gNRJ5ErN0RxRgiqljZMp7
         LBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dvSNeM/HuzCD6/qY5AxiHJaWaTF4pUpRkK3BjwaDzSk=;
        b=SBCkmDrX7E9sat2JIEYKacRYVcOL/Rlj/TYc5d6lnTaIWNJmCZyNKrDRaB1IiUBIeC
         qXnqwi51k/73l9PGwCJWaRtEeLZ/1ItvW//h+gp6Xyj+OY6MEw62jIsO0oyYXun9Kg/J
         S4j8A0+DaD5hkoGL+gdiHe0IqcRyEUdpGDcabakbYl/GMmUGatpsI5ApVLsspYf46erm
         ZenI2LeFrLWxQ+Y+4VyHbV8B1mnekRg+AV1xoN3iN+vXvR4TUm8Lw9XzO7m+0wKferKt
         6Z9PQ5VQAWlLAeECGWhlHQ2r24g8C1M/+FvLdGm6UlK/JDMFaNwRkfZA2RWzNRfAbgd7
         wq+w==
X-Gm-Message-State: AOAM532G5Gx4YnFs7zkKF4n9P7VLCgBLQYtt/jFvCS35N7NMi73zhHcZ
        KKUuOKiHHnBYEyI38v9Klx59a1w=
X-Google-Smtp-Source: ABdhPJxgZM6hm7DUOEr3GJf7Nvk01UofwDwMKuVcl6/m9LM+s0iXwV8a/DZZD/PVSl5NcN8Mv6UEVO0=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:98c9:: with SMTP id m9mr6397301ybo.359.1624558049634;
 Thu, 24 Jun 2021 11:07:29 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:16 -0700
Message-Id: <20210624180632.3659809-1-bcf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 00/16] gve: Introduce DQO descriptor format
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQO is the descriptor format for our next generation virtual NIC. The existing
descriptor format will be referred to as "GQI" in the patch set.

One major change with DQO is it uses dual descriptor rings for both TX and RX
queues.

The TX path uses a TX queue to send descriptors to HW, and receives packet
completion events on a TX completion queue.

The RX path posts buffers to HW using an RX buffer queue and receives incoming
packets on an RX queue.

One important note is that DQO descriptors and doorbells are little endian. We
continue to use the existing big endian control plane infrastructure.

The general format of the patch series is:
- Refactor existing code/data structures to be shared by DQO
- Expand admin queues to support DQO device setup
- Expand data structures and device setup to support DQO
- Add logic to setup DQO queues
- Implement datapath

Bailey Forrest (16):
  gve: Update GVE documentation to describe DQO
  gve: Move some static functions to a common file
  gve: gve_rx_copy: Move padding to an argument
  gve: Make gve_rx_slot_page_info.page_offset an absolute offset
  gve: Introduce a new model for device options
  gve: Introduce per netdev `enum gve_queue_format`
  gve: adminq: DQO specific device descriptor logic
  gve: Add support for DQO RX PTYPE map
  gve: Add dqo descriptors
  gve: Add DQO fields for core data structures
  gve: Update adminq commands to support DQO queues
  gve: DQO: Add core netdev features
  gve: DQO: Add ring allocation and initialization
  gve: DQO: Configure interrupts on device up
  gve: DQO: Add TX path
  gve: DQO: Add RX path

 .../device_drivers/ethernet/google/gve.rst    |   53 +-
 drivers/net/ethernet/google/Kconfig           |    2 +-
 drivers/net/ethernet/google/gve/Makefile      |    2 +-
 drivers/net/ethernet/google/gve/gve.h         |  332 +++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  334 ++++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  112 +-
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  256 ++++
 drivers/net/ethernet/google/gve/gve_dqo.h     |   81 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c |   21 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  291 ++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |   54 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  763 ++++++++++++
 drivers/net/ethernet/google/gve/gve_tx.c      |   25 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 1031 +++++++++++++++++
 drivers/net/ethernet/google/gve/gve_utils.c   |   81 ++
 drivers/net/ethernet/google/gve/gve_utils.h   |   28 +
 16 files changed, 3250 insertions(+), 216 deletions(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc_dqo.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_dqo.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx_dqo.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx_dqo.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.h


base-commit: 35713d9b8f090d7a226e4aaeeb742265cde33c82
-- 
2.32.0.288.g62a8d224e6-goog

