Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77D55805FD
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiGYU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGYU4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:56:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF022BEC;
        Mon, 25 Jul 2022 13:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782596; x=1690318596;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OD9ZmETWABUq2Z2k95JhOwopvpHsK0NcZdkU94kL2HE=;
  b=nQEfd61IDIwA9Gr2EzRc8EKW6k6WyGdjC4RtTUklQTx4uySrB+17ldFE
   fAX84Etav6hQel2vD5CF7AEs0cA2AqeIBTay1M3reP7Qe0iH5QMgGNPfk
   rA6/5Tz4xcHQn0UB92pJFWJwB9TeiHFwdOkRRVE/yeOYmer5Gd2/0+uus
   ShQiSW0aVet6NMgDS1ojTEo0S9rgBoEaNNuo11ozw7zI4w8YhVcGo+ySw
   VWhw7N4PSaRxZf828H2KMCQb4NWFqJJlPxLgHZgjDwWYV9Y8aDir41Tjx
   qg7WOyin76v0mK9KrjuWLhpYTCj8U5BqP/VLPB+O0MObT0pX2Gl4Pw4BD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="267564329"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="267564329"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="689191011"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: [net-next v3 0/4] devlink: implement dry run support for flash update
Date:   Mon, 25 Jul 2022 13:56:25 -0700
Message-Id: <20220725205629.3993766-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Changes since v1:
* Added maintainers to Cc (thanks for pointing out the script, Jiri!)
* Replaced bool in struct with u8 : 1
* Added kernel doc to devlink_flash_update_params
* Renamed PLDMFW parameter from dry_run to validate
* Reduced indentation in devlink.c by using nla_get_flag

Changes since v2:
* Split the fix for overwrite_mask doc to its own patch
* Split pldmfw changes to their own patch
* Fix lib/pldmfw.c code mentioning dry_run
* Name the pldmfw context parameter "only_validate" for clarity
* Dropped the comment about dry run

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-doc@vger.kernel.org
Cc: netdev@vger.kernel.org

Jacob Keller (4):
  devlink: add missing kdoc for overwrite mask
  devlink: add dry run attribute to flash update
  pldmfw: offer option to only validate in image but not update
  ice: support dry run of a flash update to validate firmware file

 Documentation/driver-api/pldmfw/index.rst     | 10 ++++++++
 .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  3 ++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 14 +++++++----
 include/linux/pldmfw.h                        |  5 ++++
 include/net/devlink.h                         |  4 ++++
 include/uapi/linux/devlink.h                  |  8 +++++++
 lib/pldmfw/pldmfw.c                           | 12 ++++++++++
 net/core/devlink.c                            | 17 +++++++++++++-
 9 files changed, 90 insertions(+), 6 deletions(-)


base-commit: 5588d628027092e66195097bdf6835ddf64418b3
-- 
2.35.1.456.ga9c7032d4631

