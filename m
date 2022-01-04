Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4D48399E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiADBJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiADBJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:09:36 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68723C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:09:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id jw3so30020744pjb.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 17:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/vp+LSZlF49bOdngEwNmp5iwzr1+Ex613XhJ7FLTEz0=;
        b=al1qfFX830q+i9UHZu+0LpI7ZfKGwlwdCdm79T0iWInbpq+976mRscI+//Qtrxpz8n
         OmWFa2+UOpzqV8bEFeD2ZpnAGOML+qb2+iSfzaG4aEdAQdo2K5djPWvcrsjRzUyeIsIC
         58naFtmC7D/eY+/TkqxRHbOxNGWHAvu4jxr7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/vp+LSZlF49bOdngEwNmp5iwzr1+Ex613XhJ7FLTEz0=;
        b=FZ1EOhHVU+7ndbXnq/fTiU8NwqqNrqo5Fy6SSIoJHOSHhOFIlEVI/EdW3HlzSabUZv
         5ZaW8UmN4H/l5c+AU19HWKWEDceOAR6yhogBYnNjauIVpFKNY7ritDTPpuMlvoGn/1Ry
         2bLzgSeLXPfaNpii+ivjc0NXAD8ubVTTfbYmbMTo0V5oBbcBZWolF4oMesvDZ2o3pZEt
         TFmHgB6u8yZGpCUOWvrl/+2sckyptwlmUJyfdqQ7yDx/QpigjYLacFj4yAf5y7m/fGsu
         mxYLYvuNF78idY6EqOK+idwbfzN/iSaw44O0nGBtnjsplcmbCluMHePBrCK++oPqBBeB
         plqg==
X-Gm-Message-State: AOAM5318p1lyUZOVZv6ricRM5he7fBZv8y7WO96UxhvLEPqGt+oUaA2p
        VQkhrKUurumRtz6ELj63hAQbfg==
X-Google-Smtp-Source: ABdhPJxMJvBePoIunqmKUBkbIeWaqikxzYkdIyJ1h+B1peKeEEDChljC1HznrjdDwPq5SUYvBSOOXA==
X-Received: by 2002:a17:90b:3809:: with SMTP id mq9mr57974033pjb.245.1641258575888;
        Mon, 03 Jan 2022 17:09:35 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id v10sm39208654pjr.11.2022.01.03.17.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:09:35 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v3 0/8] new Fungible Ethernet driver
Date:   Mon,  3 Jan 2022 17:09:25 -0800
Message-Id: <20220104010933.1770777-1-dmichail@fungible.com>
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
 .../net/ethernet/fungible/funcore/fun_dev.c   |  847 ++++++++
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
 26 files changed, 8300 insertions(+)
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

