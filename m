Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C88233FDB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgGaHSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49936 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbgGaHSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7FD15205F0;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dvLbAEjhFBNK; Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6FB720519;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 47F693180676;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-07-31
Date:   Fri, 31 Jul 2020 09:17:54 +0200
Message-ID: <20200731071804.29557-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix policy matching with mark and mask on userspace interfaces.
   From Xin Long.

2) Several fixes for the new ESP in TCP encapsulation.
   From Sabrina Dubroca.

3) Fix crash when the hold queue is used. The assumption that
   xdst->path and dst->child are not a NULL pointer only if dst->xfrm
   is not a NULL pointer is true with the exception of using the
   hold queue. Fix this by checking for hold queue usage before
   dereferencing xdst->path or dst->child.

4) Validate pfkey_dump parameter before sending them.
   From Mark Salyzyn.

5) Fix the location of the transport header with ESP in UDPv6
   encapsulation. From Sabrina Dubroca.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 0275875530f692c725c6f993aced2eca2d6ac50c:

  Merge branch 'Two-phylink-pause-fixes' (2020-06-23 20:53:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 71b59bf482b2dd662774f34108c5b904efa9e02b:

  espintcp: count packets dropped in espintcp_rcv (2020-07-30 06:51:36 +0200)

----------------------------------------------------------------
Mark Salyzyn (1):
      af_key: pfkey_dump needs parameter validation

Sabrina Dubroca (7):
      xfrm: esp6: fix encapsulation header offset computation
      espintcp: support non-blocking sends
      espintcp: recv() should return 0 when the peer socket is closed
      xfrm: policy: fix IPv6-only espintcp compilation
      xfrm: esp6: fix the location of the transport header with encapsulation
      espintcp: handle short messages instead of breaking the encap socket
      espintcp: count packets dropped in espintcp_rcv

Steffen Klassert (2):
      Merge remote-tracking branch 'origin/testing'
      xfrm: Fix crash when the hold queue is used.

Xin Long (1):
      xfrm: policy: match with both mark and mask on user interfaces

 include/net/xfrm.h     | 15 +++++++-----
 net/ipv6/esp6.c        | 13 ++++++++---
 net/key/af_key.c       | 11 +++++++--
 net/xfrm/espintcp.c    | 62 ++++++++++++++++++++++++++++++++++++++------------
 net/xfrm/xfrm_policy.c | 43 +++++++++++++++-------------------
 net/xfrm/xfrm_user.c   | 18 +++++++++------
 6 files changed, 104 insertions(+), 58 deletions(-)
