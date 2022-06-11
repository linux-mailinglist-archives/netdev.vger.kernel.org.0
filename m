Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5184B547144
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 04:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347216AbiFKCUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 22:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiFKCUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 22:20:04 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FF936089C
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 19:20:02 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id C7C41D855F38; Fri, 10 Jun 2022 19:17:34 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        mathew.j.martineau@linux.intel.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v3 0/3] bhash2 binding table fixups 
Date:   Fri, 10 Jun 2022 19:16:43 -0700
Message-Id: <20220611021646.1578080-1-joannelkoong@gmail.com>
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

There are two fix-ups related to the bhash2 binding table in this
patchset:

1) Fixes an inconsistency in the bhash2 table in the case where a
socket's rcv saddr changes after it is binded.

2) Fixes the case where the bhash2 hashbucket is accessed concurrently
by sockets that hash to different bhash hashbuckets. To address this, the
bhash2 hashbucket has its own lock.

--
v2 -> v3:
v2:
https://lore.kernel.org/netdev/20220602165101.3188482-1-joannelkoong@gmai=
l.com/
* Add a patch that adds bhash2 hashbucket locks

v1 -> v2:
v1:
https://lore.kernel.org/netdev/20220601201434.1710931-1-joannekoong@fb.co=
m/
* Mark __inet_bhash2_update_saddr as static

Joanne Koong (3):
  net: Update bhash2 when socket's rcv saddr changes
  net: Add bhash2 hashbucket locks
  selftests/net: Add sk_bind_sendto_listen test

 include/net/inet_hashtables.h                 |  31 +++--
 include/net/ipv6.h                            |   2 +-
 net/dccp/ipv4.c                               |  10 +-
 net/dccp/ipv6.c                               |   4 +-
 net/dccp/proto.c                              |   3 +-
 net/ipv4/af_inet.c                            |   7 +-
 net/ipv4/inet_connection_sock.c               |  60 +++++----
 net/ipv4/inet_hashtables.c                    | 115 +++++++++++++-----
 net/ipv4/tcp.c                                |   7 +-
 net/ipv4/tcp_ipv4.c                           |   8 +-
 net/ipv6/inet6_hashtables.c                   |   4 +-
 net/ipv6/tcp_ipv6.c                           |   4 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/sk_bind_sendto_listen.c     |  82 +++++++++++++
 15 files changed, 251 insertions(+), 88 deletions(-)
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c

--=20
2.30.2

