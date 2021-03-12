Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DB933930F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhCLQWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:22:21 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:16910 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhCLQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:22:02 -0500
Date:   Fri, 12 Mar 2021 16:21:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615566120; bh=EPyxtkpOV0rtQrrZHCg1xpqZt46LZWrmCOQTPzRuzYA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=EKHGhAMkK4ER+10mdzNmG6VdJIIEzgJEKBv6kMYaC6tcb0/6RjLBl1IcRC1y0OZRr
         un88+YNB3sIM7aoVUJ1w3i3Y7VK8vMhpFfPpT7U89H7gnjxTUXiuJdGhQhpAZ00NlY
         eD+rLcQ3KA9XPa3O443qF+ocURhPhhJAFvr19BAB1M2C6vxXN11D5n8KrRAfzH7gxZ
         0plt2RWiKDyOGVZyJapPNOGd6V/o4UpWTp+RIw3FkXtPTS8NlDkPMrI98jAdSt1+uX
         y1EvbNpSVI62awMGnNWOM9vOh1mTVvec9/eVaO75eHukN6AMoVooo2f3xxSjy72DXo
         M/4SLt0KAn6Yg==
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
Subject: [PATCH net-next 0/4] gro: micro-optimize dev_gro_receive()
Message-ID: <20210312162127.239795-1-alobakin@pm.me>
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

This random series addresses some of suboptimal paths used in
the main GRO entry point.
The main body is patches 3-4 which simplify the code and improve
flow distribution. Two others are mostly cosmetic to make code
more readable.

The benetifs are not so huge and mostly depend on NIC RSS hash
function and a number of Rx flows per single NAPI instance. I got
something like +10-15 Mbps on 4-8 flows NATing.

Alexander Lobakin (4):
  gro: give 'hash' variable in dev_gro_receive() a less confusing name
  gro: don't dereference napi->gro_hash[x] multiple times in
    dev_gro_receive()
  gro: simplify gro_list_prepare()
  gro: improve flow distribution across GRO buckets in dev_gro_receive()

 net/core/dev.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--
2.30.2


