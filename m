Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2727A59C5CE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiHVSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiHVSKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:10:55 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC946D8F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:10:53 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 67B4810CCCA24; Mon, 22 Aug 2022 11:10:41 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, dccp@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH RESEND net-next v4 0/3] Add a second bind table hashed by port and address
Date:   Mon, 22 Aug 2022 11:10:20 -0700
Message-Id: <20220822181023.3979645-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
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

v3 -> v4
v3: https://lore.kernel.org/netdev/20220722195406.1304948-2-joannelkoong@=
gmail.com/
  * Address kernel test robot bad page map:
    - only update the bhash2 table in connect() on addr 0, if the socket =
is bound

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
 net/dccp/ipv4.c                               |  25 +-
 net/dccp/ipv6.c                               |  18 ++
 net/dccp/proto.c                              |  34 ++-
 net/ipv4/af_inet.c                            |  26 +-
 net/ipv4/inet_connection_sock.c               | 275 ++++++++++++++----
 net/ipv4/inet_hashtables.c                    | 268 ++++++++++++++++-
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_ipv4.c                           |  23 +-
 net/ipv6/tcp_ipv6.c                           |  17 ++
 tools/testing/selftests/net/.gitignore        |   5 +-
 tools/testing/selftests/net/Makefile          |   5 +
 tools/testing/selftests/net/bind_bhash.c      | 144 +++++++++
 tools/testing/selftests/net/bind_bhash.sh     |  66 +++++
 .../selftests/net/sk_bind_sendto_listen.c     |  80 +++++
 .../selftests/net/sk_connect_zero_addr.c      |  62 ++++
 18 files changed, 1061 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
 create mode 100644 tools/testing/selftests/net/sk_connect_zero_addr.c

--=20
2.30.2

