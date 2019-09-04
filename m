Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D9DA8A46
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbfIDP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfIDP6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00623233FF;
        Wed,  4 Sep 2019 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612729;
        bh=fb/h9KR3pLXlfXJogUmAfXxs7PKwlfI//BnBLXHS7Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh7KWDeaHuaZgRyOqYsbMYM2+cGUB8zIA/5ZlzkBlvmF3VKjYFX89DYoVVg2PX3GI
         ypFXym4AXnLoHQ/3CvGl0WqSgmVvqECpje1J22FQEy+VsAI+uSiPovpepslqO0CB6G
         lGXVqtcQkIYtyZhq+yMebq7vxcImV//Y+gS4DAIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 46/94] SUNRPC: Handle connection breakages correctly in call_status()
Date:   Wed,  4 Sep 2019 11:56:51 -0400
Message-Id: <20190904155739.2816-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c82e5472c9980e0e483f4b689044150eefaca408 ]

If the connection breaks while we're waiting for a reply from the
server, then we want to immediately try to reconnect.

Fixes: ec6017d90359 ("SUNRPC fix regression in umount of a secure mount")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 3f090a75f3721..49adae7cf4c2d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2292,7 +2292,7 @@ call_status(struct rpc_task *task)
 	case -ECONNABORTED:
 	case -ENOTCONN:
 		rpc_force_rebind(clnt);
-		/* fall through */
+		break;
 	case -EADDRINUSE:
 		rpc_delay(task, 3*HZ);
 		/* fall through */
-- 
2.20.1

