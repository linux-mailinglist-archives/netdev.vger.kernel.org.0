Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2493A505CD3
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346567AbiDRQyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346578AbiDRQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FA33A01;
        Mon, 18 Apr 2022 09:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7756A612FB;
        Mon, 18 Apr 2022 16:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FEFC385A7;
        Mon, 18 Apr 2022 16:51:21 +0000 (UTC)
Subject: [PATCH RFC 02/15] SUNRPC: Ignore data_ready callbacks during TLS
 handshakes
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:51:20 -0400
Message-ID: <165030068031.5246.6914334811243049065.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RPC header parser doesn't recognize TLS handshake traffic, so it
will close the connection prematurely. To avoid that, shunt the
transport's data_ready callback when there is a TLS handshake in
progress.

The ignore_dr boolean will be toggled by code added in a subsequent
patch.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/xprtsock.h |    1 +
 net/sunrpc/xprtsock.c           |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 38284f25eddf..426c3bd516fe 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -40,6 +40,7 @@ struct sock_xprt {
 				len;
 
 		unsigned long	copied;
+		bool		ignore_dr;
 	} recv;
 
 	/*
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e62d339ba589..b5bc03c52b9b 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -703,6 +703,8 @@ static void xs_poll_check_readable(struct sock_xprt *transport)
 {
 
 	clear_bit(XPRT_SOCK_DATA_READY, &transport->sock_state);
+	if (transport->recv.ignore_dr)
+		return;
 	if (!xs_poll_socket_readable(transport))
 		return;
 	if (!test_and_set_bit(XPRT_SOCK_DATA_READY, &transport->sock_state))
@@ -1394,6 +1396,10 @@ static void xs_data_ready(struct sock *sk)
 		trace_xs_data_ready(xprt);
 
 		transport->old_data_ready(sk);
+
+		if (transport->recv.ignore_dr)
+			return;
+
 		/* Any data means we had a useful conversation, so
 		 * then we don't need to delay the next reconnect
 		 */
@@ -2779,6 +2785,7 @@ static struct rpc_xprt *xs_setup_xprt(struct xprt_create *args,
 	}
 
 	new = container_of(xprt, struct sock_xprt, xprt);
+	new->recv.ignore_dr = false;
 	mutex_init(&new->recv_mutex);
 	memcpy(&xprt->addr, args->dstaddr, args->addrlen);
 	xprt->addrlen = args->addrlen;


