Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2C13D52C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 08:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgAPHoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 02:44:19 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33046 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbgAPHoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 02:44:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1irzpA-0003GY-6p; Thu, 16 Jan 2020 08:44:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nft_tunnel: fix null-attribute check
Date:   Thu, 16 Jan 2020 08:44:11 +0100
Message-Id: <20200116074411.19511-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000b62bda059c36db7c@google.com>
References: <000000000000b62bda059c36db7c@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

else we get null deref when one of the attributes is missing, both
must be non-null.

Reported-by: syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Fixes: aaecfdb5c5dd8ba ("netfilter: nf_tables: match on tunnel metadata")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae605a8..d89c7c553030 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -76,7 +76,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 	struct nft_tunnel *priv = nft_expr_priv(expr);
 	u32 len;
 
-	if (!tb[NFTA_TUNNEL_KEY] &&
+	if (!tb[NFTA_TUNNEL_KEY] ||
 	    !tb[NFTA_TUNNEL_DREG])
 		return -EINVAL;
 
-- 
2.24.1

