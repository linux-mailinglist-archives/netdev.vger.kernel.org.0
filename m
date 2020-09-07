Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A10A2601AC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgIGRLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgIGQcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F526207DE;
        Mon,  7 Sep 2020 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496360;
        bh=gUUgEPZqAoLipWidzmgdXudjOM+qFVqVAfA4HqFwDbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Gvrs9sH5tjpwrkuaiQoPS4Q3OxdEj2h/MHANLrRHkPtDW90uRFjnlrBdHl55976W
         RcPuoP7B7yB1Gn1H38ST5rIz0F6VxGmA4VlB7MDRCbmrF41lzIWZcZuB6nGeijLW4p
         az+3g357MgizT7YFBGRZPvJdPXEkohUJLKaG1mZs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yi Li <yili@winhong.com>, Li Bing <libing@winhong.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 15/53] net: hns3: Fix for geneve tx checksum bug
Date:   Mon,  7 Sep 2020 12:31:41 -0400
Message-Id: <20200907163220.1280412-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Li <yili@winhong.com>

[ Upstream commit a156998fc92d3859c8e820f1583f6d0541d643c3 ]

when skb->encapsulation is 0, skb->ip_summed is CHECKSUM_PARTIAL
and it is udp packet, which has a dest port as the IANA assigned.
the hardware is expected to do the checksum offload, but the
hardware will not do the checksum offload when udp dest port is
6081.

This patch fixes it by doing the checksum in software.

Reported-by: Li Bing <libing@winhong.com>
Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 71ed4c54f6d5d..eaadcc7043349 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -20,6 +20,7 @@
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
+#include <net/geneve.h>
 
 #include "hnae3.h"
 #include "hns3_enet.h"
@@ -780,7 +781,7 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
  * hardware will not do the checksum offload when udp dest port is
- * 4789.
+ * 4789 or 6081.
  */
 static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 {
@@ -789,7 +790,8 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 	l4.hdr = skb_transport_header(skb);
 
 	if (!(!skb->encapsulation &&
-	      l4.udp->dest == htons(IANA_VXLAN_UDP_PORT)))
+	      (l4.udp->dest == htons(IANA_VXLAN_UDP_PORT) ||
+	      l4.udp->dest == htons(GENEVE_UDP_PORT))))
 		return false;
 
 	skb_checksum_help(skb);
-- 
2.25.1

