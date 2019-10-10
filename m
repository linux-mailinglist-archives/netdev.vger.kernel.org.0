Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB1D1F2E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfJJEIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:08:24 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:58786 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfJJEIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:08:24 -0400
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 738C51A40556; Wed,  9 Oct 2019 21:08:24 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:08:24 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sock_get_timeout: drop unnecessary return variable
Message-ID: <20191010040824.fbauijiiyyz5dl5y@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove pointless use of size return variable by directly returning
sizes.

Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
---
 net/core/sock.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index fac2b4d80de5..e01ff0d3be95 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -333,7 +333,6 @@ EXPORT_SYMBOL(__sk_backlog_rcv);
 static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 {
 	struct __kernel_sock_timeval tv;
-	int size;
 
 	if (timeo == MAX_SCHEDULE_TIMEOUT) {
 		tv.tv_sec = 0;
@@ -354,13 +353,11 @@ static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 		old_tv.tv_sec = tv.tv_sec;
 		old_tv.tv_usec = tv.tv_usec;
 		*(struct __kernel_old_timeval *)optval = old_tv;
-		size = sizeof(old_tv);
-	} else {
-		*(struct __kernel_sock_timeval *)optval = tv;
-		size = sizeof(tv);
+		return sizeof(old_tv);
 	}
 
-	return size;
+	*(struct __kernel_sock_timeval *)optval = tv;
+	return sizeof(tv);
 }
 
 static int sock_set_timeout(long *timeo_p, char __user *optval, int optlen, bool old_timeval)
-- 
2.11.0

