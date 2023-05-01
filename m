Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE7A6F3A89
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjEAWfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjEAWfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BD226BC;
        Mon,  1 May 2023 15:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53AE361FFD;
        Mon,  1 May 2023 22:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551CEC433D2;
        Mon,  1 May 2023 22:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682980503;
        bh=tFgPQnUGzkWSyNbxoqNLA0lCOJAEhy+Hl6nBDMeibNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G3zly/zuoUp/BaN3h2TTKmhO2jNFFyPjfY6kTuBst7h7CX4xh0XOQmpjKt5+XfpLn
         CYhWL4ekIGhgb5Is7uJGiVQNCln08JMxt0y95iuiPYOeNDVdYw+2RL0wxvHydgid7T
         Ilt28qn0cF3QD8sbbeb0VVcxLjnj1wtUMfuXchcO2KonOGlBTsc2bSDL4A9pcsq0AP
         QsrbVzT+AY0/9lzSPwPoUajAPaEcZLhuodxh1x3TOdAvsUBvS7PL+mGXefUvJvuznU
         rijeB/LKwhDoni4rgyupPLw5o4WrR100CY2IwCv0zk64CnwVws2HQJNm3XQRx5MfKv
         B0gQa+j5aoGJg==
Date:   Mon, 1 May 2023 15:35:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pds_core: fix linking without CONFIG_DEBUG_FS
Message-ID: <20230501153502.34f194ed@kernel.org>
In-Reply-To: <20230501150624.3552344-1-arnd@kernel.org>
References: <20230501150624.3552344-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 May 2023 17:06:14 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The debugfs.o file is only built when the fs is enabled:
> 
> main.c:(.text+0x47c): undefined reference to `pdsc_debugfs_del_dev'
> main.c:(.text+0x8dc): undefined reference to `pdsc_debugfs_add_dev'
> main.c:(.exit.text+0x14): undefined reference to `pdsc_debugfs_destroy'
> main.c:(.init.text+0x8): undefined reference to `pdsc_debugfs_create'
> dev.c:(.text+0x988): undefined reference to `pdsc_debugfs_add_ident'
> core.c:(.text+0x6b0): undefined reference to `pdsc_debugfs_del_qcq'
> core.c:(.text+0x998): undefined reference to `pdsc_debugfs_add_qcq'
> core.c:(.text+0xf0c): undefined reference to `pdsc_debugfs_add_viftype'
> 
> Add dummy helper functions for these interfaces.

Debugfs should wrap itself. Doesn't this work:

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 0abc33ce826c..54d1d5b375ce 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -9,6 +9,5 @@ pds_core-y := main.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
-	      fw.o
-
-pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
+	      fw.o \
+	      debugfs.o
