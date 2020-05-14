Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EDD1D25A8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 06:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgENEFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 00:05:18 -0400
Received: from m17616.mail.qiye.163.com ([59.111.176.16]:19822 "EHLO
        m17616.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgENEFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 00:05:18 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2020 00:05:17 EDT
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by m17616.mail.qiye.163.com (Hmail) with ESMTPA id BE95D107CAA;
        Thu, 14 May 2020 11:56:06 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Wang Wenhu <wenhu.wang@vivo.com>
Subject: [PATCH] drivers: ipa: use devm_kzalloc for simplicity
Date:   Wed, 13 May 2020 20:55:20 -0700
Message-Id: <20200514035520.2162-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VNS0pCQkJMTkJNTE9LTFlXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRw6Cww6EzgrQjAJSjc*Hx8T
        FDYKCklVSlVKTkNCT0lDTk1CSkpNVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlMWVdZCAFZQUhITks3Bg++
X-HM-Tid: 0a7211533bcc9374kuwsbe95d107caa
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make a substitution of kzalloc with devm_kzalloc to simplify the
ipa_probe() process.

Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
Cc: Alex Elder <elder@kernel.org>
---
 drivers/net/ipa/ipa_clock.c | 7 ++-----
 drivers/net/ipa/ipa_main.c  | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 374491ea11cf..ddbd687fe64b 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -276,7 +276,7 @@ struct ipa_clock *ipa_clock_init(struct device *dev)
 		goto err_clk_put;
 	}
 
-	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	clock = devm_kzalloc(dev, sizeof(*clock), GFP_KERNEL);
 	if (!clock) {
 		ret = -ENOMEM;
 		goto err_clk_put;
@@ -285,15 +285,13 @@ struct ipa_clock *ipa_clock_init(struct device *dev)
 
 	ret = ipa_interconnect_init(clock, dev);
 	if (ret)
-		goto err_kfree;
+		goto err_clk_put;
 
 	mutex_init(&clock->mutex);
 	atomic_set(&clock->count, 0);
 
 	return clock;
 
-err_kfree:
-	kfree(clock);
 err_clk_put:
 	clk_put(clk);
 
@@ -308,6 +306,5 @@ void ipa_clock_exit(struct ipa_clock *clock)
 	WARN_ON(atomic_read(&clock->count) != 0);
 	mutex_destroy(&clock->mutex);
 	ipa_interconnect_exit(clock);
-	kfree(clock);
 	clk_put(clk);
 }
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 28998dcce3d2..b7b348b863f7 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -760,7 +760,7 @@ static int ipa_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate and initialize the IPA structure */
-	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
+	ipa = devm_kzalloc(dev, sizeof(*ipa), GFP_KERNEL);
 	if (!ipa) {
 		ret = -ENOMEM;
 		goto err_wakeup_source_unregister;
@@ -776,7 +776,7 @@ static int ipa_probe(struct platform_device *pdev)
 
 	ret = ipa_reg_init(ipa);
 	if (ret)
-		goto err_kfree_ipa;
+		goto err_wakeup_source_unregister;
 
 	ret = ipa_mem_init(ipa, data->mem_count, data->mem_data);
 	if (ret)
@@ -848,8 +848,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_mem_exit(ipa);
 err_reg_exit:
 	ipa_reg_exit(ipa);
-err_kfree_ipa:
-	kfree(ipa);
 err_wakeup_source_unregister:
 	wakeup_source_unregister(wakeup_source);
 err_clock_exit:
@@ -885,7 +883,6 @@ static int ipa_remove(struct platform_device *pdev)
 	gsi_exit(&ipa->gsi);
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
-	kfree(ipa);
 	wakeup_source_unregister(wakeup_source);
 	ipa_clock_exit(clock);
 	rproc_put(rproc);
-- 
2.17.1

