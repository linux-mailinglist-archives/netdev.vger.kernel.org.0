Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589222E7100
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgL2Nst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:48:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10374 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2Nst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:48:49 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D4whM2spfz7MVY;
        Tue, 29 Dec 2020 21:47:15 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:47:56 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: core: Replace fput with sockfd_put
Date:   Tue, 29 Dec 2020 21:48:34 +0800
Message-ID: <20201229134834.22962-1-zhengyongjun3@huawei.com>
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
 net/core/sock_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ddc899e83313..2e59256a06e9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -611,7 +611,7 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value,
 		ret = sock_hash_update_common(map, key, sk, flags);
 	sock_map_sk_release(sk);
 out:
-	fput(sock->file);
+	sockfd_put(sock);
 	return ret;
 }
 
-- 
2.22.0

