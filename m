Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1665212A8
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 05:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfEQDx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 23:53:27 -0400
Received: from web1.siteocity.com ([67.227.147.204]:43164 "EHLO
        web1.siteocity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfEQDx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 23:53:27 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2019 23:53:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=felipegasper.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j63K5kt/+ZVwWL7v54vZ6nKLjjvImcbcZCJ95gUcFYo=; b=mhIVdWYFz7zvgarpgJTIsHK+97
        6+Nh7rY9O/brQjWXyQ+OooEg7lJD4E9RDd11r0v2mK+ItdCLV/4Kg9SzpGYdF/GVFH9KiCNQof/Mr
        AqbyWO9GzUvVdmYtzMzkhqdUwmM/H5BodILF3bEwxsDqpMYZuyFXRc4uy+UORbXzlvbouzw3kA1JT
        SI/Y82H5kiD1bB9+kpm9P9zYwOL0kRPVsRnN88K7we/dUoCst3KTemNsSHjwvHQPDmo9I5FaQNsO6
        VRcQTS+SH++NNZgrMFsrnQd+dF2gRprnDRLLeglrsWrKxN0O7hw9RLh9eJRzneZW8JXghfc9ALN7w
        b0J3B3sQ==;
Received: from fgasper by web1.siteocity.com with local (Exim 4.92)
        (envelope-from <fgasper@web1.siteocity.com>)
        id 1hRTUX-0005Sf-Cv; Thu, 16 May 2019 22:25:06 -0500
From:   Felipe <felipe@felipegasper.com>
To:     davem@davemloft.net, felipe@felipegasper.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH] Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date:   Thu, 16 May 2019 22:25:05 -0500
Message-Id: <20190517032505.19921-1-felipe@felipegasper.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Author: Felipe Gasper <felipe@felipegasper.com>
Date:   Thu May 16 12:16:53 2019 -0500

    Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
    
    This adds the ability for Netlink to report a socket’s UID along with the
    other UNIX socket diagnostic information that is already available. This will
    allow diagnostic tools greater insight into which users control which socket.
    
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
index 3183d9b..011f56c 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -110,6 +110,11 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+{
+	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(kuid_t), &(sk->sk_uid));
+}
+
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
 		u32 portid, u32 seq, u32 flags, int sk_ino)
 {
@@ -156,6 +161,10 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
 		goto out_nlmsg_trim;
 
+	if ((req->udiag_show & UDIAG_SHOW_UID) &&
+	    sk_diag_dump_uid(sk, skb))
+		goto out_nlmsg_trim;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
