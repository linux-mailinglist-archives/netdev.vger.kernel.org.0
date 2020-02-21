Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FA3166FC0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 07:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgBUGrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 01:47:13 -0500
Received: from first.geanix.com ([116.203.34.67]:55352 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgBUGrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 01:47:13 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 845BDAEB4D;
        Fri, 21 Feb 2020 06:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582267630; bh=v8hfyWw4kbOSf4Vr8iOqNpwVN5vkMHP3BbYopvXwRbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fwDB4CLntBUZXODVM2cahRr/VQAtZPn9lNpIVIiNpOosKQMFtOvNweEJwPzrQFEqz
         Ej22eU/HJg+Stttbh4O+BGQL2Oz9L+X0uhqlsyxSW/75MM61yAuPH1lXmG1bXqcaKB
         tF5R9LhsLcCTV7qCLodEdc/W52+THIAcHgbwhQL5oRVSYDuPbnY/68GZ2o7gOv9xb/
         9GN0tBryV5QcONGfisqhk9N4RnENk3oC24JC5nR0JNP2sksliUajyqCfl+7/lRU+Ag
         HrwnJZN/HTr11ASBMKqVtl8Yc6W9NGNIUY+QnhdRdG1CkyuHii+aaht1d2RrTqom43
         CPmXrxArJA32g==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net v2 0/4] net: ll_temac: Bugfixes
Date:   Fri, 21 Feb 2020 07:47:09 +0100
Message-Id: <cover.1582267079.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582108989.git.esben@geanix.com>
References: <cover.1582108989.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a number of bugs which have been present since the first commit.

The bugs fixed in patch 1,2 and 4 have all been observed in real systems, and
was relatively easy to reproduce given an appropriate stress setup.

Changes since v1:

- Changed error handling of of dma_map_single() in temac_start_xmit() to drop
  packet instead of returning NETDEV_TX_BUSY.

Esben Haabendal (4):
  net: ll_temac: Fix race condition causing TX hang
  net: ll_temac: Add more error handling of dma_map_single() calls
  net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC
    pressure
  net: ll_temac: Handle DMA halt condition caused by buffer underrun

 drivers/net/ethernet/xilinx/ll_temac.h      |   4 +
 drivers/net/ethernet/xilinx/ll_temac_main.c | 209 ++++++++++++++++----
 2 files changed, 175 insertions(+), 38 deletions(-)

-- 
2.25.0

