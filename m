Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8622998E8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389515AbgJZVe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389407AbgJZVeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:34:25 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABA92207C4;
        Mon, 26 Oct 2020 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748065;
        bh=nxOKKlKqMU4NDYkRtekhmwGMQw4/QJdTu+0OdBe0WDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxqbmCRIF+lLlTKSGb59T+3H/HmmR5SxAgB4Zivqnprwxke/yqr6jU5OpwPiPTpyE
         AVjYwd32xXkfHh3tLYnKMcvGEDQ8yVnoxKNQL041KXg1Zk51BpD0cJaUQ1RDr143Vu
         t3BIaPRSPSg/BvFGHAYwnJ5MABs99c9msl/xBrag=
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuval Shaia <yuval.shaia@oracle.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Xin Long <lucien.xin@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Sven Eckelmann <sven@narfation.org>,
        Fernando Gont <fgont@si6networks.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/11] ipv6: fix type mismatch warning
Date:   Mon, 26 Oct 2020 22:29:58 +0100
Message-Id: <20201026213040.3889546-11-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building with 'make W=2' shows a warning for every time this header
gets included because of a pointer type mismatch:

net/addrconf.h:163:32: warning: passing 'unsigned char *' to parameter of type 'const char *' converts between pointers to integer
types with different sign [-Wpointer-sign]
        addrconf_addr_eui48_base(eui, dev->dev_addr);

Change the type to unsigned according to the input argument.

Fixes: 4d6f28591fe4 ("{net,IB}/{rxe,usnic}: Utilize generic mac to eui32 function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/net/addrconf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 18f783dcd55f..074ce761e482 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -127,7 +127,8 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 u32 addr_flags, bool sllao, bool tokenized,
 				 __u32 valid_lft, u32 prefered_lft);
 
-static inline void addrconf_addr_eui48_base(u8 *eui, const char *const addr)
+static inline void addrconf_addr_eui48_base(u8 *eui,
+					    const unsigned char *const addr)
 {
 	memcpy(eui, addr, 3);
 	eui[3] = 0xFF;
@@ -135,7 +136,7 @@ static inline void addrconf_addr_eui48_base(u8 *eui, const char *const addr)
 	memcpy(eui + 5, addr + 3, 3);
 }
 
-static inline void addrconf_addr_eui48(u8 *eui, const char *const addr)
+static inline void addrconf_addr_eui48(u8 *eui, const unsigned char *const addr)
 {
 	addrconf_addr_eui48_base(eui, addr);
 	eui[0] ^= 2;
-- 
2.27.0

