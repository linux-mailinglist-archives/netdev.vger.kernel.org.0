Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45316C86F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 06:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfGRE1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 00:27:01 -0400
Received: from relay.sw.ru ([185.231.240.75]:45266 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfGRE1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 00:27:00 -0400
Received: from [172.16.24.21]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <vvs@virtuozzo.com>)
        id 1hny0P-0004TI-85; Thu, 18 Jul 2019 07:26:57 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] connector: remove redundant input callback from cn_dev
To:     linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Cc:     stanislav.kinsburskiy@gmail.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <1f53c1fb-c42e-fb78-7b2b-ad6c4712fe72@virtuozzo.com>
Date:   Thu, 18 Jul 2019 07:26:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A small cleanup: this callback is never used.
Originally fixed by Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
for OpenVZ7 bug OVZ-6877

cc: stanislav.kinsburskiy@gmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/connector/connector.c | 6 +-----
 include/linux/connector.h     | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 23553ed6b548..2d22d6bf52f2 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -248,16 +248,12 @@ static int __maybe_unused cn_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct cn_dev cdev = {
-	.input   = cn_rx_skb,
-};
-
 static int cn_init(void)
 {
 	struct cn_dev *dev = &cdev;
 	struct netlink_kernel_cfg cfg = {
 		.groups	= CN_NETLINK_USERS + 0xf,
-		.input	= dev->input,
+		.input	= cn_rx_skb,
 	};
 
 	dev->nls = netlink_kernel_create(&init_net, NETLINK_CONNECTOR, &cfg);
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 1d72ef76f24f..bc18f04e8b46 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -50,7 +50,6 @@ struct cn_dev {
 
 	u32 seq, groups;
 	struct sock *nls;
-	void (*input) (struct sk_buff *skb);
 
 	struct cn_queue_dev *cbdev;
 };
-- 
2.17.1

