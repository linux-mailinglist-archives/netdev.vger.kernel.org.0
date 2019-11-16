Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB4FEE01
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfKPPsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbfKPPsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:16 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF7C208CD;
        Sat, 16 Nov 2019 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919295;
        bh=wm40pxxZ59JGzonob8Ges0kmf+882DncGH3d04jzJGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auLby6rtu6B0YPnoeDytv1SFiLHYdeKUFgK3GCoH+C3vxWmBG4lsu8Vf34iVKPKn6
         mbhm2q31aMm/X9En/sUxjYZTICd9nBSo69ZLyuJtjrLdSw4elK+EAv2PySKsN0A7zM
         bao+G2FMP/aoRE3E9ngBq3QXXdvR+3poIk6pvQxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyeongdon Kim <kyeongdon.kim@lge.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 042/150] net: fix warning in af_unix
Date:   Sat, 16 Nov 2019 10:45:40 -0500
Message-Id: <20191116154729.9573-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kyeongdon Kim <kyeongdon.kim@lge.com>

[ Upstream commit 33c4368ee2589c165aebd8d388cbd91e9adb9688 ]

This fixes the "'hash' may be used uninitialized in this function"

net/unix/af_unix.c:1041:20: warning: 'hash' may be used uninitialized in this function [-Wmaybe-uninitialized]
  addr->hash = hash ^ sk->sk_type;

Signed-off-by: Kyeongdon Kim <kyeongdon.kim@lge.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4de9dfd14d09d..99f581a61cfac 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -225,6 +225,8 @@ static inline void unix_release_addr(struct unix_address *addr)
 
 static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
 {
+	*hashp = 0;
+
 	if (len <= sizeof(short) || len > sizeof(*sunaddr))
 		return -EINVAL;
 	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
-- 
2.20.1

