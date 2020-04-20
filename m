Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674641B19FB
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDTXN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgDTXNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:55 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F027B22209;
        Mon, 20 Apr 2020 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587424435;
        bh=5Zi8x0JeurjhIcP7IV2nyMkTa9RGGpTHwyKcRvFzluY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhJtYA/ySMP7uK1r4Z3JEMiTveJo5vqkHwlyAlYNH1+UGbK09aounUHnHQE5vSh9C
         y2Z4VAtlg2Cdk+OcdwYq+3EA80wL96WW2ArAiKLRT4XkXuaHkJ47S73Hwx8tY8ww7Y
         FX9FhwbSpK+MkP6yW4bzBOqgRmyhAgtzfabKhhVA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, trev@larock.ca,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 2/2] vrf: Check skb for XFRM_TRANSFORMED flag
Date:   Mon, 20 Apr 2020 17:13:52 -0600
Message-Id: <20200420231352.50855-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200420231352.50855-1-dsahern@kernel.org>
References: <20200420231352.50855-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

To avoid a loop with qdiscs and xfrms, check if the skb has already gone
through the qdisc attached to the VRF device and then to the xfrm layer.
If so, no need for a second redirect.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Reported-by: Trev Larock <trev@larock.ca>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/vrf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 66e00ddc0d42..6f5d03b7d9c0 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -474,7 +474,8 @@ static struct sk_buff *vrf_ip6_out(struct net_device *vrf_dev,
 	if (rt6_need_strict(&ipv6_hdr(skb)->daddr))
 		return skb;
 
-	if (qdisc_tx_is_default(vrf_dev))
+	if (qdisc_tx_is_default(vrf_dev) ||
+	    IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
 		return vrf_ip6_out_direct(vrf_dev, sk, skb);
 
 	return vrf_ip6_out_redirect(vrf_dev, skb);
@@ -686,7 +687,8 @@ static struct sk_buff *vrf_ip_out(struct net_device *vrf_dev,
 	    ipv4_is_lbcast(ip_hdr(skb)->daddr))
 		return skb;
 
-	if (qdisc_tx_is_default(vrf_dev))
+	if (qdisc_tx_is_default(vrf_dev) ||
+	    IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
 		return vrf_ip_out_direct(vrf_dev, sk, skb);
 
 	return vrf_ip_out_redirect(vrf_dev, skb);
-- 
2.20.1

