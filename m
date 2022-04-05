Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50514F44AD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351251AbiDEUCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455525AbiDEQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:00:07 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A37166AD3;
        Tue,  5 Apr 2022 08:16:16 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E1B731EC0576;
        Tue,  5 Apr 2022 17:16:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649171771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKDLQe/dPEsrthvk8DnqVfdROlALev9E4MPr2/mYC3c=;
        b=avwuDCDJzrRV5vhJCZCf6wLf1RWpmroqdHmBeTIQDKxladtn0DJ9zGp9itab8MYMyEbYss
        TOfTXejLUEN1L5nDRn7AZ7D7YF8ChYFuSTeKDiX2nmMJ1bkc/eI1mD4LrIpU4B8EAchEpu
        cnSlgQKOVSckOX99hnMsH9UATzmK88A=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 10/11] IB/mlx5: Fix undefined behavior due to shift overflowing the constant
Date:   Tue,  5 Apr 2022 17:15:16 +0200
Message-Id: <20220405151517.29753-11-bp@alien8.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405151517.29753-1-bp@alien8.de>
References: <20220405151517.29753-1-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Fix:

  drivers/infiniband/hw/mlx5/main.c: In function ‘translate_eth_legacy_proto_oper’:
  drivers/infiniband/hw/mlx5/main.c:370:2: error: case label does not reduce to an integer constant
    case MLX5E_PROT_MASK(MLX5E_50GBASE_KR2):
    ^~~~

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 include/linux/mlx5/port.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 28a928b0684b..e96ee1e348cb 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -141,7 +141,7 @@ enum mlx5_ptys_width {
 	MLX5_PTYS_WIDTH_12X	= 1 << 4,
 };
 
-#define MLX5E_PROT_MASK(link_mode) (1 << link_mode)
+#define MLX5E_PROT_MASK(link_mode) (1U << link_mode)
 #define MLX5_GET_ETH_PROTO(reg, out, ext, field)	\
 	(ext ? MLX5_GET(reg, out, ext_##field) :	\
 	MLX5_GET(reg, out, field))
-- 
2.35.1

