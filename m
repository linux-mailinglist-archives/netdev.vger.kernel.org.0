Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901EE4C5E7D
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 21:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiB0UBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 15:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiB0UBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 15:01:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975146C928;
        Sun, 27 Feb 2022 12:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zvPoRbRGflwvccoJinhcgsceuV9u+xvDry8XOoJJfKc=; b=2ZUtfPAzFvlPZRS2dm1pkOFcnh
        Dkob8eUyA6jVfz5zhPfV6lkWm7+VqdDqmjToVUON+9r2BO4MoJqNkUGUBo7c8TlOsbUBJb/BT2AP+
        huUy5BNgX8oIM+hBhmlX/b1rRRh2m9nFVsJsvUpxdlhj7UX/GtvA+Fh+t/xJWbGVnDjcPsUEkx8nV
        A8LOZoQUlzMH34GWSt5f9CkLGrlzdpNKKyzz29sFDNiKMC7m2KxVPtGFDh4FmGDUQup/lvmoev13m
        8tGBdrHuCHKDeceBqvbcTeZMcWxgI4mym8bn87JQn7jsWkwqTsPokowq/e5n0bZ5H19WXyeRUxlrj
        fTJtxpdQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOPiu-00A3iE-2D; Sun, 27 Feb 2022 20:00:52 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] net: iwlwifi: fix build error for IWLMEI
Date:   Sun, 27 Feb 2022 12:00:51 -0800
Message-Id: <20220227200051.7176-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_IWLWIFI=m and CONFIG_IWLMEI=y, the kernel build system
must be told to build the iwlwifi/ subdirectory for both IWLWIFI and
IWLMEI so that builds for both =y and =m are done.

This resolves an undefined reference build error:

ERROR: modpost: "iwl_mei_is_connected" [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!

Fixes: 977df8bd5844 ("wlwifi: work around reverse dependency on MEI")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/intel/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20220225.orig/drivers/net/wireless/intel/Makefile
+++ linux-next-20220225/drivers/net/wireless/intel/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
 obj-$(CONFIG_IWLEGACY)	+= iwlegacy/
 
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
+obj-$(CONFIG_IWLMEI)	+= iwlwifi/
