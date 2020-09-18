Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA182703EB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRSZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:25:02 -0400
Received: from mail.efficios.com ([167.114.26.124]:59976 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:25:02 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 14:25:01 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 269702720C9;
        Fri, 18 Sep 2020 14:18:09 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id uwwoz7vMsGlG; Fri, 18 Sep 2020 14:18:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B404D272278;
        Fri, 18 Sep 2020 14:18:08 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B404D272278
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600453088;
        bh=MU6thkWVkKoS8dDf7JdBpCGYTgh4e+6N89rnMjYFM+g=;
        h=From:To:Date:Message-Id;
        b=ONzbpc8OLZOyEIfj0MYaKRYW5hzVGb7wqVLZWa3nSpS4UcQ2Mw3ztAnP4i6QJRb2R
         JYy/WRXrn/STTtbZ2JkNi+aTHWjxg2Q9DaMUJrTqoRFI957kjwHNsWxFFJogudh+ew
         tgHgi7uDcBOgi2Np6pMlfp1imTchbuLosdCHg90IaH9N2gn8TiGds9p/VuWnr9MIvK
         kI0QWkeAVmvhltNM0zVl9HcZAR+J/ymu7DA6LZAEZcelahj8oGcUU8mQgfhWIi0OiR
         Yc+WvOwR6byzL7kpDbBq+u5whjrVhG0q8dPxpzWG7Vf/rOXhTN0raXqd1szRvySGfw
         Sc9xewFdRzztw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VbkxNHjadDP4; Fri, 18 Sep 2020 14:18:08 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 6D31D2727B0;
        Fri, 18 Sep 2020 14:18:08 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
Date:   Fri, 18 Sep 2020 14:17:58 -0400
Message-Id: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is an updated series of fixes for ipv4 and ipv6 which which ensure
the route lookup is performed on the right routing table in VRF
configurations when sending TTL expired icmp errors (useful for
traceroute).

It includes tests for both ipv4 and ipv6.

These fixes address specifically address the code paths involved in
sending TTL expired icmp errors. As detailed in the individual commit
messages, those fixes do not address similar issues related to network
namespaces and unreachable / fragmentation needed messages, which appear
to use different code paths.

Thanks,

Mathieu


Mathieu Desnoyers (2):
  ipv4/icmp: l3mdev: Perform icmp error route lookup on source device
    routing table (v2)
  ipv6/icmp: l3mdev: Perform icmp error route lookup on source device
    routing table (v2)

Michael Jeanson (1):
  selftests: Add VRF icmp error route lookup test

 net/ipv4/icmp.c                               |  23 +-
 net/ipv6/icmp.c                               |   7 +-
 net/ipv6/ip6_output.c                         |   2 -
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/vrf_icmp_error_route.sh     | 475 ++++++++++++++++++
 5 files changed, 502 insertions(+), 6 deletions(-)
 create mode 100755 tools/testing/selftests/net/vrf_icmp_error_route.sh

-- 
2.17.1

