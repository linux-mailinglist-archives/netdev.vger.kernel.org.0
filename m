Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F2339DD8
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhCMLhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:37:33 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:54953 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhCMLhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:37:11 -0500
Date:   Sat, 13 Mar 2021 11:37:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615635429; bh=aO0Fo1XBjYTxfkc7UFdM4I8RL3S4bf1o7JgajErXmgE=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=FC58vUCmuoG6cneXrGTB2aMDGbOFZN+GOeJJ8mU4luK0s7tv/yiy6u1Jtyr8+pHPU
         7kJAkfugMx0CHM6bups8+bUSr3z2DmgUx1zR58N1by4C5w8iDwdNb4RJ3QcE2na6h3
         ckstcL8p/nhVq9q0DIR9DZUYjVWk2FEJUZIkcHvR3wheX263Z5bKBFrn2fhSwkLRIl
         p/pCS5ZoCRO4vTMahZVVtHgS2lJ72pBndswRnSUHeBFGgZfV59KrXqxIOeW5e6LTCq
         Wvy3QyEYYuF8leZqUe6EsoZxkq6ycVk5WrIeu6cWM0/ZllT+BNz/89u/K5mvJL3zna
         +MQkq3Zm3eRjw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 0/6] skbuff: micro-optimize flow dissection
Message-ID: <20210313113645.5949-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little number makes all of the flow dissection functions take
raw input data pointer as const (1-5) and shuffles the branches in
__skb_header_pointer() according to their hit probability.

The result is +20 Mbps per flow/core with one Flow Dissector pass
per packet. This affects RPS (with software hashing), drivers that
use eth_get_headlen() on their Rx path and so on.

Since v1 [0]:
 - rebase on top of the latest net-next. This was super-weird, but
   I double-checked that the series applies with no conflicts, and
   then on Patchwork it didn't;
 - no other changes.

[0] https://lore.kernel.org/netdev/20210312194538.337504-1-alobakin@pm.me

Alexander Lobakin (6):
  flow_dissector: constify bpf_flow_dissector's data pointers
  skbuff: make __skb_header_pointer()'s data argument const
  flow_dissector: constify raw input @data argument
  linux/etherdevice.h: misc trailing whitespace cleanup
  ethernet: constify eth_get_headlen()'s @data argument
  skbuff: micro-optimize {,__}skb_header_pointer()

 include/linux/etherdevice.h  |  4 ++--
 include/linux/skbuff.h       | 26 +++++++++++------------
 include/net/flow_dissector.h |  6 +++---
 net/core/flow_dissector.c    | 41 +++++++++++++++++++-----------------
 net/ethernet/eth.c           |  2 +-
 5 files changed, 40 insertions(+), 39 deletions(-)

--
2.30.2


