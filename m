Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30186323D6E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhBXNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235654AbhBXNEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:04:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99DF464F6C;
        Wed, 24 Feb 2021 12:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171228;
        bh=QyqmuYoRGSJH8828aZB0dBhCpY8JG6gVzQKplNpetiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEomkJ50qO9E08LlU77F69esTtg7L01P+vJpjR5E03tzetCeKvg9IsIb0IAY58NRP
         C4pvzqRKQ5f4SH2Xdqw+tEwhhqq8PN4XALqv0W23uFcrm5g0/hiMxNZLYJ9WQCO13i
         /fGx2IVc9/uiRYfseXhcLItKc/2Ss+gnzTC5im6pcDHnNpm46cUH3jSkAxbZqnm6lp
         ECXXyPuuGP1s4UnV1kB6SZrHrpMLZpyauoNu5WpI9GkHFePIATIkQaTAcl0/Mf8nWn
         e+BtHBjMIaqMtfGULJ0DkZAenES5fSuctfMx6hTBVcyr55MqtyzrLANrknC4jv0UiD
         Nzj4254Kc9YpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Di Zhu <zhudi21@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/40] pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
Date:   Wed, 24 Feb 2021 07:53:06 -0500
Message-Id: <20210224125340.483162-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

[ Upstream commit 275b1e88cabb34dbcbe99756b67e9939d34a99b6 ]

pktgen create threads for all online cpus and bond these threads to
relevant cpu repecivtily. when this thread firstly be woken up, it
will compare cpu currently running with the cpu specified at the time
of creation and if the two cpus are not equal, BUG_ON() will take effect
causing panic on the system.
Notice that these threads could be migrated to other cpus before start
running because of the cpu hotplug after these threads have created. so the
BUG_ON() used here seems unreasonable and we can replace it with WARN_ON()
to just printf a warning other than panic the system.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
Link: https://lore.kernel.org/r/20210125124229.19334-1-zhudi21@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index cb3b565ff5adc..1d20dd70879bb 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3465,7 +3465,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	BUG_ON(smp_processor_id() != cpu);
+	WARN_ON(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
-- 
2.27.0

