Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB1F2E7102
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgL2Ns7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:48:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10002 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2Ns7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:48:59 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D4whc1Szdzhw13;
        Tue, 29 Dec 2020 21:47:28 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:48:08 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: kcm: Replace fput with sockfd_put
Date:   Tue, 29 Dec 2020 21:48:45 +0800
Message-ID: <20201229134845.23020-1-zhengyongjun3@huawei.com>
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

The problem was fixed using the following semantic patch.
    (http://www.emn.fr/x-info/coccinelle/)

    // <smpl>
    @@
    expression s;
    @@

       s = sockfd_lookup(...)
       ...
    +  sockfd_put(s);
    ?- fput(s->file);
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

