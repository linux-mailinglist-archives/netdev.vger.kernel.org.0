Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE54C8082
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiCABuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiCABuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:50:16 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B605DE5D;
        Mon, 28 Feb 2022 17:49:15 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K70Vj3YRHz9snW;
        Tue,  1 Mar 2022 09:47:25 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 09:49:12 +0800
Subject: Re: [PATCH bpf-next 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>,
        <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-2-wangyufen@huawei.com>
 <YhvPKB8O7ml5JSHQ@pop-os.localdomain>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <43776e3f-08c0-5d1a-1c2b-dd6084a6de33@huawei.com>
Date:   Tue, 1 Mar 2022 09:49:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YhvPKB8O7ml5JSHQ@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/28 3:21, Cong Wang 写道:
> On Fri, Feb 25, 2022 at 09:49:26AM +0800, Wang Yufen wrote:
>> If tcp_bpf_sendmsg is running during a tear down operation we may enqueue
>> data on the ingress msg queue while tear down is trying to free it.
>>
>>   sk1 (redirect sk2)                         sk2
>>   -------------------                      ---------------
>> tcp_bpf_sendmsg()
>>   tcp_bpf_send_verdict()
>>    tcp_bpf_sendmsg_redir()
>>     bpf_tcp_ingress()
>>                                            sock_map_close()
>>                                             lock_sock()
>>      lock_sock() ... blocking
>>                                             sk_psock_stop
>>                                              sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>>                                             release_sock(sk);
>>      lock_sock()	
>>      sk_mem_charge()
>>      get_page()
>>      sk_psock_queue_msg()
>>       sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
>>        drop_sk_msg()
>>      release_sock()
>>
>> While drop_sk_msg(), the msg has charged memory form sk by sk_mem_charge
>> and has sg pages need to put. To fix we use sk_msg_free() and then kfee()
>> msg.
>>
> What about the other code path? That is, sk_psock_skb_ingress_enqueue().
> I don't see skmsg is charged there.

sk_psock_skb_ingress_self() | sk_psock_skb_ingress()
    skb_set_owner_r()
       sk_mem_charge()
    sk_psock_skb_ingress_enqueue()

The other code path skmsg is charged by skb_set_owner_r()->sk_mem_charge()

>
> Thanks.
> .
