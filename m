Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648B6362BF4
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhDPXnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhDPXnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:43:33 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224AAC061574;
        Fri, 16 Apr 2021 16:43:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h20so14791104plr.4;
        Fri, 16 Apr 2021 16:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z63PuqgJ/ggxFrYFCkXGSXN03aWadtC6tjM/hw5TpgI=;
        b=vJWaf7u0f0lO+hw8cBKlG2cuZhDRYRwU/bTa44oOTgVnClhioVObk0gkwEhX/oeQrM
         rJjnq/5YQ9g1H+6VjnrKsc8vFogu4IeMpTxHiKY7Tlw7ny4T2KapgtLKEuMcC2k8D+05
         a9qXcCUoI/cmJzy2vBfSANqy0gYdOiKkzaY0//3a6n+dZFicfh9lKcySpqy1iShEB7Al
         3bYdB8DVAaQ/T61eoYpfvJhFYTLP6M9egUNRbfajO351ZtUvmcUauWw9R/zlhGU7MhQB
         7OL6NgceNpFPrsIC/PO8MeDceuTtbnn2k7zeRSC/x0sOV0H6iZ+WhQKaBe7hPxLBB5Y9
         p2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z63PuqgJ/ggxFrYFCkXGSXN03aWadtC6tjM/hw5TpgI=;
        b=os+07w05Ff1Lv4IQfGt6iIdh766M6hTeWWq+CacEPSyVv5pYx7K+gGEXEHYW2B0OBQ
         kPm7v0UTlDiEBt1YLddmUjcAG3CE+/FMfMJoANRljVB/V3eEeUbMGYQ3MXLIkhanlKDF
         YWkWHbns6nkNx5lrZKJ0VyaPSjtN9m92IyX+I6rMPYU+Fv7/Y3aMSYZ8vvkcjswG4CLJ
         2Hk7RRtSSWwEo2QJF0IOjb3cebk9T5PDHuEcjRUw5L3vhDQL2u17RKQkfrxuUbvgzkHF
         FYdlb0M7RRlt2Gnq8PMBj8I9XensjRLmyACNI3gbRzcUDovLeOI+0r13sn0Bb2w4AU74
         ND5g==
X-Gm-Message-State: AOAM5332SXzukETi//MnuThcshktsE0sQcGxKLct6cJG6H0Gy8lqQdZ8
        q1dGtLiLrbyIA23ZXM7N/qM=
X-Google-Smtp-Source: ABdhPJyLi7qnfd6nj4nrHRLXDCGHwbksuLNQLymnErRrHO0V1LQBQwcQhbCZRAhBUjDEz0r/uDyEuQ==
X-Received: by 2002:a17:90a:5311:: with SMTP id x17mr11802813pjh.25.1618616587637;
        Fri, 16 Apr 2021 16:43:07 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/5] Flow control for NXP ENETC
Date:   Sat, 17 Apr 2021 02:42:20 +0300
Message-Id: <20210416234225.3715819-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series contains logic for enabling the lossless mode on the
RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
memory.

During testing it was found that, with the default FIFO configuration,
a sender which isn't persuaded by our PAUSE frames and keeps sending
will cause some MAC RX frame errors. To mitigate this, we need to ensure
that the FIFO never runs completely full, so we need to fix up a setting
that was supposed to be configured well out of reset. Unfortunately this
requires the addition of a new mini-driver.

Vladimir Oltean (5):
  net: enetc: create a common enetc_pf_to_port helper
  dt-bindings: net: fsl: enetc: add the IERB documentation
  net: enetc: add a mini driver for the Integrated Endpoint Register
    Block
  arm64: dts: ls1028a: declare the Integrated Endpoint Register Block
    node
  net: enetc: add support for flow control

 .../devicetree/bindings/net/fsl-enetc.txt     |  15 ++
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |   6 +
 drivers/net/ethernet/freescale/enetc/Kconfig  |   9 +
 drivers/net/ethernet/freescale/enetc/Makefile |   3 +
 drivers/net/ethernet/freescale/enetc/enetc.h  |  16 ++
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  18 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   9 +
 .../net/ethernet/freescale/enetc/enetc_ierb.c | 155 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_ierb.h |  20 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  95 ++++++++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  16 +-
 11 files changed, 349 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.c
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.h

-- 
2.25.1

