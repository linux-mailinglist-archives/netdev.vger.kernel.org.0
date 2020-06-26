Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0250D20B6F2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgFZR1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:27:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725833AbgFZR1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593192429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnAgukC9feUE5fx8vXb2ln7WITVXa1QP9Y31QVCHsrU=;
        b=XPULCef+IIAe2vzdmwiS1Q7GGNArOdNuYGAnJHr/ssLwrcBpiY1hiRcNx6n1P1Rgtl9Szr
        aZ3tQM3bJg35IfJkxNotN++6zoMDeZT97x4vkehqPQ1AyknKXWGCFgp9PdMeG650xrYsVT
        /0EWvLoY790OP5Tq/E0a5hbILKgOn1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-YVdjOFOkPVikXd5zWU1pJg-1; Fri, 26 Jun 2020 13:27:08 -0400
X-MC-Unique: YVdjOFOkPVikXd5zWU1pJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BABE0804003;
        Fri, 26 Jun 2020 17:27:06 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64B9C1C8;
        Fri, 26 Jun 2020 17:27:05 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, teigland@redhat.com, ccaulfie@redhat.com,
        cluster-devel@redhat.com, netdev@vger.kernel.org,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCHv2 dlm-next 1/3] net: sock: add sock_set_mark
Date:   Fri, 26 Jun 2020 13:26:48 -0400
Message-Id: <20200626172650.115224-2-aahringo@redhat.com>
In-Reply-To: <20200626172650.115224-1-aahringo@redhat.com>
References: <20200626172650.115224-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new socket helper function to set the mark value for a
kernel socket.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 include/net/sock.h | 1 +
 net/core/sock.c    | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab92..591dd3f12dbb1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2696,6 +2696,7 @@ void sock_no_linger(struct sock *sk);
 void sock_set_keepalive(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_rcvbuf(struct sock *sk, int val);
+void sock_set_mark(struct sock *sk, u32 val);
 void sock_set_reuseaddr(struct sock *sk);
 void sock_set_reuseport(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220b..ea6e8348b3dc8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -828,6 +828,14 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+void sock_set_mark(struct sock *sk, u32 val)
+{
+	lock_sock(sk);
+	sk->sk_mark = val;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_mark);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
-- 
2.26.2

