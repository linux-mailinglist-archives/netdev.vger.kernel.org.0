Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D0B66BEBB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjAPNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbjAPNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:07:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA661710;
        Mon, 16 Jan 2023 05:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 645F660F9B;
        Mon, 16 Jan 2023 13:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0DFC433F1;
        Mon, 16 Jan 2023 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874419;
        bh=Z9+KomyeN4vAjModCpaAbKOjkyqP4m8dRccCmgRLn8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPeQnGdMKL0qvPIWYWzLqm//vIJ6xVrQ+zSrw9NRNMJnbSzuJa9VEEYupUejVnt06
         HRNhIbjJVVOzzBSXSeoUjnDrYIDLqtF3CjSOmEgHFu37MIVWOwUbq/DFyGfdnJ++Yg
         BvhvBUhhKztQYlOb92vy7VS8Uiq44148kyxwVg4auh30C5QonsBIXdBs6dnWQlVAaH
         p/08idib6ImCyqQwz1xJ8CyMsMgn2pwOnLcSRdNel6waQkTHTGQTYUJsOWFJsf4Ywz
         ++JUX3bjsvRlVxxLqSrPNBs7farZKtwyKf2xjpumDEoLbmQvbxXcM2CM0TkhY3sduc
         8JxubTZg4TsUw==
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
Subject: [PATCH rdma-next 12/13] nvme: Add crypto profile at nvme controller
Date:   Mon, 16 Jan 2023 15:05:59 +0200
Message-Id: <efc8dc5952baa096a14db1761f84a5ab2e76654a.1673873422.git.leon@kernel.org>
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

The crypto profile will be filled by the transport drivers. This
is a preparation patch for adding support of inline encryption
at nvme-rdma driver.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/nvme/host/core.c | 3 +++
 drivers/nvme/host/nvme.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 51a9880db6ce..f09e4e0216b3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1928,6 +1928,9 @@ static void nvme_update_disk_info(struct gendisk *disk,
 			capacity = 0;
 	}
 
+	if (ctrl->crypto_enable)
+		blk_crypto_register(&ctrl->crypto_profile, disk->queue);
+
 	set_capacity_and_notify(disk, capacity);
 
 	nvme_config_discard(disk, ns);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 424c8a467a0c..591380f53744 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/blk-crypto-profile.h>
 
 #include <trace/events/block.h>
 
@@ -374,6 +375,9 @@ struct nvme_ctrl {
 
 	enum nvme_ctrl_type cntrltype;
 	enum nvme_dctype dctype;
+
+	bool crypto_enable;
+	struct blk_crypto_profile crypto_profile;
 };
 
 enum nvme_iopolicy {
-- 
2.39.0

