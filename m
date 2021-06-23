Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216533B1438
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWG5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:57:13 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33326 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhFWG5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:57:10 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id DE52C800053;
        Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:54:52 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:54:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 52F5331803BD; Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2021-06-23
Date:   Wed, 23 Jun 2021 08:54:43 +0200
Message-ID: <20210623065449.2143405-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Don't return a mtu smaller than 1280 on IPv6 pmtu discovery.
   From Sabrina Dubroca

2) Fix seqcount rcu-read side in xfrm_policy_lookup_bytype
   for the PREEMPT_RT case. From Varad Gautam.

3) Remove a repeated declaration of xfrm_parse_spi.
   From Shaokun Zhang.

4) IPv4 beet mode can't handle fragments, but IPv6 does.
   commit 68dc022d04eb ("xfrm: BEET mode doesn't support
   fragments for inner packets") handled IPv4 and IPv6
   the same way. Relax the check for IPv6 because fragments
   are possible here. From Xin Long.

5) Memory allocation failures are not reported for
   XFRMA_ENCAP and XFRMA_COADDR in xfrm_state_construct.
   Fix this by moving both cases in front of the function.

6) Fix a missing initialization in the xfrm offload fallback
   fail case for bonding devices. From Ayush Sawal.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 88a5af943985fb43b4c9472b5abd9c0b9705533d:

  Merge tag 'net-5.12-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-04-17 09:57:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to dd72fadf2186fc8a6018f97fe72f4d5ca05df440:

  xfrm: Fix xfrm offload fallback fail case (2021-06-22 09:08:15 +0200)

----------------------------------------------------------------
Ayush Sawal (1):
      xfrm: Fix xfrm offload fallback fail case

Sabrina Dubroca (1):
      xfrm: xfrm_state_mtu should return at least 1280 for ipv6

Shaokun Zhang (1):
      xfrm: Remove the repeated declaration

Steffen Klassert (1):
      xfrm: Fix error reporting in xfrm_state_construct.

Varad Gautam (1):
      xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype

Xin Long (1):
      xfrm: remove the fragment check for ipv6 beet mode

 include/net/xfrm.h     |  2 +-
 net/ipv4/esp4.c        |  2 +-
 net/ipv6/esp6.c        |  2 +-
 net/xfrm/xfrm_device.c |  1 +
 net/xfrm/xfrm_output.c |  7 -------
 net/xfrm/xfrm_policy.c | 21 ++++++++++++++-------
 net/xfrm/xfrm_state.c  | 14 ++++++++++++--
 net/xfrm/xfrm_user.c   | 28 ++++++++++++++--------------
 8 files changed, 44 insertions(+), 33 deletions(-)
