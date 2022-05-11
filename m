Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2290522821
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbiEKAFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 20:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiEKAFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 20:05:12 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ABC248E35
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 17:05:11 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id E528AC314A33; Tue, 10 May 2022 17:04:52 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v3 0/2] Add a bhash2 table hashed by port + address
Date:   Tue, 10 May 2022 17:04:22 -0700
Message-Id: <20220511000424.2223932-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
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

This patchset proposes adding a bhash2 table that hashes by port and addr=
ess.
The motivation behind bhash2 is to expedite bind requests in situations w=
here
the port has many sockets in its bhash table entry, which makes checking =
bind
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

The patches are as follows:
1/2 - Adds a second bhash table (bhash2) hashed by port and address
2/2 - Adds a test for timing how long an additional bind request takes wh=
en
the bhash entry is populated

When experimentally testing this on a local server for ~24k sockets bound=
 to
the port, the results seen were:

ipv4:
before - 0.002317 seconds
with bhash2 - 0.000018 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

v2 -> v3:
v2:
https://lore.kernel.org/netdev/20220510005316.3967597-1-joannelkoong@gmai=
l.com/

* Fix bhash2 allocation error handling for dccp
* Rebase onto net-next/master

v1 -> v2:
v1:
https://lore.kernel.org/netdev/20220421221449.1817041-1-joannelkoong@gmai=
l.com/

* Attached test for timing bind request

Joanne Koong (2):
  net: Add a second bind table hashed by port and address
  selftests: Add test for timing a bind request to a port with a
    populated bhash entry

 include/net/inet_connection_sock.h            |   3 +
 include/net/inet_hashtables.h                 |  56 ++++-
 include/net/sock.h                            |  14 ++
 net/dccp/proto.c                              |  34 ++-
 net/ipv4/inet_connection_sock.c               | 227 +++++++++++++-----
 net/ipv4/inet_hashtables.c                    | 188 ++++++++++++++-
 net/ipv4/tcp.c                                |  14 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/bind_bhash_test.c | 119 +++++++++
 10 files changed, 576 insertions(+), 82 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash_test.c

--=20
2.30.2

