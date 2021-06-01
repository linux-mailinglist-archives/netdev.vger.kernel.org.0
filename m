Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719D13972B5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhFALr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:47:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:47596 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFALrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 07:47:53 -0400
IronPort-SDR: V8bw9rbg2ZJZRuZYKS0twzWZJU3jMl0ag/QAerUWubk1JVw/Ze08vY31C9/fiUKBD9rGgdLt83
 bZ4q9e6SW5oQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="190884036"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="190884036"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:46:11 -0700
IronPort-SDR: ovwvWknKV5qnbqnY2ThMg6YjgHEfadAuRFMxnLmyNEcqapYiiTe/lF+xQqvdr6KudyEFHrwsqf
 WY864hzFGffQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446931344"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2021 04:46:09 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 0/2] ice: bring up XDP_TX back to life
Date:   Tue,  1 Jun 2021 13:32:34 +0200
Message-Id: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

here are the improvements for handling the XDP_TX/REDIRECT actions in
ice driver. People have been recently reporting that they stumble upon a
situation where no packets are xmitted when they do XDP_TX from their
BPF programs - first patch addresses that.

Second patch handles the case where we could not have XDP ring per core.
Let's consider that as a starting point of fixing Intel drivers against
that scenario.

Note that this is based on the series that I sent two weeks ago:
https://lore.kernel.org/bpf/20210520063500.62037-1-maciej.fijalkowski@intel.com/

Parametrizing of ice_vsi_cfg_txqs/ice_vsi_stop_tx_rings is needed for a
fallback path.

Thanks!

Maciej Fijalkowski (2):
  ice: unify xdp_rings accesses
  ice: introduce XDP Tx fallback path

 drivers/net/ethernet/intel/ice/ice.h          | 37 +++++++++
 drivers/net/ethernet/intel/ice/ice_base.c     |  5 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 76 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 62 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 13 +++-
 7 files changed, 191 insertions(+), 8 deletions(-)

-- 
2.20.1

