Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8B62491D0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHSA2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:48102 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgHSA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:28:48 -0400
IronPort-SDR: wr0jLXwnwC2K67uJhz7MUXAbIgPzTM0hlRqBWuc12/nspGdjvlsqx4bxwGT9kXI9isnz5D+TFU
 ob64dE8OCh4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856132"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856132"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:38 -0700
IronPort-SDR: XePB5QtwlhVtZM0ElCHXjKDKIEaSniZBjtlNHqnsGoOeX41Oechnrh0mZMiFgy5TnFlVA8U2yj
 mbF7A2jGfVIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283582"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 17:28:38 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v3 0/2] devlink flash update overwrite mask
Date:   Tue, 18 Aug 2020 17:28:19 -0700
Message-Id: <20200819002821.2657515-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for the new attribute to devlink flash
update, DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.

This attribute is a bitfield which allows userspace to specify what set of
subfields to overwrite when performing a flash update for a device.

The intention is to support the ability to control the behavior of
overwriting the configuration and identifying fields in the Intel ice device
flash update process. This is necessary  as the firmware layout for the ice
device includes some settings and configuration within the same flash
section as the main firmware binary.

This series, and the accompanying kernel series, introduce support for the
attribute. Once applied, the overwrite support can be be invoked via
devlink:

  # overwrite settings
  devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings

  # overwrite identifiers and settings
  devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings overwrite identifiers

The overwrite mask is determined by combining all of the "overwrite
<section>" arguments into a bitmask by doing bitwise OR. The "selector" for
the nla_bitfield32 will always be specified as the
DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS provided in our copy of the uapi
header.

Changes since v2:
* remove the use of GENMASK from the userspace API header.
* separate iproute2 and net-next patches to avoid confusion.
* convert to using an nla_bitfield32 using the mnl_attr_push().

Jacob Keller (2):
  Update devlink header for overwrite mask attribute
  devlink: support setting the overwrite mask

 devlink/devlink.c            | 48 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h | 24 ++++++++++++++++++
 2 files changed, 70 insertions(+), 2 deletions(-)


base-commit: e8e8f16ed155dfbe026ad3c22458d1277e17794e
-- 
2.28.0.218.ge27853923b9d.dirty

