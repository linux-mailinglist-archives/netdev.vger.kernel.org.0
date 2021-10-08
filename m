Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221B0426813
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbhJHKnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:43:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:45104 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhJHKnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:43:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213622801"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213622801"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478934482"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 0/4] devlink: add dry run support for flash update
Date:   Fri,  8 Oct 2021 03:41:11 -0700
Message-Id: <20211008104115.1327240-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of a previous idea I had discussed on the list at
https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.com/

The idea is to allow user space to query whether a given destructive devlink
command would work without actually performing any actions. This is commonly
referred to as a "dry run", and is intended to give tools and system
administrators the ability to test things like flash image validity, or
whether a given option is valid without having to risk performing the update
when not sufficiently ready.

The intention is that all "destructive" commands can be updated to support
the new DEVLINK_ATTR_DRY_RUN, although this series only implements it for
flash update.

I expect we would want to support this for commands such as reload as well
as other commands which perform some action with no interface to check state
before hand.

I tried to implement the DRY_RUN checks along with useful extended ACK
messages so that even if a driver does not support DRY_RUN, some useful
information can be retrieved. (i.e. the stack indicates that flash update is
supported and will validate the other attributes first before rejecting the
command due to inability to fully validate the run within the driver).

Jacob Keller (4):
  ice: move and rename ice_check_for_pending_update
  ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
  devlink: add dry run attribute to flash update
  ice: support dry run of a flash update to validate firmware file

 Documentation/driver-api/pldmfw/index.rst     |  10 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  53 +-----
 .../net/ethernet/intel/ice/ice_fw_update.c    | 170 ++++++++++--------
 .../net/ethernet/intel/ice/ice_fw_update.h    |   7 +-
 include/linux/pldmfw.h                        |   5 +
 include/net/devlink.h                         |   2 +
 include/uapi/linux/devlink.h                  |   2 +
 lib/pldmfw/pldmfw.c                           |  12 ++
 net/core/devlink.c                            |  19 +-
 9 files changed, 145 insertions(+), 135 deletions(-)


base-commit: c514fbb6231483b05c97eb22587188d4c453b28e
-- 
2.31.1.331.gb0c09ab8796f

