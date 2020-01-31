Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004C814EC6C
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgAaMYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:24:48 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:60607 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgAaMYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580473487; x=1612009487;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=hpl5HxaihywVtQY3qJ7FpPc6AopqensDSG4dnfX/kE4=;
  b=hDbr2Xsj8sUZnrPZNo+HdJJqHieeNv2DVrT2IzYQ2vfxJoOHlBa6P/xC
   OqEPGPELN75hJGseTt7GuXfptJFsB0WcfYrLCTHqSLQ4f4WGtAsUfuS0Q
   i5Yqi0v1EEVHu2ISRTCMbu1o81/fvmPbeMGXhd1wHLKQYyjWchDj3NBht
   k=;
IronPort-SDR: SWTzM1pJA56M/Sb3Op2xhMtl9Mg175MWqxvJN1x9RtAgSazWTi8en/VSkXxxJdZbH4VOty9I5+
 TeAl6Mkjv9mQ==
X-IronPort-AV: E=Sophos;i="5.70,385,1574121600"; 
   d="scan'208";a="15621072"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 Jan 2020 12:24:45 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id DD97FA21E9;
        Fri, 31 Jan 2020 12:24:43 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 12:24:43 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.50) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 12:24:38 +0000
From:   <sjpark@amazon.com>
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sj38.park@gmail.com>, <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH 0/3] Fix reconnection latency caused by FIN/ACK handling race
Date:   Fri, 31 Jan 2020 13:24:18 +0100
Message-ID: <20200131122421.23286-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

When closing a connection, the two acks that required to change closing
socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
reverse order.  This is possible in RSS disabled environments such as a
connection inside a host.

For example, expected state transitions and required packets for the
disconnection will be similar to below flow.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 		<--ACK---
	 07 FIN_WAIT_2
	 08 		<--FIN/ACK---
	 09 TIME_WAIT
	 10 		---ACK-->
	 11 					LAST_ACK
	 12 CLOSED				CLOSED

The acks in lines 6 and 8 are the acks.  If the line 8 packet is
processed before the line 6 packet, it will be just ignored as it is not
a expected packet, and the later process of the line 6 packet will
change the status of Process A to FIN_WAIT_2, but as it has already
handled line 8 packet, it will not go to TIME_WAIT and thus will not
send the line 10 packet to Process B.  Thus, Process B will left in
CLOSE_WAIT status, as below.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 				(<--ACK---)
	 07	  			(<--FIN/ACK---)
	 08 				(fired in right order)
	 09 		<--FIN/ACK---
	 10 		<--ACK---
	 11 		(processed in reverse order)
	 12 FIN_WAIT_2

Later, if the Process B sends SYN to Process A for reconnection using
the same port, Process A will responds with an ACK for the last flow,
which has no increased sequence number.  Thus, Process A will send RST,
wait for TIMEOUT_INIT (one second in default), and then try
reconnection.  If reconnections are frequent, the one second latency
spikes can be a big problem.  Below is a tcpdump results of the problem:

    14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
    14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
    14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
    /* ONE SECOND DELAY */
    15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644

Patchset Organization
---------------------

The first patch fix a trivial nit.  The second one fix the problem by
adjusting the resend delay of the SYN in the case.  Finally, the third
patch adds a user space test to reproduce this problem.

The patches are based on the v5.5.  You can also clone the complete git
tree:

    $ git clone git://github.com/sjp38/linux -b patches/finack_lat/v1

The web is also available:
https://github.com/sjp38/linux/tree/patches/finack_lat/v1

SeongJae Park (3):
  net/ipv4/inet_timewait_sock: Fix inconsistent comments
  tcp: Reduce SYN resend delay if a suspicous ACK is received
  selftests: net: Add FIN_ACK processing order related latency spike
    test

 net/ipv4/inet_timewait_sock.c                 |  1 +
 net/ipv4/tcp_input.c                          |  6 +-
 tools/testing/selftests/net/.gitignore        |  2 +
 tools/testing/selftests/net/Makefile          |  2 +
 tools/testing/selftests/net/fin_ack_lat.sh    | 42 ++++++++++
 .../selftests/net/fin_ack_lat_accept.c        | 49 +++++++++++
 .../selftests/net/fin_ack_lat_connect.c       | 81 +++++++++++++++++++
 7 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh
 create mode 100644 tools/testing/selftests/net/fin_ack_lat_accept.c
 create mode 100644 tools/testing/selftests/net/fin_ack_lat_connect.c

-- 
2.17.1

