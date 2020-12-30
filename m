Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F32E775D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL3JSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:18:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9659 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgL3JSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:18:20 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D5Qdr0msSz15lf9;
        Wed, 30 Dec 2020 17:16:48 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 30 Dec 2020 17:17:30 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Markus.Elring@web.de>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v3 net-next] net: kcm: Replace fput with sockfd_put
Date:   Wed, 30 Dec 2020 17:18:09 +0800
Message-ID: <20201230091809.942-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function sockfd_lookup uses fget on the value that is stored in
the file field of the returned structure, so fput should ultimately be
applied to this value.  This can be done directly, but it seems better
to use the specific macro sockfd_put, which does the same thing.

Perform a source code refactoring by using the following semantic patch.

    // <smpl>
    @@
    expression s;
    @@

       s = sockfd_lookup(...)
       ...
    + sockfd_put(s);
    - fput(s->file);
    // </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/kcm/kcmsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 56dad9565bc9..a9eb616f5521 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1496,7 +1496,7 @@ static int kcm_attach_ioctl(struct socket *sock, struct kcm_attach *info)
 
 	return 0;
 out:
-	fput(csock->file);
+	sockfd_put(csock);
 	return err;
 }
 
@@ -1644,7 +1644,7 @@ static int kcm_unattach_ioctl(struct socket *sock, struct kcm_unattach *info)
 	spin_unlock_bh(&mux->lock);
 
 out:
-	fput(csock->file);
+	sockfd_put(csock);
 	return err;
 }
 
-- 
2.22.0

