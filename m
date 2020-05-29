Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A6E1E7B23
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgE2LEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39444 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgE2LEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 54BDE205CB;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6U1sXmKrosdH; Fri, 29 May 2020 13:04:12 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D5A7A2051F;
        Fri, 29 May 2020 13:04:12 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:12 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 07642318012D;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-05-29
Date:   Fri, 29 May 2020 13:03:53 +0200
Message-ID: <20200529110408.6349-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Several fixes for ESP gro/gso in transport and beet mode when
   IPv6 extension headers are present. From Xin Long.

2) Fix a wrong comment on XFRMA_OFFLOAD_DEV.
   From Antony Antony.

3) Fix sk_destruct callback handling on ESP in TCP encapsulation.
   From Sabrina Dubroca.

4) Fix a use after free in xfrm_output_gso when used with vxlan.
   From Xin Long.

5) Fix secpath handling of VTI when used wiuth IPCOMP.
   From Xin Long.

6) Fix an oops when deleting a x-netns xfrm interface.
   From Nicolas Dichtel.

7) Fix a possible warning on policy updates. We had a case where it was
   possible to add two policies with the same lookup keys.
   From Xin Long.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 91fac45cd0061854633036695cf37a11befa8062:

  Merge branch 'Fix-88x3310-leaving-power-save-mode' (2020-04-14 16:48:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to f6a23d85d078c2ffde79c66ca81d0a1dde451649:

  xfrm: fix a NULL-ptr deref in xfrm_local_error (2020-05-29 12:10:22 +0200)

----------------------------------------------------------------
Antony Antony (1):
      xfrm: fix error in comment

Nicolas Dichtel (1):
      xfrm interface: fix oops when deleting a x-netns interface

Sabrina Dubroca (1):
      xfrm: espintcp: save and call old ->sk_destruct

Xin Long (12):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: do pskb_pull properly in __xfrm_transport_prep
      esp6: get the right proto for transport mode in esp6_gso_encap
      xfrm: remove the xfrm_state_put call becofe going to out_reset
      esp6: support ipv6 nexthdrs process for beet gso segment
      esp4: support ipv6 nexthdrs process for beet gso segment
      xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
      ip_vti: receive ipip packet by calling ip_tunnel_rcv
      esp6: calculate transport_header correctly when sel.family != AF_INET6
      esp4: improve xfrm4_beet_gso_segment() to be more readable
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error

 include/net/espintcp.h    |  1 +
 include/uapi/linux/xfrm.h |  2 +-
 net/ipv4/esp4_offload.c   | 30 ++++++++++++++++++------------
 net/ipv4/ip_vti.c         | 23 ++++++++++++++++++++++-
 net/ipv6/esp6_offload.c   | 37 +++++++++++++++++++++++++------------
 net/xfrm/espintcp.c       |  2 ++
 net/xfrm/xfrm_device.c    |  8 +++-----
 net/xfrm/xfrm_input.c     |  2 +-
 net/xfrm/xfrm_interface.c | 21 +++++++++++++++++++++
 net/xfrm/xfrm_output.c    | 15 +++++++++------
 net/xfrm/xfrm_policy.c    |  7 +------
 11 files changed, 104 insertions(+), 44 deletions(-)
