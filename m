Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3051639A8C3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhFCRRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233631AbhFCRQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5FA6142F;
        Thu,  3 Jun 2021 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740276;
        bh=7FHT3txLUIWcHfvYeQqQl2mN7/I0q/3rhcPmbCXrO+8=;
        h=From:To:Cc:Subject:Date:From;
        b=tcHIZOKWGFM3LRhQ9D3eNa2x+DRvPywuOQ+AoUeGhaiX7BYM4kjywlJvZM8xNNoRH
         RxlfnFaztM/rlaiwX+fQtk9r9v6uEXsgjNCkKOjhHE+sJKJGzh8P7XarVMIARGL0Fa
         hwSHCam3yl/IvNxj6tphgCkM8LCXtJ3R16S6pdqxQ1CwZC4yTrRrqvawuSYeH66Oze
         go7xzy5sPXk5PpfX2hoadYLHOXQVohqQWUg06kehV4q0qvbSYL9jnO6kOgcNwY+iMY
         5RrNdJ6X2/3haHH2xgcSG4Z048hpGU3E27+arTXQ88LKLIV7y5rHyEDYSIzESJPV9D
         9vwwYe0HxHgUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/15] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:11:00 -0400
Message-Id: <20210603171114.3170086-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeimon <jjjinmeng.zhou@gmail.com>

[ Upstream commit 8ab78863e9eff11910e1ac8bcf478060c29b379e ]

The function rawsock_create() calls a privileged function sk_alloc(), which requires a ns-aware check to check net->user_ns, i.e., ns_capable(). However, the original code checks the init_user_ns using capable(). So we replace the capable() with ns_capable().

Signed-off-by: Jeimon <jjjinmeng.zhou@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 92a3cfae4de8..2fba626a0125 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -345,7 +345,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2

