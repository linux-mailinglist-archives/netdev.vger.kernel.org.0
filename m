Return-Path: <netdev+bounces-3003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3126704FC6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 594DD28163F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907B02772B;
	Tue, 16 May 2023 13:50:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490A34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:50:17 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EDCD2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684245014; x=1715781014;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Te1MCOJWoprMz8crYWwv+jl5wlERnan/kACoEJ4MmKo=;
  b=OZt6WJpjpqBAHstkAg211QT0jSrDrHA8HayI2AhH2N1SUGQ1vu6TRvPk
   P9FQAPGMwWMpUXaWNMefk9yzoG22tQ5cH4pPoO+C6ksv8znzk8FOg/O2t
   4MfBlAjo2zQTph7+aqs/FggicNdS1WsXTuzq8g06fwiVrCncfzMX+AVsN
   2k3YBx2GRCPIh8Z5+O86VXUyhPv0nGyFj6HSrE2rDP9En2zNYXi/Be//r
   mCW+vN5S26B6r8o/woalQPxHrJt+dQ0hPlaXK0+NTBtQDwMbvhEkBGYzr
   o6ncaKHU5gFdJY0h1zLgUd+uUb5GKJ7zK9HGD22gfJ5ozJhDLkwzZ+PtH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="350319824"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="350319824"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 06:50:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="651846380"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="651846380"
Received: from amlin-018-068.igk.intel.com ([10.102.18.68])
  by orsmga003.jf.intel.com with ESMTP; 16 May 2023 06:50:13 -0700
From: Mateusz Palczewski <mateusz.palczewski@intel.com>
To: j.vosburgh@gmail.com,
	andy@greyhouse.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dbanerje@akamai.com,
	netdev@vger.kernel.org
Cc: Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: [PATCH iwl-net  v1 0/2] Fix for bond 802.3ad mode with VFs
Date: Tue, 16 May 2023 09:44:45 -0400
Message-Id: <20230516134447.193511-1-mateusz.palczewski@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Bond 802.3ad mode with PFs works fine.

Problem appears when one or both of the nodes contains VFs.
Let's assume there is setup with 2 hosts, on both there are 2 PFs with each one with 1 VFs.
Bond(802.3ad)--|--VFs(two VFs)--Switch(with lacp enabled)--VFs-Bond(802.3ad)
In this particular scenario, there are 2 problems:

1. VFs needs some more time than PFs to set the link up, bonding drivers checks link only once, without any delay.
This caused issues with setting up bonding link. Fixed by adding small delay loop which checks link state.
2. Only master link works properly. Slave link cannot negotiate connection. This happens because permanent hw address
is used for creating lacpdu packets, not current address. Fixed by using current hw address to create lacpdu packet.

Sebastian Basierski (2):
  drivers/net/bonding/bond_3ad: Use updated MAC address for lacpdu
    packets
  drivers/net/bonding: Added some delay while checking for VFs link

 drivers/net/bonding/bond_3ad.c  |  4 ++--
 drivers/net/bonding/bond_main.c | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.31.1


