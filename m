Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7BE5D11
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfJZNe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfJZNR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B37721D80;
        Sat, 26 Oct 2019 13:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095847;
        bh=joTHe+yaRF3GKLhIBUmQA67eXqEKKEarIqHC+MsJ/94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2I+H/5RW9WNNaJvRGjrYEQDB7xda4DA8etSQfuKGFJqz7tOBnsH7T4XkaxfDdah38
         9XXpX0Tv8vUXdSD+VSLnbNKmGNN79YRUtfwSpBGcxKJ38o7Fz+9JMZqYlb/fl/D7cp
         xxwkmhgGUgm7rhWrhhXKeyS2Dpk7VGDdciYKb+0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 46/99] act_mirred: Fix mirred_init_module error handling
Date:   Sat, 26 Oct 2019 09:15:07 -0400
Message-Id: <20191026131600.2507-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 11c9a7d38af524217efb7a176ad322b97ac2f163 ]

If tcf_register_action failed, mirred_device_notifier
should be unregistered.

Fixes: 3b87956ea645 ("net sched: fix race in mirred device removal")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 9d1bf508075a8..11b826f1f5397 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -479,7 +479,11 @@ static int __init mirred_init_module(void)
 		return err;
 
 	pr_info("Mirror/redirect action on\n");
-	return tcf_register_action(&act_mirred_ops, &mirred_net_ops);
+	err = tcf_register_action(&act_mirred_ops, &mirred_net_ops);
+	if (err)
+		unregister_netdevice_notifier(&mirred_device_notifier);
+
+	return err;
 }
 
 static void __exit mirred_cleanup_module(void)
-- 
2.20.1

