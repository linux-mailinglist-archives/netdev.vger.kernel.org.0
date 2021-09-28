Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6BC41A5F4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhI1DRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:17:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:26917 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbhI1DRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 23:17:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HJPfg3vdzzbm9Z;
        Tue, 28 Sep 2021 11:11:23 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 11:15:39 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 11:15:37 +0800
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
Subject: [PATCH net 0/2] auth_gss: Fix netns refcount leaks when use-gss-proxy==1
Date:   Tue, 28 Sep 2021 11:14:38 +0800
Message-ID: <20210928031440.2222303-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
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
gssp_rpc_create(), this increases netns refcount by 2 [1], these
refcounts are supposed to be released in rpcsec_gss_exit_net(), but
it will never happen because rpcsec_gss_exit_net() is triggered only
when netns refcount gets to 0, specifically:
     refcount=0 -> cleanup_net() -> ops_exit_list -> rpcsec_gss_exit_net
It is a deadlock situation here, refcount will never get to 0 unless
rpcsec_gss_exit_net() is called. 

[1]
SyS_write
    vfs_write
        proc_reg_write
            write_gssp
                set_gssp_clnt
                    gssp_rpc_create
                        rpc_create
                            xprt_create_transport
                                xs_setup_local
                                    xs_setup_xprt
                                        xprt_alloc   // get net refcount
                                    xs_local_setup_socket
                                        unix_create
                                        kernel_connect // get net refcount

In this case, the net refcount shouldn't be increased when creating rpc
client, otherwise it will lead to deadlock.

This patchset removes the increased netns reference count.

Wang Hai (2):
  net: Modify unix_stream_connect to not reference count the netns of
    kernel sockets
  auth_gss: Fix deadlock that blocks rpcsec_gss_exit_net when
    use-gss-proxy==1

 include/linux/sunrpc/clnt.h                |  1 +
 include/linux/sunrpc/xprt.h                |  6 ++++--
 net/sunrpc/auth_gss/gss_rpc_upcall.c       |  3 ++-
 net/sunrpc/clnt.c                          |  2 ++
 net/sunrpc/xprt.c                          | 13 +++++++++----
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |  2 +-
 net/sunrpc/xprtrdma/transport.c            |  2 +-
 net/sunrpc/xprtsock.c                      |  4 +++-
 net/unix/af_unix.c                         |  3 ++-
 9 files changed, 25 insertions(+), 11 deletions(-)

-- 
2.17.1

