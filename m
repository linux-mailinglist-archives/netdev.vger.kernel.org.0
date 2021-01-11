Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53B92F24EC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391699AbhALAZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390844AbhAKWzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:55:52 -0500
X-Greylist: delayed 1852 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jan 2021 14:55:12 PST
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28DBC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 14:55:12 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMNcKH010401;
        Mon, 11 Jan 2021 22:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=F5gTNodYxj5GCB2CiAasAHDvULOoKdfShxMNdjkfiY8=;
 b=TVJyUNhfwPRNWwuhteJCeycCRKm+tdVJcZz6VjJ/Y/UXCVGZSZC1mj+a+h2XQmFXZlSG
 AKMJmoKvBcwmogyfq66kyEyWLUHOVVgHrp7JEV37jccjaLzDJk6htCFQfeH4/zDO8nfp
 B6gNbwLhB3ciQ1QRgeWZ2p4uZjlNg+kRndBgeKumEbZ+YjF17ZHsCLucCOiGqDHHtTkH
 LGs0Xv8ur6vjTrCyOZBKrk47Do6lvsRyMWeRVpScppFPh/LH4Oi1Sxrix3ToydUb+fqG
 1uMx3MmTcHiTdW+5PvL5z2fMjIbCgrFjdsHM4V+uE1Rv/FsaxL4n3Sg0v5kpnuXL1fIw iQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 35y5m4t82h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:24:16 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BMImYr008919;
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint6.akamai.com with ESMTP id 35y8q3vt33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from USMA1EX-CAS3.msg.corp.akamai.com (172.27.123.32) by
 usma1ex-dag3mb6.msg.corp.akamai.com (172.27.123.54) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 11 Jan 2021 17:24:14 -0500
Received: from bos-lhvedt.bos01.corp.akamai.com (172.28.223.201) by
 USMA1EX-CAS3.msg.corp.akamai.com (172.27.123.32) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 17:24:14 -0500
Received: by bos-lhvedt.bos01.corp.akamai.com (Postfix, from userid 33863)
        id B4187160050; Mon, 11 Jan 2021 17:24:14 -0500 (EST)
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>,
        Heath Caldwell <hcaldwel@akamai.com>
Subject: [PATCH net-next 4/4] tcp: remove limit on initial receive window
Date:   Mon, 11 Jan 2021 17:24:11 -0500
Message-ID: <20210111222411.232916-5-hcaldwel@akamai.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210111222411.232916-1-hcaldwel@akamai.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1011
 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110125
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.61)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the 64KB limit imposed on the initial receive window.

The limit was added by commit a337531b942b ("tcp: up initial rmem to 128KB
and SYN rwin to around 64KB").

This change removes that limit so that the initial receive window can be
arbitrarily large (within existing limits and depending on the current
configuration).

The arbitrary, internal limit can interfere with research because it
irremediably restricts the receive window at the beginning of a connection
below what would be expected when explicitly configuring the receive buffer
size.

-

Here is a scenario to illustrate how the limit might cause undesirable
behavior:

Consider an installation where all parts of a network are either controlled
or sufficiently monitored and there is a desired use case where a 1MB
object is transmitted over a newly created TCP connection in a single
initial burst.

Let MSS be 1460 bytes.

The initial cwnd would need to be at least:

                |-  1048576 bytes  -|
    cwnd_init = |  ---------------  | = 719 packets
                |   1460 bytes/pkt  |

Let us say that it was determined that the network could handle bursts of
800 full sized packets at the frequency which the connections under
consideration would be expected to occur, so the sending host is configured
to use an initial cwnd of 800 for these connections.

In order for the receiver to be able to receive a 1MB burst, it needs to
have a sufficiently large receive buffer for the connection.  Considering
overhead, let us say that the receiver is configured to initially use a
receive buffer of 2148K for TCP connections:

    net.ipv4.tcp_rmem = 4096 2199552 6291456

Let rtt be 50 milliseconds.

If the entire object is sent in a single burst, then the theoretically
highest achievable throughput (discounting handshake and request) should
be:

                   bits   1048576 bytes   8 bits
    T_upperbound = ---- = ------------- * ------ =~ 168 Mbit/s
                   rtt       0.05 s       1 byte

But, if flow control limits throughput because the receive window is
initially limited to 64KB and grows at a rate of quadrupling every
rtt (maybe not accurate but seems to be optimistic from observation), we
should expect the highest achievable throughput to be limited to:

    bytes_sent = 65536 * (1 + 4)^(t / rtt)

    When bytes_sent = object size = 1048576:

    1048576 = 65536 * (1 + 4)^(t / rtt)
          t = rtt * log_5(16)

                            1048576 bytes              8 bits
    T_limited = ------------------------------------ * ------
                       /    |- rtt * log_5(16) -| \    1 byte
                rtt * ( 1 + |  ---------------- |  )
                       \    |        rtt        | /

                 1048576 bytes     8 bits
              = ---------------- * ------
                0.05 s * (1 + 2)   1 byte

              =~ 55.9 Mbit/s

In short: for this scenario, the 64KB limit on the initial receive window
increases the achievable acknowledged delivery time from 1 rtt
to (optimistically) 3 rtts, reducing the achievable throughput from
168 Mbit/s to 55.9 Mbit/s.

Here is an experimental illustration:

A time sequence chart of a packet capture taken on the sender for a
scenario similar to what is described above, where the receiver had the
64KB limit in place:

Symbols:
.:' - Data packets
_-  - Window advertised by receiver

y-axis - Relative sequence number
x-axis - Time from sending of first data packet, in seconds

3212891                                                                   _
3089318                                                                   -
2965745                                                                   -
2842172                                                                   -
2718600                                                           ________-
2595027                                                           -
2471454                                                           -
2347881                                                    --------
2224309                                                    _
2100736                                                    -
1977163                                                   --
1853590                                                   _
1730018                                                   -
1606445                                                   -
1482872                                                   -
1359300                                                   -
1235727                                                   -
1112154                                                   -
 988581                                                  _:
 865009                                   _______--------.:
 741436                                   .      :       '
 617863                                  -:
 494290                                  -:
 370718                                  .:
 247145                  --------.-------:
 123572 _________________:       '
      0 .:               '
      0.000    0.028    0.056    0.084    0.112    0.140    0.168    0.195

Note that the sender was not able to send the object in a single initial
burst and that it took around 4 rtts for the object to be fully
acknowledged.


A time sequence chart of a packet capture taken for the same scenario, but
with the limit removed:

2147035                                                                  __
2064456                                                                 _-
1981878                                                                _-
1899300                                                                -
1816721                                                               --
1734143                                                              _-
1651565                                                             _-
1568987                                                             -
1486408                                                            --
1403830                                                           _-
1321252                                                          _-
1238674                                                          -
1156095 ________________________________________________________--
1073517
 990939           :
 908360          :'
 825782         :'
 743204        .:
 660626        :
 578047       :'
 495469      :'
 412891     .:
 330313    .:
 247734    :
 165156   :'
  82578  :'
      0 .:
      0.000    0.008    0.016    0.025    0.033    0.041    0.049    0.057

Note that the sender was able to send the entire object in a single burst
and that it was fully acknowledged after a little over 1 rtt.

Signed-off-by: Heath Caldwell <hcaldwel@akamai.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1d2773cd02c8..d7ab1f5f071e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -232,7 +232,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
-		(*rcv_wnd) = min_t(u32, space, U16_MAX);
+		(*rcv_wnd) = space;
 
 	if (init_rcv_wnd)
 		*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
-- 
2.28.0

