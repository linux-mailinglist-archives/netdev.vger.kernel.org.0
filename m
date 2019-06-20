Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455EE4D7AB
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfFTSIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 14:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbfFTSIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 14:08:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EA82084E;
        Thu, 20 Jun 2019 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054127;
        bh=l/yJKou2oDHAdhnzdsC8NyeBypmK5iwGNwUo+9N61XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLBLhQTpFh5aNFU/xWxb97iIdTrJ98zYyfYiWfSgzyk0qzN3oupKy9i1xnQP4dd4f
         kzAeWSmdmlj74QMPt6go1xNvxdY6En7vzR5Gf3EHeCj1eX3GZycnYch8y1d7a6YZau
         J/MxgPS8ze1AkxPYPz5h4wUQdlNWN7M3YFZItqLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 4.14 08/45] sctp: Free cookie before we memdup a new one
Date:   Thu, 20 Jun 2019 19:57:10 +0200
Message-Id: <20190620174333.093872702@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
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
@@ -2586,6 +2586,8 @@ do_addr_param:
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
+		if (asoc->peer.cookie)
+			kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2650,6 +2652,8 @@ do_addr_param:
 			goto fall_through;
 
 		/* Save peer's random parameter */
+		if (asoc->peer.peer_random)
+			kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2663,6 +2667,8 @@ do_addr_param:
 			goto fall_through;
 
 		/* Save peer's HMAC list */
+		if (asoc->peer.peer_hmacs)
+			kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
@@ -2678,6 +2684,8 @@ do_addr_param:
 		if (!ep->auth_enable)
 			goto fall_through;
 
+		if (asoc->peer.peer_chunks)
+			kfree(asoc->peer.peer_chunks);
 		asoc->peer.peer_chunks = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_chunks)


