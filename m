Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2B578A9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF0Aav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfF0Aav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:51 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 179F1217D7;
        Thu, 27 Jun 2019 00:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595449;
        bh=oLXxZ23PxMtr4AgajN54CECw/vg69hq/wtmyTzA3Ceg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSzfe2pZGD460EvkQ5deswGpqufFdpC6QNeBJYc55Kt8SbFK4tygbow6/AQvr9T2o
         UMs2xZ8YHL8VKhsMoAEkMFczBosxOAqpnaibpgvzj0NYbAJNGzWh4IF9HiHRG+RlZW
         YNCFmM1yDDqLVFpIB+9lNLD74SYV0KMWxPNf9Bwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 08/95] bpf: fix out-of-bounds read in __bpf_skc_lookup
Date:   Wed, 26 Jun 2019 20:28:53 -0400
Message-Id: <20190627003021.19867-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 9b28ae243ef3b13d8a88b5451d025475c75ebdef ]

__bpf_skc_lookup takes a socket tuple and the length of the
tuple as an argument. Based on the length, it decides which
address family to pass to the helper function sk_lookup.

In case of AF_INET6, it fails to verify that the length
of the tuple is long enough. sk_lookup may therefore access
data past the end of the tuple.

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 27e61ffd9039..85f9e960588b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5173,7 +5173,13 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	struct net *net;
 	int sdif;
 
-	family = len == sizeof(tuple->ipv4) ? AF_INET : AF_INET6;
+	if (len == sizeof(tuple->ipv4))
+		family = AF_INET;
+	else if (len == sizeof(tuple->ipv6))
+		family = AF_INET6;
+	else
+		return NULL;
+
 	if (unlikely(family == AF_UNSPEC || flags ||
 		     !((s32)netns_id < 0 || netns_id <= S32_MAX)))
 		goto out;
-- 
2.20.1

