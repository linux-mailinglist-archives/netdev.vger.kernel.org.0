Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B054871CE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbiAGEgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiAGEgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:36:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4783FC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 20:36:15 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m1so4193834pfk.8
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 20:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=afNwxBAumsExj6nbFhWBzbchBS3A9hDQ0qChWx4/amg=;
        b=h4hcqnA5Hi5iAFkHfwpJuSaAJXZyoJIbkmLcYUrVvNasGYRHQ7Mzi88W88CYzoOPlL
         h0tmx1B/1gHhVR2SW3zS9VvtQ1e6sAZAEI5A/NMS33nyw7g1lBzCwjuABwwKI01+uNZN
         6WaSsqbwVRPN2Hjl9eFXl1WhDxZfx6gzFH15I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=afNwxBAumsExj6nbFhWBzbchBS3A9hDQ0qChWx4/amg=;
        b=VwTRsIdPubd3+6FZttAd404WEvVllIZcWcdojb5YNvml21JHAFO4HaOUUpzkMb/0vi
         91Lrk5piGoJwgde2lJu0JgPVf8lWc9fDCwCHVgKkXay93xyzMPO0/B3TPjzWr6EbRPkj
         BfakbYUqYRCRqd9pLQ+zEzSxpPUItwsqjnWjwp+Rs3MRqsd3NuQ6zWwUUhfbxv52ehkw
         4AHaShfNdjk+NwHhubekykygsLaeQaf/5aF+p0yqd/KLFU/G12LgWRdEMAftkAO8lrxD
         bHozXRJzd9h1pkIve8t1Z925ZZL9pcWCLE3mZ15pHRpZj9K06vcf29AxTIIhkNXDG/OU
         PycA==
X-Gm-Message-State: AOAM531dqk68P9uUSh0Kq6WpqOKUgs4kXYEdgGOO2tmTEYDY6uHBSN84
        2Nr6M1hnI/Gnj+LEJ/ne2fx2uqQCnd2Csg==
X-Google-Smtp-Source: ABdhPJzN4zbbamsi4AZwknQ1+1t0rp09/XCjrENrIzwMqjOojADhjo1e7tDDEkGDr3IbgRoZW69W9A==
X-Received: by 2002:a05:6a00:114e:b0:4bc:b9f1:7215 with SMTP id b14-20020a056a00114e00b004bcb9f17215mr18446107pfm.13.1641530174774;
        Thu, 06 Jan 2022 20:36:14 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id p12sm4297877pfo.95.2022.01.06.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 20:36:14 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v5 0/8] new Fungible Ethernet driver
Date:   Thu,  6 Jan 2022 20:36:04 -0800
Message-Id: <20220107043612.21342-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains a new network driver for the Ethernet
functionality of Fungible cards.

It contains two modules. The first one in patch 2 is a library module
that implements some of the device setup, queue managenent, and support
for operating an admin queue. These are placed in a separate module
because the cards provide a number of PCI functions handled by different
types of drivers and all use the same common means to interact with the
device. Each of the drivers will be relying on this library module for
them.

The remaining patches provide the Ethernet driver for the cards.

v2:
- Fix set_pauseparam, remove get_wol, remove module param (Andrew Lunn)
- Fix a register poll loop (Andrew)
- Replace constants defined with 'static const'
- make W=1 C=1 is clean
- Remove devlink FW update (Jakub)
- Remove duplicate ethtool stats covered by structured API (Jakub)

v3:
- Make TLS stats unconditional (Andrew)
- Remove inline from .c (Andrew)
- Replace some ifdef with IS_ENABLED (Andrew)
- Fix build failure on 32b arches (build robot)
- Fix build issue with make O= (Jakub)

v4:
- Fix for newer bpf_warn_invalid_xdp_action() (Jakub)
- Remove 32b dma_set_mask_and_coherent()

v5:
- Make XDP enter/exit non-disruptive to active traffic.
- Remove dormant port state.
- Style fixes, unused stuff removal (Jakub)

Dimitris Michailidis (8):
  PCI: add Fungible vendor ID to pci_ids.h
  net/fungible: Add service module for Fungible drivers
  net/funeth: probing and netdev ops
  net/funeth: ethtool operations
  net/funeth: devlink support
  net/funeth: add the data path
  net/funeth: add kTLS TX control part
  net/fungible: Kconfig, Makefiles, and MAINTAINERS

 MAINTAINERS                                   |    6 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/fungible/Kconfig         |   27 +
 drivers/net/ethernet/fungible/Makefile        |    7 +
 .../net/ethernet/fungible/funcore/Makefile    |    5 +
 .../net/ethernet/fungible/funcore/fun_dev.c   |  844 ++++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  151 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1202 +++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  601 ++++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  175 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  147 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |   40 +
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1179 +++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  181 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   33 +
 .../ethernet/fungible/funeth/funeth_main.c    | 1786 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  791 ++++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 ++
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  745 +++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  245 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8423 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_hci.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/funeth/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funeth/fun_port.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_main.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_rx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_trace.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_tx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_txrx.h

-- 
2.25.1

