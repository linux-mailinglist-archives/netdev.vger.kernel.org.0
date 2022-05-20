Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469D252E534
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbiETGpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345958AbiETGpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737DE14CDCE
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04FDF61DAE
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB63C385A9;
        Fri, 20 May 2022 06:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653029112;
        bh=YUbX3JtusIzXc7sFFiCK91kV5cPUy9Rk1AwIlgAqjck=;
        h=From:To:Cc:Subject:Date:From;
        b=ifka/h0OGHS4t8mm2+DuaXvCHLgoOMHD2a7E1Q57lBZmqooco+4tHqSRgWZBzVg4v
         b/X34yaUR5ljHMWUwhTckqVnR8Jvu8ES48TwQ/q62+T5dfCYr/lwyYVbXC4LU5W5rK
         OZ56QMCdEIVNJSYdtmClGMaY3PVKrzt4/ulpKsv08Csppl/H1IcOPo8enub4VIluVc
         omdTyI5ujhQVqjoJkQ6Q/oO2ryHs7TEdOcSiCHEJV6n6dmK+KL6O2MxC3wfpPbEznC
         lS+m2Y+bwbx4jPtTjYv6qPDYuipMwwSaIJc5KRl3vdV7/L2F+64CugswvjBlQb+FcY
         2tN3QIe+qxxFg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mchan@broadcom.com, siva.kallam@broadcom.com,
        prashant@broadcom.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Thu, 19 May 2022 23:45:05 -0700
Message-Id: <20220520064505.2316192-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 currently generates a rather inconsistent warning:

drivers/net/ethernet/broadcom/tg3.c:17795:51: warning: array subscript 5 is above array bounds of ‘struct tg3_napi[5]’ [-Warray-bounds]
17795 |                 struct tg3_napi *tnapi = &tp->napi[i];
      |                                           ~~~~~~~~^~~

i is guaranteed < tp->irq_max which in turn is either 1 or 5.
There are more loops like this one in the driver, but strangely
GCC 12 dislikes only this single one.

Silence this silliness for now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
---
 drivers/net/ethernet/broadcom/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 0ddfb5b5d53c..577130c020d0 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,3 +17,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+
+# FIXME: temporarily silence -Warray-bounds on non W=1 builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_tg3.o += $(call cc-disable-warning, array-bounds)
+endif
-- 
2.34.3

