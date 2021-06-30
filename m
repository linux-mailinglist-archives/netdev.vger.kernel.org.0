Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CEA3B7E8C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhF3IEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:04:22 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37522 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhF3IEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:04:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5A8041A2698;
        Wed, 30 Jun 2021 10:01:36 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E70E11A16B5;
        Wed, 30 Jun 2021 10:01:35 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 2D78D183AC99;
        Wed, 30 Jun 2021 16:01:33 +0800 (+08)
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
Subject: [net-next, v5, 10/11] selftests/net: timestamping: support binding PHC
Date:   Wed, 30 Jun 2021 16:12:01 +0800
Message-Id: <20210630081202.4423-11-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210630081202.4423-1-yangbo.lu@nxp.com>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support binding PHC of PTP vclock for timestamping.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
Changes for v4:
	- Fixed checkpatch.
Changes for v5:
	- Dropped wrong conditional compile.
---
 tools/testing/selftests/net/timestamping.c | 55 ++++++++++++++--------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
index 21091be70688..aee631c5284e 100644
--- a/tools/testing/selftests/net/timestamping.c
+++ b/tools/testing/selftests/net/timestamping.c
@@ -47,7 +47,7 @@ static void usage(const char *error)
 {
 	if (error)
 		printf("invalid option: %s\n", error);
-	printf("timestamping interface option*\n\n"
+	printf("timestamping <interface> [bind_phc_index] [option]*\n\n"
 	       "Options:\n"
 	       "  IP_MULTICAST_LOOP - looping outgoing multicasts\n"
 	       "  SO_TIMESTAMP - normal software time stamping, ms resolution\n"
@@ -58,6 +58,7 @@ static void usage(const char *error)
 	       "  SOF_TIMESTAMPING_RX_SOFTWARE - software fallback for incoming packets\n"
 	       "  SOF_TIMESTAMPING_SOFTWARE - request reporting of software time stamps\n"
 	       "  SOF_TIMESTAMPING_RAW_HARDWARE - request reporting of raw HW time stamps\n"
+	       "  SOF_TIMESTAMPING_BIND_PHC - request to bind a PHC of PTP vclock\n"
 	       "  SIOCGSTAMP - check last socket time stamp\n"
 	       "  SIOCGSTAMPNS - more accurate socket time stamp\n"
 	       "  PTPV2 - use PTPv2 messages\n");
@@ -311,7 +312,6 @@ static void recvpacket(int sock, int recvmsg_flags,
 
 int main(int argc, char **argv)
 {
-	int so_timestamping_flags = 0;
 	int so_timestamp = 0;
 	int so_timestampns = 0;
 	int siocgstamp = 0;
@@ -325,6 +325,8 @@ int main(int argc, char **argv)
 	struct ifreq device;
 	struct ifreq hwtstamp;
 	struct hwtstamp_config hwconfig, hwconfig_requested;
+	struct so_timestamping so_timestamping_get = { 0, -1 };
+	struct so_timestamping so_timestamping = { 0, -1 };
 	struct sockaddr_in addr;
 	struct ip_mreq imr;
 	struct in_addr iaddr;
@@ -342,7 +344,12 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	for (i = 2; i < argc; i++) {
+	if (argc >= 3 && sscanf(argv[2], "%d", &so_timestamping.bind_phc) == 1)
+		val = 3;
+	else
+		val = 2;
+
+	for (i = val; i < argc; i++) {
 		if (!strcasecmp(argv[i], "SO_TIMESTAMP"))
 			so_timestamp = 1;
 		else if (!strcasecmp(argv[i], "SO_TIMESTAMPNS"))
@@ -356,17 +363,19 @@ int main(int argc, char **argv)
 		else if (!strcasecmp(argv[i], "PTPV2"))
 			ptpv2 = 1;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_TX_HARDWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_TX_HARDWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_TX_HARDWARE;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_TX_SOFTWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_TX_SOFTWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_TX_SOFTWARE;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_RX_HARDWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_RX_HARDWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_RX_HARDWARE;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_RX_SOFTWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_RX_SOFTWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_RX_SOFTWARE;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_SOFTWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_SOFTWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_SOFTWARE;
 		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_RAW_HARDWARE"))
-			so_timestamping_flags |= SOF_TIMESTAMPING_RAW_HARDWARE;
+			so_timestamping.flags |= SOF_TIMESTAMPING_RAW_HARDWARE;
+		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_BIND_PHC"))
+			so_timestamping.flags |= SOF_TIMESTAMPING_BIND_PHC;
 		else
 			usage(argv[i]);
 	}
@@ -385,10 +394,10 @@ int main(int argc, char **argv)
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
-		(so_timestamping_flags & SOF_TIMESTAMPING_TX_HARDWARE) ?
+		(so_timestamping.flags & SOF_TIMESTAMPING_TX_HARDWARE) ?
 		HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
 	hwconfig.rx_filter =
-		(so_timestamping_flags & SOF_TIMESTAMPING_RX_HARDWARE) ?
+		(so_timestamping.flags & SOF_TIMESTAMPING_RX_HARDWARE) ?
 		ptpv2 ? HWTSTAMP_FILTER_PTP_V2_L4_SYNC :
 		HWTSTAMP_FILTER_PTP_V1_L4_SYNC : HWTSTAMP_FILTER_NONE;
 	hwconfig_requested = hwconfig;
@@ -413,6 +422,9 @@ int main(int argc, char **argv)
 		 sizeof(struct sockaddr_in)) < 0)
 		bail("bind");
 
+	if (setsockopt(sock, SOL_SOCKET, SO_BINDTODEVICE, interface, if_len))
+		bail("bind device");
+
 	/* set multicast group for outgoing packets */
 	inet_aton("224.0.1.130", &iaddr); /* alternate PTP domain 1 */
 	addr.sin_addr = iaddr;
@@ -444,10 +456,9 @@ int main(int argc, char **argv)
 			   &enabled, sizeof(enabled)) < 0)
 		bail("setsockopt SO_TIMESTAMPNS");
 
-	if (so_timestamping_flags &&
-		setsockopt(sock, SOL_SOCKET, SO_TIMESTAMPING,
-			   &so_timestamping_flags,
-			   sizeof(so_timestamping_flags)) < 0)
+	if (so_timestamping.flags &&
+	    setsockopt(sock, SOL_SOCKET, SO_TIMESTAMPING, &so_timestamping,
+		       sizeof(so_timestamping)) < 0)
 		bail("setsockopt SO_TIMESTAMPING");
 
 	/* request IP_PKTINFO for debugging purposes */
@@ -468,14 +479,18 @@ int main(int argc, char **argv)
 	else
 		printf("SO_TIMESTAMPNS %d\n", val);
 
-	if (getsockopt(sock, SOL_SOCKET, SO_TIMESTAMPING, &val, &len) < 0) {
+	len = sizeof(so_timestamping_get);
+	if (getsockopt(sock, SOL_SOCKET, SO_TIMESTAMPING, &so_timestamping_get,
+		       &len) < 0) {
 		printf("%s: %s\n", "getsockopt SO_TIMESTAMPING",
 		       strerror(errno));
 	} else {
-		printf("SO_TIMESTAMPING %d\n", val);
-		if (val != so_timestamping_flags)
-			printf("   not the expected value %d\n",
-			       so_timestamping_flags);
+		printf("SO_TIMESTAMPING flags %d, bind phc %d\n",
+		       so_timestamping_get.flags, so_timestamping_get.bind_phc);
+		if (so_timestamping_get.flags != so_timestamping.flags ||
+		    so_timestamping_get.bind_phc != so_timestamping.bind_phc)
+			printf("   not expected, flags %d, bind phc %d\n",
+			       so_timestamping.flags, so_timestamping.bind_phc);
 	}
 
 	/* send packets forever every five seconds */
-- 
2.25.1

