Return-Path: <netdev+bounces-10369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B10172E2C7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DA5B2811FF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D240E2D250;
	Tue, 13 Jun 2023 12:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D43C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:24:31 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C928DCE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686659069; x=1718195069;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uRT9JLXdBgnt/JTOF41e88faFHrO2GR6FggvMkMJk2A=;
  b=ccJdi5AoZmSyz0WAJuh9BiTSmQECHcrVmNzp9f9dhQd0GfZzLWNthqoQ
   P1PJQI3cBHg9QOQrg0f2wLwN1BbVx67zOHIlVysvcoXzca7csBSG2d2Zu
   47QPBhsBMglBjHiUnPykkDcqKI4Uqi/OWCTg6rlDYAGrYnk0CixOu0AiJ
   /A6XBbhxfvI2lAIQF+H0OTK0ZzHfGCYCMbpU27QRrLPRdIBSRpvZs3M/3
   cpWiCx705cGO9MtqG4Kzl0oFRzV9YKs7ihJpNaPO435/W6wZjdTyYjcGD
   eEYvzZWbsZ4dzkbFahXhvdduV/KHmP1ftUjc7VOdkZgR9YoQR6/m8h62r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="337951206"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337951206"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:24:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="835871993"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835871993"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:24:26 -0700
From: Piotr Gardocki <piotrx.gardocki@intel.com>
To: netdev@vger.kernel.org
Cc: piotrx.gardocki@intel.com,
	intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com,
	michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de,
	kuba@kernel.org,
	maciej.fijalkowski@intel.com,
	anthony.l.nguyen@intel.com,
	simon.horman@corigine.com,
	aleksander.lobakin@intel.com
Subject: [PATCH net-next v2 0/3] optimize procedure of changing MAC address on interface
Date: Tue, 13 Jun 2023 14:24:17 +0200
Message-Id: <20230613122420.855486-1-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The first patch adds an if statement in core to skip early when
the MAC address is not being changes.
The remaining patches remove such checks from Intel drivers
as they're redundant at this point.

v2: modified check in core to support addresses of any length,
removed redundant checks in i40e and ice

Piotr Gardocki (3):
  net: add check for current MAC address in dev_set_mac_address
  i40e: remove unnecessary check for old MAC == new MAC
  ice: remove unnecessary check for old MAC == new MAC

 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ------
 drivers/net/ethernet/intel/ice/ice_main.c   | 5 -----
 net/core/dev.c                              | 2 ++
 3 files changed, 2 insertions(+), 11 deletions(-)

-- 
2.34.1


