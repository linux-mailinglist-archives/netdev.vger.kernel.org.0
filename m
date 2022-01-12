Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1024748C9DB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355715AbiALRga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiALRfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:35:48 -0500
X-Greylist: delayed 136 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Jan 2022 09:35:33 PST
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA08C0611FF;
        Wed, 12 Jan 2022 09:35:33 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 6EDB3C000B;
        Wed, 12 Jan 2022 17:35:30 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools v2 0/7] IEEE 802.15.4 scan support
Date:   Wed, 12 Jan 2022 18:35:22 +0100
Message-Id: <20220112173529.765170-1-miquel.raynal@bootlin.com>
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

* Sending (or stopping) beacons. Intervals ranging from 0 to 14 are
  valid for passively sending beacons at regular intervals. An interval
  of 15 would request the core to answer to received BEACON_REQ.
  # iwpan dev wpan0 beacons send interval 2 # send BEACON at a fixed rate
  # iwpan dev wpan0 beacons send interval 15 # answer BEACON_REQ only
  # iwpan dev wpan0 beacons stop # apply to both cases

* Scanning all the channels or only a subset:
  # iwpan dev wpan1 scan type passive duration 3 # will not trigger BEACON_REQ
  # iwpan dev wpan1 scan type active duration 3 # will trigger BEACON_REQ

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
  # iwpan dev wpan1 set max_pan_entries 100
  # iwpan dev wpan1 set pans_expiration 3600

* It is also possible to monitor the events with:
  # iwpan event

* As well as triggering a non blocking scan:
  # iwpan dev wpan1 scan trigger type passive duration 3
  # iwpan dev wpan1 scan done
  # iwpan dev wpan1 scan abort

Cheers,
Miquèl

Changes in v2:
* Dropped the binaries added by accident.
* New sync of the headers with Linux.
* Added two new commands to configure the stack regarding the number of
  PANs listed and their delay before expiration.

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

 src/Makefile.am |   2 +
 src/event.c     | 221 +++++++++++++++++++++++
 src/info.c      |   4 +-
 src/iwpan.c     |   2 +-
 src/iwpan.h     |  13 +-
 src/mac.c       |  56 ++++++
 src/nl802154.h  |  99 ++++++++++
 src/scan.c      | 471 ++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 859 insertions(+), 9 deletions(-)
 create mode 100644 src/event.c
 create mode 100644 src/scan.c

-- 
2.27.0

