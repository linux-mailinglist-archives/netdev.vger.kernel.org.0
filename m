Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8998A3573FA
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbhDGSKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:10:43 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:32878 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348221AbhDGSKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:10:39 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 14:10:38 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 137I49dc014753
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 7 Apr 2021 20:04:09 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC net-next 0/1] seg6: Counters for SRv6 Behaviors 
Date:   Wed,  7 Apr 2021 20:03:31 +0200
Message-Id: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides counters for SRv6 Behaviors as defined in [1],
section 6. For each SRv6 Behavior instance, counters defined in [1] are:

 - the total number of packets that have been correctly processed;
 - the total amount of traffic in bytes of all packets that have been
   correctly processed;

In addition, this patch introduces a new counter that counts the number of
packets that have NOT been properly processed (i.e. errors) by an SRv6
Behavior instance.

Counters are not only interesting for network monitoring purposes (i.e.
counting the number of packets processed by a given behavior) but they also
provide a simple tool for checking whether a behavior instance is working
as we expect or not.
Counters can be useful for troubleshooting misconfigured SRv6 networks.
Indeed, an SRv6 Behavior can silently drop packets for very different
reasons (i.e. wrong SID configuration, interfaces set with SID addresses,
etc) without any notification/message to the user.

Due to the nature of SRv6 networks, diagnostic tools such as ping and
traceroute may be ineffective: paths used for reaching a given router can
be totally different from the ones followed by probe packets. In addition,
paths are often asymmetrical and this makes it even more difficult to keep
up with the journey of the packets and to understand which behaviors are
actually processing our traffic.

When counters are enabled on an SRv6 Behavior instance, it is possible to
verify if packets are actually processed by such behavior and what is the
outcome of the processing. Therefore, the counters for SRv6 Behaviors offer
an non-invasive observability point which can be leveraged for both traffic
monitoring and troubleshooting purposes.

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters

Troubleshooting using SRv6 Behavior counters
--------------------------------------------

Let's make a brief example to see how helpful counters can be for SRv6
networks. Let's consider a node where an SRv6 End Behavior receives an SRv6
packet whose Segment Left (SL) is equal to 0. In this case, the End
Behavior (which accepts only packets with SL >= 1) discards the packet and
increases the error counter.
This information can be leveraged by the network operator for
troubleshooting. Indeed, the error counter is telling the user that the
packet:

  (i) arrived at the node;
 (ii) the packet has been taken into account by the SRv6 End behavior;
(iii) but an error has occurred during the processing.

The error (iii) could be caused by different reasons, such as wrong route
settings on the node or due to an invalid SID List carried by the SRv6
packet. Anyway, the error counter is used to exclude that the packet did
not arrive at the node or it has not been processed by the behavior at
all.

Turning on/off counters for SRv6 Behaviors
------------------------------------------

Each SRv6 Behavior instance can be configured, at the time of its creation,
to make use of counters.
This is done through iproute2 which allows the user to create an SRv6
Behavior instance specifying the optional "count" attribute as shown in the
following example:

 $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0

per-behavior counters can be shown by adding "-s" to the iproute2 command
line, i.e.:

 $ ip -s -6 route show 2001:db8::1
 2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0


####################################################


Impact of counters for SRv6 Behaviors on performance
====================================================

To determine the performance impact due to the introduction of counters in
the SRv6 Behavior subsystem, we have carried out extensive tests.

We chose to test the throughput achieved by the SRv6 End.DX2 Behavior
because, among all the other behaviors implemented so far, it reaches the
highest throughput which is around 1.5 Mpps (per core at 2.4 GHz on a
Xeon(R) CPU E5-2630 v3) on kernel 5.12-rc2 using packets of size ~ 100
bytes.

Three different tests were conducted in order to evaluate the overall
throughput of the SRv6 End.DX2 Behavior in the following scenarios:

 1) vanilla kernel (without the SRv6 Behavior counters patch) and a single
    instance of an SRv6 End.DX2 Behavior;
 2) patched kernel with SRv6 Behavior counters and a single instance of
    an SRv6 End.DX2 Behavior with counters turned off;
 3) patched kernel with SRv6 Behavior counters and a single instance of
    SRv6 End.DX2 Behavior with counters turned on.

All tests were performed on a testbed deployed on the CloudLab facilities
[2], a flexible infrastructure dedicated to scientific research on the
future of Cloud Computing.


Results of tests are shown in the following table:

Scenario (1): average 1504764,81 pps (~1504,76 kpps); std. dev 3956,82 pps
Scenario (2): average 1501469,78 pps (~1501,47 kpps); std. dev 2979,85 pps
Scenario (3): average 1501315,13 pps (~1501,32 kpps); std. dev 2956,00 pps

As can be observed, throughputs achieved in scenarios (2),(3) did not
suffer any observable degradation compared to scenario (1).

Comments, suggestions and improvements are very welcome!

Thanks,
Andrea

[2] https://www.cloudlab.us

Andrea Mayer (1):
  seg6: add counters support for SRv6 Behaviors

 include/uapi/linux/seg6_local.h |   8 ++
 net/ipv6/seg6_local.c           | 133 +++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 2 deletions(-)

-- 
2.20.1

