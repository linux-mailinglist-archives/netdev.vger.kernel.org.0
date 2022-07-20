Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CB357BDE1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiGTSev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGTSeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:34:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F77471BD2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658342087; x=1689878087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yqiPUUHr1syjDFP5vA4ZGwPje3JH9a5/bz6eP8L8TgI=;
  b=Vk9P2d2jqJTZDZZ0LrRedmzJdkvEIDUG3G66vUx4JJzoLO+w+xzbiJ+D
   jc4OZFX7dbHZSUy6+uf036SuKat3zKaLM57gpuqHqhPPPaz6/bbzyJ6aP
   4s4Jfiw5hdZoPH4YqbxT4qHkQr9DT0bFeyzdS6h0DClfcRrAeGasZaFRc
   wIPWcl5RNl+wjRrVuycpzIvHBBDU6lb/BCPf3WecYtlR2s1IjeOcdSsX+
   HfZRdsEO2DcbheUXwHZzycQy/DacW1j3Mgm4dXdwq3iJyE9kYkacUyOll
   nvarK+klNebnUvXmrpapNUUrfryce97x/JbxQTWK0pFhQIOITdttNvGSf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="350846110"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="350846110"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="656389761"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:46 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next PATCH 0/2] devlink: implement dry run support for flash update
Date:   Wed, 20 Jul 2022 11:34:31 -0700
Message-Id: <20220720183433.2070122-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a re-send of the dry run support I submitted nearly a year ago at
https://lore.kernel.org/netdev/CO1PR11MB50898047B9C0FAA520505AFDD6B59@CO1PR11MB5089.namprd11.prod.outlook.com/

I had delayed sending this because of conflicting work in the ice driver at
the time, but then forgot about it and never got around to resubmitting it.

This adds a DEVLINK_ATTR_DRY_RUN which is used to indicate a request to
validate a potentially destructive operation without performing the actions
yet. In theory it could be used for other devlink operations in the future.

For flash update, it allows the user to validate a flash image, including
ensuring the driver for the device is willing to program it, without
actually committing an update yet.

There is an accompanying series for iproute2 which allows adding the dry-run
attribute. It does as Jakub suggested and checks the maximum attribute
before allowing the dry run in order to avoid accidentally performing a real
update on older kernels.

Jacob Keller (2):
  devlink: add dry run attribute to flash update
  ice: support dry run of a flash update to validate firmware file

 Documentation/driver-api/pldmfw/index.rst     | 10 ++++++++
 .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  3 ++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 14 +++++++----
 include/linux/pldmfw.h                        |  5 ++++
 include/net/devlink.h                         |  2 ++
 include/uapi/linux/devlink.h                  |  8 +++++++
 lib/pldmfw/pldmfw.c                           | 12 ++++++++++
 net/core/devlink.c                            | 19 ++++++++++++++-
 9 files changed, 90 insertions(+), 6 deletions(-)


base-commit: 6e693a104207fbf5a22795c987e8964c0a1ffe2d
-- 
2.35.1.456.ga9c7032d4631

