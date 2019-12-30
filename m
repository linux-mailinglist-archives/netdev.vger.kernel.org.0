Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16E912D4C8
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfL3WTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727734AbfL3WTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:34 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C699F20663;
        Mon, 30 Dec 2019 22:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743878;
        bh=NyJxuSbkq2Kpbb5d2SCH6RAqhGEjRL1DCYaZI54Nlrs=;
        h=From:To:Cc:Subject:Date:From;
        b=jsYJjZ25qKttM4HBh5oAxEvq3f0NFFAnhm+HfHrAMlZ4bEXTIq670ix2BAwjgz0yW
         Vj8vh3z6+92BNVIDZEW/00KP+759hTcdiK3t/Lg2QWT1lu0ilKCNoEQG98DgyNMfYk
         mYbSoH+rproS/CS61165N1uCa+lornTa12WNiv/A=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/9] tcp: Add support for L3 domains to MD5 auth
Date:   Mon, 30 Dec 2019 14:14:24 -0800
Message-Id: <20191230221433.2717-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

With VRF, the scope of network addresses is limited to the L3 domain
the device is associated. MD5 keys are based on addresses, so proper
VRF support requires an L3 domain to be considered for the lookups.

Leverage the new TCP_MD5SIG_EXT option to add support for a device index
to MD5 keys. The __tcpm_pad entry in tcp_md5sig is renamed to tcpm_ifindex
and a new flag, TCP_MD5SIG_FLAG_IFINDEX, in tcpm_flags determines if the
entry is examined. This follows what was done for MD5 and prefixes with
commits
   8917a777be3b ("tcp: md5: add TCP_MD5SIG_EXT socket option to set a key address prefix")
   6797318e623d ("tcp: md5: add an address prefix for key lookup")

Handling both a device AND L3 domain is much more complicated for the
response paths. This set focuses only on L3 support - requiring the
device index to be an l3mdev (ie, VRF). Support for slave devices can
be added later if desired, much like the progression of support for
sockets bound to a VRF and then bound to a device in a VRF. Kernel
code is setup to explicitly call out that current lookup is for an L3
index, while the uapi just references a device index allowing its
meaning to include other devices in the future.

David Ahern (9):
  ipv4/tcp: Use local variable for tcp_md5_addr
  ipv6/tcp: Pass dif and sdif to tcp_v6_inbound_md5_hash
  ipv4/tcp: Pass dif and sdif to tcp_v4_inbound_md5_hash
  tcp: Add l3index to tcp_md5sig_key and md5 functions
  net: Add device index to tcp_md5sig
  nettest: Return 1 on MD5 failure for server mode
  nettest: Add support for TCP_MD5 extensions
  fcnal-test: Add TCP MD5 tests
  fcnal-test: Add TCP MD5 tests for VRF

 include/net/tcp.h                         |  24 +-
 include/uapi/linux/tcp.h                  |   5 +-
 net/ipv4/tcp_ipv4.c                       | 126 +++++---
 net/ipv6/tcp_ipv6.c                       | 105 +++++--
 tools/testing/selftests/net/fcnal-test.sh | 458 ++++++++++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     |  84 +++++-
 6 files changed, 715 insertions(+), 87 deletions(-)

-- 
2.11.0

