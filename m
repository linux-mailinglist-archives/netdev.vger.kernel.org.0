Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62263E2473
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbhHFHuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:50:16 -0400
Received: from relay.sw.ru ([185.231.240.75]:36230 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239768AbhHFHuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 03:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=1zrt4eD5My5s1TavWa+RtWePr0aKNve+a9G2rEups6w=; b=UntW2gkOIhY7AG/px1s
        aDHUKObFYRILEDQo8XD1g/gTZUcQOBlIaPXulfzv1QkDSp5I3/p9wwr0jbXW+kcKiH2YDKNz+ItNm
        dgnxgXQF4oDf/jof6q6FARXpZTkqCJXp6F3xhMVG4ky3vp91eKYvO/f3sSixUORCbsdhABiy0PY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mBuc1-006aeH-6y; Fri, 06 Aug 2021 10:49:49 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v4 0/7] skbuff: introduce skb_expand_head()
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
        linux-kernel@vger.kernel.org, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
Message-ID: <0d3366bb-e19c-dbd4-0ba5-a3e6aff55b4e@virtuozzo.com>
Date:   Fri, 6 Aug 2021 10:49:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ccce7edb-54dd-e6bf-1e84-0ec320d8886c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently if skb does not have enough headroom skb_realloc_headrom is called.
It is not optimal because it creates new skb.

this patch set introduces new helper skb_expand_head()
Unlike skb_realloc_headroom, it does not allocate a new skb if possible; 
copies skb->sk on new skb when as needed and frees original skb in case of failures.

This helps to simplify ip[6]_finish_output2(), ip6_xmit() and few other
functions in vrf, ax25 and bpf.

There are few other cases where this helper can be used 
but it requires an additional investigations. 

v4 changes:
 - fixed null pointer dereference in vrf patch reported by Julian Wiedmann

v3 changes:
 - ax25 compilation warning fixed
 - v5.14-rc4 rebase
 - now it does not depend on non-committed pathces

v2 changes:
 - helper's name was changed to skb_expand_head
 - fixed few mistakes inside skb_expand_head():
    skb_set_owner_w should set sk on nskb
    kfree was replaced by kfree_skb()
    improved warning message
 - added minor refactoring in changed functions in vrf and bpf patches
 - removed kfree_skb() in ax25_rt_build_path caller ax25_ip_xmit


Vasily Averin (7):
  skbuff: introduce skb_expand_head()
  ipv6: use skb_expand_head in ip6_finish_output2
  ipv6: use skb_expand_head in ip6_xmit
  ipv4: use skb_expand_head in ip_finish_output2
  vrf: use skb_expand_head in vrf_finish_output
  ax25: use skb_expand_head
  bpf: use skb_expand_head in bpf_out_neigh_v4/6

 drivers/net/vrf.c      | 23 ++++++---------
 include/linux/skbuff.h |  1 +
 net/ax25/ax25_ip.c     |  4 +--
 net/ax25/ax25_out.c    | 13 ++-------
 net/ax25/ax25_route.c  | 13 ++-------
 net/core/filter.c      | 27 ++++-------------
 net/core/skbuff.c      | 42 +++++++++++++++++++++++++++
 net/ipv4/ip_output.c   | 13 ++-------
 net/ipv6/ip6_output.c  | 78 +++++++++++++++++---------------------------------
 9 files changed, 92 insertions(+), 122 deletions(-)

-- 
1.8.3.1

