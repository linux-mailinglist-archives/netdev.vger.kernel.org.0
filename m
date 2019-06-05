Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA136635
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFEVDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:03:45 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:35409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEVDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:03:44 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MAOa3-1hOPWF3A4Z-00Bt1P; Wed, 05 Jun 2019 23:03:36 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:03:27 +0200
Message-Id: <1559768607-17439-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:RDhO0c91eGQhuPk7OHIf4MDNfPy3l+iTaNUx9a50PPTwDQpqrjO
 55dpkrt7kgxoqVnayYCOjOUfNg+9htcpuYwvkAJR9gslNxD/RqsECCRyiL0zteRLcDlns2e
 TRJRVVhzG9ZWaDjd658fE9Q9zcXTW7xd1x3hAKD3RUzVVTvWFGb5PSGvbwLELA9oXMcRZu7
 vP60tsLC8L+Zk/om8bEdQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sKdrp2sgGcQ=:pvV0FiTPX8gMA1+4M/9k2f
 SQZ9FRTN2nzdQjrrAiIwDQOcMvGS5UU5GpALTkIm7l6gT0UQVvAiwdlCxbriciOLFLP+f5f/2
 oZWRx/CznID8gGaxEI15X3hIsZXjy9tMTjdddXkzcxMBc/p5/vKi49OhaPfsAWjenWlCt9tgt
 iFnody6EFvOsVzFubjoajOtU18IYuDLeI1cbWzK+RQamOhCz5Q3Ucs54k1cOAZoLLSKXNB89z
 Hw6h1jEaUMmnJwmcYuEYU2mZpzNluZFgMIWZwwqLgOsvE1222DP8YQbWSFNdk0P5MOb8Uq68E
 75r+C4X580HDQsiMeW3jf+CZh9YzoXm+e2BJ9xwq3mTc2mfHr7JSxNxU9lNXdU0qe7zsoHzWn
 04vH9A3hHD1We9M9LetXZ6aR/nbJ8ZfMs9CBkQasEqeXO/QpeEnAR3y37IswHJMerxPq7RVVr
 cEnMVDCRkkaHhZFvt3nuBf5ErYyFWF+X9SU7HNSMPDiXmV+9z+ir2pFhWExZC0AXLhEp1TCdo
 l4+HnWs/VERXoq1B7akgU2p3FjDY5iOtSUAcNBYPZiYbIbGq99bs0XxYDDarvjbkvALVXKw7G
 G9LBNWTvwuj4HefRDvTkEyALCwu+Xp0Xu49/fQ40x2J72yiwtMgqrWLjumSYSUMHopj9e4hcw
 kxGqIAWCzjzkV/Sk7PulRGphC/K1hyvKNeP1ZYok78CMw4lpDu53G8A/NxQeJM4WYRW4HxBeu
 V3QXqsxzIa4IGcun/P35h1OYvJ5+krxd2gWC7SxDAIPWoXvQPraqY3zIoig=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 39ea0a3..c7b0f51 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Walk through the addrs buffer and count the number of addresses. */
@@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Allow security module to validate connectx addresses. */
-- 
1.9.1

