Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A58252F410
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346868AbiETT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiETT4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B187C14E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C2561BFD
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF055C34119;
        Fri, 20 May 2022 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653076574;
        bh=7KlObUJZ5JR3lLz6jjTIi+nDQB5MteYB6r8MusJcFkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HH9IOfYxQrWtYdAnGpjfjiT3xKBhPeT6eVISUucd7JajQ53EzW0tRBob26tVcUaXD
         4/gCr1EPWxH+VwvSlFEYZRIhVaY+EKCWm2cK7Rl5sDDsc6i8WEIeKpYrGs8xdK6IW/
         OfSOiSaGbVgFyWBJpJqf+Ytou1gAsO9RtW8Cey8dA2zSbAzD03Y+LajqhWG3GyJbs4
         k3KXlg+G1ILUki3/hEFx9gLVWo3lgQvSDh0hbhB9yVKUkjsQtGNjAW6eotHRF1t+c3
         SSlS0ZvSprkEB6Yc0tD2p4nNIWqIgj7ZL6HBBdmwQZ37vu9FZXjXxANi4XpjBdkHqK
         ES57ead6Lo6bw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/3] eth: tg3: silence the GCC 12 array-bounds warning
Date:   Fri, 20 May 2022 12:56:05 -0700
Message-Id: <20220520195605.2358489-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520195605.2358489-1-kuba@kernel.org>
References: <20220520195605.2358489-1-kuba@kernel.org>
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
index 0ddfb5b5d53c..2e6c5f258a1f 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -17,3 +17,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_tg3.o += -Wno-array-bounds
+endif
-- 
2.34.3

