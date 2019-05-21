Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6C424533
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfEUAoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:44:22 -0400
Received: from web1.siteocity.com ([67.227.147.204]:47490 "EHLO
        web1.siteocity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfEUAoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=felipegasper.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r2i5+1pUFCcKjhYHJxSLjKHwT9pE8J0ZbmazSsNsPlc=; b=svz0F+hmYNBm1IVqpMTHsGzT1W
        1leCToQFdxA8Uzj0f/hUfX1vp8d6R2I+C0yXg0FbcXakAjcqzxSMbVBAz3GvQaNXFjQCKO0NRUKyz
        0qAxKlbiTRzc8IfGTIxGpXM0u1Rqt7JjoXb977BEwsrWvsgpF1yw2FNxX9Vmcmb8/qd3FObOv7VHm
        y+SGpwu4jMhJe3BJkoP3EZIWDwvApkA+fC8jz/GCwSj8fHjt1VC0VwHMApQoWMNaBhZt1dU4dWNMR
        7ugLn9PU8DUMorpbFeUf46BuYvqh/YTFSg6RKuOY8sDqDKbE0jkBBFt1wXXKrHhL38oA3wAS1A7sU
        hiw2Rc1g==;
Received: from fgasper by web1.siteocity.com with local (Exim 4.92)
        (envelope-from <fgasper@web1.siteocity.com>)
        id 1hSst9-0006aW-Jq; Mon, 20 May 2019 19:44:20 -0500
From:   Felipe Gasper <felipe@felipegasper.com>
To:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Felipe Gasper <felipe@felipegasper.com>
Subject: [PATCH v4] net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date:   Mon, 20 May 2019 19:43:51 -0500
Message-Id: <20190521004351.23706-1-felipe@felipegasper.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OutGoing-Spam-Status: No, score=0.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - web1.siteocity.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [1438 994] / [47 12]
X-AntiAbuse: Sender Address Domain - web1.siteocity.com
X-Get-Message-Sender-Via: web1.siteocity.com: authenticated_id: fgasper/from_h
X-Authenticated-Sender: web1.siteocity.com: felipe@felipegasper.com
X-Source: 
X-Source-Args: 
X-Source-Dir: /home/fgasper
X-From-Rewrite: unmodified, already matched
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the ability for Netlink to report a socket's UID along with the
other UNIX diagnostic information that is already available. This will
allow diagnostic tools greater insight into which users control which
socket.

To test this, do the following as a non-root user:

    unshare -U -r bash
    nc -l -U user.socket.$$ &

.. and verify from within that same session that Netlink UNIX socket
diagnostics report the socket's UID as 0. Also verify that Netlink UNIX
socket diagnostics report the socket's UID as the user's UID from an
unprivileged process in a different session. Verify the same from
a root process.

Signed-off-by: Felipe Gasper <felipe@felipegasper.com>

diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag.h
index 5c502fd..a198857 100644
--- a/include/uapi/linux/unix_diag.h
+++ b/include/uapi/linux/unix_diag.h
@@ -20,6 +20,7 @@ struct unix_diag_req {
 #define UDIAG_SHOW_ICONS	0x00000008	/* show pending connections */
 #define UDIAG_SHOW_RQLEN	0x00000010	/* show skb receive queue len */
 #define UDIAG_SHOW_MEMINFO	0x00000020	/* show memory info of a socket */
+#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
 
 struct unix_diag_msg {
 	__u8	udiag_family;
@@ -40,6 +41,7 @@ enum {
 	UNIX_DIAG_RQLEN,
 	UNIX_DIAG_MEMINFO,
 	UNIX_DIAG_SHUTDOWN,
+	UNIX_DIAG_UID,
 
 	__UNIX_DIAG_MAX,
 };
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 3183d9b..e40f348 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -4,9 +4,11 @@
 #include <linux/unix_diag.h>
 #include <linux/skbuff.h>
 #include <linux/module.h>
+#include <linux/uidgid.h>
 #include <net/netlink.h>
 #include <net/af_unix.h>
 #include <net/tcp_states.h>
+#include <net/sock.h>
 
 static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 {
@@ -110,6 +112,12 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+{
+	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
+}
+
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
 		u32 portid, u32 seq, u32 flags, int sk_ino)
 {
@@ -156,6 +164,10 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
 		goto out_nlmsg_trim;
 
+	if ((req->udiag_show & UDIAG_SHOW_UID) &&
+	    sk_diag_dump_uid(sk, skb))
+		goto out_nlmsg_trim;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
