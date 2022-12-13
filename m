Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C4964B3EB
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiLMLMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiLMLLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A5F1A3BB
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 03:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670929853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQnj7/I7uvZnml3i80d845x9sV5K5xpn0e6auaHLQzo=;
        b=gASD2nN+rsq2jmvv9mEx5x//RU7s78xTBnIsLFCQLt3V8fZhU3HvkxDgHbZBfHurLp3VYe
        ziPGRMBxxTXtut9UQb6ZMTssKRof1oyjKGzix1y8+k+AsFLAG0zqdZkcdmNxkqk5UM+Iwc
        KHSB9ce/3sxUycEZ7kd8R3l5m6ZV+Pk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-zz03aoAGNTO2PSWpbJbtIQ-1; Tue, 13 Dec 2022 06:10:49 -0500
X-MC-Unique: zz03aoAGNTO2PSWpbJbtIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 180C53804500;
        Tue, 13 Dec 2022 11:10:48 +0000 (UTC)
Received: from bcodding.csb (unknown [10.22.50.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF1D52166B26;
        Tue, 13 Dec 2022 11:10:47 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id 95F1910C30E2; Tue, 13 Dec 2022 06:10:45 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net v3 2/3] Treewide: Stop corrupting socket's task_frag
Date:   Tue, 13 Dec 2022 06:10:38 -0500
Message-Id: <92b887a9b90dcbf5083d1f47699c2f785820d708.1670929442.git.bcodding@redhat.com>
In-Reply-To: <cover.1670929442.git.bcodding@redhat.com>
References: <cover.1670929442.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
GFP_NOIO flag on sk_allocation which the networking system uses to decide
when it is safe to use current->task_frag.  The results of this are
unexpected corruption in task_frag when SUNRPC is involved in memory
reclaim.

The corruption can be seen in crashes, but the root cause is often
difficult to ascertain as a crashing machine's stack trace will have no
evidence of being near NFS or SUNRPC code.  I believe this problem to
be much more pervasive than reports to the community may indicate.

Fix this by having kernel users of sockets that may corrupt task_frag due
to reclaim set sk_use_task_frag = false.  Preemptively correcting this
situation for users that still set sk_allocation allows them to convert to
memalloc_nofs_save/restore without the same unexpected corruptions that are
sure to follow, unlikely to show up in testing, and difficult to bisect.

CC: Philipp Reisner <philipp.reisner@linbit.com>
CC: Lars Ellenberg <lars.ellenberg@linbit.com>
CC: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Josef Bacik <josef@toxicpanda.com>
CC: Keith Busch <kbusch@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Sagi Grimberg <sagi@grimberg.me>
CC: Lee Duncan <lduncan@suse.com>
CC: Chris Leech <cleech@redhat.com>
CC: Mike Christie <michael.christie@oracle.com>
CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Valentina Manea <valentina.manea.m@gmail.com>
CC: Shuah Khan <shuah@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Howells <dhowells@redhat.com>
CC: Marc Dionne <marc.dionne@auristor.com>
CC: Steve French <sfrench@samba.org>
CC: Christine Caulfield <ccaulfie@redhat.com>
CC: David Teigland <teigland@redhat.com>
CC: Mark Fasheh <mark@fasheh.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Latchesar Ionkov <lucho@ionkov.net>
CC: Dominique Martinet <asmadeus@codewreck.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Ilya Dryomov <idryomov@gmail.com>
CC: Xiubo Li <xiubli@redhat.com>
CC: Chuck Lever <chuck.lever@oracle.com>
CC: Jeff Layton <jlayton@kernel.org>
CC: Trond Myklebust <trond.myklebust@hammerspace.com>
CC: Anna Schumaker <anna@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/block/drbd/drbd_receiver.c | 3 +++
 drivers/block/nbd.c                | 1 +
 drivers/nvme/host/tcp.c            | 1 +
 drivers/scsi/iscsi_tcp.c           | 1 +
 drivers/usb/usbip/usbip_common.c   | 1 +
 fs/afs/rxrpc.c                     | 1 +
 fs/cifs/connect.c                  | 1 +
 fs/dlm/lowcomms.c                  | 2 ++
 fs/ocfs2/cluster/tcp.c             | 1 +
 net/9p/trans_fd.c                  | 1 +
 net/ceph/messenger.c               | 1 +
 net/sunrpc/xprtsock.c              | 3 +++
 net/xfrm/espintcp.c                | 1 +
 13 files changed, 18 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ee69d50ba4fd..0d3f910ae347 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1030,6 +1030,9 @@ static int conn_connect(struct drbd_connection *connection)
 	sock.socket->sk->sk_allocation = GFP_NOIO;
 	msock.socket->sk->sk_allocation = GFP_NOIO;
 
+	sock.socket->sk->sk_use_task_frag = false;
+	msock.socket->sk->sk_use_task_frag = false;
+
 	sock.socket->sk->sk_priority = TC_PRIO_INTERACTIVE_BULK;
 	msock.socket->sk->sk_priority = TC_PRIO_INTERACTIVE;
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5cffd96ef2d7..3a46b776354d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -512,6 +512,7 @@ static int sock_xmit(struct nbd_device *nbd, int index, int send,
 	noreclaim_flag = memalloc_noreclaim_save();
 	do {
 		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
+		sock->sk->sk_use_task_frag = false;
 		msg.msg_name = NULL;
 		msg.msg_namelen = 0;
 		msg.msg_control = NULL;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9b47dcb2a7d9..fe772d6c4c96 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1537,6 +1537,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	queue->sock->sk->sk_rcvtimeo = 10 * HZ;
 
 	queue->sock->sk->sk_allocation = GFP_ATOMIC;
+	queue->sock->sk->sk_use_task_frag = false;
 	nvme_tcp_set_queue_io_cpu(queue);
 	queue->request = NULL;
 	queue->data_remaining = 0;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5fb1f364e815..1d1cf641937c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -738,6 +738,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_reuse = SK_CAN_REUSE;
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
+	sk->sk_use_task_frag = false;
 	sk_set_memalloc(sk);
 	sock_no_linger(sk);
 
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 053a2bca4c47..e15ae6ca95ea 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -315,6 +315,7 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 
 	do {
 		sock->sk->sk_allocation = GFP_NOIO;
+		sock->sk->sk_use_task_frag = false;
 
 		result = sock_recvmsg(sock, &msg, MSG_WAITALL);
 		if (result <= 0)
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index eccc3cd0cb70..ac75ad18db83 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -46,6 +46,7 @@ int afs_open_socket(struct afs_net *net)
 		goto error_1;
 
 	socket->sk->sk_allocation = GFP_NOFS;
+	socket->sk->sk_use_task_frag = false;
 
 	/* bind the callback manager's address to make this a server socket */
 	memset(&srx, 0, sizeof(srx));
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9db9527c61cf..d84f1660cacb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2944,6 +2944,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "Socket created\n");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
+		socket->sk->sk_use_task_frag = false;
 		if (sfamily == AF_INET6)
 			cifs_reclassify_socket6(socket);
 		else
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 59f64c596233..120be782edbc 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -699,6 +699,7 @@ static void add_listen_sock(struct socket *sock, struct listen_connection *con)
 
 	sk->sk_user_data = con;
 	sk->sk_allocation = GFP_NOFS;
+	sk->sk_use_task_frag = false;
 	/* Install a data_ready callback */
 	sk->sk_data_ready = lowcomms_listen_data_ready;
 	release_sock(sk);
@@ -718,6 +719,7 @@ static void add_sock(struct socket *sock, struct connection *con)
 	sk->sk_write_space = lowcomms_write_space;
 	sk->sk_state_change = lowcomms_state_change;
 	sk->sk_allocation = GFP_NOFS;
+	sk->sk_use_task_frag = false;
 	sk->sk_error_report = lowcomms_error_report;
 	release_sock(sk);
 }
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f660c0dbdb63..3eaafa5e5ec4 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1604,6 +1604,7 @@ static void o2net_start_connect(struct work_struct *work)
 	sc->sc_sock = sock; /* freed by sc_kref_release */
 
 	sock->sk->sk_allocation = GFP_ATOMIC;
+	sock->sk->sk_use_task_frag = false;
 
 	myaddr.sin_family = AF_INET;
 	myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 07db2f436d44..d9120f14684b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -868,6 +868,7 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
+	csocket->sk->sk_use_task_frag = false;
 	file = sock_alloc_file(csocket, 0, NULL);
 	if (IS_ERR(file)) {
 		pr_err("%s (%d): failed to map fd\n",
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index dfa237fbd5a3..1d06e114ba3f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -446,6 +446,7 @@ int ceph_tcp_connect(struct ceph_connection *con)
 	if (ret)
 		return ret;
 	sock->sk->sk_allocation = GFP_NOFS;
+	sock->sk->sk_use_task_frag = false;
 
 #ifdef CONFIG_LOCKDEP
 	lockdep_set_class(&sock->sk->sk_lock, &socket_class);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 915b9902f673..41ffc2169743 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1882,6 +1882,7 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_write_space = xs_udp_write_space;
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		xprt_clear_connected(xprt);
 
@@ -2082,6 +2083,7 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
+		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
 
@@ -2249,6 +2251,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
 		sk->sk_error_report = xs_error_report;
+		sk->sk_use_task_frag = false;
 
 		/* socket options */
 		sock_reset_flag(sk, SOCK_LINGER);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 29a540dcb5a7..4ca2c5927ace 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -489,6 +489,7 @@ static int espintcp_init_sk(struct sock *sk)
 
 	/* avoid using task_frag */
 	sk->sk_allocation = GFP_ATOMIC;
+	sk->sk_use_task_frag = false;
 
 	return 0;
 
-- 
2.31.1

