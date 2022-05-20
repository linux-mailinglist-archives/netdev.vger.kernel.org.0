Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C3A52F3ED
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353304AbiETTnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353271AbiETTn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22535197F62;
        Fri, 20 May 2022 12:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B235061C1D;
        Fri, 20 May 2022 19:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53017C34119;
        Fri, 20 May 2022 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075807;
        bh=1CHHoR/Uc9TOmk7VZ5FDY8+i+nmwtgnWeoA//yxKWSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqM1rnsQtmb13wh6rKfYCgUzmcvaYU/uYKKtuJFr0yp9u+YuqEkWF5urCMD3Q02pj
         uBdcLsUFXb7KcY4Di/fnfB+TItyds/+GwXFd/4zujRuaeVc9uBeBXkgXDYpcRLWTbe
         l1en4UIOgAIZ1TPyxE3Dai4f9SQdGxYKLmNEJTbFK5IRE+tBj7OpmUQ308iAp7HHq+
         EuYLoEk6ciIlkkLpm7r4Fk/B4EgV/NgSc8cmFxW+Xq1Y72aUfnvfRuBNaWAD+EzXG3
         +BF4gKURMw07rRMy1m9Y8Olv2GLSvzi7winKS2R9pQo9FPWzy3cE2LuBCb20T5/I57
         h6xW9YvRMGMEg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, chunkeey@googlemail.com
Subject: [PATCH net-next 8/8] wifi: carl9170: silence a GCC 12 -Warray-bounds warning
Date:   Fri, 20 May 2022 12:43:20 -0700
Message-Id: <20220520194320.2356236-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
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

carl9170 has a big union (struct carl9170_cmd) with all the command
types in it. But it allocates buffers only large enough for a given
command. This upsets GCC 12:

drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds]
  125 |                 tmp->hdr.cmd = cmd;
      |                 ~~~~~~~~~~~~~^~~~~

Punt the warning to W=1 for now. Hopefully GCC will learn to
recognize which fields are in-bounds.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chunkeey@googlemail.com
CC: kvalo@kernel.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/carl9170/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/Makefile b/drivers/net/wireless/ath/carl9170/Makefile
index 1a81868ce26d..7463baa62fa8 100644
--- a/drivers/net/wireless/ath/carl9170/Makefile
+++ b/drivers/net/wireless/ath/carl9170/Makefile
@@ -3,3 +3,8 @@ carl9170-objs := main.o usb.o cmd.o mac.o phy.o led.o fw.o tx.o rx.o
 carl9170-$(CONFIG_CARL9170_DEBUGFS) += debug.o
 
 obj-$(CONFIG_CARL9170) += carl9170.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_cmd.o += -Wno-array-bounds
+endif
-- 
2.34.3

