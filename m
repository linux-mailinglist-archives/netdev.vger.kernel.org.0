Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9D48419
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFQNe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:34:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41983 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfFQNe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:34:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so5699821pff.8
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MUdRUwAak57Ck6Aqsw8+YNqQywkA6ZUApjGP4kWJp8w=;
        b=hQU2+5lBIgHOKYQoLLO2sLZT5JNu/8o5opqlzeAaK2isAY2091JC8+oQbMNsArblqO
         vmX9fB4WQ3D1JFhpuik5ATFCP04I7Oi0XE/r2d4IJ7V/+ofCn9kElUXa4o4/W7WLI7wS
         EOiJaU+HrUm7ie/Sri5U+4nkLC/rDIHDpGsdVOtJrx2BNeSABNzPup24+Nw6zuv6b0Hj
         wNcY5pdwdZqUJZkW1b505mxilBX7N87FTasgd6M3pBwo2t/58MphPb2UQMCuQ7NGKlw0
         qGZVNTel2uy4zrinm4i8Vo+rnuFFhgfoLcsG920YlnCf0q+ZxlQX3Fimp9YukO9ecsFA
         mV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MUdRUwAak57Ck6Aqsw8+YNqQywkA6ZUApjGP4kWJp8w=;
        b=PP/D77lnZ5awAHsV0Xf4zllyuOdcjtl/h7rV9lwvTl/c6g5CE2xXz5u2t4kIcQXatC
         AjeNMcihs/IHRaL03A8dMSGS9OD4oWVodfRXDgD/RMUf1e5S21jmnv1gZWM0w58T02tH
         PKAV2iHYcKKaKUCDeH5Ut0mscqS9yFnP1ZL7EBsWv/SEE0ooQfByO07My0zeNPYydOP/
         2rhKKAOXhxM6mchl2L7keJixjFIMheUScrmJUjOZqWl79tYLoWeXP/wWCqZirA7seUsc
         UKnzKZb2JGqKZxH57LPLUIyRmoTjiHchRu3btqY8Xa4oBiUbEZt/vZGWGZdOmDUkCNpe
         nlLg==
X-Gm-Message-State: APjAAAVLMuStuL360uSFg3D/7iCnyhI4t1WmcRhypRZdnEQUrEHiy5/1
        2WeYc7dqtF8kJfl7QEmpByNZFzK0
X-Google-Smtp-Source: APXvYqy/P1mWY39UwLFmHCSa2cmeIRJ1C2qRGTSCLY3TpAEsJ6r0PdfUZg38KrLaKqILD+aEuYwGaQ==
X-Received: by 2002:a63:cc4e:: with SMTP id q14mr48591446pgi.84.1560778465063;
        Mon, 17 Jun 2019 06:34:25 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v138sm18638107pfc.15.2019.06.17.06.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:34:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH net 0/3] net: fix quite a few dst_cache crashes reported by syzbot
Date:   Mon, 17 Jun 2019 21:34:12 +0800
Message-Id: <cover.1560778340.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two kinds of crashes reported many times by syzbot with no
reproducer. Call Traces are like:

     BUG: KASAN: slab-out-of-bounds in rt_cache_valid+0x158/0x190
     net/ipv4/route.c:1556
       rt_cache_valid+0x158/0x190 net/ipv4/route.c:1556
       __mkroute_output net/ipv4/route.c:2332 [inline]
       ip_route_output_key_hash_rcu+0x819/0x2d50 net/ipv4/route.c:2564
       ip_route_output_key_hash+0x1ef/0x360 net/ipv4/route.c:2393
       __ip_route_output_key include/net/route.h:125 [inline]
       ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2651
       ip_route_output_key include/net/route.h:135 [inline]
     ...

   or:

     kasan: GPF could be caused by NULL-ptr deref or user memory access
     RIP: 0010:dst_dev_put+0x24/0x290 net/core/dst.c:168
       <IRQ>
       rt_fibinfo_free_cpus net/ipv4/fib_semantics.c:200 [inline]
       free_fib_info_rcu+0x2e1/0x490 net/ipv4/fib_semantics.c:217
       __rcu_reclaim kernel/rcu/rcu.h:240 [inline]
       rcu_do_batch kernel/rcu/tree.c:2437 [inline]
       invoke_rcu_callbacks kernel/rcu/tree.c:2716 [inline]
       rcu_process_callbacks+0x100a/0x1ac0 kernel/rcu/tree.c:2697
     ...

They were caused by the fib_nh_common percpu member 'nhc_pcpu_rth_output'
overwritten by another percpu variable 'dev->tstats' access overflow in
tipc udp media xmit path when counting packets on a non tunnel device.

The fix is to make udp tunnel work with no tunnel device by allowing not
to count packets on the tstats when the tunnel dev is NULL in Patches 1/3
and 2/3, then pass a NULL tunnel dev in tipc_udp_tunnel() in Patch 3/3.

Xin Long (3):
  ip_tunnel: allow not to count pkts on tstats by setting skb's dev to
    NULL
  ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL
  tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

 include/net/ip6_tunnel.h  | 9 ++++++---
 net/ipv4/ip_tunnel_core.c | 9 ++++++---
 net/tipc/udp_media.c      | 8 +++-----
 3 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.1.0

