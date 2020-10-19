Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65005292D58
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbgJSSLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgJSSLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 14:11:11 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF194C0613CE;
        Mon, 19 Oct 2020 11:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xiyanDep+kM10bm251knyIvRDseYDKXVsobmd7uBQ64=; b=Wj/6tvk0GUjQsZaURi1lej23zE
        JQzUi5xMTS5dvzUyFmFSNp0CDaLuqHdPYrB9JiHDrlKyLmAVsNHYtTH6NbNW03WD667aovUckVMaT
        4U0aelY4FO4hm7BTEAfcfEpvIc35Jp1xDnzr5cvf/LNoTvVEmKtTIhlbEoOYYW9Vtm3d2W2AP8JwC
        xxw97Hy3PrCSF6fTGG2/4W0cSFueccxe+/49WRIECayRIlmca77JH0iTSbl+7qw9/lIIuQa0Xey04
        ErC6H31dm2cYSWbCv6B6mc2ZXOQ5HPV56r9QYZDnqp1jgpHy40alrWmH7YNk26GJ8EhxzDOo1Lrc1
        ItY9NyZw==;
Received: from [2601:1c0:6280:3f0::507c] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUZce-0000jK-JZ; Mon, 19 Oct 2020 18:11:05 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: chelsio: inline_crypto: fix Kconfig and build errors
Date:   Mon, 19 Oct 2020 11:10:59 -0700
Message-Id: <20201019181059.22634-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors when TLS=m, TLS_TOE=y, and CRYPTO_DEV_CHELSIO_TLS=y.

Having (tristate) CRYPTO_DEV_CHELSIO_TLS depend on (bool) TLS_TOE
is not strong enough to prevent the bad combination of TLS=m and
CRYPTO_DEV_CHELSIO_TLS=y, so add a dependency on TLS to prevent the
problematic kconfig combination.

Fixes these build errors:

hppa-linux-ld: drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.o: in function `chtls_free_uld':
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:165: undefined reference to `tls_toe_unregister_device'
hppa-linux-ld: drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.o: in function `chtls_register_dev':
drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:204: undefined reference to `tls_toe_register_device'

Fixes: 44fd1c1fd821 ("chelsio/chtls: separate chelsio tls driver from crypto driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: netdev@vger.kernel.org
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201016.orig/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
+++ linux-next-20201016/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -16,6 +16,7 @@ if CHELSIO_INLINE_CRYPTO
 config CRYPTO_DEV_CHELSIO_TLS
 	tristate "Chelsio Crypto Inline TLS Driver"
 	depends on CHELSIO_T4
+	depends on TLS
 	depends on TLS_TOE
 	help
 	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
