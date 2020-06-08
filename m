Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417831F2650
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgFHXhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732254AbgFHX2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86537208A7;
        Mon,  8 Jun 2020 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658922;
        bh=/YM9Qim2UEDqZy57Oom9XviW8SgEHAn+SAnkAOLb4D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqLIC3G0y8tomj3AsuaAbfurjL+jMcLhOAVTj56NG4mO+kNfEVRTIXLocwKmhDexf
         nxlMRVHcIJJ+yhTD6QFhbxbwF1KkGdq4an+xNdUzNx1SHSEhTRYgkc+PNL7y8/47gX
         PDGeM+Mx9U0Iiz5iq3kZ/dNBxbm+gKP0YT6okN6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 37/37] vxlan: Avoid infinite loop when suppressing NS messages with invalid options
Date:   Mon,  8 Jun 2020 19:27:49 -0400
Message-Id: <20200608232750.3370747-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 8066e6b449e050675df48e7c4b16c29f00507ff0 ]

When proxy mode is enabled the vxlan device might reply to Neighbor
Solicitation (NS) messages on behalf of remote hosts.

In case the NS message includes the "Source link-layer address" option
[1], the vxlan device will use the specified address as the link-layer
destination address in its reply.

To avoid an infinite loop, break out of the options parsing loop when
encountering an option with length zero and disregard the NS message.

This is consistent with the IPv6 ndisc code and RFC 4886 which states
that "Nodes MUST silently discard an ND packet that contains an option
with length zero" [2].

[1] https://tools.ietf.org/html/rfc4861#section-4.3
[2] https://tools.ietf.org/html/rfc4861#section-4.6

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index d6ae6d3c98ed..c12f2984d7ef 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1476,6 +1476,10 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	daddr = eth_hdr(request)->h_source;
 	ns_olen = request->len - skb_transport_offset(request) - sizeof(*ns);
 	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
+		if (!ns->opt[i + 1]) {
+			kfree_skb(reply);
+			return NULL;
+		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
 			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;
-- 
2.25.1

