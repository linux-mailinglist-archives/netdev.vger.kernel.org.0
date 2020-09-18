Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9049B26F3FD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgIRDKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgIRCCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8F323772;
        Fri, 18 Sep 2020 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394568;
        bh=Z4tig6aruIz6mfjORxDavK1YfVzLhAsu1xNUQFQhaos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQH6Hjd/3KQKHuyXxvxn47Gp8dX9rbCdepLKlQ2Pax02+ifyWHrCOa0b0gyZvn5+e
         /jA6paJMAC+hzVOt5BgN7hVtdaktQ4TxamiFEPTXhyVcdBm1vlbuWifrzoAaLhHumR
         jahsdbsUOAYJrUBI9cRPoSgzK4WzUM9vKJsIu8ZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 080/330] neigh_stat_seq_next() should increase position index
Date:   Thu, 17 Sep 2020 21:57:00 -0400
Message-Id: <20200918020110.2063155-80-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 1e3f9f073c47bee7c23e77316b07bc12338c5bba ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 7b40d12f0c229..04953e5f25302 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3290,6 +3290,7 @@ static void *neigh_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return per_cpu_ptr(tbl->stats, cpu);
 	}
+	(*pos)++;
 	return NULL;
 }
 
-- 
2.25.1

