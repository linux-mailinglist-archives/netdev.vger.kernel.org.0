Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3172041A5F7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhI1DRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:17:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12736 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbhI1DRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 23:17:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HJPk80NK3zWVRK;
        Tue, 28 Sep 2021 11:14:24 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 11:15:41 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 11:15:39 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <bfields@fieldses.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wenbin.zeng@gmail.com>, <jlayton@kernel.org>, <dsahern@gmail.com>,
        <nicolas.dichtel@6wind.com>, <viro@zeniv.linux.org.uk>,
        <willy@infradead.org>, <jakub.kicinski@netronome.com>,
        <tyhicks@canonical.com>, <cong.wang@bytedance.com>,
        <ast@kernel.org>, <jiang.wang@bytedance.com>,
        <christian.brauner@ubuntu.com>, <edumazet@google.com>,
        <Rao.Shoaib@oracle.com>, <kuniyu@amazon.co.jp>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <chuck.lever@oracle.com>, <neilb@suse.com>, <kolga@netapp.com>,
        <timo@rothenpieler.org>, <tom@talpey.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/2] net: Modify unix_stream_connect to not reference count the netns of kernel sockets
Date:   Tue, 28 Sep 2021 11:14:39 +0800
Message-ID: <20210928031440.2222303-2-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928031440.2222303-1-wanghai38@huawei.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When use-gss-proxy is set to 1, write_gssp() creates a rpc client in
gssp_rpc_create(), this increases netns refcount by 2, these refcounts
are supposed to be released in rpcsec_gss_exit_net(), but it will never
happen because rpcsec_gss_exit_net() is triggered only when netns
refcount gets to 0, specifically:
    refcount=0 -> cleanup_net() -> ops_exit_list -> rpcsec_gss_exit_net
It is a deadlock situation here, refcount will never get to 0 unless
rpcsec_gss_exit_net() is called. So, in this case, the netns refcount
should not be increased.

In this case, kernel_connect()->unix_stream_connect() will take a netns
refcount. According to commit 26abe14379f8 ("net: Modify sk_alloc to not
reference count the netns of kernel sockets."), kernel sockets should not
take the netns refcount, so unix_stream_connect() should not take
the netns refcount when the sock is a kernel socket either.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/unix/af_unix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 92345c9bb60c..af6ba67779c8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1317,7 +1317,8 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	err = -ENOMEM;
 
 	/* create new sock for complete connection */
-	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
+	newsk = unix_create1(sock_net(sk), NULL,
+			     !sk->sk_net_refcnt, sock->type);
 	if (newsk == NULL)
 		goto out;
 
-- 
2.17.1

