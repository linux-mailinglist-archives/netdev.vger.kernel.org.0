Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D70771B81
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfGWPYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:24:01 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:33508 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfGWPYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:24:01 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id E97668217F1; Tue, 23 Jul 2019 22:17:10 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id BA31C8217E2;
        Tue, 23 Jul 2019 22:17:08 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [RFC PATCH 0/2] convert gianfar to phylink
Date:   Tue, 23 Jul 2019 22:17:00 +0700
Message-Id: <20190723151702.14430-1-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch in the series (almost) converts gianfar to phylink API. The
incentive behind this effort was to get proper support for 1000Base-X and
SGMII SFP modules.

There are some usages of the older phylib left, as serdes have to be
configured and its parameters queried via a TBI interface, and I've failed
to find a reasonably easy way to do it with phylink without much surgery.
It's the first reason for RFC here. However, usage of the older API only
covers two special cases of underlying hardware management and is not
involved in link and SFP management directly.

The conversion was tested with various 1000Base-X connected optical modules
and SGMII-connected copper ones.

The second patch deals with an issue in the phylink proper which only
manifests when bringing up or shutting down a network interface with SGMII
SFP module connected, which yields in calling phy_start() or phy_stop()
twice in a row for such modules. It doesn't look like a proper fix to me,
though, thus the second reason for RFC.

Arseny Solokha (2):
  gianfar: convert to phylink
  net: phylink: don't start and stop SGMII PHYs in SFP modules twice

 drivers/net/ethernet/freescale/Kconfig        |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      | 409 +++++++++---------
 drivers/net/ethernet/freescale/gianfar.h      |  26 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  79 ++--
 drivers/net/phy/phylink.c                     |   6 +-
 5 files changed, 254 insertions(+), 268 deletions(-)

-- 
2.22.0

