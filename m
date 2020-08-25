Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C104251931
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHYNGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:06:52 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:46191 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgHYNGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:06:51 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2020 09:06:50 EDT
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id B4A67445186;
        Tue, 25 Aug 2020 14:59:45 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kAYYD-0005Xw-Gu; Tue, 25 Aug 2020 14:59:45 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Gabriel Ganne <gabriel.ganne@6wind.com>
Subject: [PATCH net] gtp: add GTPA_LINK info to msg sent to userspace
Date:   Tue, 25 Aug 2020 14:59:40 +0200
Message-Id: <20200825125940.21238-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During a dump, this attribute is essential, it enables the userspace to
know on which interface the context is linked to.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
---

I target this to net, because I think this is a bug fix. The dump result cannot
be used if there is more than one gtp interface on the system.

 drivers/net/gtp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 21640a035d7d..8e47d0112e5d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1179,6 +1179,7 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 		goto nlmsg_failure;
 
 	if (nla_put_u32(skb, GTPA_VERSION, pctx->gtp_version) ||
+	    nla_put_u32(skb, GTPA_LINK, pctx->dev->ifindex) ||
 	    nla_put_be32(skb, GTPA_PEER_ADDRESS, pctx->peer_addr_ip4.s_addr) ||
 	    nla_put_be32(skb, GTPA_MS_ADDRESS, pctx->ms_addr_ip4.s_addr))
 		goto nla_put_failure;
-- 
2.26.2

