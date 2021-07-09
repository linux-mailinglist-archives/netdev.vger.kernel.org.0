Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE63C2128
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGIJHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:07:19 -0400
Received: from relay.sw.ru ([185.231.240.75]:59358 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhGIJHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 05:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=zFVuTQnyDA8cEkikltXIqvJF76UzOBgsQPGOznrl6Vk=; b=LurVBLVosc1opccJ312
        Vcm11i6gYFWEZmwLmEu/cja+xeO7VLjW0yJuAp60Dvv/5pzkDHR3w3AnMM3SjhcPr8bd0ZHdTk4cI
        vy+9ejMYprW2v7c2E/ZdA2175ktIHeWklAI+0qjnMv0ANvImx9HBNF1QZ1gFyILNzXD5gh6ttzY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m1mQx-003PkY-Rg; Fri, 09 Jul 2021 12:04:31 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH IPV6 v2 0/4] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
Message-ID: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
Date:   Fri, 9 Jul 2021 12:04:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
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

Suzkaller created C reproducer, it can be found in v1 cover-letter.

v2 changes: 
 new helper was created and used in ip6_finish_output2 and in ip6_xmit()
 small refactoring in changed functions: commonly used dereferences was replaced by variables

ToDo:
 clarify proper name for helper,
 move it into proper place,  
 use it in other similar places:
   pptp_xmit
   vrf_finish_output
   ax25_transmit_buffer
   ax25_rt_build_path
   bpf_out_neigh_v6
   bpf_out_neigh_v4
   ip_finish_output2
   ip6_tnl_xmit
   ipip6_tunnel_xmit
   ip_vs_prepare_tunneled_skb

Vasily Averin (4):
  ipv6: allocate enough headroom in ip6_finish_output2()
  ipv6: use new helper skb_expand_head() in ip6_xmit()
  ipv6: ip6_finish_output2 refactoring
  ipv6: ip6_xmit refactoring

 net/ipv6/ip6_output.c | 89 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 30 deletions(-)

-- 
1.8.3.1

