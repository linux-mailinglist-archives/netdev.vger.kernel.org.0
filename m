Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9E1E8D75
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 05:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgE3DLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 23:11:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728297AbgE3DLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 23:11:33 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 091513C3815A198CC33A;
        Sat, 30 May 2020 11:11:30 +0800 (CST)
Received: from huawei.com (10.175.101.78) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sat, 30 May 2020
 11:11:23 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <yangyingliang@huawei.com>
Subject: [PATCH net] devinet: fix memleak in inetdev_init()
Date:   Sat, 30 May 2020 11:34:33 +0800
Message-ID: <1590809673-105923-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devinet_sysctl_register() failed, the memory allocated
in neigh_parms_alloc() should be freed.

Fixes: 20e61da7ffcf ("ipv4: fail early when creating netdev named all or default")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/ipv4/devinet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c0dd561..5267b6b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -276,6 +276,7 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	err = devinet_sysctl_register(in_dev);
 	if (err) {
 		in_dev->dead = 1;
+		neigh_parms_release(&arp_tbl, in_dev->arp_parms);
 		in_dev_put(in_dev);
 		in_dev = NULL;
 		goto out;
-- 
1.8.3

