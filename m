Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4587B13E48A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbgAPRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389569AbgAPRJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D4721D56;
        Thu, 16 Jan 2020 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194542;
        bh=ERbZnnckjoO77vO73RH0wTiMFqHmx+d6BdLKkRwjTjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ufdhwrm8BpRiF58538aGCa5k2kZTH6WBmkIOeKYf2wO9n4WwUhsh0PLAF5n6rNhhq
         f0OMF+xoAdI0p+s2RBN5KjOkUpcPw+lndVRwbQ8qGMBxOJZGdjpbLZBizLQdxJkPgs
         scYSo9Q5W7DcyP915DSZC4DzG7FjB7Ub4HC7sMWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 428/671] net/sched: cbs: Fix error path of cbs_module_init
Date:   Thu, 16 Jan 2020 12:01:06 -0500
Message-Id: <20200116170509.12787-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 45d5cb137c3638b3a310f41b31d8e79daf647f14 ]

If register_qdisc fails, we should unregister
netdevice notifier.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 81f84cb5dd23..b3c8d04929df 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -552,12 +552,17 @@ static struct notifier_block cbs_device_notifier = {
 
 static int __init cbs_module_init(void)
 {
-	int err = register_netdevice_notifier(&cbs_device_notifier);
+	int err;
 
+	err = register_netdevice_notifier(&cbs_device_notifier);
 	if (err)
 		return err;
 
-	return register_qdisc(&cbs_qdisc_ops);
+	err = register_qdisc(&cbs_qdisc_ops);
+	if (err)
+		unregister_netdevice_notifier(&cbs_device_notifier);
+
+	return err;
 }
 
 static void __exit cbs_module_exit(void)
-- 
2.20.1

