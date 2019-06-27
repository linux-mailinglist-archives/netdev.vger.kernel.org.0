Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D286E575FA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfF0AeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfF0AeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:17 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FDEC20659;
        Thu, 27 Jun 2019 00:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595656;
        bh=44ZAF6N41qyRK/XVrqDdbf3Eoul7V12Zgw1Bu3RsjXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6qbN1k71hRDOdAdzT9LwjGlJwADlO2w6skEFx1Qx9gvs8DfNxccVlDYIvTxfAwII
         m+KAqHJC8lgZpcuJG2JBTCiasYu9cp0CVgSp4BV8/PYtihVQsEO+vVKqyBKyy1ffhy
         iPGI9NV7j306vm7pseK5pAbfjKqwKdiL8VojlZkg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 69/95] bpf, devmap: Add missing bulk queue free
Date:   Wed, 26 Jun 2019 20:29:54 -0400
Message-Id: <20190627003021.19867-69-sashal@kernel.org>
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

From: Toshiaki Makita <toshiaki.makita1@gmail.com>

[ Upstream commit edabf4d9dd905acd60048ea1579943801e3a4876 ]

dev_map_free() forgot to free bulk queue when freeing its entries.

Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index e001fb1a96b1..a126d95d12de 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -186,6 +186,7 @@ static void dev_map_free(struct bpf_map *map)
 		if (!dev)
 			continue;
 
+		free_percpu(dev->bulkq);
 		dev_put(dev->dev);
 		kfree(dev);
 	}
-- 
2.20.1

