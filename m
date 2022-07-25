Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B35805FF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbiGYU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbiGYU4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:56:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154C522BF2;
        Mon, 25 Jul 2022 13:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782600; x=1690318600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BNyLVfo5PrO3cul85/39OZl8ZcDQ0DIDuqEiBoEFH+0=;
  b=axwYOnFqDB6nQAl6QEIrOO0mHqK7d78yGpBsExn5li0uYvdbeb/+qPVe
   dYLKS5y1RrCrzw8EGiN6xm7QVgPJToJsVpLpEaju4Zcb66jISWOqPhJ09
   A2MiwXgx1x83sbW1nwHpM85C76+3MtfDO8xFkQwzSxxrb6Vpekv9Oih+9
   B4Jf0guJ/0CliUUUX6cfcRYkWK0nxFlA1Th+XIlh5zJV9fvCLUxnvMQ8f
   /dRucYwIZj3b4FLk3YvAabtwk23lVeTjpXk6hGoQ7aY4be+kMuSo8cYQG
   CS0hcd1uD6xYw/SoBu6D2nZucnZD0uuBVauS/KO0pChQvAh52UJNxAoG+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="267564333"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="267564333"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="689191020"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:37 -0700
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
Subject: [net-next v3 3/4] pldmfw: offer option to only validate in image but not update
Date:   Mon, 25 Jul 2022 13:56:28 -0700
Message-Id: <20220725205629.3993766-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220725205629.3993766-1-jacob.e.keller@intel.com>
References: <20220725205629.3993766-1-jacob.e.keller@intel.com>
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

Add an "only_validate" bit in the PLDM firmware context configuration to
allow requesting validation of a PLDM image. Setting this bit causes the
PLDMFW library to stop after finishing validation of the image. No actual
update will be performed.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2
* Split PLDMFW changes to their own patch
* Fix code and comments still referring to dry_run
* Name the parameter "only_validate" instead of validate for clarity

 Documentation/driver-api/pldmfw/index.rst | 11 +++++++++++
 include/linux/pldmfw.h                    |  5 +++++
 lib/pldmfw/pldmfw.c                       | 12 ++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/driver-api/pldmfw/index.rst b/Documentation/driver-api/pldmfw/index.rst
index ad2c33ece30f..1eca98f642eb 100644
--- a/Documentation/driver-api/pldmfw/index.rst
+++ b/Documentation/driver-api/pldmfw/index.rst
@@ -51,6 +51,17 @@ unaligned access of multi-byte fields, and to properly convert from Little
 Endian to CPU host format. Additionally the records, descriptors, and
 components are stored in linked lists.
 
+Validating a PLDM firmware file
+===============================
+
+To simply validate a PLDM firmware file, and verify whether it applies to
+the device, set the ``only_validate`` flag in the ``pldmfw`` context
+structure. If this flag is set, the library will parse the file, validating
+its UUID and checking if any record matches the device. Note that in this
+mode, the library will *not* issue any ops besides ``match_record``. It will
+not attempt to send the component table or package data to the device
+firmware.
+
 Performing a flash update
 =========================
 
diff --git a/include/linux/pldmfw.h b/include/linux/pldmfw.h
index 0fc831338226..820c0e812989 100644
--- a/include/linux/pldmfw.h
+++ b/include/linux/pldmfw.h
@@ -124,10 +124,15 @@ struct pldmfw_ops;
  * should embed this in a private structure and use container_of to obtain
  * a pointer to their own data, used to implement the device specific
  * operations.
+ *
+ * @ops: function pointers used as callbacks from the PLDMFW library
+ * @dev: pointer to the device being updated
+ * @only_validate: if true, only validate the file, do not perform an update.
  */
 struct pldmfw {
 	const struct pldmfw_ops *ops;
 	struct device *dev;
+	u8 only_validate : 1;
 };
 
 bool pldmfw_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record);
diff --git a/lib/pldmfw/pldmfw.c b/lib/pldmfw/pldmfw.c
index 6e77eb6d8e72..cb4a105487bd 100644
--- a/lib/pldmfw/pldmfw.c
+++ b/lib/pldmfw/pldmfw.c
@@ -827,6 +827,10 @@ static int pldm_finalize_update(struct pldmfw_priv *data)
  * to the device firmware. Extract and write the flash data for each of the
  * components indicated in the firmware file.
  *
+ * If the context->only_validate bit is set, this is a request to stop after
+ * validating the image, and do not actually attempt to update the device. If
+ * this is set, stop and exit after we find a valid matching record.
+ *
  * Returns: zero on success, or a negative error code on failure.
  */
 int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
@@ -844,14 +848,22 @@ int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
 	data->fw = fw;
 	data->context = context;
 
+	/* Parse the image and make sure it is a valid PLDM firmware binary */
 	err = pldm_parse_image(data);
 	if (err)
 		goto out_release_data;
 
+	/* Search for a record matching the device */
 	err = pldm_find_matching_record(data);
 	if (err)
 		goto out_release_data;
 
+	/* If this is only to validate the file, do not perform an update */
+	if (context->only_validate)
+		goto out_release_data;
+
+	/* Perform the device update */
+
 	err = pldm_send_package_data(data);
 	if (err)
 		goto out_release_data;
-- 
2.35.1.456.ga9c7032d4631

