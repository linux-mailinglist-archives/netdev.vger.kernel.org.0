Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF71952A1
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgC0IKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54954 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgC0IKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DCE232055E;
        Fri, 27 Mar 2020 09:10:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bTnNJ6zkoKx6; Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 60913204B4;
        Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0CE5431801D2; Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-03-27
Date:   Fri, 27 Mar 2020 09:09:59 +0100
Message-ID: <20200327081007.1185-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Handle NETDEV_UNREGISTER for xfrm device to handle asynchronous
   unregister events cleanly. From Raed Salem.

2) Fix vti6 tunnel inter address family TX through bpf_redirect().
   From Nicolas Dichtel.

3) Fix lenght check in verify_sec_ctx_len() to avoid a
   slab-out-of-bounds. From Xin Long.

4) Add a missing verify_sec_ctx_len check in xfrm_add_acquire
   to avoid a possible out-of-bounds to access. From Xin Long.

5) Use built-in RCU list checking of hlist_for_each_entry_rcu
   to silence false lockdep warning in __xfrm6_tunnel_spi_lookup
   when CONFIG_PROVE_RCU_LIST is enabled. From Madhuparna Bhowmik.

6) Fix a panic on esp offload when crypto is done asynchronously.
   From Xin Long.

7) Fix a skb memory leak in an error path of vti6_rcv.
   From Torsten Hilbrich.

8) Fix a race that can lead to a doulbe free in xfrm_policy_timer.
   From Xin Long.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit a444ad1432c5a0fb3bd43fc9ac39fb88b1fb141e:

  Merge branch 'netdevsim-fix-several-bugs-in-netdevsim-module' (2020-02-03 15:38:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 4c59406ed00379c8663f8663d82b2537467ce9d7:

  xfrm: policy: Fix doulbe free in xfrm_policy_timer (2020-03-24 06:56:54 +0100)

----------------------------------------------------------------
Madhuparna Bhowmik (1):
      ipv6: xfrm6_tunnel.c: Use built-in RCU list checking

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Raed Salem (1):
      xfrm: handle NETDEV_UNREGISTER for xfrm device

Torsten Hilbrich (1):
      vti6: Fix memory leak of skb if input policy check fails

Xin Long (3):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
      esp: remove the skb from the chain when it's enqueued in cryptd_wq

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

 net/ipv4/Kconfig        |  1 +
 net/ipv4/ip_vti.c       | 38 ++++++++++++++++++++++++++++++--------
 net/ipv6/ip6_vti.c      | 34 ++++++++++++++++++++++++++--------
 net/ipv6/xfrm6_tunnel.c |  2 +-
 net/xfrm/xfrm_device.c  |  9 +++++----
 net/xfrm/xfrm_policy.c  |  2 ++
 net/xfrm/xfrm_user.c    |  6 +++++-
 7 files changed, 70 insertions(+), 22 deletions(-)
