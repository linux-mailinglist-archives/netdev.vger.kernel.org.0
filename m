Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD9441FAB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhKAR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:57:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230261AbhKAR5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635789296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Xb1aazRNBHuWw3ab+ZKK+D2hPPqz71WYrp6r2ZODTM=;
        b=AeoVk729roBvF254UMdH3YzkIhU6gTDNsBMh4EpnxqSF8EbJXDW+wf2tZvZNafSrQ5upfi
        R9n/KQwYe2I4dL/C2e+3kV7wo6PVgW+0socyK97nEdDsapdEEurrH1sTIrZiShWO3r7FYP
        VROm41hTqYcs+QBAiI/ddY126TuJQRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-lT2rQFEMOBSVsuxq8GkDXw-1; Mon, 01 Nov 2021 13:54:55 -0400
X-MC-Unique: lT2rQFEMOBSVsuxq8GkDXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30E7A802682;
        Mon,  1 Nov 2021 17:54:53 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3544A5C1C5;
        Mon,  1 Nov 2021 17:54:50 +0000 (UTC)
Date:   Mon, 1 Nov 2021 18:54:49 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] mctp: handle the struct sockaddr_mctp padding
 fields
Message-ID: <28f36bbcecc5b28e56cb33ff449c3ae92adebb8c.1635788968.git.esyr@redhat.com>
References: <cover.1635788968.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1635788968.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to have the padding fields actually usable in the future,
there have to be checks that user space doesn't supply non-zero garbage
there.  It is also worth setting these padding fields to zero, unless
it is known that they have been already zeroed.

Cc: stable@vger.kernel.org # v5.15
Complements: 5a20dd46b8b84593 ("mctp: Be explicit about struct sockaddr_mctp padding")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 net/mctp/af_mctp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index d344b02..bc88159 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -33,6 +33,12 @@ static int mctp_release(struct socket *sock)
 	return 0;
 }
 
+/* Generic sockaddr checks, padding checks only so far */
+static bool mctp_sockaddr_is_ok(const struct sockaddr_mctp *addr)
+{
+	return !addr->__smctp_pad0 && !addr->__smctp_pad1;
+}
+
 static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
 	struct sock *sk = sock->sk;
@@ -52,6 +58,9 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 	/* it's a valid sockaddr for MCTP, cast and do protocol checks */
 	smctp = (struct sockaddr_mctp *)addr;
 
+	if (!mctp_sockaddr_is_ok(smctp))
+		return -EINVAL;
+
 	lock_sock(sk);
 
 	/* TODO: allow rebind */
@@ -87,6 +96,8 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			return -EINVAL;
 		if (addr->smctp_family != AF_MCTP)
 			return -EINVAL;
+		if (!mctp_sockaddr_is_ok(addr))
+			return -EINVAL;
 		if (addr->smctp_tag & ~(MCTP_TAG_MASK | MCTP_TAG_OWNER))
 			return -EINVAL;
 
@@ -198,11 +209,13 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 		addr = msg->msg_name;
 		addr->smctp_family = AF_MCTP;
+		addr->__smctp_pad0 = 0;
 		addr->smctp_network = cb->net;
 		addr->smctp_addr.s_addr = hdr->src;
 		addr->smctp_type = type;
 		addr->smctp_tag = hdr->flags_seq_tag &
 					(MCTP_HDR_TAG_MASK | MCTP_HDR_FLAG_TO);
+		addr->__smctp_pad1 = 0;
 		msg->msg_namelen = sizeof(*addr);
 
 		if (msk->addr_ext) {
-- 
2.1.4

