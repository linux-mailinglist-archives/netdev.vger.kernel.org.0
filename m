Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A5A572A1C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 01:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiGLX4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 19:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiGLX4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 19:56:25 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E26C7653
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 16:56:23 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id B986AEDF92CD; Tue, 12 Jul 2022 16:56:03 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v2 0/3] Add a second bind table hashed by port + address
Date:   Tue, 12 Jul 2022 16:53:07 -0700
Message-Id: <20220712235310.1935121-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is one bind hashtable (bhash) that hashes by port only.
This patchset adds a second bind table (bhash2) that hashes by port and a=
ddress.

The motivation for adding bhash2 is to expedite bind requests in situatio=
ns where
the port has many sockets in its bhash table entry (eg a large number of
sockets bound to different addresses on the same port), which makes check=
ing bind
conflicts costly especially given that we acquire the table entry spinloc=
k
while doing so, which can cause softirq cpu lockups and can prevent new t=
cp
connections.

We ran into this problem at Meta where the traffic team binds a large num=
ber
of IPs to port 443 and the bind() call took a significant amount of time
which led to cpu softirq lockups, which caused packet drops and other fai=
lures
on the machine

When experimentally testing this on a local server for ~24k sockets bound=
 to
the port, the results seen were:

ipv4:
before - 0.002317 seconds
with bhash2 - 0.000020 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

The additions to the initial bhash2 submission [1] are:
* Updating bhash2 in the cases where a socket's rcv saddr changes after i=
t has
* been bound
* Adding locks for bhash2 hashbuckets

[1] https://lore.kernel.org/netdev/20220520001834.2247810-1-kuba@kernel.o=
rg/

---
Changelog

v1 -> v2
v1:
https://lore.kernel.org/netdev/20220623234242.2083895-2-joannelkoong@gmai=
l.com/
* Drop formatting change to sk_add_bind_node()

Joanne Koong (3):
  net: Add a bhash2 table hashed by port + address
  selftests/net: Add test for timing a bind request to a port with a
    populated bhash entry
  selftests/net: Add sk_bind_sendto_listen test

 include/net/inet_connection_sock.h            |   3 +
 include/net/inet_hashtables.h                 |  80 ++++-
 include/net/sock.h                            |  14 +
 net/dccp/ipv4.c                               |  24 +-
 net/dccp/ipv6.c                               |  12 +
 net/dccp/proto.c                              |  34 ++-
 net/ipv4/af_inet.c                            |  31 +-
 net/ipv4/inet_connection_sock.c               | 279 ++++++++++++++----
 net/ipv4/inet_hashtables.c                    | 277 +++++++++++++++--
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_ipv4.c                           |  21 +-
 net/ipv6/tcp_ipv6.c                           |  12 +
 tools/testing/selftests/net/.gitignore        |   4 +-
 tools/testing/selftests/net/Makefile          |   4 +
 tools/testing/selftests/net/bind_bhash.c      | 119 ++++++++
 tools/testing/selftests/net/bind_bhash.sh     |  23 ++
 .../selftests/net/sk_bind_sendto_listen.c     |  80 +++++
 17 files changed, 924 insertions(+), 104 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c

--=20
2.30.2

