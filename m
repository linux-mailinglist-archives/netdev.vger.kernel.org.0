Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD26263EE5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIJHmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:42:14 -0400
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:36812 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbgIJHmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:42:06 -0400
X-Greylist: delayed 9251 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2020 03:42:06 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 08A52hWL012174;
        Wed, 9 Sep 2020 22:07:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=AyKTaeRXo/ZStMqWMSR+Dnj3SPrRF2ZKakJGQExEkOY=;
 b=S9VcpEq2AIWPTd+t8rkgmIkp0rC8lZT8iEIZnwUYLwQbD7C/F88fkw7VeB4Ehlphp0fi
 +703Dl2Eiw1xFksogH+MI13W93ORqMxKzysU7UioaTZrmD2ppWgvw05mnc32EBDjH8M0
 YbzgBPE3DDNYAY42kqni+z3x2w0xCHDP8O7V1hFLdNIhysD5KxC/MUho1djXgDXDsMWj
 rRltx/EZEvipbFks+jQHRO/qlAm8B5kg8//SJGzu09IndIAz+gIUKUDC1FVe08mnrybW
 GmQuT0/9BRx5U/BwEY4Z2WiYziNOYqJdLSqX79Ln+zVK5ILO1yicjSgoHxAUFR1vN69g UQ== 
Received: from rn-mailsvcp-mta-lapp02.rno.apple.com (rn-mailsvcp-mta-lapp02.rno.apple.com [10.225.203.150])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 33f2rwucpd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 09 Sep 2020 22:07:47 -0700
Received: from rn-mailsvcp-mmp-lapp03.rno.apple.com
 (rn-mailsvcp-mmp-lapp03.rno.apple.com [17.179.253.16])
 by rn-mailsvcp-mta-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) with ESMTPS id <0QGF0085PFKYT0G0@rn-mailsvcp-mta-lapp02.rno.apple.com>;
 Wed, 09 Sep 2020 22:07:46 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp03.rno.apple.com by
 rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QGF00800F7S5500@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Wed,
 09 Sep 2020 22:07:46 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 4e7bf050be79564d12c120994538f9bb
X-Va-E-CD: f90bb529766a28149b4faa9b3b180bdf
X-Va-R-CD: 0d56a4dbf3bc1c9a1a65176640281ffd
X-Va-CD: 0
X-Va-ID: f968c2fb-cc6a-4722-8fc2-bbea7202a66d
X-V-A:  
X-V-T-CD: 4e7bf050be79564d12c120994538f9bb
X-V-E-CD: f90bb529766a28149b4faa9b3b180bdf
X-V-R-CD: 0d56a4dbf3bc1c9a1a65176640281ffd
X-V-CD: 0
X-V-ID: cf5e406d-1315-43af-8df5-099af80855cf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-09 signatures=0
Received: from localhost ([17.234.110.28])
 by rn-mailsvcp-mmp-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QGF00CZMFKXN700@rn-mailsvcp-mmp-lapp03.rno.apple.com>; Wed,
 09 Sep 2020 22:07:46 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH] selftests/mptcp: Better delay & reordering configuration
Date:   Wed, 09 Sep 2020 22:07:36 -0700
Message-id: <20200910050736.377-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The delay was intended to be configured to "simulate" a high(er) BDP
link. As such, it needs to be set as part of the loss-configuration and
not as part of the netem reordering configuration.

The reordering-config also requires a delay but that delay is the
reordering-extend. So, a good approach is to set the reordering-extend
as a function of the configured latency. E.g., 25% of the overall
latency.

To speed up the selftests, we limit the delay to 50ms maximum to avoid
having the selftests run for too long.

Finally, the intention of tc_reorder was that when it is unset, the test
picks a random configuration. However, currently it is always initialized
and thus the random config won't be picked up.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/6
Reported-and-reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh        | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 57d75b7f6220..e4df9ba64824 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -14,9 +14,8 @@ capture=false
 timeout=30
 ipv6=true
 ethtool_random_on=true
-tc_delay="$((RANDOM%400))"
+tc_delay="$((RANDOM%50))"
 tc_loss=$((RANDOM%101))
-tc_reorder=""
 testmode=""
 sndbuf=0
 rcvbuf=0
@@ -628,30 +627,32 @@ for sender in "$ns1" "$ns2" "$ns3" "$ns4";do
 	do_ping "$ns4" $sender dead:beef:3::1
 done
 
-[ -n "$tc_loss" ] && tc -net "$ns2" qdisc add dev ns2eth3 root netem loss random $tc_loss
+[ -n "$tc_loss" ] && tc -net "$ns2" qdisc add dev ns2eth3 root netem loss random $tc_loss delay ${tc_delay}ms
 echo -n "INFO: Using loss of $tc_loss "
 test "$tc_delay" -gt 0 && echo -n "delay $tc_delay ms "
 
+reorder_delay=$(($tc_delay / 4))
+
 if [ -z "${tc_reorder}" ]; then
 	reorder1=$((RANDOM%10))
 	reorder1=$((100 - reorder1))
 	reorder2=$((RANDOM%100))
 
-	if [ $tc_delay -gt 0 ] && [ $reorder1 -lt 100 ] && [ $reorder2 -gt 0 ]; then
+	if [ $reorder_delay -gt 0 ] && [ $reorder1 -lt 100 ] && [ $reorder2 -gt 0 ]; then
 		tc_reorder="reorder ${reorder1}% ${reorder2}%"
-		echo -n "$tc_reorder "
+		echo -n "$tc_reorder with delay ${reorder_delay}ms "
 	fi
 elif [ "$tc_reorder" = "0" ];then
 	tc_reorder=""
-elif [ "$tc_delay" -gt 0 ];then
+elif [ "$reorder_delay" -gt 0 ];then
 	# reordering requires some delay
 	tc_reorder="reorder $tc_reorder"
-	echo -n "$tc_reorder "
+	echo -n "$tc_reorder with delay ${reorder_delay}ms "
 fi
 
 echo "on ns3eth4"
 
-tc -net "$ns3" qdisc add dev ns3eth4 root netem delay ${tc_delay}ms $tc_reorder
+tc -net "$ns3" qdisc add dev ns3eth4 root netem delay ${reorder_delay}ms $tc_reorder
 
 for sender in $ns1 $ns2 $ns3 $ns4;do
 	run_tests_lo "$ns1" "$sender" 10.0.1.1 1
-- 
2.23.0

