Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B331643D6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgBSMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:03:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57487 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgBSMDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 07:03:02 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j4O4A-00028x-UM; Wed, 19 Feb 2020 12:02:59 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Haw Loeung <haw.loeung@canonical.com>
Subject: [PATCH net-next] net/ipv4/sysctl: show tcp_{allowed,available}_congestion_control in non-initial netns
Date:   Wed, 19 Feb 2020 13:02:53 +0100
Message-Id: <20200219120253.2667548-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is currenty possible to switch the TCP congestion control algorithm
in non-initial network namespaces:

unshare -U --map-root --net --fork --pid --mount-proc
echo "reno" > /proc/sys/net/ipv4/tcp_congestion_control

works just fine. But currently non-initial network namespaces have no
way of kowing which congestion algorithms are available or allowed other
than through trial and error by writing the names of the algorithms into
the aforementioned file.
Since we already allow changing the congestion algorithm in non-initial
network namespaces by exposing the tcp_congestion_control file there is
no reason to not also expose the
tcp_{allowed,available}_congestion_control files to non-initial network
namespaces. After this change a container with a separate network
namespace will show:

root@f1:~# ls -al /proc/sys/net/ipv4/tcp_* | grep congestion
-rw-r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_allowed_congestion_control
-r--r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_available_congestion_control
-rw-r--r-- 1 root root 0 Feb 19 11:54 /proc/sys/net/ipv4/tcp_congestion_control

Link: https://github.com/lxc/lxc/issues/3267
Reported-by: Haw Loeung <haw.loeung@canonical.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 net/ipv4/sysctl_net_ipv4.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9684af02e0a5..d9531b4b33f2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -554,18 +554,6 @@ static struct ctl_table ipv4_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif /* CONFIG_NETLABEL */
-	{
-		.procname	= "tcp_available_congestion_control",
-		.maxlen		= TCP_CA_BUF_MAX,
-		.mode		= 0444,
-		.proc_handler   = proc_tcp_available_congestion_control,
-	},
-	{
-		.procname	= "tcp_allowed_congestion_control",
-		.maxlen		= TCP_CA_BUF_MAX,
-		.mode		= 0644,
-		.proc_handler   = proc_allowed_congestion_control,
-	},
 	{
 		.procname	= "tcp_available_ulp",
 		.maxlen		= TCP_ULP_BUF_MAX,
@@ -885,6 +873,18 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= TCP_CA_NAME_MAX,
 		.proc_handler	= proc_tcp_congestion_control,
 	},
+	{
+		.procname	= "tcp_available_congestion_control",
+		.maxlen		= TCP_CA_BUF_MAX,
+		.mode		= 0444,
+		.proc_handler   = proc_tcp_available_congestion_control,
+	},
+	{
+		.procname	= "tcp_allowed_congestion_control",
+		.maxlen		= TCP_CA_BUF_MAX,
+		.mode		= 0644,
+		.proc_handler   = proc_allowed_congestion_control,
+	},
 	{
 		.procname	= "tcp_keepalive_time",
 		.data		= &init_net.ipv4.sysctl_tcp_keepalive_time,

base-commit: bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9
-- 
2.25.0

