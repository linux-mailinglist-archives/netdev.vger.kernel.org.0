Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24575479E33
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhLRXyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:17 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25254 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbhLRXyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=wzP9DgYMpXKgYWsfuD1dK/4zmX3SgTAGErInexoo/KQ=;
        b=gDPysHXYB/iATmWtUO1Ybe9qnHorO8Mpvalz5DHQBs8vb/+sCcgwIUw5xfITPmcfAFT2
        J2z9y6k1Y6qeahSmmU7jXfPd+338+8ZTP79cXhV7GrbxD9Ei+HwYZ1ePnsJHO0WjDNwJJc
        7XEt2yswC09ewvicROZtZ68GdPMMckOMpRgg8vwNp7bLgsTFZSpTtqDDqrk88dq9xwZMsK
        GgI4/TzckUxdwlC12ICjNWeuvXJdr27JGzmTbhD1aA/SQve585Bsja7uPSFqJZ3dTx8X3P
        8bKDNFev5vLD8Nm0aplNR8lDMZddhkuLGucgbPjDa6BGDyMYRZ1oekTLtAx83pfw==
Received: by filterdrecv-64fcb979b9-x2652 with SMTP id filterdrecv-64fcb979b9-x2652-1-61BE74A8-19
        2021-12-18 23:54:16.475973623 +0000 UTC m=+8294249.160301187
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id r_NccQJDT_mpwXRgch3XiA
        Sat, 18 Dec 2021 23:54:16.296 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 825627003AE; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 00/23] wilc1000: rework tx path to use sk_buffs throughout
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOFHE9PCYzQvZsVwd?=
 =?us-ascii?Q?WSSZ+IiAKcuygXdhofy425Aqh2rrAOH9u05cT8w?=
 =?us-ascii?Q?bhPNda82cAwYGzOSH4wb8=2FQsvubpKoI2u7ogRaR?=
 =?us-ascii?Q?jcUZBohAO6mBXJTuo5KADs70XvCZGPSbmDBufVH?=
 =?us-ascii?Q?BOJlWoiX3PNsPmVv4j+09t8LFhKTLVE+Nik+Tv?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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

Based on the earlier discussion (RFC: wilc1000: refactor TX path to
use sk_buff queue), here is the full patch series to clean up and
simplify the TX path.

The biggest patch is 0016, which is the one actually switching the
queue data type, but I worked hard to minimize it to only direct
changes due to the type changes.

There is no significant performance difference due to this patch.  I'd
expect the new code to be slightly faster, but my WLAN
test-environment is not sufficiently controlled to be sure of that.

original iperf3 performance (duration 120 seconds):

                TX [Mbps]	RX [Mbps]
  PSM off:	14.8		18.9
  PSM  on:	10.5		17.1

iperf3 performance with this patch-series applied:

		TX [Mbps]	RX [Mbps]
  PSM off:	15.6		19.5
  PSM  on:	11.2		17.7

(PSM == power-save-mode; controlled by iw dev wlan0 set power_save on/off)

David Mosberger-Tang (23):
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
  wilc1000: Add struct wilc_skb_tx_cb as an alias of struct txq_entry_t
  wilc1000: switch tx queue to normal sk_buff entries
  wilc1000: remove no longer used "vif" argument from init_txq_entry()
  wilc1000: split huge tx handler into subfunctions
  wilc1000: don't tell the chip to go to sleep while copying tx packets
  wilc1000: eliminate "max_size_over" variable in fill_vmm_table
  wilc1000: declare read-only ac_preserve_ratio as static and const
  wilc1000: minor syntax cleanup
  wilc1000: introduce symbolic names for two tx-related control bits

 .../wireless/microchip/wilc1000/cfg80211.c    |  37 +-
 drivers/net/wireless/microchip/wilc1000/mon.c |  36 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |  40 +-
 .../net/wireless/microchip/wilc1000/netdev.h  |  13 +-
 .../net/wireless/microchip/wilc1000/wlan.c    | 755 +++++++++---------
 .../net/wireless/microchip/wilc1000/wlan.h    |  52 +-
 6 files changed, 442 insertions(+), 491 deletions(-)

-- 
2.25.1

