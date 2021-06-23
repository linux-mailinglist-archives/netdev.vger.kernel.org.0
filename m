Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5493B194D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFWLwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:52:20 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56529 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230019AbhFWLwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:52:18 -0400
X-UUID: e5c50f87811e4ff8902f0e9b34026b36-20210623
X-UUID: e5c50f87811e4ff8902f0e9b34026b36-20210623
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1980747268; Wed, 23 Jun 2021 19:49:55 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 19:49:54 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 19:49:53 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
CC:     <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <zhuoliang.zhang@mediatek.com>, <kuohong.wang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH 3/4] net: dev_is_mac_header_xmit() return false for ARPHRD_PUREIP
Date:   Wed, 23 Jun 2021 19:34:51 +0800
Message-ID: <20210623113452.5671-3-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210623113452.5671-1-rocco.yue@mediatek.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the incoming/outgoing packets on that pure ip interface do
not have an ethernet header. So adding ARPHRD_PUREIP to the
dev_is_mac_header_xmit() make the function return false, and
__bpf_redirect() checks this boolean to determine whether to
prefix an ethernet header.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/linux/if_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index bf5c5f32c65e..0dc7af11c463 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -51,6 +51,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
+	case ARPHRD_PUREIP:
 		return false;
 	default:
 		return true;
-- 
2.18.0

