Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746F742DDF9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhJNPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:23:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231552AbhJNPXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 11:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634224856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tOTKFFGtjip5ZWj15JuU+YQ9cEjBP5TceDwsinyFy6Q=;
        b=HC0Q9p+rL8240Dd6auZTPrrxTUSjyN0rks76EhPyZuOvdwKNAhXcELFVwgya0ctiD7Qnhb
        P1SsORjH7gf9ao7yU6XPgcqeVFyojDPkxeD32P1wurKtFQQIU5eqowD3tWWwslJP763D0r
        Yl3pcgz7hSrT6yWU4JSFx364w7eZLFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-uVLmyzpnMvOJJ5Lw9uSMMA-1; Thu, 14 Oct 2021 11:20:53 -0400
X-MC-Unique: uVLmyzpnMvOJJ5Lw9uSMMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 101AA1922961;
        Thu, 14 Oct 2021 15:20:52 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.194.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7945D6B1;
        Thu, 14 Oct 2021 15:20:46 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] vsock_diag_test: remove free_sock_stat() call in test_no_sockets
Date:   Thu, 14 Oct 2021 17:20:45 +0200
Message-Id: <20211014152045.173872-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In `test_no_sockets` we don't expect any sockets, indeed
check_no_sockets() prints an error and exits if `sockets` list is
not empty, so free_sock_stat() call is unnecessary since it would
only be called when the `sockets` list is empty.

This was discovered by a strange warning printed by gcc v11.2.1:
  In file included from ../../include/linux/list.h:7,
                   from vsock_diag_test.c:18:
  vsock_diag_test.c: In function ‘test_no_sockets’:
  ../../include/linux/kernel.h:35:45: error: array subscript ‘struct vsock_stat[0]’ is partly outside array bound
  s of ‘struct list_head[1]’ [-Werror=array-bounds]
     35 |         const typeof(((type *)0)->member) * __mptr = (ptr);     \
        |                                             ^~~~~~
  ../../include/linux/list.h:352:9: note: in expansion of macro ‘container_of’
    352 |         container_of(ptr, type, member)
        |         ^~~~~~~~~~~~
  ../../include/linux/list.h:393:9: note: in expansion of macro ‘list_entry’
    393 |         list_entry((pos)->member.next, typeof(*(pos)), member)
        |         ^~~~~~~~~~
  ../../include/linux/list.h:522:21: note: in expansion of macro ‘list_next_entry’
    522 |                 n = list_next_entry(pos, member);                       \
        |                     ^~~~~~~~~~~~~~~
  vsock_diag_test.c:325:9: note: in expansion of macro ‘list_for_each_entry_safe’
    325 |         list_for_each_entry_safe(st, next, sockets, list) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~
  In file included from vsock_diag_test.c:18:
  vsock_diag_test.c:333:19: note: while referencing ‘sockets’
    333 |         LIST_HEAD(sockets);
        |                   ^~~~~~~
  ../../include/linux/list.h:23:26: note: in definition of macro ‘LIST_HEAD’
     23 |         struct list_head name = LIST_HEAD_INIT(name)

It seems related to some compiler optimization and assumption
about the empty `sockets` list, since this warning is printed
only with -02 or -O3. Also removing `exit(1)` from
check_no_sockets() makes the warning disappear since in that
case free_sock_stat() can be reached also when the list is
not empty.

Reported-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_diag_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/vsock_diag_test.c
index cec6f5a738e1..fa927ad16f8a 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -332,8 +332,6 @@ static void test_no_sockets(const struct test_opts *opts)
 	read_vsock_stat(&sockets);
 
 	check_no_sockets(&sockets);
-
-	free_sock_stat(&sockets);
 }
 
 static void test_listen_socket_server(const struct test_opts *opts)
-- 
2.31.1

