Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422C3447EA4
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbhKHLRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237770AbhKHLQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 06:16:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BCE16101C;
        Mon,  8 Nov 2021 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636370008;
        bh=S0fwIeFYVC5FAJOEOUbu7HhdPx9jgmW9+TrZK0SHTPg=;
        h=From:To:Cc:Subject:Date:From;
        b=cpwdwxvusDt525tx4Wdlg4L0DzCyxDhfv6TqLY4bDTQYCzz4NKrjY9psjdqkeEjcG
         h1aobjyUiiG3+Afqvxp2dQT+RbOZPZKa6te2BQkFXaIVU6ebqHZqLjASmvaKBrwcD1
         deSOQ/WqcwpKaGclXOXwND8l/KJhagwPFKMee3wpCS9aD+zdNDmHqK8lX1ILTgnVbd
         oDx+ecww/MIRVsbKVVTmxlhPnlZGy1+kqXAjvlykWsvnEQw7qYchFqjt9ZhhWb5xs/
         Rzz5xhZ+yIZdqfE1R/HiJ/2Heza9D9ZGfiij7JYI+FqhLbQsE0EP4fHlEFiH/Att8/
         QsETXbSxQJISA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] amt: add IPV6 Kconfig dependency
Date:   Mon,  8 Nov 2021 12:12:24 +0100
Message-Id: <20211108111322.3852690-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver cannot be built-in if IPV6 is a loadable module:

x86_64-linux-ld: drivers/net/amt.o: in function `amt_build_mld_gq':
amt.c:(.text+0x2e7d): undefined reference to `ipv6_dev_get_saddr'

Add the idiomatic Kconfig dependency that all such modules
have.

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 034dbd487c33..10506a4b66ef 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -294,6 +294,7 @@ config GTP
 config AMT
 	tristate "Automatic Multicast Tunneling (AMT)"
 	depends on INET && IP_MULTICAST
+	depends on IPV6 || !IPV6
 	select NET_UDP_TUNNEL
 	help
 	  This allows one to create AMT(Automatic Multicast Tunneling)
-- 
2.29.2

