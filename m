Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086193397A8
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhCLTqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:46:33 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:59775 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbhCLTqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:46:12 -0500
Date:   Fri, 12 Mar 2021 19:46:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615578370; bh=FVaxpghToa5cTKlLnjzirHEfN54b3wPIDQHNtytUAGw=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=JTChfssTXc1JLmDGSO7as9QzSItT2wcBqgE0ObJ1lZ/DU+W36ddX/dJKSrtHO8aIw
         iccb5BDBhIybn1zM6kU9M7yyi5brnLmOdnOb8DebjB3nEo161ujs2O21yWRhWVeduK
         ARq5lIFXPNTsN95eXP+4MfoLbQcSpqbfLcvUR0QvEOmO2C4x339NdZL2JqVYFW75Hf
         cspGXUdg2v0sXKlhbAlwFWOC9Waj23i3qvd1VdkAGWZv4hX5dHxrs7JdS1Rvoi5fqr
         yna2u0E3u/flMGEleQmSPEiASHj7a++27rdsNLX5KWICiZUrJXkrJbTtWA+AOwFBMf
         ecfolYA7f7kNQ==
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
Subject: [PATCH net-next 0/6] skbuff: micro-optimize flow dissection
Message-ID: <20210312194538.337504-1-alobakin@pm.me>
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


