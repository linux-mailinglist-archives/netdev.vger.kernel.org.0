Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDED53BCE1
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiFBQxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbiFBQxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:53:04 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEA627ED80
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:53:03 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id AE255D2E57CB; Thu,  2 Jun 2022 09:52:35 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v2 0/2] Update bhash2 when socket's rcv saddr changes
Date:   Thu,  2 Jun 2022 09:50:59 -0700
Message-Id: <20220602165101.3188482-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As syzbot noted [1], there is an inconsistency in the bhash2 table in the
case where a socket's rcv saddr changes after it is binded. (For more
details, please see the commit message of the first patch)

This patchset fixes that and adds a test that triggers the case where the
sk's rcv saddr changes. The subsequent listen() call should succeed.

[1] https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.co=
m/

--
v1 -> v2:
v1: https://lore.kernel.org/netdev/20220601201434.1710931-1-joannekoong@f=
b.com/
* Mark __inet_bhash2_update_saddr as static

Joanne Koong (2):
  net: Update bhash2 when socket's rcv saddr changes
  selftests/net: Add sk_bind_sendto_listen test

 include/net/inet_hashtables.h                 |  6 +-
 include/net/ipv6.h                            |  2 +-
 net/dccp/ipv4.c                               | 10 ++-
 net/dccp/ipv6.c                               |  4 +-
 net/ipv4/af_inet.c                            |  7 +-
 net/ipv4/inet_hashtables.c                    | 70 ++++++++++++++--
 net/ipv4/tcp_ipv4.c                           |  8 +-
 net/ipv6/inet6_hashtables.c                   |  4 +-
 net/ipv6/tcp_ipv6.c                           |  4 +-
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  1 +
 .../selftests/net/sk_bind_sendto_listen.c     | 82 +++++++++++++++++++
 12 files changed, 181 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c

--=20
2.30.2

