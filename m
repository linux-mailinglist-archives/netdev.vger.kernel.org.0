Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60958304AA2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbhAZFCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbhAYMoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E1B229EF;
        Mon, 25 Jan 2021 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611574334;
        bh=korZHA4N+5N7x+HxWDYsFG7OLXGozqFeC35pIVA8E1w=;
        h=From:To:Cc:Subject:Date:From;
        b=mgTolqdVu3vPLoH+5GdnRjtJbmkEHvzmgOd5331GrCD25GBB8VGE8Lu30fOVo+A/G
         qtGdhKhrVWvL+qCNV6Jm9UniNoyudf1/Hf4Dqc+HETApfveB+8KtI7jOwBOVh4avTF
         s+1G74+0O8RHnkHCZWm8h2b3m7vT3HUD89LjQd76Z1UScbRI7Mw65Wyi+7tla/YoPj
         3l8BVFE/P+9KEH+XmJ2GIv5W1aY1T7uktwyNPXdRbMvAvybVeznR2YpcmmWfwgVHA5
         dXx/aHnAuAb1tgbQIU3tb371/lDD96K0FcWVUewjXoBjtN8lDq4UXGxHTNrN2olf36
         FdqAsoSg7DXHg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Loic Poulain <loic.poulain@linaro.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] bonding: add TLS dependency
Date:   Mon, 25 Jan 2021 12:31:59 +0100
Message-Id: <20210125113209.2248522-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When TLS is a module, the built-in bonding driver may cause a
link error:

x86_64-linux-ld: drivers/net/bonding/bond_main.o: in function `bond_start_xmit':
bond_main.c:(.text+0xc451): undefined reference to `tls_validate_xmit_skb'

Add a dependency to avoid the problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I could not figure out when this started, it seems to have been
possible for a while.
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 672fcdd9aecb..45d12b0e9a2f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -42,6 +42,7 @@ config BONDING
 	tristate "Bonding driver support"
 	depends on INET
 	depends on IPV6 || IPV6=n
+	depends on TLS || TLS_DEVICE=n
 	help
 	  Say 'Y' or 'M' if you wish to be able to 'bond' multiple Ethernet
 	  Channels together. This is called 'Etherchannel' by Cisco,
-- 
2.29.2

