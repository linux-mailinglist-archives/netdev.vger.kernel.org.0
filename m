Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4031928A67D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgJKJKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:10:08 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43190 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJKJKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 05:10:08 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09B99okE010651;
        Sun, 11 Oct 2020 11:09:50 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH net-next 0/3] macb: support the 2-deep Tx queue on at91
Date:   Sun, 11 Oct 2020 11:09:41 +0200
Message-Id: <20201011090944.10607-1-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while running some tests on my Breadbee board, I noticed poor network
Tx performance. I had a look at the driver (macb, at91ether variant)
and noticed that at91ether_start_xmit() immediately stops the queue
after sending a frame and waits for the interrupt to restart the queue,
causing a dead time after each packet is sent.

The AT91RM9200 datasheet states that the controller supports two frames,
one being sent and the other one being queued, so I performed minimal
changes to support this. The transmit performance on my board has
increased by 50% on medium-sized packets (HTTP traffic), and with large
packets I can now reach line rate.

Since this driver is shared by various platforms, I tried my best to
isolate and limit the changes as much as possible and I think it's pretty
reasonable as-is. I've run extensive tests and couldn't meet any
unexpected situation (no stall, overflow nor lockup).

There are 3 patches in this series. The first one adds the missing
interrupt flag for RM9200 (TBRE, indicating the tx buffer is willing
to take a new packet). The second one replaces the single skb with a
2-array and uses only index 0. It does no other change, this is just
to prepare the code for the third one. The third one implements the
queue. Packets are added at the tail of the queue, the queue is
stopped at 2 packets and the interrupt releases 0, 1 or 2 depending
on what the transmit status register reports.

Thanks,
Willy

Willy Tarreau (3):
  macb: add RM9200's interrupt flag TBRE
  macb: prepare at91 to use a 2-frame TX queue
  macb: support the two tx descriptors on at91rm9200

 drivers/net/ethernet/cadence/macb.h      | 10 ++--
 drivers/net/ethernet/cadence/macb_main.c | 66 ++++++++++++++++++------
 2 files changed, 56 insertions(+), 20 deletions(-)

-- 
2.28.0

