Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4457447DCE3
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbhLWBPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:01 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:17798 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbhLWBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=sqK3n4KAn/bFCIZgOngBsx4n4PZvfSggV2zGspKRJnk=;
        b=RHQ51xrjxq9tDevjJI2vs7stnJm69FoFmsx6aDLC/9A15CJ7pfadfRIeIDqiDtoTyqcT
        RBBKtSj7ClOiglfoJ+17g3xUxOGLb3coZtzMPTtHmpSSj6bALe+uZEj3QvuEDjWzKXAeHa
        qixZrPJSZvktHdnIGYRiLVsPZAFzEPHaR69FttK394PhbkluXxgH+T9ZOClpE98ia73HT3
        NhI8OhcbhiWZOEt9HAaROEIhsWbAHJuFc0KahUgCA+tNtSZVcyOB7z6ZXxpSjr2nfy4CC1
        nQqvZs2wYY6Oy6qIsDfcDg2U/SNNWlCHswik2JB3fQ5FxSeRuD5puRYAfCWNa+/Q==
Received: by filterdrecv-656998cfdd-v2fsg with SMTP id filterdrecv-656998cfdd-v2fsg-1-61C3CD5D-2C
        2021-12-23 01:14:05.85301251 +0000 UTC m=+7955206.079180242
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id vbucpfIiSqi5TqOhTl6K8A
        Thu, 23 Dec 2021 01:14:05.577 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id CF34A700394; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 00/50] wilc1000: rework tx path to use sk_buffs throughout
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFYw=2FjcbvhZcqgNlT?=
 =?us-ascii?Q?QDMsFFPh1nkoeqdwNK+Wpr1q3dcBMq5RjcZpWx3?=
 =?us-ascii?Q?RmrrlFu8O3k2VAugLWDHq0Np4VKwGUgNrGhxT+H?=
 =?us-ascii?Q?Viw2ClYU09zKL0DNuy3hw+G9CAY2puuiX2xzS+Y?=
 =?us-ascii?Q?csAJETibrVNVGfPr2Ng1W1yOi8YGBQHvwnmVP4?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, so I'm nervous about such a large patch series, but it took a lot
of work to break things down into atomic changes.  This should be it
for the transmit path as far as I'm concerned.

- v2:
	- Fix 64-bit architecture compile breakage found by
          kernel build daemon.
	- Fix kernel-doc issues.
	- All patches compie with "make W=1" now and pass scripts/checkpatch.pl
        - Expand series to clean up some locking issues.
        - Expand series to support zero-copy tx transfers for SPI.
        - Rebase to latest wireless-drivers-next

Rework tx path to use sk_buffs throughout and optionally provide
zero-copy transmit.

Based on the earlier discussion (RFC: wilc1000: refactor TX path to
use sk_buff queue), here is the full patch series to clean up and
simplify the TX path.

The biggest patch is 0016, which is the one actually switching the
queue data type, but I worked hard to minimize it to only direct
changes due to the type changes.

There is no dramatic performance difference due to this patch.  I'd
expect the new code to be slightly faster, but my WLAN
test-environment is not sufficiently controlled to be sure of that.

original iperf3 performance (duration 120 seconds):

                TX [Mbps]	RX [Mbps]
  PSM off:	14.8		18.9
  PSM  on:	10.5		17.1

iperf3 performance with this patch-series applied:

		TX [Mbps]	RX [Mbps]
  PSM off:	16.0		19.9
  PSM  on:	11.7		18.0

(PSM == power-save-mode; controlled by iw dev wlan0 set power_save on/off)

David Mosberger-Tang (50):
  wilc1000: don't hold txq_spinlock while initializing AC queue limits
  wilc1000: switch txq_event from completion to waitqueue
  wilc1000: move receive-queue stats from txq to wilc structure
  wilc1000: factor common code in wilc_wlan_cfg_set() and wilc_wlan_cfg_get()
  wilc1000: add wilc_wlan_tx_packet_done() function
  wilc1000: move tx packet drop code into its own function
  wilc1000: increment tx_dropped stat counter on tx packet drop
  wilc1000: fix management packet type inconsistency
  wilc1000: prepare wilc_wlan_tx_packet_done() for sk_buff changes
  wilc1000: factor initialization of tx queue-specific packet fields
  wilc1000: convert tqx_entries from "int" to "atomic_t"
  wilc1000: refactor wilc_wlan_cfg_commit() a bit
  wilc1000: sanitize config packet sequence number management a bit
  wilc1000: if there is no tx packet, don't increment packets-sent counter
  wilc1000: add struct wilc_skb_tx_cb as an alias of struct txq_entry_t
  wilc1000: switch tx queue to normal sk_buff entries
  wilc1000: remove no longer used "vif" argument from init_txq_entry()
  wilc1000: split huge tx handler into subfunctions
  wilc1000: don't tell the chip to go to sleep while copying tx packets
  wilc1000: eliminate "max_size_over" variable in fill_vmm_table
  wilc1000: declare read-only ac_preserve_ratio as static and const
  wilc1000: minor syntax cleanup
  wilc1000: introduce symbolic names for two tx-related control bits
  wilc1000: protect tx_q_limit with a mutex instead of a spinlock
  wilc1000: replace txq_spinlock with ack_filter_lock mutex
  wilc1000: reduce amount of time ack_filter_lock is held
  wilc1000: simplify ac_balance() a bit
  wilc1000: improve send_packets() a bit
  wilc1000: factor header length calculation into a new function
  wilc1000: use more descriptive variable names
  wilc1000: eliminate another magic constant
  wilc1000: introduce vmm_table_entry() helper function
  wilc1000: move ac_desired_ratio calculation to where its needed
  wilc1000: restructure wilc-wlan_handle_txq() for clarity
  wilc1000: introduce copy_and_send_packets() helper function
  wilc1000: introduce transmit path chip queue
  wilc1000: introduce set_header() function
  wilc1000: take advantage of chip queue
  wilc1000: eliminate txq_add_to_head_cs mutex
  wilc1000: introduce schedule_packets() function
  wilc1000: use more descriptive variable name
  wilc1000: simplify code by adding header/padding to skb
  wilc1000: add support for zero-copy transmit of tx packets
  wilc1000: don't allocate tx_buffer when zero-copy is available
  wilc1000: move struct wilc_spi declaration
  wilc1000: remove duplicate CRC calculation code
  wilc1000: factor SPI DMA command initialization code into a function
  wilc1000: introduce function to find and check DMA response
  wilc1000: implement zero-copy transmit support for SPI
  wilc1000: add module parameter "disable_zero_copy_tx" to SPI driver

 .../wireless/microchip/wilc1000/cfg80211.c    |  45 +-
 drivers/net/wireless/microchip/wilc1000/mon.c |  36 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |  46 +-
 .../net/wireless/microchip/wilc1000/netdev.h  |  41 +-
 drivers/net/wireless/microchip/wilc1000/spi.c | 293 ++++-
 .../net/wireless/microchip/wilc1000/wlan.c    | 998 ++++++++++--------
 .../net/wireless/microchip/wilc1000/wlan.h    |  55 +-
 7 files changed, 888 insertions(+), 626 deletions(-)

-- 
2.25.1

