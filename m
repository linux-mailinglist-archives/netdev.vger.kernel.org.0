Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5E52E28E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241258AbiETCgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344738AbiETCgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A03922511
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41F7461BF8
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A45C385AA;
        Fri, 20 May 2022 02:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653014179;
        bh=TBraK3iS9/2qKJ0rI58MnwenZHMrQ57Ngmy97YLts38=;
        h=Date:From:To:Cc:Subject:From;
        b=ed4CSueaOO6ftf6auvivQtqUTDzSEl2DXvrIps9rw28VBOTyjesIinp8GDU8LNCJY
         ETVRSAvWqJsIRaOkPzVYslXucaDT7aaCO2TZU+bU4rJUh5gCZjgUHejzIASXKModhc
         pLNUCiZFjgbbiIuTt0q4rxsu6R2QAKgmT2t/a+icbEPChcd1ISbuTcUCMCTCCCjN+q
         vw9z0/3rM942pLbv+XqBHCFjU440dmw6Rt3C9KOfPN4ms58Qc+KDLjVkyXtKGcclVt
         zL+nbxJzx2Y+bHx8HeLwjvFMNRktstFQ0K1L+xccS9dX1JZJUj6E8DXqHBA1SwuyTQ
         v1dUYBbR/Stzg==
Date:   Thu, 19 May 2022 19:36:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org
Subject: GCC 12 warnings
Message-ID: <20220519193618.6539f9d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

I'm sure you're involved in a number of glorious GCC 12 conversations..

We have a handful of drivers in networking which get hit by
-Warray-bounds because they allocate partial structures (I presume 
to save memory, misguided but more than 15min of work to refactor).

Since -Warray-bounds is included by default now this is making our
lives a little hard [1]. Is there a wider effort to address this?
If not do you have a recommendation on how to deal with it?

My best idea is to try to isolate the bad files and punt -Warray-bounds
to W=1 for those, so we can prevent more of them getting in but not
break WERROR builds on GCC 12. That said, I'm not sure how to achieve
that.. This for example did not work:

--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -9,5 +9,9 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o
 ifdef CONFIG_DEBUG_FS
 mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
 obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
+
+ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
+CFLAGS_mtk_ppe.o += -Wno-array-bounds
+endif

[1]
https://lore.kernel.org/all/20220520012555.2262461-1-kuba@kernel.org/
