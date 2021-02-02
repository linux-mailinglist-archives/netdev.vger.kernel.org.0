Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE41E30C323
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhBBPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235130AbhBBPJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269F964E4C;
        Tue,  2 Feb 2021 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278385;
        bh=ECBiNusZ6x2h9HYHwiSqB6jmDGduRAqvrEGM7641/rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h80po7JxSndRpujdyCB5QUr68jGAYZtd6BUeYSswrZ8/qfkD+sGrUXL/QhQbJuRtz
         bIgEwweELolO18JPyIB5zyuiVMqFER0JcAqF16jZnZ5d0ws8+JmVlaZ7gr8bQFTIvc
         CjBW1GPYEpH194qUo7H7V+Agnry1kkMbetlrKJTf288JegtDBfGNA5uyH0FvxlQeIl
         TC3Qb/wUNPia2IXBPbKL3R3hRdWPM9BxNIk8m0hrtBsAyXN+a1r/glxGYrQXvig2OW
         dLzbGNj1njokV02G7LTPaHtC2Vi996yevrol1U4T6ZJMAbFu4sBHJ8FyK41NSzHS/M
         1sXMh/tkG1vnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/25] chtls: Fix potential resource leak
Date:   Tue,  2 Feb 2021 10:05:57 -0500
Message-Id: <20210202150615.1864175-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit b6011966ac6f402847eb5326beee8da3a80405c7 ]

The dst entry should be released if no neighbour is found. Goto label
free_dst to fix the issue. Besides, the check of ndev against NULL is
redundant.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121145738.51091-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 5beec901713fb..a262c949ed76b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1158,11 +1158,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 #endif
 	}
 	if (!n || !n->dev)
-		goto free_sk;
+		goto free_dst;
 
 	ndev = n->dev;
-	if (!ndev)
-		goto free_dst;
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
@@ -1249,7 +1247,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
-	neigh_release(n);
+	if (n)
+		neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);
-- 
2.27.0

