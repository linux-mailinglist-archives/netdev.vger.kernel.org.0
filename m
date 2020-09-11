Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67522664FB
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIKQtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:49:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60046 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726361AbgIKPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RfLpjdNwvP4oDkLx7yFMIC9ktPxDvmhr2AAximMjnME=;
        b=CXQoaaTK8G0W7RGCsB0w75lBzU9Y04BOzw0Ij78BvTMIhtAlb1kPQ0TlvRApyo/Q3op+ul
        FMzJTWXbbNs/e4NNsgVhmX+Ar6+TFtCI1RWrJ4Ce5em9M8zx8EW+waGeWQp45zrX0xicMv
        1za9UKMbRW0b5KhKE8feCEDaWBaHbKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-IULedvSjOe-8SEqJvMqGzQ-1; Fri, 11 Sep 2020 09:52:28 -0400
X-MC-Unique: IULedvSjOe-8SEqJvMqGzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2973A1017DCC;
        Fri, 11 Sep 2020 13:52:27 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE6A95C1BD;
        Fri, 11 Sep 2020 13:52:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 00/13] mptcp: introduce support for real multipath xmit
Date:   Fri, 11 Sep 2020 15:51:55 +0200
Message-Id: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enable MPTCP socket to transmit data on multiple subflows
concurrently in a load balancing scenario.

First the receive code path is refactored to better deal with out-of-order
data (patches 1-7). An RB-tree is introduced to queue MPTCP-level out-of-order
data, closely resembling the TCP level OoO handling.

When data is sent on multiple subflows, the peer can easily see OoO - "future"
data at the MPTCP level, especially if speeds, delay, or jitter are not
symmetric.

The other major change regards the netlink PM, which is extended to allow
creating non backup subflows in patches 9-11.

There are a few smaller additions, like the introduction of OoO related mibs,
send buffer autotuning and better ack handling.

Finally a bunch of new self-tests is introduced. The new feature is tested
ensuring that the B/W used by an MPTCP socket using multiple subflows matches
the link aggregated B/W - we use low B/W virtual links, to ensure the tests
are not CPU bounded.

Paolo Abeni (13):
  mptcp: rethink 'is writable' conditional
  mptcp: set data_ready status bit in subflow_check_data_avail()
  mptcp: trigger msk processing even for OoO data
  mptcp: basic sndbuf autotuning
  mptcp: introduce and use mptcp_try_coalesce()
  mptcp: move ooo skbs into msk out of order queue.
  mptcp: cleanup mptcp_subflow_discard_data()
  mptcp: add OoO related mibs
  mptcp: move address attribute into mptcp_addr_info
  mptcp: allow creating non-backup subflows
  mptcp: allow picking different xmit subflows
  mptcp: call tcp_cleanup_rbuf on subflows
  mptcp: simult flow self-tests

 include/net/tcp.h                             |   2 +
 net/ipv4/tcp.c                                |   2 +-
 net/mptcp/mib.c                               |   5 +
 net/mptcp/mib.h                               |   5 +
 net/mptcp/pm_netlink.c                        |  39 +-
 net/mptcp/protocol.c                          | 509 ++++++++++++++----
 net/mptcp/protocol.h                          |  21 +-
 net/mptcp/subflow.c                           |  99 ++--
 tools/testing/selftests/net/mptcp/Makefile    |   3 +-
 .../selftests/net/mptcp/simult_flows.sh       | 293 ++++++++++
 10 files changed, 796 insertions(+), 182 deletions(-)
 create mode 100755 tools/testing/selftests/net/mptcp/simult_flows.sh

-- 
2.26.2

