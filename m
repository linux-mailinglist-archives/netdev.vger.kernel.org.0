Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B7839E481
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhFGQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:57118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230416AbhFGQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:47 -0400
IronPort-SDR: 1rQutOH1enCciXUGYDorXWP0IxEh0FQxiEwCTJUjaLa52P/brkSUxvNI3U/gI2X0O+a/A3yg79
 YnSvW9WjEdgQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474559"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474559"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:55 -0700
IronPort-SDR: /idd/3jtL/8roOho1DbpLNPqKXoWD3hT7DlLduvqRI0n9BXZ/X0wx5DyWrihRYaNjf58QjPDnc
 IrpjKe1tHisw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841258"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 10/15] ice: add error message when pldmfw_flash_image fails
Date:   Mon,  7 Jun 2021 09:53:20 -0700
Message-Id: <20210607165325.182087-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When flashing a new firmware image onto the device, the pldmfw library
parses the image contents looking for a matching record. If no record
can be found, the function reports an error of -ENOENT. This can produce
a very confusing error message and experience for the user:

  $devlink dev flash pci/0000:ab:00.0 file image.bin
  devlink answers: No such file or directory

This is because the ENOENT error code is interpreted as a missing file
or directory. The pldmfw library does not have direct access to the
extack pointer as it is generic and non-netdevice specific. The only way
that ENOENT is returned by the pldmfw library is when no record matches.

Catch this specific error and report a suitable extended ack message:

  $devlink dev flash pci/0000:ab:00.0 file image.bin
  Error: ice: Firmware image has no record matching this device
  devlink answers: No such file or directory

In addition, ensure that we log an error message to the console whenever
this function fails. Because our driver specific PLDM operation
functions potentially set the extended ACK message, avoid overwriting
this with a generic message.

This change should result in an improved experience when attempting to
flash an image that does not have a compatible record.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index dcec0360ce55..f8601d5b0b19 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -702,6 +702,16 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	}
 
 	err = pldmfw_flash_image(&priv.context, fw);
+	if (err == -ENOENT) {
+		dev_err(dev, "Firmware image has no record matching this device\n");
+		NL_SET_ERR_MSG_MOD(extack, "Firmware image has no record matching this device");
+	} else if (err) {
+		/* Do not set a generic extended ACK message here. A more
+		 * specific message may already have been set by one of our
+		 * ops.
+		 */
+		dev_err(dev, "Failed to flash PLDM image, err %d", err);
+	}
 
 	ice_release_nvm(hw);
 
-- 
2.26.2

