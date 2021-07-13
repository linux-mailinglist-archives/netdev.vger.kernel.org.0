Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B541E3C7012
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhGMMEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:04:01 -0400
Received: from relay.sw.ru ([185.231.240.75]:54432 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235797AbhGMMEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 08:04:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=XdVSeYsWM6gpkohRLdjfHrqyvOYT/lKERJYnjF+csFw=; b=yJ3he1RbKYdlrK/Y8YO
        rGj7smjCQp2KnyoyEWpCSveyvJhUjsoDrxlNA72QxeHxO+/nqRuZA1poxEwj/LY1I+N72D6ks+GNY
        YGHNv/FlKvRdunOeDJbbYcGjIe3n3TP9oeTjm9186KoReM/sVRtIKjOKeQY8UsYVVtUAGGIT8bk=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m3H63-003pDM-9n; Tue, 13 Jul 2021 15:01:07 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH NET v4 0/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
Message-ID: <8bad3fda-2f74-75d7-8461-e49a7e6fdbd9@virtuozzo.com>
Date:   Tue, 13 Jul 2021 15:01:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently Syzkaller found one more issue on RHEL7-based OpenVz kernels.
During its investigation I've found that upstream is affected too. 

TEE target send sbk with small headroom into another interface which requires
an increased headroom.

ipv4 handles this problem in ip_finish_output2() and creates new skb with enough headroom,
though ip6_finish_output2() lacks this logic.

Suzkaller created C reproducer, it can be found in v1 cover-letter 
https://lkml.org/lkml/2021/7/7/467

v4 changes:
 fixed skb_set_owner_w() call: it should set sk on new nskb

v3 changes:
 now I think it's better to separate bugfix itself and creation of new helper.
 now bugfix does not create new inline function. Unlike from v1 it creates new skb
 only when it is necessary, i.e. for shared skb only.
 In case of failure it updates IPSTATS_MIB_OUTDISCARDS counter
 Patch set with new helper will be sent separately.

v2 changes: 
 new helper was created and used in ip6_finish_output2 and in ip6_xmit()
 small refactoring in changed functions: commonly used dereferences was replaced by variables


Vasily Averin (1):
  ipv6: allocate enough headroom in ip6_finish_output2()

 net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

-- 
1.8.3.1

