Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51910488E74
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiAJB4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbiAJB4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:56:38 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9C5C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:56:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i6so10706890pla.0
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 17:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zPdL0tqFlPPgbtrY1WPI311cwt2tABYGSAtRYgb8q9E=;
        b=ey6O8HIiyWs/03FGDCMlbk9nVnDkXLYKe+sIG7Hiw4ApfKDfS/7oUTZwHsLnAG/hoy
         DUeKbz7HWedTdVMxfrMjEqi/9Ks901Z54PoXnmLSmWxdD/Hnzd57aKjA5itjFWUB/J5K
         cHVlvi3Zksp53GaN48W76t70DAye6HVnJfVZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zPdL0tqFlPPgbtrY1WPI311cwt2tABYGSAtRYgb8q9E=;
        b=YrCuAmms+Uw5elX8EIkswHOSj3eU93k1h58rQgDW2oMoMCzln6bD55wzKiezUZXNMD
         AurOiwoazJnUJ8PVW8dBxzXxigDBdlKvGXEpyzoxeUTf4kPud1M6yq2+y/g1zfGa9Qh/
         1sDqefRlhAV9slY53hy5XEFWUrea8JMMVxXjjAGa+W5Y0mPYI2BxvxSxT9vtKXLD3uI3
         5019awaa0Bl7gVyVcpRHiBdqr+qgOI5UAaxMG/vtSwZS1hnGdhtlMIrOPh3rY5ZUcyfF
         ay6sDnr37JE8G+y7b8GJxGWhu7AjiPmbnfo9UXNqH7IMmhyYb69Y9IDb90pdEYZX3qxi
         FYFQ==
X-Gm-Message-State: AOAM532+nTNd7VaXMymqkYbbotCCELnblPNmfF9bKlHRtuONhtQxmLSQ
        M3PAFmljrFm+QVwjFNlGYvLGc16D2uzZMg==
X-Google-Smtp-Source: ABdhPJx8o2eDw5urXuAZAsucBPa59EV7IM8FBoEcAveIphvSqXWOiAfs/Yms6M0iqUAudA5gPmpmXQ==
X-Received: by 2002:a17:90b:4c42:: with SMTP id np2mr14657017pjb.164.1641779798078;
        Sun, 09 Jan 2022 17:56:38 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id rm3sm6909535pjb.8.2022.01.09.17.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:56:37 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v6 0/8] new Fungible Ethernet driver
Date:   Sun,  9 Jan 2022 17:56:28 -0800
Message-Id: <20220110015636.245666-1-dmichail@fungible.com>
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
- Make XDP enter/exit non-disruptive to active traffic
- Remove dormant port state
- Style fixes, unused stuff removal (Jakub)

v6:
- When changing queue depth or numbers allocate the new queues
  before shutting down the existing ones (Jakub)

Dimitris Michailidis (8):
  PCI: Add Fungible Vendor ID to pci_ids.h
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
 .../net/ethernet/fungible/funcore/fun_dev.c   |  844 +++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  151 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1202 ++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  601 +++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  175 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  162 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |   40 +
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1182 ++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  181 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   33 +
 .../ethernet/fungible/funeth/funeth_main.c    | 1954 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  819 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 +
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  766 +++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  257 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8670 insertions(+)
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

