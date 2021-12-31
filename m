Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA18A4822E4
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhLaJIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhLaJIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:08:36 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DEFC061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:35 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r5so23363779pgi.6
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NUdyT3RHXa5RFyihd3KxZfov8E2pydBPAFvG+pEE9ts=;
        b=RQDcYvsL7qiK405f+1+jtAOjkepxxpW9q8injlx4OIB0F4rWUUnQLK62meg57vNSc3
         G59MwzBqEGQ7rc0lDfYnBUW/7zwb8St46Gne01FoJTjd/WhHKhBPFNsx/m8/18uMTfj6
         TTwEAYctnF6Ld3Qu4NJM3DM5l2ySzFXrPY8Dg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NUdyT3RHXa5RFyihd3KxZfov8E2pydBPAFvG+pEE9ts=;
        b=hY+axFvCC6PKakiHRVnvybyCYu3OymclstLrDQXjhutILIxGkJXSOXec4hfdERdtof
         kDZOryKlFqrZHxwc9IGXVpoEfK4I2LX4ilhMTSkyWC0dc5Y1vClkpylY6pnSLdZkYShi
         RN5kzNadZKpewiOHY1qyHe/+M6nwgtnCg9IUY8TmiMnq8cocgX4vaUClF/Tnu7lkoNEL
         yqs5CXK2R3A3aqg29HrakEtJRRJ/8BiNz/b5qQmtSnNRXc+VekGtkSDf4bgNXM7kluor
         8sW5iVAX9tyo+sE1juh3YjukpbvuShpX86T2MiHJ4rTlPlUMaUYhiV1RQ2IwHLentICR
         zHuw==
X-Gm-Message-State: AOAM532yu8ljBYibNZVDd1WywzBALe5nWCUxbIRpahrnCWlLE6S+9R+t
        fVAYyThFKM0lUG08PW3rKnHPLA==
X-Google-Smtp-Source: ABdhPJyb9WnxWyKTgRBd0yxv25BCFg3czpznGrJdh8dbQcbShsofO9Ro5EFNdqspr+h1HPkOhYEGsA==
X-Received: by 2002:a63:b50d:: with SMTP id y13mr30252274pge.286.1640941715373;
        Fri, 31 Dec 2021 01:08:35 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id t31sm19875192pfg.184.2021.12.31.01.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 01:08:34 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v2 0/8] new Fungible Ethernet driver
Date:   Fri, 31 Dec 2021 01:08:25 -0800
Message-Id: <20211231090833.98977-1-dmichail@fungible.com>
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
 .../net/ethernet/fungible/funcore/fun_dev.c   |  846 ++++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  151 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1187 +++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  620 ++++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  178 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  151 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |   40 +
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1182 +++++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  181 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   33 +
 .../ethernet/fungible/funeth/funeth_main.c    | 1773 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  725 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 ++
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  701 +++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  242 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8313 insertions(+)
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

