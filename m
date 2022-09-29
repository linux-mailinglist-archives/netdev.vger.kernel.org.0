Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86F5EEED0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiI2HWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiI2HWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7AC113B79
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8D062063
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D76C433D6;
        Thu, 29 Sep 2022 07:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436158;
        bh=0isdiF9sofr6hLn0jB32FHI5frmHmFlFvOvNCiDTaVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMzCm3/PXruMsfP89Y5502q17bY7DtIoLMrdppTrA7CMkVRgMh1QRGMqZrbhsMpkh
         X1StNCFX8zCyUDam5zSDpLwJ6IJfBNZmtV7fszXUV8FDzrKk2jhZKeX5h+gQZPZPwj
         QCa3yivy+DdkobxUSSF62+Jn3v9kzgLnnPD4l36+PYbPxSGP50cNxaX7e+ddO0ch1Z
         51ICB9HBwTdGXu4Dfh2aoWoGXqt05pwVtAuLx41mpPxaSnxUaMy1lFX4i3IWBc3fDd
         hTxza5QwnVDZSynyJuTYzx/zh20USvpCKqal1ZtSuMUDxjfW+J0uJqVSIAo0FGiKaB
         dw3MxBip3dxww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 01/16] xsk: Expose min chunk size to drivers
Date:   Thu, 29 Sep 2022 00:21:41 -0700
Message-Id: <20220929072156.93299-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Drivers should be aware of the range of valid UMEM chunk sizes to be
able to allocate their internal structures of an appropriate size. It
will be used by mlx5e in the following patches.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
CC: "Björn Töpel" <bjorn@kernel.org>
CC: Magnus Karlsson <magnus.karlsson@intel.com>
CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/xdp_sock_drv.h | 3 +++
 net/xdp/xdp_umem.c         | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 0e58c38ce0c1..6406faa3d57d 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -9,6 +9,9 @@
 #include <net/xdp_sock.h>
 #include <net/xsk_buff_pool.h>
 
+#define XDP_UMEM_MIN_CHUNK_SHIFT 11
+#define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
+
 #ifdef CONFIG_XDP_SOCKETS
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 869b9b9b9fad..4681e8e8ad94 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -19,8 +19,6 @@
 #include "xdp_umem.h"
 #include "xsk_queue.h"
 
-#define XDP_UMEM_MIN_CHUNK_SIZE 2048
-
 static DEFINE_IDA(umem_ida);
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
-- 
2.37.3

