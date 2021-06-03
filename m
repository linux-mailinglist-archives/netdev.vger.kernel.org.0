Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DA39A83A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhFCROW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232988AbhFCRNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F776142C;
        Thu,  3 Jun 2021 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740232;
        bh=sYYFiaSa6jR7mtASzMjv1fOrQuqDdaSGCKubgqmYfKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZ8mqEJQyH1qjxyekDmvBnPYJinRB1rF/K1mcOuYE8mjYAsUz5KwHvSFiRvfMaGgA
         6DUpNdJ+RxtzYmoTdC+V6Ed5XDanRP6avzyZZ9E5aYwHOst1PmrkOdZWN2LoDgKsKD
         nE7GFHg3Wy7sDfnHQbTmAKUZ5oY4RN+E/Yi0GO9bMP2m1U3VluLaLpirdgE/gKwPNf
         14iXXAyUOamk3KKy46apxKhuHnuGy2dzjugHSS50fCIWGpKoGTWoiMoQs38VyztGhF
         m/mR//+9z1z9akrYUoj6DTajb0y51LVrD/VyS7fqdzE+UFchJPFy/xhoD6OuxxV9X4
         Gqi9pfA+Pf6sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/18] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:10:13 -0400
Message-Id: <20210603171029.3169669-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171029.3169669-1-sashal@kernel.org>
References: <20210603171029.3169669-1-sashal@kernel.org>
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
index 57a07ab80d92..bdc72737fe24 100644
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

