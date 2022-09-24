Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F55E8954
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 09:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiIXH7T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Sep 2022 03:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiIXH7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 03:59:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B19F14D48E;
        Sat, 24 Sep 2022 00:59:17 -0700 (PDT)
Received: from canpemm100010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZLsb6PynzWgvF;
        Sat, 24 Sep 2022 15:55:15 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100010.china.huawei.com (7.192.104.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 15:59:15 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Sat, 24 Sep 2022 15:59:15 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        davem <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [bug report] one possible out-of-order issue in sockmap
Thread-Topic: [bug report] one possible out-of-order issue in sockmap
Thread-Index: AdjPzwrK0RHLCS69QbyGLr5ej4bpUw==
Date:   Sat, 24 Sep 2022 07:59:15 +0000
Message-ID: <061d068ccd6f4db899d095cd61f52114@huawei.com>
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

Hello,

I had a scp failure problem here. I analyze the code, and the reasons may be as follows:

From commit e7a5f1f1cd00 ("bpf/sockmap: Read psock ingress_msg before
 sk_receive_queue", if we use sockops (BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
and BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) to enable socket's sockmap
function, and don't enable strparse and verdict function, the out-of-order
problem may occur in the following process.

client SK                                   server SK
--------------------------------------------------------------------------
tcp_rcv_synsent_state_process
  tcp_finish_connect
    tcp_init_transfer
      tcp_set_state(sk, TCP_ESTABLISHED);
      // insert SK to sockmap
    wake up waitter
    tcp_send_ack

tcp_bpf_sendmsg(msgA)
// msgA will go tcp stack
                                            tcp_rcv_state_process
                                              tcp_init_transfer
                                                //insert SK to sockmap
                                              tcp_set_state(sk,
                                                     TCP_ESTABLISHED)
                                              wake up waitter
tcp_bpf_sendmsg(msgB)
// msgB go sockmap
                                              tcp_bpf_recvmsg
                                                //msgB, out-of-order
                                              tcp_bpf_recvmsg
                                                //msgA, out-of-order


Even if msgA arrives earlier than msgB (in most cases), tcp_bpf_recvmsg receives msg from the psock queue first.
The worst case is that msgA waits for serverSK to change to TCP_ESTABLISHED in the protocol stack. msgA may arrive at the serverSK receive queue later than msgB.
If msgA befor than msgB, 

If the ACK packets of the three-way TCP handshake are dropped for a period of time, the OOO problem is easily reproduced.

iptables -A INPUT -p tcp -m tcp --dport 5006 --tcp-flags SYN,RST,ACK,FIN ACK -j DROP
...
iptables -D INPUT -p tcp -m tcp --dport 5006 --tcp-flags SYN,RST,ACK,FIN ACK -j DROP

Best Wishes
Liu Jian
