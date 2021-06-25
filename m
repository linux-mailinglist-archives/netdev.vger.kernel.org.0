Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B361E3B406C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFYJ1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:22 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53592 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231491AbhFYJ1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:27:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D015C20073C;
        Fri, 25 Jun 2021 11:24:44 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 968CD2006F5;
        Fri, 25 Jun 2021 11:24:44 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id E96A8183ACDF;
        Fri, 25 Jun 2021 17:24:42 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v4, 09/11] net: socket: support hardware timestamp conversion to PHC bound
Date:   Fri, 25 Jun 2021 17:35:11 +0800
Message-Id: <20210625093513.38524-10-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to support hardware timestamp conversion to
PHC bound. This applies to both RX and TX since their skb
handling (for TX, it's skb clone in error queue) all goes
through __sock_recv_timestamp.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
Changes for v4:
	- None.
---
 net/socket.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index bd9233da2497..0b2dad3bdf7f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -104,6 +104,7 @@
 #include <linux/sockios.h>
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
+#include <linux/ptp_clock_kernel.h>
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
@@ -873,12 +874,18 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 		empty = 0;
 	if (shhwtstamps &&
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
-	    !skb_is_swtx_tstamp(skb, false_tstamp) &&
-	    ktime_to_timespec64_cond(shhwtstamps->hwtstamp, tss.ts + 2)) {
-		empty = 0;
-		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
-		    !skb_is_err_queue(skb))
-			put_ts_pktinfo(msg, skb);
+	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
+		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
+			ptp_convert_timestamp(shhwtstamps, sk->sk_bind_phc);
+
+		if (ktime_to_timespec64_cond(shhwtstamps->hwtstamp,
+					     tss.ts + 2)) {
+			empty = 0;
+
+			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
+			    !skb_is_err_queue(skb))
+				put_ts_pktinfo(msg, skb);
+		}
 	}
 	if (!empty) {
 		if (sock_flag(sk, SOCK_TSTAMP_NEW))
-- 
2.25.1

