Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55633602987
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJRKo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJRKoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:44:25 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B95CDA3
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 03:44:21 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1666089859; bh=9oIaumfOj6bwSGNBI3LbDysj0Dw9PV2ix1nGA4G2JHM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=s/WljlgIbHexctzOjr068hXJ96dg2WEfn7Jg4OG2FqIWVD2Ur8Jg6Md3WovmOEItS
         X7lCbjSY30PN3iFit/JW+pWpmXhicjCYnilrkxa7/ydGLtuteyAGD22VRgI+YB/SoZ
         2QgmJPQCznaD23T2P/M3oCruJm2EBkg6FC9A67h/hdeo7+rdcHayYnpop2xwp0HX4x
         JgLSHjSdxYMEPsYv99fG5Pg8foUJHEEmFo6ZpGl/pYGTyYVFwbdDfJ2JPbvFlvcROH
         qhKMFPvAt/ArDGTcWvDNn8eVFuDiPoqIO6eVUha2WJ/SinMX0Uw0OYbOJRBrs58/Bu
         9G5fxFxO6qayw==
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     dave.taht@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com,
        shaozhengchao@huawei.com
Subject: Re: [PATCH net,v2 1/3] net: sched: cake: fix null pointer access
 issue when cake_init() fails
In-Reply-To: <20221018063201.306474-2-shaozhengchao@huawei.com>
References: <20221018063201.306474-1-shaozhengchao@huawei.com>
 <20221018063201.306474-2-shaozhengchao@huawei.com>
Date:   Tue, 18 Oct 2022 12:44:18 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874jw1bed9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> When the default qdisc is cake, if the qdisc of dev_queue fails to be
> inited during mqprio_init(), cake_reset() is invoked to clear
> resources. In this case, the tins is NULL, and it will cause gpf issue.
>
> The process is as follows:
> qdisc_create_dflt()
> 	cake_init()
> 		q->tins =3D kvcalloc(...)        --->failed, q->tins is NULL
> 	...
> 	qdisc_put()
> 		...
> 		cake_reset()
> 			...
> 			cake_dequeue_one()
> 				b =3D &q->tins[...]   --->q->tins is NULL
>
> The following is the Call Trace information:
> general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:cake_dequeue_one+0xc9/0x3c0
> Call Trace:
> <TASK>
> cake_reset+0xb1/0x140
> qdisc_reset+0xed/0x6f0
> qdisc_destroy+0x82/0x4c0
> qdisc_put+0x9e/0xb0
> qdisc_create_dflt+0x2c3/0x4a0
> mqprio_init+0xa71/0x1760
> qdisc_create+0x3eb/0x1000
> tc_modify_qdisc+0x408/0x1720
> rtnetlink_rcv_msg+0x38e/0xac0
> netlink_rcv_skb+0x12d/0x3a0
> netlink_unicast+0x4a2/0x740
> netlink_sendmsg+0x826/0xcc0
> sock_sendmsg+0xc5/0x100
> ____sys_sendmsg+0x583/0x690
> ___sys_sendmsg+0xe8/0x160
> __sys_sendmsg+0xbf/0x160
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f89e5122d04
> </TASK>
>
> Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake)=
 qdisc")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
