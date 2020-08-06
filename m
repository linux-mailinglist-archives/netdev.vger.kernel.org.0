Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790FF23E2CC
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 22:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHFUDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 16:03:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725272AbgHFUDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 16:03:46 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 10DED993A89FDCE84213;
        Thu,  6 Aug 2020 19:50:54 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 6 Aug 2020
 19:50:45 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <viro@zeniv.linux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH 3/5] net: Set fput_needed iff FDPUT_FPUT is set
Date:   Thu, 6 Aug 2020 19:53:16 +0800
Message-ID: <1596714796-25298-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

We should fput() file iff FDPUT_FPUT is set. So we should set fput_needed
accordingly.

Fixes: 00e188ef6a7e ("sockfd_lookup_light(): switch to fdget^W^Waway from fget_light")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 6aff5aeb6728..ee9c9dac4728 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -500,7 +500,7 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 	if (f.file) {
 		sock = sock_from_file(f.file, err);
 		if (likely(sock)) {
-			*fput_needed = f.flags;
+			*fput_needed = f.flags & FDPUT_FPUT;
 			return sock;
 		}
 		fdput(f);
-- 
2.19.1

