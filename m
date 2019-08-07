Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6757856AB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 01:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbfHGXzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 19:55:16 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:48330 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729624AbfHGXzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 19:55:16 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x77NkmCi003861;
        Thu, 8 Aug 2019 00:55:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=Mh5QuKNIA8WBCkTQjyjKquagyT4tXjVmJA7lpd65Aco=;
 b=itxFaIww2hfLvtcQPJ3LH+9gyKkQM65V3OskNaopki5HVeC1TPEV+EDCDGeKmZZP+FGJ
 rvRJbKQYGc/rtTIktF6rMNOrjMPCkWlzvtsbl8hl6KsIlpk9Ix7eqcB0+ggFnQt3lxbF
 P97YvrkATehDocezNrYlKJFum/XZ0K3q0NTZjfNYqcVjcNVdgNdu6e2LTiIK2UlcDB6M
 3VsTLlRh+e/wsgvFt+5fCPiWDbu0788gb91rPqz1ndkfUnTIIzSYppJzuCcYSzyGUmgb
 N9NJxU+gPDXyjRxH4shtU1ugqBDZdhlhtNd4BU7qdsEkC2+pOlcp5JEf5YhfIbA+8W7W 9g== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2u52p8kwsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 00:55:11 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x77Nm3bW013521;
        Wed, 7 Aug 2019 19:55:10 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2u55kw81pg-1;
        Wed, 07 Aug 2019 19:55:10 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id BCE562926C;
        Wed,  7 Aug 2019 23:55:09 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1hvVm7-0000N9-Sk; Wed, 07 Aug 2019 19:55:23 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 1/2] tcp: add new tcp_mtu_probe_floor sysctl
Date:   Wed,  7 Aug 2019 19:52:29 -0400
Message-Id: <1565221950-1376-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=638
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070211
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-07_07:2019-08-07,2019-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=635
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908070211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation of TCP MTU probing can considerably
underestimate the MTU on lossy connections allowing the MSS to get down to
48. We have found that in almost all of these cases on our networks these
paths can handle much larger MTUs meaning the connections are being
artificially limited. Even though TCP MTU probing can raise the MSS back up
we have seen this not to be the case causing connections to be "stuck" with
an MSS of 48 when heavy loss is present.

Prior to pushing out this change we could not keep TCP MTU probing enabled
b/c of the above reasons. Now with a reasonble floor set we've had it
enabled for the past 6 months.

The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
administrators the ability to control the floor of MSS probing.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 Documentation/networking/ip-sysctl.txt | 6 ++++++
 include/net/netns/ipv4.h               | 1 +
 net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
 net/ipv4/tcp_ipv4.c                    | 1 +
 net/ipv4/tcp_timer.c                   | 2 +-
 5 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index df33674799b5..49e95f438ed7 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
 	Path MTU discovery (MTU probing).  If MTU probing is enabled,
 	this is the initial MSS used by the connection.
 
+tcp_mtu_probe_floor - INTEGER
+	If MTU probing is enabled this caps the minimum MSS used for search_low
+	for the connection.
+
+	Default : 48
+
 tcp_min_snd_mss - INTEGER
 	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
 	as described in RFC 1122 and RFC 6691.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index bc24a8ec1ce5..c0c0791b1912 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -116,6 +116,7 @@ struct netns_ipv4 {
 	int sysctl_tcp_l3mdev_accept;
 #endif
 	int sysctl_tcp_mtu_probing;
+	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0b980e841927..59ded25acd04 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra2		= &tcp_min_snd_mss_max,
 	},
 	{
+		.procname	= "tcp_mtu_probe_floor",
+		.data		= &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_min_snd_mss_min,
+		.extra2		= &tcp_min_snd_mss_max,
+	},
+	{
 		.procname	= "tcp_probe_threshold",
 		.data		= &init_net.ipv4.sysctl_tcp_probe_threshold,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d57641cb3477..e0a372676329 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
+	net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
 
 	net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
 	net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index c801cd37cc2a..dbd9d2d0ee63 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	} else {
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
-		mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
+		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
 		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
-- 
2.7.4

