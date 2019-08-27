Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B725B9E620
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfH0KvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0KvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:51:10 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B75075D66B;
        Tue, 27 Aug 2019 10:51:09 +0000 (UTC)
Received: from localhost (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 927635D9CC;
        Tue, 27 Aug 2019 10:51:06 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:51:02 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Li Shuang <shuali@redhat.com>
Subject: Re: [PATCH net v2] net/sched: pfifo_fast: fix wrong dereference
 when qdisc is reset
Message-ID: <20190827125102.315ecd08@redhat.com>
In-Reply-To: <783231162b9d32faaf5df34ad8ad437b0031bd31.1566901438.git.dcaratti@redhat.com>
References: <783231162b9d32faaf5df34ad8ad437b0031bd31.1566901438.git.dcaratti@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 27 Aug 2019 10:51:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 12:29:09 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
> 'TCQ_F_NOLOCK' bit in the parent qdisc, we need to be sure that per-cpu
> counters are present when 'reset()' is called for pfifo_fast qdiscs.
> Otherwise, the following script:
> 
>  # tc q a dev lo handle 1: root htb default 100
>  # tc c a dev lo parent 1: classid 1:100 htb \
>  > rate 95Mbit ceil 100Mbit burst 64k  
>  [...]
>  # tc f a dev lo parent 1: protocol arp basic classid 1:100
>  [...]
>  # tc q a dev lo parent 1:100 handle 100: pfifo_fast
>  [...]
>  # tc q d dev lo root
> 
> can generate the following splat:
> 
>  Unable to handle kernel paging request at virtual address dfff2c01bd148000
>  Mem abort info:
>    ESR = 0x96000004
>    Exception class = DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>  Data abort info:
>    ISV = 0, ISS = 0x00000004
>    CM = 0, WnR = 0
>  [dfff2c01bd148000] address between user and kernel address ranges
>  Internal error: Oops: 96000004 [#1] SMP
>  [...]
>  pstate: 80000005 (Nzcv daif -PAN -UAO)
>  pc : pfifo_fast_reset+0x280/0x4d8
>  lr : pfifo_fast_reset+0x21c/0x4d8
>  sp : ffff800d09676fa0
>  x29: ffff800d09676fa0 x28: ffff200012ee22e4
>  x27: dfff200000000000 x26: 0000000000000000
>  x25: ffff800ca0799958 x24: ffff1001940f332b
>  x23: 0000000000000007 x22: ffff200012ee1ab8
>  x21: 0000600de8a40000 x20: 0000000000000000
>  x19: ffff800ca0799900 x18: 0000000000000000
>  x17: 0000000000000002 x16: 0000000000000000
>  x15: 0000000000000000 x14: 0000000000000000
>  x13: 0000000000000000 x12: ffff1001b922e6e2
>  x11: 1ffff001b922e6e1 x10: 0000000000000000
>  x9 : 1ffff001b922e6e1 x8 : dfff200000000000
>  x7 : 0000000000000000 x6 : 0000000000000000
>  x5 : 1fffe400025dc45c x4 : 1fffe400025dc357
>  x3 : 00000c01bd148000 x2 : 0000600de8a40000
>  x1 : 0000000000000007 x0 : 0000600de8a40004
>  Call trace:
>   pfifo_fast_reset+0x280/0x4d8
>   qdisc_reset+0x6c/0x370
>   htb_reset+0x150/0x3b8 [sch_htb]
>   qdisc_reset+0x6c/0x370
>   dev_deactivate_queue.constprop.5+0xe0/0x1a8
>   dev_deactivate_many+0xd8/0x908
>   dev_deactivate+0xe4/0x190
>   qdisc_graft+0x88c/0xbd0
>   tc_get_qdisc+0x418/0x8a8
>   rtnetlink_rcv_msg+0x3a8/0xa78
>   netlink_rcv_skb+0x18c/0x328
>   rtnetlink_rcv+0x28/0x38
>   netlink_unicast+0x3c4/0x538
>   netlink_sendmsg+0x538/0x9a0
>   sock_sendmsg+0xac/0xf8
>   ___sys_sendmsg+0x53c/0x658
>   __sys_sendmsg+0xc8/0x140
>   __arm64_sys_sendmsg+0x74/0xa8
>   el0_svc_handler+0x164/0x468
>   el0_svc+0x10/0x14
>  Code: 910012a0 92400801 d343fc03 11000c21 (38fb6863)
> 
> Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
> before dereferencing 'qdisc->cpu_qstats'.
> 
> Changes since v1:
>  - coding style improvements, thanks to Stefano Brivio
> 
> Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
> CC: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano
