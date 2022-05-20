Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2F52F3E5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353293AbiETTnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353281AbiETTn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D73199489;
        Fri, 20 May 2022 12:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F7C361B9A;
        Fri, 20 May 2022 19:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9ECC34115;
        Fri, 20 May 2022 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075805;
        bh=7YbNykz9c0aOCfyDPVpLz+qw4U51npRt4eZFKtm6Hoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWUE9y/h7QwfETx0oy7xKGmX5Xbb6QWoIx57tCK1rS27ZXCPMC5goUnEKRcnrn8W3
         ziF7gZ4qmWgFClZSaFdAAg2ncvljRLlUX8V+cCIpgcpFTEbRlWU26ODdCnzKYLQTjH
         6Zz5zvpXFTrGBzlxe1J1RJ4oQjUYh5SvD4cRvyuahuxlHAmOhW1mL4U96vFh6OV90g
         WnoblE4At5zYaTpaodBxkhl6J7vaewMHV4+Cj3P1YO4aSXdfHqu4Fjyg0tZTapuf1Y
         tR35OqBy1ydxOyE1P7JbhXzWziWl/c7c9Imu40HyDlW8h96b4ZGiwR5xtlJw6p6L0l
         H9JiWmbEa/4ng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/8] wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12
Date:   Fri, 20 May 2022 12:43:16 -0700
Message-Id: <20220520194320.2356236-5-kuba@kernel.org>
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

For some reason GCC 12 decided to complain about the common
pattern of queuing an object onto a list on the stack in ath6k:

    inlined from ‘ath6kl_htc_mbox_tx’ at drivers/net/wireless/ath/ath6kl/htc_mbox.c:1142:3:
include/linux/list.h:74:19: warning: storing the address of local variable ‘queue’ in ‘*&packet_15(D)->list.prev’ [-Wdangling-pointer=]
   74 |         new->prev = prev;
      |         ~~~~~~~~~~^~~~~~

Move the warning to W=1, hopefully it goes away with a compiler
update.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kvalo@kernel.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath6kl/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index dc2b3b46781e..01cc0d50fee6 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -36,6 +36,11 @@ ath6kl_core-y += wmi.o
 ath6kl_core-y += core.o
 ath6kl_core-y += recovery.o
 
+# FIXME: temporarily silence -Wdangling-pointer on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_htc_mbox.o += -Wno-dangling-pointer
+endif
+
 ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath6kl_core-$(CONFIG_ATH6KL_TRACING) += trace.o
 
-- 
2.34.3

