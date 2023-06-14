Return-Path: <netdev+bounces-10757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C6E73025F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DDE82810C0
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EC28BFB;
	Wed, 14 Jun 2023 14:53:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFD58486
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:53:14 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8701FEF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686754391; x=1718290391;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fj9DXsvWrj81d+2jTqsvEn4kEKCA81tyuhprouAkq7Y=;
  b=OIE5gT5knseuJeyqPk+oaJiTCG5FGNh2H8g4mHFNtTQ2/39R2rBLd5Vv
   e3m3dby5kSrVBqNw2ceS2VJ5NEFDgG9URkwfIxdXyzVzDBP26XS78cJ3v
   JzU6hYwHC5NPo2jh/E2Uyt27G80BjCyTp4pf8P7VmSAyRV4DI6dgr8LEz
   p3vJFdcv+0kQRhhlNbQvpBftrLgwXs4gT+QlCESYvpwXwEyVlJVWG4Ghs
   gyl0COwWGdcyGi64aEuRYmelrcOoCaiCRw75WvYsjnaKka/Tv+1wQeX6m
   6a9CV6cW/sBbG8mPAZaCWTFyIC/Ovl+qz0kU3vzW3FCy6ln00PDUKyWsS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387040536"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="387040536"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782114841"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="782114841"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:08 -0700
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
Subject: [PATCH net-next v3 0/3] optimize procedure of changing MAC address on interface
Date: Wed, 14 Jun 2023 16:52:59 +0200
Message-Id: <20230614145302.902301-1-piotrx.gardocki@intel.com>
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
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The first patch adds an if statement in core to skip early when
the MAC address is not being changes.
The remaining patches remove such checks from Intel drivers
as they're redundant at this point.

v3: removed "This patch ..." from first patch to simplify sentence.
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


