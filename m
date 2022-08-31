Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6B5A7449
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiHaDMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 23:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiHaDMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 23:12:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49D6B02A8;
        Tue, 30 Aug 2022 20:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HvIU68aA/rL72BAj/039XHANsPIzEkm3dmrxFvteCJk=; b=Kw3D9UaQL0/MMa6/vqMD1iTx/y
        AVi+sPBKfCucR8zxYBi/4E7aYePAkW8fjvfDfyftTPnsH4QuP5iA6KIa8iokgqVY7xjOhw6iUljzp
        5IgYzmOQPmYKSD2EMd+PFY73Qz5vrB6YonkLqqDeae82qzAzD+uo3xWqsY++sfRerOM11jJBExiVp
        TdwNRgCztmZVChnzF2JdRy8tk+R23+U+onEJwLQV4FhYEq/ynt2NJfB/w4nwtNLCAj53eOGG69crN
        fK7b7ZDzwiY1ruYxuahy60F6sOLFCNxG+yLuncFYs7k37BnDnQ6bQmGVYBaLMulECIaU3fjZ74WeN
        WoL9dabQ==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTE9b-004hNT-EW; Wed, 31 Aug 2022 03:12:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v2] net: mlx5: eliminate anonymous module_init & module_exit
Date:   Tue, 30 Aug 2022 20:12:29 -0700
Message-Id: <20220831031229.12313-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate anonymous module_init() and module_exit(), which can lead to
confusion or ambiguity when reading System.map, crashes/oops/bugs,
or an initcall_debug log.

Give each of these init and exit functions unique driver-specific
names to eliminate the anonymous names.

Example 1: (System.map)
 ffffffff832fc78c t init
 ffffffff832fc79e t init
 ffffffff832fc8f8 t init

Example 2: (initcall_debug log)
 calling  init+0x0/0x12 @ 1
 initcall init+0x0/0x12 returned 0 after 15 usecs
 calling  init+0x0/0x60 @ 1
 initcall init+0x0/0x60 returned 0 after 2 usecs
 calling  init+0x0/0x9a @ 1
 initcall init+0x0/0x9a returned 0 after 74 usecs

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eli Cohen <eli@mellanox.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
v2: add Reviewed-by: tags;
    refresh & resend;

 drivers/net/ethernet/mellanox/mlx5/core/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2015,7 +2015,7 @@ static void mlx5_core_verify_params(void
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -2050,7 +2050,7 @@ err_debug:
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 	mlx5e_cleanup();
 	mlx5_sf_driver_unregister();
@@ -2058,5 +2058,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
