Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB51FE34A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgFRCH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbgFRBWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE1E1221EF;
        Thu, 18 Jun 2020 01:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443332;
        bh=Qst3gLNK9wrok6P6osrJ4g7xTY41Syzr7EHJ/Cl8yVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WORZfR56P3nzA12RbV9lh0uCfD/mUf71Cu6RF11UzBPMv/Rg412p7AXnLT3YqNoUL
         5pK617GemWL7yBW1IrFnFehPEtENn+N96AoteDBz0m5mWJp4bee58RvqaxoCixql/k
         Zc8EJJAeSSuvpUtkcKZP72K8Lqi+EvScpTUSb1z0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 264/266] xdp: Fix xsk_generic_xmit errno
Date:   Wed, 17 Jun 2020 21:16:29 -0400
Message-Id: <20200618011631.604574-264-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit aa2cad0600ed2ca6a0ab39948d4db1666b6c962b ]

Propagate sock_alloc_send_skb error code, not set it to
EAGAIN unconditionally, when fail to allocate skb, which
might cause that user space unnecessary loops.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/1591852266-24017-1-git-send-email-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7181a30666b4..f9eb5efb237c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -362,10 +362,8 @@ static int xsk_generic_xmit(struct sock *sk)
 
 		len = desc.len;
 		skb = sock_alloc_send_skb(sk, len, 1, &err);
-		if (unlikely(!skb)) {
-			err = -EAGAIN;
+		if (unlikely(!skb))
 			goto out;
-		}
 
 		skb_put(skb, len);
 		addr = desc.addr;
-- 
2.25.1

