Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C800B8C972
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfHNCLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfHNCLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206D120874;
        Wed, 14 Aug 2019 02:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748696;
        bh=KJC1zLryXGyifwxyw7PIR5MBD6APX3t7YJiS0gvm7dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC+BnhVAiyRPUTWvtOF0rCgv43sESEsPYNTEE0ZpmrsZyRpNR5/6fnh0Oy3Iq/pwn
         PnYYYKaBvJ860brkQ88U/n+Zt7PVuplqY6Sg7/0Kb50DfWlju0jCoZvuqFqMgUHIdv
         oNrd7LK5DJV5GaUs7O96L8e28QfTIvuoqBam5WGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 027/123] bpf: sockmap, only create entry if ulp is not already enabled
Date:   Tue, 13 Aug 2019 22:09:11 -0400
Message-Id: <20190814021047.14828-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 0e858739c2d2eedeeac1d35bfa0ec3cc2a7190d8 ]

Sockmap does not currently support adding sockets after TLS has been
enabled. There never was a real use case for this so it was never
added. But, we lost the test for ULP at some point so add it here
and fail the socket insert if TLS is enabled. Future work could
make sockmap support this use case but fixup the bug here.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index bbc91597d8364..8a4a45e7c29df 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -339,6 +339,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_psock_link *link;
 	struct sk_psock *psock;
 	struct sock *osk;
@@ -349,6 +350,8 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 		return -EINVAL;
 	if (unlikely(idx >= map->max_entries))
 		return -E2BIG;
+	if (unlikely(icsk->icsk_ulp_data))
+		return -EINVAL;
 
 	link = sk_psock_init_link();
 	if (!link)
-- 
2.20.1

