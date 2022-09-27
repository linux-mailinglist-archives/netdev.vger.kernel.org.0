Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F405EBE84
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiI0JZl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 05:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiI0JZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 05:25:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5EED2D6C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 02:23:30 -0700 (PDT)
Received: from canpemm100010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McDb52QzbzlXGn;
        Tue, 27 Sep 2022 17:19:13 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100010.china.huawei.com (7.192.104.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 17:23:28 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Tue, 27 Sep 2022 17:23:28 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] xfrm: Reinject transport-mode packets through
 workqueue
Thread-Topic: [PATCH net v2] xfrm: Reinject transport-mode packets through
 workqueue
Thread-Index: AQHYz+u2uLrBCUb2OEG+vxfvEdmhfa3yZncAgACW3lA=
Date:   Tue, 27 Sep 2022 09:23:28 +0000
Message-ID: <3a0e0b1827304eb481e422826bc5a4a7@huawei.com>
References: <20220924080157.247678-1-liujian56@huawei.com>
 <20220927075320.GR2950045@gauss3.secunet.de>
In-Reply-To: <20220927075320.GR2950045@gauss3.secunet.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Steffen Klassert [mailto:steffen.klassert@secunet.com]
> Sent: Tuesday, September 27, 2022 3:53 PM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net v2] xfrm: Reinject transport-mode packets through
> workqueue
> 
> On Sat, Sep 24, 2022 at 04:01:57PM +0800, Liu Jian wrote:
> > The following warning is displayed when the tcp6-multi-diffip11 stress
> > test case of the LTP test suite is tested:
> >
> > watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [ns-tcpserver:48198]
> > CPU: 0 PID: 48198 Comm: ns-tcpserver Kdump: loaded Not tainted
> > 6.0.0-rc6+ #39 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0
> > 02/06/2015
> > pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) pc :
> > des3_ede_encrypt+0x27c/0x460 [libdes] lr : 0x3f sp : ffff80000ceaa1b0
> > x29: ffff80000ceaa1b0 x28: ffff0000df056100 x27: ffff0000e51e5280
> > x26: ffff80004df75030 x25: ffff0000e51e4600 x24: 000000000000003b
> > x23: 0000000000802080 x22: 000000000000003d x21: 0000000000000038
> > x20: 0000000080000020 x19: 000000000000000a x18: 0000000000000033
> > x17: ffff0000e51e4780 x16: ffff80004e2d1448 x15: ffff80004e2d1248
> > x14: ffff0000e51e4680 x13: ffff80004e2d1348 x12: ffff80004e2d1548
> > x11: ffff80004e2d1848 x10: ffff80004e2d1648 x9 : ffff80004e2d1748
> > x8 : ffff80004e2d1948 x7 : 000000000bcaf83d x6 : 000000000000001b
> > x5 : ffff80004e2d1048 x4 : 00000000761bf3bf x3 : 000000007f1dd0a3
> > x2 : ffff0000e51e4780 x1 : ffff0000e3b9a2f8 x0 : 00000000db44e872 Call
> > trace:
> >  des3_ede_encrypt+0x27c/0x460 [libdes]
> >  crypto_des3_ede_encrypt+0x1c/0x30 [des_generic]
> >  crypto_cbc_encrypt+0x148/0x190
> >  crypto_skcipher_encrypt+0x2c/0x40
> >  crypto_authenc_encrypt+0xc8/0xfc [authenc]
> >  crypto_aead_encrypt+0x2c/0x40
> >  echainiv_encrypt+0x144/0x1a0 [echainiv]
> >  crypto_aead_encrypt+0x2c/0x40
> >  esp6_output_tail+0x1c8/0x5d0 [esp6]
> >  esp6_output+0x120/0x278 [esp6]
> >  xfrm_output_one+0x458/0x4ec
> >  xfrm_output_resume+0x6c/0x1f0
> >  xfrm_output+0xac/0x4ac
> >  __xfrm6_output+0x130/0x270
> >  xfrm6_output+0x60/0xec
> >  ip6_xmit+0x2ec/0x5bc
> >  inet6_csk_xmit+0xbc/0x10c
> >  __tcp_transmit_skb+0x460/0x8c0
> >  tcp_write_xmit+0x348/0x890
> >  __tcp_push_pending_frames+0x44/0x110
> >  tcp_rcv_established+0x3c8/0x720
> >  tcp_v6_do_rcv+0xdc/0x4a0
> >  tcp_v6_rcv+0xc24/0xcb0
> >  ip6_protocol_deliver_rcu+0xf0/0x574
> >  ip6_input_finish+0x48/0x7c
> >  ip6_input+0x48/0xc0
> >  ip6_rcv_finish+0x80/0x9c
> >  xfrm_trans_reinject+0xb0/0xf4
> >  tasklet_action_common.constprop.0+0xf8/0x134
> >  tasklet_action+0x30/0x3c
> >  __do_softirq+0x128/0x368
> >  do_softirq+0xb4/0xc0
> 
> ...
> 
> > The tasklet software interrupt takes too much time.
> 
> Do you know why this tasklet takes so long? Whatever happens in that
> tasklet, it should not need more than 22s.
> 
Something like this:
1. In the tcp6-multi-diffip11 test case, data is sent based on the sendbuf size of the sock (1638400 is set in the current environment), and the IPSec ESP/transport mode is used. In the TCP protocol stack, the size of each SKB is 1500. (did not coalesce? If each SKB is 1500, there is a 1638400 / 1500 loop in tcp_sendmsg.)
2. In the tcp6-multi-diffip11 test case, 100 sockets are used to perform the pressure test described in [1]. When xfrm_trans_reinject is triggered, the length of trans->queue is 64 to 2000.
3. The callback function in xfrm_trans_reinject is ip6_rcv_finish. In this function, __tcp_push_pending_frames is called to trigger data transmission of the other 99 sockets.
4. In my environment, __local_bh_enable_ip sometimes takes nearly 1 second (the time consumed by using ktime_get_raw_fast_ns).

And sorry, the tested VM environment is released due to timeout and logs are lost. If necessary, I may need to test it again later.

> > Therefore, the
> > xfrm_trans_reinject executor is changed from tasklet to workqueue.
> 
> Why should do a workqueue with BHs off better than a tasklet?
In this case, the path of tcp_sendmsg can be reduced. As shown in the preceding call trace, the software interrupt xfrm_trans_reinject is inserted in tcp_sendmsg. Change xfrm_trans_reinject from tasklet to workqueue. The xfrm_trans_reinject process is deleted from the sendmsg process.
