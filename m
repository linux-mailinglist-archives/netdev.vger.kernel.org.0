Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2630276E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbhAYQFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730058AbhAYQDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611590539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UihjeK/JF/Yh0udJ/IeVbOTgj/YZE43vzfnWSv/Durg=;
        b=OAqflXbsuEPTNtt0viTxouM3tzhkDIZjQjwH81q2WvKIrEY0seqJKo5mMTzEC6NRi4RI1Z
        Ma4fdHqu6qnujhnJvg0ubqiAvKgWf4Z0uI82C+UQco/RUJawMVOvVy0yGJFqE3tco6yjxh
        pPsoiXuCBp7nooq+qY4J86nRhO36L48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-gI1MWXGHNzWgVHih-Dp3CQ-1; Mon, 25 Jan 2021 11:02:17 -0500
X-MC-Unique: gI1MWXGHNzWgVHih-Dp3CQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0E08193410E;
        Mon, 25 Jan 2021 16:02:15 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2AA85C1C5;
        Mon, 25 Jan 2021 16:02:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "dsahern @ kernel . org" <dsahern@kernel.org>
Subject: [PATCH iproute2] ss: do not emit warn while dumping MPTCP on old kernels
Date:   Mon, 25 Jan 2021 17:02:07 +0100
Message-Id: <89e5acb6c86bb10675697dabbefafad7088dc0f6.1611590423.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this commit, running 'ss' on a kernel older than v5.9
bumps an error message:

RTNETLINK answers: Invalid argument

When asked to dump protocol number > 255 - that is: MPTCP - 'ss'
adds an INET_DIAG_REQ_PROTOCOL attribute, unsupported by the older
kernel.

Avoid the warning ignoring filter issues when INET_DIAG_REQ_PROTOCOL
is used.

Additionally older kernel end-up invoking tcpdiag_send(), which
in turn will try to dump DCCP socks. Bail early in such function,
as the kernel does not implement an MPTCPDIAG_GET request.

Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Fixes: 9c3be2c0eee0 ("ss: mptcp: add msk diag interface support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 misc/ss.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 0593627b..ad46f9db 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3404,7 +3404,7 @@ static int tcpdiag_send(int fd, int protocol, struct filter *f)
 	struct iovec iov[3];
 	int iovlen = 1;
 
-	if (protocol == IPPROTO_UDP)
+	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
 		return -1;
 
 	if (protocol == IPPROTO_TCP)
@@ -3623,6 +3623,14 @@ static int inet_show_netlink(struct filter *f, FILE *dump_fp, int protocol)
 	if (preferred_family == PF_INET6)
 		family = PF_INET6;
 
+	/* extended protocol will use INET_DIAG_REQ_PROTOCOL,
+	 * not supported by older kernels. On such kernel
+	 * rtnl_dump will bail with rtnl_dump_error().
+	 * Suppress the error to avoid confusing the user
+	 */
+	if (protocol > 255)
+		rth.flags |= RTNL_HANDLE_F_SUPPRESS_NLERR;
+
 again:
 	if ((err = sockdiag_send(family, rth.fd, protocol, f)))
 		goto Exit;
-- 
2.26.2

