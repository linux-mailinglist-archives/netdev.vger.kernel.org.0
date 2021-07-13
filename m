Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91B33C784C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 22:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhGMVAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:00:44 -0400
Received: from relay.sw.ru ([185.231.240.75]:56672 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235490AbhGMVAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 17:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=sNeWr16D67k9ERD9fz0l1ggJ+G2nxSzI7yaf7NQ9na0=; b=DJgFQOy4wSSnzCq9GhR
        ZQgmbURved4np9B5ieb1Q5t48PpilGDirtKcDKFFBYWPi2Bk/XzK2iCe0AgJ/jiGiNZlv3f9oR25d
        J60UwD3yOcGcQYZGDvyN3ENUPYXp+zx8yfiiNY0TWBBcS7ldB7PqCl2oM4XwJwYtetExwbLYWUg=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3PTO-003sYX-HV; Tue, 13 Jul 2021 23:57:46 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v2 0/7] skbuff: introduce skb_expand_head()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <55c9e2ae-b060-baa2-460c-90eb3e9ded5c@virtuozzo.com>
Message-ID: <15eba3b2-80e2-5547-8ad9-167d810ad7e3@virtuozzo.com>
Date:   Tue, 13 Jul 2021 23:57:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <55c9e2ae-b060-baa2-460c-90eb3e9ded5c@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently if skb does not have enough headroom skb_realloc_headrom is called.
It is not optimal because it creates new skb.

Unlike skb_realloc_headroom, new helper skb_учзфтв_head 
does not allocate a new skb if possible; 
copies skb->sk on new skb when as needed
and frees original skb in case of failures.

This helps to simplify ip[6]_finish_output2(), ip6_xmit() and a few other
functions in vrf, ax25 and bpf.

There are few other cases where this helper can be used but they require
an additional investigations. 

v2 changes:
 - helper's name was changed to skb_expand_head
 - fixed few mistakes inside skb_expand_head():
    skb_set_owner_w should set sk on nskb
    kfree was replaced by kfree_skb()
    improved warning message
 - added minor refactoring in changed functions in vrf and bpf patches
 - removed kfree_skb() in ax25_rt_build_path caller ax25_ip_xmit

NB: patch "ipv6: use skb_expand_head in ip6_finish_output2" depends on 
patch "ipv6: allocate enough headroom in ip6_finish_output2()" submitted separately
https://lkml.org/lkml/2021/7/12/732

Vasily Averin (7):
  skbuff: introduce skb_expand_head()
  ipv6: use skb_expand_head in ip6_finish_output2
  ipv6: use skb_expand_head in ip6_xmit refactoring
  ipv4: use skb_expand_head in ip_finish_output2
  vrf: use skb_expand_head in vrf_finish_output
  ax25: use skb_expand_head
  bpf: use skb_expand_head in bpf_out_neigh_v4/6

 drivers/net/vrf.c      | 21 +++++---------
 include/linux/skbuff.h |  1 +
 net/ax25/ax25_out.c    | 12 ++------
 net/ax25/ax25_route.c  | 13 ++-------
 net/core/filter.c      | 27 ++++-------------
 net/core/skbuff.c      | 42 +++++++++++++++++++++++++++
 net/ipv4/ip_output.c   | 13 ++-------
 net/ipv6/ip6_output.c  | 78 +++++++++++++++++---------------------------------
 8 files changed, 90 insertions(+), 117 deletions(-)

-- 
1.8.3.1

