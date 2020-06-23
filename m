Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B72204E43
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgFWJo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:44:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:17328 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgFWJo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 05:44:26 -0400
IronPort-SDR: Oenico+0Ce0Y/ZdZsJpkhE7dVRVNNfTOxLLziYivmJFHVxoTA5qm9koG2ur7Se9IF1IEeqRcMc
 dbvd08DIIkhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142272405"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="142272405"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 02:44:26 -0700
IronPort-SDR: 0z+W89ZQa5LaKnAFhUH+eLcTsWYsMLhtMCYGMM9UtrmMxjh4uXaNDSKaUZO1K7u+Fy5oQLsuw9
 +W27FpUUZlgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="422947135"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.33.84])
  by orsmga004.jf.intel.com with ESMTP; 23 Jun 2020 02:44:22 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        sridhar.samudrala@intel.com
Cc:     maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] i40e: improve AF_XDP performance
Date:   Tue, 23 Jun 2020 11:44:15 +0200
Message-Id: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series improves AF_XDP performance for the i40e NIC. The
first patch optimizes the Tx completion path for AF_XDP. The second
one removes a division in the data path for the normal SKB path, XDP
as well as AF_XDP. Finally, the third one moves the test of a full Tx
ring to outside the send loop. Overall, the throughput of the l2fwd
application in xpdsock improves with around 8% on my machine.

v1->v2:
* Removed unnecessary variables in i40e_clean_xdp_tx_irq [Sridhar]
* Added one further optimization to Tx path in a new patch [Sridhar]
* Fixed two API documentation warnings with make W=1

This patch has been applied against commit 8af7b4525acf ("Merge branch
'net-atlantic-additional-A2-features'")

Thanks: Magnus

Magnus Karlsson (3):
  i40e: optimize AF_XDP Tx completion path
  i40e: eliminate division in napi_poll data path
  i40e: move check of full Tx ring to outside of send loop

 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 17 ++++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 57 +++++++++++++----------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 +-
 4 files changed, 39 insertions(+), 39 deletions(-)

--
2.7.4
