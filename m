Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FA3225AB
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 03:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfESBir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 21:38:47 -0400
Received: from web1.siteocity.com ([67.227.147.204]:40642 "EHLO
        web1.siteocity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfESBiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 21:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=felipegasper.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LHUYI5r/brNCMF1zXddbN6oSe+nBsFtr2AD/KlWPiRo=; b=qxcnOWjW58Pvk7n0wlmZqlhrgt
        lR0IcMmHspnA/iZ9a3vzYlz+wWkI0fc4u1UAT44DG/9XuiQG1U3dzjHyQNNSVOnMSJSTkgtm+flOl
        MIvEYtUVRrGMSXirBXLPfiiDW+IrnMaXFw7abQHkaE9fYmhIDX8o/ILbCDS3JV3AdZYdit3iqfRqE
        4zJgi/LxVfNo+rUUeQmxkUtuXtWQUkGn01k9TDAkX9xy/BjijX2K32BdPHmbj03Nlv/gCd4gYtL+7
        UBfXl3cBgCAffw2JcRhOAT0h+4CWhx6eviUYgbX/kl2uy6+H3Dcg9bqwG4PYdLGLRouayz5y0PfTb
        tmfSRrFA==;
Received: from fgasper by web1.siteocity.com with local (Exim 4.92)
        (envelope-from <fgasper@web1.siteocity.com>)
        id 1hSAmd-0005Rm-Sh; Sat, 18 May 2019 20:38:44 -0500
From:   Felipe Gasper <felipe@felipegasper.com>
To:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v3] net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date:   Sat, 18 May 2019 20:38:39 -0500
Message-Id: <20190519013839.20355-1-felipe@felipegasper.com>
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

Author: Felipe Gasper <felipe@felipegasper.com>
Date:   Sat May 18 20:04:40 2019 -0500

   net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.

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
 
