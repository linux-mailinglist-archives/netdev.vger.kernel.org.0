Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A811E856
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfLMQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:29:16 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:29440 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbfLMQ3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 11:29:16 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xBDGPxKt002386;
        Fri, 13 Dec 2019 17:25:59 +0100
Date:   Fri, 13 Dec 2019 17:25:59 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "William J. Tolley" <william@breakpointingbad.com>,
        "Jason A. Donenfeld" <zx2c4@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC] tcp: implement new per-interface sysctl "auto_dev_bind"
Message-ID: <20191213162559.GE2209@1wt.eu>
References: <20191213100730.2153-1-w@1wt.eu>
 <d40a3670-e983-d9fc-0a06-4f62bafe96b2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d40a3670-e983-d9fc-0a06-4f62bafe96b2@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Fri, Dec 13, 2019 at 08:03:52AM -0800, Eric Dumazet wrote:
> Hi Willy, thanks for working on this.

Thanks for reviewing :-)

> Could you check if your patch works with syncookies mode ?
> 
> echo 2 >/proc/sys/net/ipv4/tcp_syncookies

Good catch:

[19401.670076] Call trace:
[19401.672494]  tcp_v4_syn_recv_sock+0x168/0x250
[19401.676807]  tcp_get_cookie_sock+0x4c/0xe4
[19401.680858]  cookie_v4_check+0x470/0x4a8
[19401.684740]  tcp_v4_do_rcv+0xf4/0x1c8
[19401.688362]  tcp_v4_rcv+0x410/0x790
[19401.691815]  ip_protocol_deliver_rcu+0x8c/0x128
[19401.696298]  ip_local_deliver_finish+0x64/0x78
[19401.700696]  ip_local_deliver+0x90/0x94
[19401.704491]  ip_rcv_finish+0x3c/0x50
[19401.708027]  ip_rcv+0x5c/0x74
[19401.710961]  __netif_receive_skb_one_core+0x54/0x7c
[19401.715790]  __netif_receive_skb+0x5c/0x64
[19401.719843]  netif_receive_skb_internal+0x68/0xcc
[19401.724501]  napi_gro_receive+0x70/0xa0
[19401.728298]  gro_cell_poll+0x74/0x88
[19401.731832]  net_rx_action+0x134/0x2c8
[19401.735543]  __do_softirq+0x1bc/0x1fc
[19401.739165]  irq_exit+0x60/0xb0
[19401.742270]  __handle_domain_irq+0x6c/0x98
[19401.746322]  gic_handle_irq+0x70/0xac
[19401.749945]  el1_irq+0xb8/0x180
[19401.753052]  arch_cpu_idle+0x10/0x18
[19401.756588]  do_idle+0x134/0x22c
[19401.759778]  cpu_startup_entry+0x20/0x3c
[19401.763660]  rest_init+0xd0/0xdc
[19401.766852]  arch_call_rest_init+0xc/0x14
[19401.770818]  start_kernel+0x41c/0x448
[19401.774444] Code: 790bd261 aa1303e0 97ffbdd1 f9400ac0 (f9416000) 
[19401.780485] ---[ end trace e08862982660f052 ]---
[19401.785049] Kernel panic - not syncing: Fatal exception in interrupt

> I wonder if your patch could be simpler if you were plugging the logic for passive
> flows in inet_request_bound_dev_if() ?

I'm not sure yet. For having had a quick lookk and tried to move the
code there, I feel like I'll need to distinguish the protocols (v4/v6)
in order to look at the per-interface configuration, while it's already
done in the caller. Or maybe there are some ipv4 settings that also
apply to ipv6 and we could do the same by having a single one for the
two maybe ?

Willy
