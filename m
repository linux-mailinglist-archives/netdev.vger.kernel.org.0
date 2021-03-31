Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F079A34FB69
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhCaITb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:19:31 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48058 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbhCaIS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 04:18:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 748182056D;
        Wed, 31 Mar 2021 10:18:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8NTTaWP49L77; Wed, 31 Mar 2021 10:18:54 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 14A4B20569;
        Wed, 31 Mar 2021 10:18:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 10:18:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 10:18:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7E5E931804DE; Wed, 31 Mar 2021 10:18:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2021-03-31
Date:   Wed, 31 Mar 2021 10:18:36 +0200
Message-ID: <20210331081847.3547641-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix ipv4 pmtu checks for xfrm anf vti interfaces.
   From Eyal Birger.

2) There are situations where the socket passed to
   xfrm_output_resume() is not the same as the one
   attached to the skb. Use the socket passed to
   xfrm_output_resume() to avoid lookup failures
   when xfrm is used with VRFs.
   From Evan Nimmo.

3) Make the xfrm_state_hash_generation sequence counter per
   network namespace because but its write serialization
   lock is also per network namespace. Write protection
   is insufficient otherwise.
   From Ahmed S. Darwish.

4) Fixup sctp featue flags when used with esp offload.
   From Xin Long.

5) xfrm BEET mode doesn't support fragments for inner packets.
   This is a limitation of the protocol, so no fix possible.
   Warn at least to notify the user about that situation.
   From Xin Long.

6) Fix NULL pointer dereference on policy lookup when
   namespaces are uses in combination with esp offload.

7) Fix incorrect transformation on esp offload when
   packets get segmented at layer 3.

8) Fix some user triggered usages of WARN_ONCE in
   the xfrm compat layer.
   From Dmitry Safonov.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 3a2eb515d1367c0f667b76089a6e727279c688b8:

  octeontx2-af: Fix an off by one in rvu_dbg_qsize_write() (2021-02-21 13:29:25 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to ef19e111337f6c3dca7019a8bad5fbc6fb18d635:

  xfrm/compat: Cleanup WARN()s that can be user-triggered (2021-03-30 07:29:09 +0200)

----------------------------------------------------------------
Ahmed S. Darwish (2):
      net: xfrm: Localize sequence counter per network namespace
      net: xfrm: Use sequence counter with associated spinlock

Dmitry Safonov (1):
      xfrm/compat: Cleanup WARN()s that can be user-triggered

Evan Nimmo (1):
      xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume

Eyal Birger (3):
      xfrm: interface: fix ipv4 pmtu check to honor ip header df
      vti: fix ipv4 pmtu check to honor ip header df
      vti6: fix ipv4 pmtu check to honor ip header df

Steffen Klassert (2):
      xfrm: Fix NULL pointer dereference on policy lookup
      xfrm: Provide private skb extensions for segmented and hw offloaded ESP packets

Xin Long (2):
      esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
      xfrm: BEET mode doesn't support fragments for inner packets

 include/net/netns/xfrm.h  |  4 +++-
 include/net/xfrm.h        |  4 ++--
 net/ipv4/ah4.c            |  2 +-
 net/ipv4/esp4.c           |  2 +-
 net/ipv4/esp4_offload.c   | 17 ++++++++++++++---
 net/ipv4/ip_vti.c         |  6 ++++--
 net/ipv6/ah6.c            |  2 +-
 net/ipv6/esp6.c           |  2 +-
 net/ipv6/esp6_offload.c   | 17 ++++++++++++++---
 net/ipv6/ip6_vti.c        |  6 ++++--
 net/xfrm/xfrm_compat.c    | 12 +++++++++---
 net/xfrm/xfrm_device.c    |  2 --
 net/xfrm/xfrm_interface.c |  3 +++
 net/xfrm/xfrm_output.c    | 23 ++++++++++++++++++-----
 net/xfrm/xfrm_state.c     | 11 ++++++-----
 15 files changed, 81 insertions(+), 32 deletions(-)
