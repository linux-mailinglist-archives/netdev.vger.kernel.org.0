Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34C481E3B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240002AbhL3QjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbhL3QjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:39:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31220C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so23592485pjb.5
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 08:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMAhLN+b37njsmb/RPK/nPY6dBg7tR0XgBX+MHpXka4=;
        b=egqYwYfWYXbT2QfNId+gD9U2DuRXR5c94KrxSnL17N7dltwRGdNhKoj7Pfhuy/fD4P
         gxLzXtUtItdMXChd/PSMlUDBmolPKCaaG7gF8g46z4ri08HP0V8Aoug9CJZRM1yM7F1q
         ZS1K6US2B6vKv7Fw4dLGvJvn0IwRk26/AlnBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMAhLN+b37njsmb/RPK/nPY6dBg7tR0XgBX+MHpXka4=;
        b=K27kAyma9nacd+GFlgzbNMV79c1eJL5nyhKhmqIWRwmbBNFwtAkxPneMJz8o1LCobv
         emmpsbPGGTvxc1hKW8ZH69tvO0PYTVe9SZr830MAT7jJNjGEJ108V5vG/4+Ciaq9T0j8
         tIWfi4601FYK/e1qD8veNF0+yLHJ/xQlH43I5oNwUulJTWLmyEijecCGydTYUCgkhq6s
         BBfWA13uHlpFuOoWsjajrMwqq1T9a+l4R1aakJ3ea1XzczZ7yRnsiqHrh16sI+2yQVnd
         CkO5tyf0cUvoON5kx1/e+/egkXSU1BOJUatnoYtgnbNEeedBOVOPh6CohcwPtXvD5kxd
         AawQ==
X-Gm-Message-State: AOAM531/hCu7lMSBqCeGmwqmXtsPgTVHcWQwXc5wbgpMRGwpVI4ahqS4
        knU7sQDsRvCOPFoj2lHeCj/Z29NsKSJQFA==
X-Google-Smtp-Source: ABdhPJxXX61NcvstlFkYw7j5KmDe48tI985On7dofyd8eUxMDsHrojlAFg2uGPd4zDjkQ5jEgLhhZw==
X-Received: by 2002:a17:902:f54e:b0:148:e8ae:ffde with SMTP id h14-20020a170902f54e00b00148e8aeffdemr32498644plf.25.1640882351574;
        Thu, 30 Dec 2021 08:39:11 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l6sm27390380pfu.63.2021.12.30.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:39:11 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/8] new Fungible Ethernet driver
Date:   Thu, 30 Dec 2021 08:39:01 -0800
Message-Id: <20211230163909.160269-1-dmichail@fungible.com>
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
 .../net/ethernet/fungible/funcore/fun_dev.c   |  879 ++++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  152 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1163 +++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  620 ++++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  178 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  153 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |  273 +++
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1255 ++++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  181 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   33 +
 .../ethernet/fungible/funeth/funeth_main.c    | 1772 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  725 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 ++
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  701 +++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  242 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8630 insertions(+)
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

