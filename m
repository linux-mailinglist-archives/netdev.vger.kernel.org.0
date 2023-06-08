Return-Path: <netdev+bounces-9351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC1F728956
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF2E5281751
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AB92DBD1;
	Thu,  8 Jun 2023 20:25:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5081F187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:49 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518852D68
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255948; x=1717791948;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6w8b8OUmW62NsSWqu3u5WSPYYDRrT82c0Cs/q5YLhpk=;
  b=FVu29Q0CPmEr6LTpOBkhPoQrynRB/Ak1Luq2JpDvjYYwrnOMogDEVvPy
   xqs9JYVfJ40Shmse/Uc0ZVIQMgL67VoNWd6hoaKbFUWUdh17KJ1blPom5
   evuP0KNAswPhzPdIIi5lqjHl+IPwwNKCP6kgpFx0KN8wOE/UGIsiHDhCl
   wKsfgddZCWDnmvd4bWJ6J30Sh+F++GQDMobUNfuLO2Lsf/7r8Ef2sbicg
   cebm7VkjDYlpdR5gclMjHFXC9Q39OyhaFbOXuCRN6LJakK+MSY5RjHSPD
   Et9kzlgG47Z+nv/OOJxX6DMw5I21diMuI0eKv7cjckNaiL0PMvvPZSXrV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776271"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776271"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767838"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767838"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 13:25:47 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	jacob.e.keller@intel.com,
	richardcochran@gmail.com
Subject: [PATCH net-next 0/5][pull request] ice: Improve miscellaneous interrupt code
Date: Thu,  8 Jun 2023 13:21:10 -0700
Message-Id: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jacob Keller says:

This series improves the driver's use of the threaded IRQ and the
communication between ice_misc_intr() and the ice_misc_intr_thread_fn()
which was previously introduced by commit 1229b33973c7 ("ice: Add low
latency Tx timestamp read").

First, a new custom enumerated return value is used instead of a boolean for
ice_ptp_process_ts(). This significantly reduces the cognitive burden when
reviewing the logic for this function, as the expected action is clear from
the return value name.

Second, the unconditional loop in ice_misc_intr_thread_fn() is removed,
replacing it with a write to the Other Interrupt Cause register. This causes
the MAC to trigger the Tx timestamp interrupt again. This makes it possible
to safely use the ice_misc_intr_thread_fn() to handle other tasks beyond
just the Tx timestamps. It is also easier to reason about since the thread
function will exit cleanly if we do something like disable the interrupt and
call synchronize_irq().

Third, refactor the handling for external timestamp events to use the
miscellaneous thread function. This resolves an issue with the external
time stamps getting blocked while processing the periodic work function
task.

Fourth, a simplification of the ice_misc_intr() function to always return
IRQ_WAKE_THREAD, and schedule the ice service task in the
ice_misc_intr_thread_fn() instead.

Finally, the Other Interrupt Cause is kept disabled over the thread function
processing, rather than immediately re-enabled.

Special thanks to Michal Schmidt for the careful review of the series and
pointing out my misunderstandings of the kernel IRQ code. It has been
determined that the race outlined as being fixed in previous series was
actually introduced by this series itself, which I've since corrected.

The following are changes since commit bfd019d10fdabf70f9b01264aea6d6c7595f9226:
  Merge branch 'crypto-splice-net-make-af_alg-handle-sendmsg-msg_splice_pages'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (3):
  ice: introduce ICE_TX_TSTAMP_WORK enumeration
  ice: trigger PFINT_OICR_TSYN_TX interrupt instead of polling
  ice: do not re-enable miscellaneous interrupt until thread_fn
    completes

Karol Kolacinski (2):
  ice: handle extts in the miscellaneous interrupt thread
  ice: always return IRQ_WAKE_THREAD in ice_misc_intr()

 drivers/net/ethernet/intel/ice/ice.h      |  7 +++
 drivers/net/ethernet/intel/ice/ice_main.c | 47 +++++++++++------
 drivers/net/ethernet/intel/ice/ice_ptp.c  | 62 ++++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_ptp.h  | 16 ++++--
 4 files changed, 84 insertions(+), 48 deletions(-)

-- 
2.38.1


