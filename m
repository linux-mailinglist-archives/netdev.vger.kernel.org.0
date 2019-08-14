Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851538C976
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfHNCLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfHNCLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04064216F4;
        Wed, 14 Aug 2019 02:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748695;
        bh=9zDbpXrPwc3N3ew0Hf5XdLobrVPXyTxAnXCNgfMII4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gnlpni8M+xCyxdPovOFiGTFx4BZBfMWbgXwea3h+ztWqlryhS0wysdybhzitm2TB7
         gy2dcBCU0fBnFi5v0LhV4gv/jl1/ylA1fLgoQzK96BFifkctv5Ni6ddsw03fNNOZ2L
         BD2TyaJjwiZ7mqhOFZP7EVitU5Uc3sscujm3o4BM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 026/123] bpf: sockmap, synchronize_rcu before free'ing map
Date:   Tue, 13 Aug 2019 22:09:10 -0400
Message-Id: <20190814021047.14828-26-sashal@kernel.org>
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

[ Upstream commit 2bb90e5cc90e1d09f631aeab041a9cf913a5bbe5 ]

We need to have a synchronize_rcu before free'ing the sockmap because
any outstanding psock references will have a pointer to the map and
when they use this could trigger a use after free.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 1d40e040320d2..bbc91597d8364 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -252,6 +252,8 @@ static void sock_map_free(struct bpf_map *map)
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
 
+	synchronize_rcu();
+
 	bpf_map_area_free(stab->sks);
 	kfree(stab);
 }
-- 
2.20.1

