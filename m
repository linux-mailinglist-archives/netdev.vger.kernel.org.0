Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FC6F3275
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjEAPGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjEAPGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:06:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AE8ED;
        Mon,  1 May 2023 08:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9569B610A5;
        Mon,  1 May 2023 15:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF05C433EF;
        Mon,  1 May 2023 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682953590;
        bh=7ON5awAEDJjN8Hex2o/+imLwvCcOHq32ieI0j7qLVgk=;
        h=From:To:Cc:Subject:Date:From;
        b=jPNPhyUO0Fx+LIO9XJXgIAQIkuQHzhl0Fn1PLRTFWcRR8brLdXuXqrSMM8wOQ0IvA
         HpzhBSY1PVem4z1yig8+zTt5jdXaJI/57AN4m1cniMgcSSX0jRgRhVPJ+acsgdTe/a
         1NpKG9SBeCR5zkbb9xtvWgQ4kgnk+SLVzMpNGENmkzBUY+lLYZUQd9YougVu9d2txx
         /fuZPjCxr2dthcBqHH101rk5BemNratiNhJIEabW0fHkhilcEydDGq70HZ7Vkumg/0
         dqQbAdofCdJfDB+Z0tsY3diiXVYHP9flk24TYCHFgRPmFbf4NnizokCuv+aYjPr3+o
         5qTveQaL/FpxQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pds_core: fix linking without CONFIG_DEBUG_FS
Date:   Mon,  1 May 2023 17:06:14 +0200
Message-Id: <20230501150624.3552344-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The debugfs.o file is only built when the fs is enabled:

main.c:(.text+0x47c): undefined reference to `pdsc_debugfs_del_dev'
main.c:(.text+0x8dc): undefined reference to `pdsc_debugfs_add_dev'
main.c:(.exit.text+0x14): undefined reference to `pdsc_debugfs_destroy'
main.c:(.init.text+0x8): undefined reference to `pdsc_debugfs_create'
dev.c:(.text+0x988): undefined reference to `pdsc_debugfs_add_ident'
core.c:(.text+0x6b0): undefined reference to `pdsc_debugfs_del_qcq'
core.c:(.text+0x998): undefined reference to `pdsc_debugfs_add_qcq'
core.c:(.text+0xf0c): undefined reference to `pdsc_debugfs_add_viftype'

Add dummy helper functions for these interfaces.

Fixes: 55435ea7729a ("pds_core: initial framework for pds_core PF driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/amd/pds_core/core.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index e545fafc4819..2cc430403e9c 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -261,6 +261,7 @@ int pdsc_dl_enable_validate(struct devlink *dl, u32 id,
 
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
+#ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
@@ -270,6 +271,17 @@ void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
+#else
+static inline void pdsc_debugfs_create(void) {}
+static inline void pdsc_debugfs_destroy(void) {}
+static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) {}
+static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) {}
+static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) {}
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) {}
+static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) {}
+static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq) {}
+static inline void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq) {}
+#endif
 
 int pdsc_err_to_errno(enum pds_core_status_code code);
 bool pdsc_is_fw_running(struct pdsc *pdsc);
-- 
2.39.2

