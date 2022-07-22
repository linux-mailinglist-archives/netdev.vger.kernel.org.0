Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C1C57E7B3
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 21:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiGVT5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 15:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbiGVT5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 15:57:13 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8FC9DEDC
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 12:57:10 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 6BA1BF53C54A; Fri, 22 Jul 2022 12:56:58 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, edumazet@google.com, kuba@kernel.org,
        kafai@fb.com, davem@davemloft.net,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v3 0/3] Add a second bind table hashed by port + address
Date:   Fri, 22 Jul 2022 12:54:03 -0700
Message-Id: <20220722195406.1304948-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        TVD_RCVD_IP autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is one bind hashtable (bhash) that hashes by port only.
This patchset adds a second bind table (bhash2) that hashes by port and
address.

The motivation for adding bhash2 is to expedite bind requests in situatio=
ns
where the port has many sockets in its bhash table entry (eg a large numb=
er
of sockets bound to different addresses on the same port), which makes ch=
ecking
bind conflicts costly especially given that we acquire the table entry sp=
inlock
while doing so, which can cause softirq cpu lockups and can prevent new t=
cp
connections.

We ran into this problem at Meta where the traffic team binds a large num=
ber
of IPs to port 443 and the bind() call took a significant amount of time
which led to cpu softirq lockups, which caused packet drops and other fai=
lures
on the machine.

When experimentally testing this on a local server for ~24k sockets bound=
 to
the port, the results seen were:

ipv4:
before - 0.002317 seconds
with bhash2 - 0.000020 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

The additions to the initial bhash2 submission [0] are:
* Updating bhash2 in the cases where a socket's rcv saddr changes after i=
t has
* been bound
* Adding locks for bhash2 hashbuckets

[0] https://lore.kernel.org/netdev/20220520001834.2247810-1-kuba@kernel.o=
rg/

---
Changelog

v2 -> v3
v2: https://lore.kernel.org/netdev/20220712235310.1935121-1-joannelkoong@=
gmail.com/
  * Address Paolo's feedback
    1/3:
        - Move inet_bhashfn_portaddr down in inet_csk_find_open_port()
        - Remove unused "head" in inet_bhash2_update_saddr
    2/3:
        - Make tests work for ipv4, make address configurable from comman=
d line
        - Use 'nodad' option for ip addr add in script
    3/3:
        - Add sk_bind_sendto_listen to Makefile for it to run automatical=
ly

  * Check if the icsk_bind2_hash was set before finding the prev_addr_has=
hbucket.
    If the icsk_bind2_hash wasn't set, this means the prev address was ne=
ver
    added to the bhash2, so pass in NULL "prev_saddr" to inet_bhash2_upda=
te_saddr().
    This addresses the kernel_NULL_pointer_dereference report [1].

  * Add sk_connect_zero_addr test (tests that the kernel_NULL_pointer_der=
eference bug
    is fixed).

  [1] https://lore.kernel.org/netdev/YtLJMxChUupbAa+U@xsang-OptiPlex-9020=
/

v1 -> v2
v1: https://lore.kernel.org/netdev/20220623234242.2083895-2-joannelkoong@=
gmail.com/
  * Drop formatting change to sk_add_bind_node()

Joanne Koong (3):
  net: Add a bhash2 table hashed by port + address
  selftests/net: Add test for timing a bind request to a port with a
    populated bhash entry
  selftests/net: Add sk_bind_sendto_listen and sk_connect_zero_addr

 include/net/inet_connection_sock.h            |   3 +
 include/net/inet_hashtables.h                 |  80 ++++-
 include/net/sock.h                            |  14 +
 net/dccp/ipv4.c                               |  26 +-
 net/dccp/ipv6.c                               |  13 +
 net/dccp/proto.c                              |  34 ++-
 net/ipv4/af_inet.c                            |  27 +-
 net/ipv4/inet_connection_sock.c               | 275 ++++++++++++++----
 net/ipv4/inet_hashtables.c                    | 268 ++++++++++++++++-
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_ipv4.c                           |  24 +-
 net/ipv6/tcp_ipv6.c                           |  13 +
 tools/testing/selftests/net/.gitignore        |   5 +-
 tools/testing/selftests/net/Makefile          |   5 +
 tools/testing/selftests/net/bind_bhash.c      | 144 +++++++++
 tools/testing/selftests/net/bind_bhash.sh     |  66 +++++
 .../selftests/net/sk_bind_sendto_listen.c     |  80 +++++
 .../selftests/net/sk_connect_zero_addr.c      |  57 ++++
 18 files changed, 1050 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
 create mode 100644 tools/testing/selftests/net/sk_connect_zero_addr.c

--=20
2.30.2

