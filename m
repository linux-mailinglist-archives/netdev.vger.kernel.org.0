Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D911FE5BD
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbgFRC2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbgFRBQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA28F21D80;
        Thu, 18 Jun 2020 01:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442984;
        bh=iRRKd0TbaPUHurhMmZORB6+4Ul6s8eYjZm6WinlAIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0robWIOEe+R+7I7qqA6tmrAwmXX3TMXtoW/R7VF7UAoYAMHZdNPuNRgNpV0R6ZsA
         oovbnSbVUdfyEBu1epXRYWOl9FI1wur/yEboNNmPb/NVzBC8u2G6PN3QR3UIXznBRF
         13yhoi9jdctgKgc58GjQ8QR4BYv4YcxZkk0pDta0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 385/388] bpf: sockmap: Don't attach programs to UDP sockets
Date:   Wed, 17 Jun 2020 21:08:02 -0400
Message-Id: <20200618010805.600873-385-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit f6fede8569689dd31e7b0ed15024b25e5ce2e2e5 ]

The stream parser infrastructure isn't set up to deal with UDP
sockets, so we mustn't try to attach programs to them.

I remember making this change at some point, but I must have lost
it while rebasing or something similar.

Fixes: 7b98cd42b049 ("bpf: sockmap: Add UDP support")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200611172520.327602-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 050bfac97cfb..7e858c1dd711 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -417,10 +417,7 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
 	return 0;
 }
 
-static bool sock_map_redirect_allowed(const struct sock *sk)
-{
-	return sk->sk_state != TCP_LISTEN;
-}
+static bool sock_map_redirect_allowed(const struct sock *sk);
 
 static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
@@ -501,6 +498,11 @@ static bool sk_is_udp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_UDP;
 }
 
+static bool sock_map_redirect_allowed(const struct sock *sk)
+{
+	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+}
+
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
 	return sk_is_tcp(sk) || sk_is_udp(sk);
-- 
2.25.1

