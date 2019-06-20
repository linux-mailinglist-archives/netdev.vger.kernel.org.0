Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3264D6A5
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 20:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfFTSKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 14:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfFTSK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD0F2084E;
        Thu, 20 Jun 2019 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054228;
        bh=YVtlttnl81jCDsQm5FgclaSwVngRwlFS1G2pxgAc0g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asu8nKj7RtNKuyhm933Jpcp4O4SGWqwsgx31zh7SXByUr04IMyklOvImRnjQyVHJY
         VWvcj1I5qoGd9B8vKgf449l1jgrCY43TlJgwBNXa4gmndq0dNLGFt9t9RkmkyvFnqr
         4lB6tuL7qcT2Wh6Ei5BnRKXlIH+/dZcrlMMS/6Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 4.19 10/61] sctp: Free cookie before we memdup a new one
Date:   Thu, 20 Jun 2019 19:57:05 +0200
Message-Id: <20190620174339.137345137@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit ce950f1050cece5e406a5cde723c69bba60e1b26 ]

Based on comments from Xin, even after fixes for our recent syzbot
report of cookie memory leaks, its possible to get a resend of an INIT
chunk which would lead to us leaking cookie memory.

To ensure that we don't leak cookie memory, free any previously
allocated cookie first.

Change notes
v1->v2
update subsystem tag in subject (davem)
repeat kfree check for peer_random and peer_hmacs (xin)

v2->v3
net->sctp
also free peer_chunks

v3->v4
fix subject tags

v4->v5
remove cut line

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: Xin Long <lucien.xin@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2600,6 +2600,8 @@ do_addr_param:
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
+		if (asoc->peer.cookie)
+			kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2664,6 +2666,8 @@ do_addr_param:
 			goto fall_through;
 
 		/* Save peer's random parameter */
+		if (asoc->peer.peer_random)
+			kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2677,6 +2681,8 @@ do_addr_param:
 			goto fall_through;
 
 		/* Save peer's HMAC list */
+		if (asoc->peer.peer_hmacs)
+			kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
@@ -2692,6 +2698,8 @@ do_addr_param:
 		if (!ep->auth_enable)
 			goto fall_through;
 
+		if (asoc->peer.peer_chunks)
+			kfree(asoc->peer.peer_chunks);
 		asoc->peer.peer_chunks = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_chunks)


