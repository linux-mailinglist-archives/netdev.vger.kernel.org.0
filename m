Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7F306D79
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhA1GL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:11:29 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:52571 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231317AbhA1GL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:11:28 -0500
X-UUID: b750d5c8d9ce4689b0573bbc227ffbec-20210128
X-UUID: b750d5c8d9ce4689b0573bbc227ffbec-20210128
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 523626734; Thu, 28 Jan 2021 14:10:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 28 Jan 2021 14:10:39 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 14:10:39 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next 2/2] net: ipv6: don't generate link local address on PUREIP device
Date:   Thu, 28 Jan 2021 13:58:09 +0800
Message-ID: <20210128055809.31199-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7B2B7C4553CCBA3F7B9FFADABE25EC8F855F847BDA9C4A9AB060FB4FE6B5835C2000:8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PUREIP device such as ccmni does not need kernel to generate
link-local address in any addr_gen_mode, generally, it shall
use the IPv6 Interface Identifier, as provided by the GGSN,
to create its IPv6 link-ocal Unicast Address.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 net/ipv6/addrconf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9edc5bb2d531..5e8134d3e704 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3337,7 +3337,8 @@ static void addrconf_dev_config(struct net_device *dev)
 	    (dev->type != ARPHRD_IPGRE) &&
 	    (dev->type != ARPHRD_TUNNEL) &&
 	    (dev->type != ARPHRD_NONE) &&
-	    (dev->type != ARPHRD_RAWIP)) {
+	    (dev->type != ARPHRD_RAWIP) &&
+	    (dev->type != ARPHRD_PUREIP)) {
 		/* Alas, we support only Ethernet autoconfiguration. */
 		idev = __in6_dev_get(dev);
 		if (!IS_ERR_OR_NULL(idev) && dev->flags & IFF_UP &&
@@ -3350,6 +3351,12 @@ static void addrconf_dev_config(struct net_device *dev)
 	if (IS_ERR(idev))
 		return;
 
+	/* this device type doesn't need to generate
+	 * link-local address in any addr_gen_mode
+	 */
+	if (dev->type == ARPHRD_PUREIP)
+		return;
+
 	/* this device type has no EUI support */
 	if (dev->type == ARPHRD_NONE &&
 	    idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_EUI64)
-- 
2.18.0

