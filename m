Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D256866BEB0
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjAPNHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjAPNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D700F3A92;
        Mon, 16 Jan 2023 05:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8885CB80D31;
        Mon, 16 Jan 2023 13:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2E2C433D2;
        Mon, 16 Jan 2023 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874378;
        bh=FGqAyVpLDpa6MeOFTzSFbDozHcqVNx/tnBsc6ttpwoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in1GLNrzq+wqFOE9AjaQ/K0YCORb2NHrxF8tjgbcNj/kIKb2H6NHGODGVottYTQMO
         hSCapPblNrwwp6gJsN5FxW6/Vks9AoCr/LmQoiE/dkc4qxBb0U8Oj1ndZjy5CjDjiI
         PQmjUt1pRAF+CAlIhFstqLSerYxKXNovbzYn8WNAuAnfSP5IPDEBLB8xArwA+3tCn8
         FW/qet4RhByW7xKJPoGynWXG84hWb2hIT/wBSpa/LG7tzX6k71bUS+lW6pwuNvJB/m
         AyROUjPdB2yGTQpVzslf6xLN3OfmWOXVz4lISPONbX2LmTreM8inz9x683LsyBUvN3
         pVoCrD78rk9hw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 04/13] RDMA/core: Add cryptographic device capabilities
Date:   Mon, 16 Jan 2023 15:05:51 +0200
Message-Id: <4be0048cfe54548acc3730d733009237d8a896f8.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

Some advanced RDMA devices have HW engines with cryptographic
capabilities. Those devices can encrypt/decrypt data when transmitting
from memory domain to wire domain and when receiving data from wire
domain to memory domain. Expose these capabilities via common RDMA
device attributes. For now, add only AES-XTS cryptographic support.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 include/rdma/crypto.h   | 37 +++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h |  2 ++
 2 files changed, 39 insertions(+)
 create mode 100644 include/rdma/crypto.h

diff --git a/include/rdma/crypto.h b/include/rdma/crypto.h
new file mode 100644
index 000000000000..4779eacb000e
--- /dev/null
+++ b/include/rdma/crypto.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ */
+
+#ifndef _RDMA_CRYPTO_H_
+#define _RDMA_CRYPTO_H_
+
+#include <linux/types.h>
+
+/**
+ * Encryption and decryption operations are done by attaching crypto properties
+ * to a memory region. Once done, every access to the memory via the crypto
+ * memory region will result in inline encryption or decryption of the data
+ * by the RDMA device. The crypto properties contain the Data Encryption Key
+ * (DEK) and the crypto standard that should be used and its attributes.
+ */
+
+/**
+ * Cryptographic engines in clear text mode capabilities.
+ * @IB_CRYPTO_ENGINES_CAP_AES_XTS: Support AES-XTS engine.
+ */
+enum {
+	IB_CRYPTO_ENGINES_CAP_AES_XTS = 1 << 0,
+};
+
+/**
+ * struct ib_crypto_caps - Cryptographic capabilities
+ * @crypto_engines: From enum ib_crypto_engines_cap_bits.
+ * @max_num_deks: Maximum number of Data Encryption Keys.
+ */
+struct ib_crypto_caps {
+	u32 crypto_engines;
+	u32 max_num_deks;
+};
+
+#endif /* _RDMA_CRYPTO_H_ */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cc2ddd4e6c12..83be7e49c5f7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -40,6 +40,7 @@
 #include <rdma/rdma_counter.h>
 #include <rdma/restrack.h>
 #include <rdma/signature.h>
+#include <rdma/crypto.h>
 #include <uapi/rdma/rdma_user_ioctl.h>
 #include <uapi/rdma/ib_user_ioctl_verbs.h>
 
@@ -450,6 +451,7 @@ struct ib_device_attr {
 	u64			max_dm_size;
 	/* Max entries for sgl for optimized performance per READ */
 	u32			max_sgl_rd;
+	struct ib_crypto_caps	crypto_caps;
 };
 
 enum ib_mtu {
-- 
2.39.0

