Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7BD483C03
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiADGrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiADGrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:47:00 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D8EC061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:47:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 8so31918687pgc.10
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlodjpI3BMMPsvyFLRpdctFxWS3Rwu5EdMzoSmD+hag=;
        b=AnzPA3n49dXdpDy24tu8p/wsA1H5GY62ECWdmKs6GJhzODRB02Mi4GCeMDcno85Ku8
         g0jnN7cYyiku60yCAB8tAiV2w0xeYPpvMBwY4cNKM9mUSttF37STOtX+lNgdcUJABUn4
         JnR67e6iIdsQBygb1WQIUYnj6dJ011zP11CfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlodjpI3BMMPsvyFLRpdctFxWS3Rwu5EdMzoSmD+hag=;
        b=5DSpRWZq3MdJYrB0FVzfopHKrDADjbe19wUbuACO3xASwCiL7ensnvmUXZaj9vC/fc
         Ib8n0BdeYoJ5zjkjYzqUvcFRgVgXqihq811Pld2bDBu1ZEhZX+cPK7gTMoRtmLJtxAJN
         pjERDahNGAHdpHSRVgAwnttSC/AeIozf2Mjk7Svp2dtLDZ6fM74rqH+b6XdwAGi4NFlb
         KhJe60/LsPx34mPuO16pOH0CjP7005j6u9dHxjLub0mDZQa2jW12SVtH7I2lYd+1ohLj
         vZNZ6Wu04TL2i/HlsT6XqfNHdrOBqksKSTlTyMEH85sPzEPNZQo+XlTzl8BdBj2gdUPP
         E1Ew==
X-Gm-Message-State: AOAM530OPWoofrhWkgg8Q8J4rxtXgV73OC0jTM/QESit4lJwXzne9vBB
        qwMRpQV2d1M+y6MrmvW03r52uXKgu9Sr/Q==
X-Google-Smtp-Source: ABdhPJzuc/+pQ7D2kSzKYPhGFh+6t7V+fVtURTeMWPy4JfERM7CwMLztgdfD2rm7qNOFfHsiXMiuHg==
X-Received: by 2002:a05:6a00:198e:b0:4bb:2522:56b9 with SMTP id d14-20020a056a00198e00b004bb252256b9mr49667140pfl.22.1641278819841;
        Mon, 03 Jan 2022 22:46:59 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 93sm40424090pjo.26.2022.01.03.22.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:46:59 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v4 0/8] new Fungible Ethernet driver
Date:   Mon,  3 Jan 2022 22:46:49 -0800
Message-Id: <20220104064657.2095041-1-dmichail@fungible.com>
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
 .../net/ethernet/fungible/funcore/fun_dev.c   |  845 ++++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  151 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1187 +++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  620 ++++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  178 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  147 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |   40 +
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1176 +++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  181 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   33 +
 .../ethernet/fungible/funeth/funeth_main.c    | 1773 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  725 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 ++
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  699 +++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  240 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8298 insertions(+)
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

