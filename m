Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438F14585BC
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhKUSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:04:13 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:62802 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbhKUSEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:04:13 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id or9EmhhgNdmYbor9EmGDZk; Sun, 21 Nov 2021 19:01:07 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 21 Nov 2021 19:01:07 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        alexanderduyck@fb.com, pabeni@redhat.com, weiwan@google.com,
        lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net-sysfs: Slightly optimize 'xps_queue_show()'
Date:   Sun, 21 Nov 2021 19:01:03 +0100
Message-Id: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'mask' bitmap is local to this function. So the non-atomic
'__set_bit()' can be used to save a few cycles.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9e..3be3f4a6add3 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1452,7 +1452,7 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
 
 		for (i = map->len; i--;) {
 			if (map->queues[i] == index) {
-				set_bit(j, mask);
+				__set_bit(j, mask);
 				break;
 			}
 		}
-- 
2.30.2

