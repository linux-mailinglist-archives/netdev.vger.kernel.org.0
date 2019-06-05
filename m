Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4183659B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFEUif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:38:35 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.91]:32495 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFEUif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:38:35 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 38C4F400D187F
        for <netdev@vger.kernel.org>; Wed,  5 Jun 2019 15:38:34 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ycg6hgTnc2PzOYcg6h0omh; Wed, 05 Jun 2019 15:38:34 -0500
X-Authority-Reason: nr=8
Received: from [189.250.127.120] (port=34852 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hYcg0-0040oS-L4; Wed, 05 Jun 2019 15:38:33 -0500
Date:   Wed, 5 Jun 2019 15:38:27 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] nfp: flower: use struct_size() helper
Message-ID: <20190605203827.GA22786@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.127.120
X-Source-L: No
X-Exim-ID: 1hYcg0-0040oS-L4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.127.120]:34852
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct nfp_tun_active_tuns {
	...
        struct route_ip_info {
                __be32 ipv4;
                __be32 egress_port;
                __be32 extra[2];
        } tun_info[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following form:

sizeof(struct nfp_tun_active_tuns) + sizeof(struct route_ip_info) * count

with:

struct_size(payload, tun_info, count)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 8c67505865a4..a7a80f4b722a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -162,8 +162,7 @@ void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb)
 	}
 
 	pay_len = nfp_flower_cmsg_get_data_len(skb);
-	if (pay_len != sizeof(struct nfp_tun_active_tuns) +
-	    sizeof(struct route_ip_info) * count) {
+	if (pay_len != struct_size(payload, tun_info, count)) {
 		nfp_flower_cmsg_warn(app, "Corruption in tunnel keep-alive message.\n");
 		return;
 	}
-- 
2.21.0

