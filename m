Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3291DD505
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbgEURs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbgEURsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:48:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2F9C061A0E;
        Thu, 21 May 2020 10:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Sd+3/PB7POgHUMs6w6WsFWk89mGAgCLuwcIRH4Naaf8=; b=qy/pSGQ0doHi3IbopS3sS6ykRk
        z+ygodANbd5S2hsFCcqvO03TtqVdJGtMJa+IHs6Vv6/6W3dmSXb+tgFqcjbCiOHN2HI6GDcaQtDnp
        R5x2fADiRZeFHdQlXw30kjwS2/rqt0eBpOcnNjl9M10YG6rSaUAvc9O4kj3SjZOe4LmzWjjDtwuck
        7899dZpibjwVoSUgA4ccY1XEevkGmaCnfOG3dMZYuMB8CqpghXHiRZD6bva7JOL1E3WXkkbJ6h+83
        HM+o2hdX+DmNXsk2cnv7F6qUNoym6w5eXexlRX/j6q3nR3BXV2FNm/UCdluhXrPeQDiBSwY140/Jd
        iRcWX+OQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbpJI-0003Kv-PB; Thu, 21 May 2020 17:48:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 30/49] sctp: pass a kernel pointer to sctp_setsockopt_auto_asconf
Date:   Thu, 21 May 2020 19:47:05 +0200
Message-Id: <20200521174724.2635475-31-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
References: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1631760e4b0af..04eac086831f0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3803,26 +3803,23 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
  * Note. In this implementation, socket operation overrides default parameter
  * being set by sysctl as well as FreeBSD implementation
  */
-static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_auto_asconf(struct sock *sk, int *val,
 					unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (!sctp_is_ep_boundall(sk) && val)
+	if (!sctp_is_ep_boundall(sk) && *val)
 		return -EINVAL;
-	if ((val && sp->do_auto_asconf) || (!val && !sp->do_auto_asconf))
+	if ((*val && sp->do_auto_asconf) || (!*val && !sp->do_auto_asconf))
 		return 0;
 
 	spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
-	if (val == 0 && sp->do_auto_asconf) {
+	if (*val == 0 && sp->do_auto_asconf) {
 		list_del(&sp->auto_asconf_list);
 		sp->do_auto_asconf = 0;
-	} else if (val && !sp->do_auto_asconf) {
+	} else if (*val && !sp->do_auto_asconf) {
 		list_add_tail(&sp->auto_asconf_list,
 		    &sock_net(sk)->sctp.auto_asconf_splist);
 		sp->do_auto_asconf = 1;
@@ -4686,7 +4683,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_deactivate_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTO_ASCONF:
-		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
+		retval = sctp_setsockopt_auto_asconf(sk, kopt, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
 		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
-- 
2.26.2

