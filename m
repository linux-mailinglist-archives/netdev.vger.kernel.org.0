Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D02686B7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgINIBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:01:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50157 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726132AbgINIBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uovh2p4XZhwPfYothlb7/Hf6Xzz2AAoglZnFqQhwQxY=;
        b=OC5olQKTYdMDIa7yt4tgd9b8kSaGj7Cdni7z6guw/oF2qRBt1TncDHe9Ffybh949+5Sdo0
        qlylumrOUFAX3vOW/qvNm+K8hvwlgr/zpbEUUt/hnWxNb/2PkQbybnBClu1EevZ7PQ8Hzc
        7SQly7xdUR0S0BZyOFXHk43h45ZNKdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-uCHrL_hDP6SfSaC2nroIkA-1; Mon, 14 Sep 2020 04:01:38 -0400
X-MC-Unique: uCHrL_hDP6SfSaC2nroIkA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C248380EFBF;
        Mon, 14 Sep 2020 08:01:36 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ACE519C66;
        Mon, 14 Sep 2020 08:01:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 00/13] mptcp: introduce support for real multipath xmit
Date:   Mon, 14 Sep 2020 10:01:06 +0200
Message-Id: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

v1 -> v2:
  - fix 32 bit build breakage
  - fix a bunch of checkpatch issues

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
 net/mptcp/protocol.c                          | 511 ++++++++++++++----
 net/mptcp/protocol.h                          |  21 +-
 net/mptcp/subflow.c                           |  99 ++--
 tools/testing/selftests/net/mptcp/Makefile    |   3 +-
 .../selftests/net/mptcp/simult_flows.sh       | 293 ++++++++++
 10 files changed, 798 insertions(+), 182 deletions(-)
 create mode 100755 tools/testing/selftests/net/mptcp/simult_flows.sh

-- 
2.26.2

