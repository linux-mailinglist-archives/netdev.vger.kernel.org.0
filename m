Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCE1441FAE
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhKAR5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhKAR5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635789304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cdA4HEi03IAhyS4b70T1LHDhUS3p0K2wOZ6l2OOPtzk=;
        b=LM83STOs4bkI5P5rucpzgYa66wWe9PjLa4Skd02RWKlBRQ6kvZ2sStKJUB/TRIaBl1POzM
        uYS8teNxM/e/toNRbEv71Rpz8sCgzRFLrn1HpfCWr4REy8XCnY61qzlY6DzyeSEulX1ruG
        YuXzI70vOq7JB4KObCBtcGmvg0Ne+u0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-FsODh18NP9CY1-GxhOsuuQ-1; Mon, 01 Nov 2021 13:54:58 -0400
X-MC-Unique: FsODh18NP9CY1-GxhOsuuQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8190010B3940;
        Mon,  1 Nov 2021 17:54:57 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D50E5D9D3;
        Mon,  1 Nov 2021 17:54:55 +0000 (UTC)
Date:   Mon, 1 Nov 2021 18:54:53 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] mctp: handle the struct sockaddr_mctp_ext
 padding field
Message-ID: <ebab61afcbcd91441c4a5395612a4f1eca691bae.1635788968.git.esyr@redhat.com>
References: <cover.1635788968.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1635788968.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct sockaddr_mctp_ext.__smctp_paddin0 has to be checked for being set
to zero, otherwise it cannot be utilised in the future.

Complements: 99ce45d5e7dbde39 ("mctp: Implement extended addressing")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 net/mctp/af_mctp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index bc88159..6cd1308 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -39,6 +39,13 @@ static bool mctp_sockaddr_is_ok(const struct sockaddr_mctp *addr)
 	return !addr->__smctp_pad0 && !addr->__smctp_pad1;
 }
 
+static bool mctp_sockaddr_ext_is_ok(const struct sockaddr_mctp_ext *addr)
+{
+	return !addr->__smctp_pad0[0]
+	       && !addr->__smctp_pad0[1]
+	       && !addr->__smctp_pad0[2];
+}
+
 static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
 	struct sock *sk = sock->sk;
@@ -135,7 +142,8 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		DECLARE_SOCKADDR(struct sockaddr_mctp_ext *,
 				 extaddr, msg->msg_name);
 
-		if (extaddr->smctp_halen > sizeof(cb->haddr)) {
+		if (!mctp_sockaddr_ext_is_ok(extaddr)
+		    || extaddr->smctp_halen > sizeof(cb->haddr)) {
 			rc = -EINVAL;
 			goto err_free;
 		}
@@ -224,6 +232,7 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			msg->msg_namelen = sizeof(*ae);
 			ae->smctp_ifindex = cb->ifindex;
 			ae->smctp_halen = cb->halen;
+			memset(ae->__smctp_pad0, 0x0, sizeof(ae->__smctp_pad0));
 			memset(ae->smctp_haddr, 0x0, sizeof(ae->smctp_haddr));
 			memcpy(ae->smctp_haddr, cb->haddr, cb->halen);
 		}
-- 
2.1.4

