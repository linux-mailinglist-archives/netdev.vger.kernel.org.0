Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F038E5B43
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfJZNVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfJZNVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C354214DA;
        Sat, 26 Oct 2019 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096104;
        bh=UVw5wCMe8nlRqLQdA7M/iefUaS6HfUfveFEn+roFtug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sc6dTbvav1XgHigGi7VbJouI3T2N0KI2v2EDowTv8ZhV7bMWsAkY+OyH+kbzZ8xJm
         uFV1jyhN6alye58TofDCpWYEkwVslplT84fOcEk2uQ0Kg768SEbDK5CNmHTtsa5gFV
         35afzTxpvc74ObXunsRf/8wxr5HgeFBipboRgiDA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/33] net: avoid possible false sharing in sk_leave_memory_pressure()
Date:   Sat, 26 Oct 2019 09:20:55 -0400
Message-Id: <20191026132110.4026-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 503978aca46124cd714703e180b9c8292ba50ba7 ]

As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
a C compiler can legally transform :

if (memory_pressure && *memory_pressure)
        *memory_pressure = 0;

to :

if (memory_pressure)
        *memory_pressure = 0;

Fixes: 0604475119de ("tcp: add TCPMemoryPressuresChrono counter")
Fixes: 180d8cd942ce ("foundations of per-cgroup memory pressure controlling.")
Fixes: 3ab224be6d69 ("[NET] CORE: Introducing new memory accounting interface.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5f466db916ee8..0ae37781848bd 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2165,8 +2165,8 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-		if (memory_pressure && *memory_pressure)
-			*memory_pressure = 0;
+		if (memory_pressure && READ_ONCE(*memory_pressure))
+			WRITE_ONCE(*memory_pressure, 0);
 	}
 }
 
-- 
2.20.1

