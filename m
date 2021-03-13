Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F1333A10A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 21:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhCMUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 15:30:21 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:26503 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhCMUaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 15:30:02 -0500
Date:   Sat, 13 Mar 2021 20:29:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615667400; bh=sKq9mciRke6VPBD51VxE705FzzXLemerqlyrFNFi8+0=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=av+jDWvOqaJCjjUYzBzBNrDI7ecLUylCDLntF2aXK3wFYMTIOfaubIVR3f8AeCd3h
         wnn6LPoAmHxlnM4T9OE3atPF1gnkA6R09cr7WjEqIRbQ7QPSNaUo0BsmUjowpMxpNM
         d/6g6Dct7fI74auqcGnLyyZHt6ZymZTe6oiwZr4CjVimv+6ypMkrIz8PwLZ+hspS7N
         qHjVM5OS1RFKVmUdwaERb6bA2f925j0WfdFIFRQQtKv7bj4JkKzsbDEqzc+OMcEWcM
         sUyg3YX7vSlrFftbKHBb6mh9ZpblwNsosPEEvAXvoVhPknpaCNQDwrvn1y7ZSO9URq
         I6t1d0/+z7neg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 0/3] gro: micro-optimize dev_gro_receive()
Message-ID: <20210313202946.59729-1-alobakin@pm.me>
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

This random series addresses some of suboptimal constructions used
in the main GRO entry point.
The main body is gro_list_prepare() simplification and pointer usage
optimization in dev_gro_receive() itself. Being mostly cosmetic, it
gives like +10 Mbps on my setup to both TCP and UDP (both single- and
multi-flow).

Since v1 [0]:
 - drop the replacement of bucket index calculation with
   reciprocal_scale() since it makes absolutely no sense (Eric);
 - improve stack usage in dev_gro_receive() (Eric);
 - reverse the order of patches to avoid changes superseding.

[0] https://lore.kernel.org/netdev/20210312162127.239795-1-alobakin@pm.me

Alexander Lobakin (3):
  gro: simplify gro_list_prepare()
  gro: consistentify napi->gro_hash[x] access in dev_gro_receive()
  gro: give 'hash' variable in dev_gro_receive() a less confusing name

 net/core/dev.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--
2.30.2


