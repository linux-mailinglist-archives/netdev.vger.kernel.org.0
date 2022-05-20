Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5A152F3EE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353309AbiETTnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353294AbiETTnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD6C19579C;
        Fri, 20 May 2022 12:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA002CE2CE0;
        Fri, 20 May 2022 19:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F078DC34118;
        Fri, 20 May 2022 19:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075807;
        bh=4oZB8rFjKLED/jr3XhcfTR1suooV0P6bDjygrUvsKhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMV5QsJy+1QT0U+2aMfvDIxlAjp9ezvNgmIslJR4vLTEtTmVhW0ffWxR1p3W2ertC
         wgVy6cUHE7e5WaY3yigCNU94ZCQLepClZNFoQWkva0T07Xrr471r+URWjOLeFOuy4H
         FyA1hp44Q1BRJI8luQml2MZVKtTs+jzQ9p2QBE1xrVJTSXodY2/Vgl9BxGkLxNMrym
         a7VNDMVbffaXYX2SMdPr7sKASO3mZeskRseHaYGrM2eoHpsz1X/39CdBvX9wtEM/LH
         VbvvovMlipT7X18niNqCC4Kq10e8SW7st5lJZ7w5+p4BJ3ebrK/m628KvplK6MILqz
         g7Uzr1WispgaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        libertas-dev@lists.infradead.org
Subject: [PATCH net-next 7/8] wifi: libertas: silence a GCC 12 -Warray-bounds warning
Date:   Fri, 20 May 2022 12:43:19 -0700
Message-Id: <20220520194320.2356236-8-kuba@kernel.org>
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

This driver does a lot of casting of smaller buffers to
a larger command response struct, GCC 12 does not like that:

drivers/net/wireless/marvell/libertas/cfg.c:1198:63: warning: array subscript ‘struct cmd_ds_802_11_associate_response[0]’ is partly outside array bounds of ‘unsigned char[203]’ [-Warray-bounds]
 1198 |                       "aid 0x%04x\n", status, le16_to_cpu(resp->statuscode),
      |                                                               ^~

Annoyingly it's not clever enough to recognize which fields
are safe to access, so move this warning to W=1 for now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kvalo@kernel.org
CC: libertas-dev@lists.infradead.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/marvell/libertas/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/Makefile b/drivers/net/wireless/marvell/libertas/Makefile
index 41b9b440a542..da4ea5a0812c 100644
--- a/drivers/net/wireless/marvell/libertas/Makefile
+++ b/drivers/net/wireless/marvell/libertas/Makefile
@@ -10,6 +10,11 @@ libertas-y += tx.o
 libertas-y += firmware.o
 libertas-$(CONFIG_LIBERTAS_MESH) += mesh.o
 
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_cfg.o += -Wno-array-bounds
+endif
+
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
 libertas_sdio-objs += if_sdio.o
-- 
2.34.3

