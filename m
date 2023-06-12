Return-Path: <netdev+bounces-10227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B10A172D131
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF95280C20
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D603BD2F3;
	Mon, 12 Jun 2023 20:57:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D37EA0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:57:45 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230B244A0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686603445; x=1718139445;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=STpUVPaDWrk65b6XI3lBcBypvq2Tc9sxqQtaVfM0W4w=;
  b=g1plry5vsRtOweybPQs6ODKXQoPtEK/JDv1LW5RkCq7lPWjyPW3oXW7b
   q/JfWEk2Nc+aLobS+8dCf9nN1mD3qwXXCSADjIrils3oK2xUyyHqj/kCD
   S5xED3GytSBbA4iTulRMMfnUiY7wDQAQbPZ3R47TwIzb7iGkOB/R38YG2
   8CVIRYPwHcbMFoOf97NrDragG1SJ/0wayYCjz1+QWofTNMHRQeaLh6l20
   +Ux2CeSy+OTzNpqBqdfiAkzaWeyeUyynCoNmh++jHvhB/0C1LbuDVpAM4
   gcJbvm0iXG9EHND5Y3EbtWREL0tlkeg84L2NOs1bFVsdMbsYNgDc+KkE3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386548187"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="386548187"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 13:56:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885586110"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="885586110"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2023 13:56:44 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net v3 0/3][pull request] Intel Wired LAN Driver Updates 2023-06-12 (igc, igb)
Date: Mon, 12 Jun 2023 13:52:05 -0700
Message-Id: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
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

This series contains updates to igc and igb drivers.

Husaini clears Tx rings when interface is brought down for igc.

Vinicius disables PTM and PCI busmaster when removing igc driver.

Alex adds error check and path for NVM read error on igb.
---
v3:
Patch 3
 - Adjust 'out' label to only free and return

v2: https://lore.kernel.org/netdev/20230609161058.3485225-1-anthony.l.nguyen@intel.com/
Patch 1
 - Changes to commit message
 - Disable TX Queue ring during ndo_stop()

v1: https://lore.kernel.org/netdev/20230509170935.2237051-1-anthony.l.nguyen@intel.com/

The following are changes since commit 75e6def3b26736e7ff80639810098c9074229737:
  sctp: fix an error code in sctp_sf_eat_auth()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aleksandr Loktionov (1):
  igb: fix nvm.ops.read() error handling

Muhammad Husaini Zulkifli (1):
  igc: Clean the TX buffer and TX descriptor ring

Vinicius Costa Gomes (1):
  igc: Fix possible system crash when loading module

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  3 +++
 drivers/net/ethernet/intel/igc/igc_main.c    | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.38.1


