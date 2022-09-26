Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CC5E97BB
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiIZBel convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Sep 2022 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiIZBeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 21:34:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030A25D6;
        Sun, 25 Sep 2022 18:34:35 -0700 (PDT)
Received: from canpemm100010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MbQDX04FHzlWf5;
        Mon, 26 Sep 2022 09:30:20 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100010.china.huawei.com (7.192.104.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 09:34:33 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Mon, 26 Sep 2022 09:34:33 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        davem <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [bug report] one possible out-of-order issue in sockmap
Thread-Topic: [bug report] one possible out-of-order issue in sockmap
Thread-Index: AdjPzwrK0RHLCS69QbyGLr5ej4bpUwA+hnmAAB7NriA=
Date:   Mon, 26 Sep 2022 01:34:33 +0000
Message-ID: <fb254c963d3549a19c066b6bd2acf9c7@huawei.com>
References: <061d068ccd6f4db899d095cd61f52114@huawei.com>
 <YzCdHXtgKPciEusR@pop-os.localdomain>
In-Reply-To: <YzCdHXtgKPciEusR@pop-os.localdomain>
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
> From: Cong Wang [mailto:xiyou.wangcong@gmail.com]
> Sent: Monday, September 26, 2022 2:26 AM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: John Fastabend <john.fastabend@gmail.com>; Jakub Sitnicki
> <jakub@cloudflare.com>; Eric Dumazet <edumazet@google.com>; davem
> <davem@davemloft.net>; yoshfuji@linux-ipv6.org; dsahern@kernel.org;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> netdev <netdev@vger.kernel.org>; bpf@vger.kernel.org
> Subject: Re: [bug report] one possible out-of-order issue in sockmap
> 
> On Sat, Sep 24, 2022 at 07:59:15AM +0000, liujian (CE) wrote:
> > Hello,
> >
> > I had a scp failure problem here. I analyze the code, and the reasons may
> be as follows:
> >
> > From commit e7a5f1f1cd00 ("bpf/sockmap: Read psock ingress_msg
> before
> > sk_receive_queue", if we use sockops
> > (BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
> > and BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) to enable socket's
> sockmap
> > function, and don't enable strparse and verdict function, the
> > out-of-order problem may occur in the following process.
> >
> > client SK                                   server SK
> > ----------------------------------------------------------------------
> > ----
> > tcp_rcv_synsent_state_process
> >   tcp_finish_connect
> >     tcp_init_transfer
> >       tcp_set_state(sk, TCP_ESTABLISHED);
> >       // insert SK to sockmap
> >     wake up waitter
> >     tcp_send_ack
> >
> > tcp_bpf_sendmsg(msgA)
> > // msgA will go tcp stack
> >                                             tcp_rcv_state_process
> >                                               tcp_init_transfer
> >                                                 //insert SK to sockmap
> >                                               tcp_set_state(sk,
> >                                                      TCP_ESTABLISHED)
> >                                               wake up waitter
> 
> Here after the socket is inserted to a sockmap, its ->sk_data_ready() is
> already replaced with sk_psock_verdict_data_ready(), so msgA should go to
> sockmap, not TCP stack?
> 
It is TCP stack.  Here I only enable BPF_SK_MSG_VERDICT type.
bpftool prog load bpf_redir.o /sys/fs/bpf/bpf_redir map name sock_ops_map pinned /sys/fs/bpf/sock_ops_map
bpftool prog attach pinned /sys/fs/bpf/bpf_redir msg_verdict pinned /sys/fs/bpf/sock_ops_map

The call trace like this:
Tcp_bpf_sendmsg
--tcp_bpf_send_verdict
---- sk_psock_msg_verdict // did not find serverSK, return __SK_PASS
---- tcp_bpf_push
------ do_tcp_sendpages // go to TCP stack

After this, serverSk is inserted to a sockmap, but msgA is already running the TCP stack.

> > tcp_bpf_sendmsg(msgB)
> > // msgB go sockmap
> >                                               tcp_bpf_recvmsg
> >                                                 //msgB, out-of-order
> >                                               tcp_bpf_recvmsg
> >                                                 //msgA, out-of-order
> >
> >
> > Even if msgA arrives earlier than msgB (in most cases), tcp_bpf_recvmsg
> receives msg from the psock queue first.
> > The worst case is that msgA waits for serverSK to change to
> TCP_ESTABLISHED in the protocol stack. msgA may arrive at the serverSK
> receive queue later than msgB.
> > If msgA befor than msgB,
> >
> > If the ACK packets of the three-way TCP handshake are dropped for a
> period of time, the OOO problem is easily reproduced.
> >
> > iptables -A INPUT -p tcp -m tcp --dport 5006 --tcp-flags
> > SYN,RST,ACK,FIN ACK -j DROP ...
> > iptables -D INPUT -p tcp -m tcp --dport 5006 --tcp-flags
> > SYN,RST,ACK,FIN ACK -j DROP
> >
> > Best Wishes
> > Liu Jian
