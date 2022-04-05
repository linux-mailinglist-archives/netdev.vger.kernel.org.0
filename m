Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538034F4585
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358367AbiDEUED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455464AbiDEQAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:00:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613DB56754;
        Tue,  5 Apr 2022 08:15:43 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED80F1EC0518;
        Tue,  5 Apr 2022 17:15:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649171738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luB7TMkZKRRM3TEoQ4R8/NjdvmPgDZy3QgqEge4f+08=;
        b=mp7uj8rh+qT1te6TN78hfnAl+SEVUwh/XB6GJNWc9jjOTScA1pWHFhh0ZXTQuN19oWTHAt
        ZluQq13l01mFQlgLyrWKpDwy3POmPE8l05L0o16f1Nvi6ehaoKMst91nom7Kkc4rFaJxvW
        nawuUPZxoz7+MBEmTz91CYxRmPaboIg=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 03/11] bnx2x: Fix undefined behavior due to shift overflowing the constant
Date:   Tue,  5 Apr 2022 17:15:09 +0200
Message-Id: <20220405151517.29753-4-bp@alien8.de>
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

  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: In function ‘bnx2x_check_blocks_with_parity3’:
  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:4917:4: error: case label does not reduce to an integer constant
      case AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY:
      ^~~~

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
index 5caa75b41b73..881ac33fe914 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
@@ -6218,7 +6218,7 @@
 #define AEU_INPUTS_ATTN_BITS_GPIO0_FUNCTION_0			 (0x1<<2)
 #define AEU_INPUTS_ATTN_BITS_IGU_PARITY_ERROR			 (0x1<<12)
 #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_ROM_PARITY		 (0x1<<28)
-#define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY		 (0x1<<31)
+#define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_SCPAD_PARITY		 (0x1U<<31)
 #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_UMP_RX_PARITY		 (0x1<<29)
 #define AEU_INPUTS_ATTN_BITS_MCP_LATCHED_UMP_TX_PARITY		 (0x1<<30)
 #define AEU_INPUTS_ATTN_BITS_MISC_HW_INTERRUPT			 (0x1<<15)
-- 
2.35.1

