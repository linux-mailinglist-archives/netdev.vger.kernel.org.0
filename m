Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56360225021
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgGSHXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgGSHXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1064C0619D2;
        Sun, 19 Jul 2020 00:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VzA+udS3z6Ai3MimZSYnuUCnZob7wLhl7sR+QS/D1Qc=; b=e9ImQONz+xqwvDGReHEZB5GdMB
        mly2goE3cw3x9LC+A9F21vSW32ATIgiT+LBkQjxMQzzhqGmlGNpdfx37Mm38EAm3ClNQn3pwwWaWZ
        z2NVlYHPvv4elb3i4YrULXsPEVgQp5DnfGLe1VtBX+eikIspeS7o4p9mLgLS7inBzUrPf3vdzb1Xy
        2EON/akwFgIprOdpTS0RScIXLKuYDh/ERkiEgnmuYW9Av651hsf9P/ZpouMwGlV5LsDg/Q2b4/Dcg
        +VokPs9ids1I/jsRFag9NE026+j+B66+nsbYMMSwD7HGetbdNYXrAiBXEEkNbzPGTWSTISg8EoLzT
        gazbsquA==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3fC-0000VS-TJ; Sun, 19 Jul 2020 07:23:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 31/51] sctp: pass a kernel pointer to sctp_setsockopt_auto_asconf
Date:   Sun, 19 Jul 2020 09:22:08 +0200
Message-Id: <20200719072228.112645-32-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
index ab155c15939ee8..64f2a967ddf5d3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3807,26 +3807,23 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
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
@@ -4690,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_deactivate_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTO_ASCONF:
-		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
+		retval = sctp_setsockopt_auto_asconf(sk, kopt, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
 		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
-- 
2.27.0

