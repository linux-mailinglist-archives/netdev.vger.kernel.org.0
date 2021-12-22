Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7684D47D4B0
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344030AbhLVP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50977 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344032AbhLVP6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:20 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6F339E0011;
        Wed, 22 Dec 2021 15:58:17 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools 0/7] IEEE 802.15.4 passive scan support
Date:   Wed, 22 Dec 2021 16:58:09 +0100
Message-Id: <20211222155816.256405-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series follows the work done in the Linux kernel stack: now that
the core knows about the different netlink commands and attributes in
order to support passive scan requests from end-to-end, here are the
userspace changes to be able to use it.

Here is a list of the new available features.

* Passively sending (or stopping) beacons. So far only intervals ranging
  from 0 to 14 are valid. Bigger values would request the PAN
  coordinator to answer to BEACONS_REQ (active scans), this is not
  supported yet.
  # iwpan dev wpan0 beacons send interval 2
  # iwpan dev wpan0 beacons stop

* Scanning all the channels or only a subset:
  # iwpan dev wpan1 scan type passive duration 3

* If a beacon is received during this operation the internal PAN list is
  updated and can be dumped or flushed with:
  # iwpan dev wpan1 pans dump
  PAN 0xffff (on wpan1)
	coordinator 0x2efefdd4cdbf9330
	page 0
	channel 13
	superframe spec. 0xcf22
	LQI 0
	seen 7156ms ago
  # iwpan dev wpan1 pans flush

* It is also possible to monitor the events with:
  # iwpan event

* As well as triggering a non blocking scan:
  # iwpan dev wpan1 scan trigger type passive duration 3
  # iwpan dev wpan1 scan done
  # iwpan dev wpan1 scan abort

Cheers,
Miquèl

David Girault (4):
  iwpan: Export iwpan_debug
  iwpan: Remove duplicated SECTION
  iwpan: Add full scan support
  iwpan: Add events support

Miquel Raynal (2):
  iwpan: Fix a comment
  iwpan: Synchronize nl802154 header with the Linux kernel

Romuald Despres (1):
  iwpan: Fix the channels printing

 DEST/usr/local/bin/iwpan      | Bin 0 -> 178448 bytes
 DEST/usr/local/bin/wpan-hwsim | Bin 0 -> 45056 bytes
 DEST/usr/local/bin/wpan-ping  | Bin 0 -> 47840 bytes
 src/Makefile.am               |   2 +
 src/event.c                   | 221 ++++++++++++++++
 src/info.c                    |   2 +-
 src/iwpan.c                   |   2 +-
 src/iwpan.h                   |  13 +-
 src/nl802154.h                |  95 +++++++
 src/scan.c                    | 471 ++++++++++++++++++++++++++++++++++
 10 files changed, 797 insertions(+), 9 deletions(-)
 create mode 100755 DEST/usr/local/bin/iwpan
 create mode 100755 DEST/usr/local/bin/wpan-hwsim
 create mode 100755 DEST/usr/local/bin/wpan-ping
 create mode 100644 src/event.c
 create mode 100644 src/scan.c

-- 
2.27.0

