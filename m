Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CC24192C
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 11:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHKJza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 05:55:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgHKJz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 05:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597139728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0t6pyerkz2yQxFGUrBVr3335mJPptpvA69HZOPrEqE4=;
        b=SSSp5xgABeOzvYjcTmRh5mRWKboJwAKa3R9BdSYW/xm8vyZnwMxzCSC6pzKVcM0o7Vgeck
        VdveAp+DJ239ESjAMVqH8oFdytRDLlt6GrC8nQj0RpWJ7SpML4jd2xAkJxcfIGxuMpoqeI
        /hqmk6v7kMzjEK0h1ybtPD9KId7+T0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-GaghuQZsPpy8XUvNlyvc4w-1; Tue, 11 Aug 2020 05:55:26 -0400
X-MC-Unique: GaghuQZsPpy8XUvNlyvc4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26077107ACCA;
        Tue, 11 Aug 2020 09:55:25 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-182.ams2.redhat.com [10.36.113.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE54D5D9FC;
        Tue, 11 Aug 2020 09:55:21 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net 2/2] vsock: small cleanup in vsock_poll()
Date:   Tue, 11 Aug 2020 11:55:04 +0200
Message-Id: <20200811095504.25051-3-sgarzare@redhat.com>
In-Reply-To: <20200811095504.25051-1-sgarzare@redhat.com>
References: <20200811095504.25051-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch combines nested if statements in a single one to reduce
the indentation in vsock_poll().
It also combines an if nested in the else branch.

The behavior isn't changed.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc0..2c80dc14fa60 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1032,21 +1032,18 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		}
 
 		/* Connected sockets that can produce data can be written. */
-		if (transport && sk->sk_state == TCP_ESTABLISHED) {
-			if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
-				bool space_avail_now = false;
-				int ret = transport->notify_poll_out(
-						vsk, 1, &space_avail_now);
-				if (ret < 0) {
-					mask |= EPOLLERR;
-				} else {
-					if (space_avail_now)
-						/* Remove EPOLLWRBAND since INET
-						 * sockets are not setting it.
-						 */
-						mask |= EPOLLOUT | EPOLLWRNORM;
-
-				}
+		if (transport && sk->sk_state == TCP_ESTABLISHED &&
+		    !(sk->sk_shutdown & SEND_SHUTDOWN)) {
+			bool space_avail_now = false;
+			int ret = transport->notify_poll_out(vsk, 1,
+							     &space_avail_now);
+			if (ret < 0) {
+				mask |= EPOLLERR;
+			} else if (space_avail_now) {
+				/* Remove EPOLLWRBAND since INET
+				 * sockets are not setting it.
+				 */
+				mask |= EPOLLOUT | EPOLLWRNORM;
 			}
 		}
 
-- 
2.26.2

