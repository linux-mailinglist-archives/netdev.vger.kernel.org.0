Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7271F3A2C6D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhFJNGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:06:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5494 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhFJNGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:06:47 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G13ys2WGJzZdYm;
        Thu, 10 Jun 2021 21:01:57 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 10
 Jun 2021 21:04:46 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <gustavoars@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] atm: Use list_for_each_entry() to simplify code in resources.c
Date:   Thu, 10 Jun 2021 21:03:55 +0800
Message-ID: <20210610130355.3836817-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert list_for_each() to list_for_each_entry() where
applicable. This simplifies the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/atm/resources.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/atm/resources.c b/net/atm/resources.c
index 53236986dfe0..2b2d33eeaf20 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -52,10 +52,8 @@ static struct atm_dev *__alloc_atm_dev(const char *type)
 static struct atm_dev *__atm_dev_lookup(int number)
 {
 	struct atm_dev *dev;
-	struct list_head *p;
 
-	list_for_each(p, &atm_devs) {
-		dev = list_entry(p, struct atm_dev, dev_list);
+	list_for_each_entry(dev, &atm_devs, dev_list) {
 		if (dev->number == number) {
 			atm_dev_hold(dev);
 			return dev;
@@ -215,8 +213,7 @@ int atm_getnames(void __user *buf, int __user *iobuf_len)
 		return -ENOMEM;
 	}
 	tmp_p = tmp_buf;
-	list_for_each(p, &atm_devs) {
-		dev = list_entry(p, struct atm_dev, dev_list);
+	list_for_each_entry(dev, &atm_devs, dev_list) {
 		*tmp_p++ = dev->number;
 	}
 	mutex_unlock(&atm_dev_mutex);
-- 
2.17.1

