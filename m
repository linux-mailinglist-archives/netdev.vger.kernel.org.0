Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2545A4CCEEA
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiCDHOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiCDHNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:13:08 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE567199D7F;
        Thu,  3 Mar 2022 23:08:38 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K8zSQ22yQzdfxT;
        Fri,  4 Mar 2022 15:07:18 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 15:08:36 +0800
Subject: Re: [PATCH bpf-next v2 3/4] bpf, sockmap: Fix more uncharged while
 msg has more_data
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220302022755.3876705-1-wangyufen@huawei.com>
 <20220302022755.3876705-4-wangyufen@huawei.com>
 <YiBczo/gN8w9Hl+L@pop-os.localdomain>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <43486167-1d02-c053-96f4-55a2683f3da8@huawei.com>
Date:   Fri, 4 Mar 2022 15:08:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YiBczo/gN8w9Hl+L@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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


在 2022/3/3 14:14, Cong Wang 写道:
> On Wed, Mar 02, 2022 at 10:27:54AM +0800, Wang Yufen wrote:
>> In tcp_bpf_send_verdict(), if msg has more data after
>> tcp_bpf_sendmsg_redir():
>>
>> tcp_bpf_send_verdict()
>>   tosend = msg->sg.size  //msg->sg.size = 22220
>>   case __SK_REDIRECT:
>>    sk_msg_return()  //uncharged msg->sg.size(22220) sk->sk_forward_alloc
>>    tcp_bpf_sendmsg_redir() //after tcp_bpf_sendmsg_redir, msg->sg.size=11000
>>   goto more_data;
>>   tosend = msg->sg.size  //msg->sg.size = 11000
>>   case __SK_REDIRECT:
>>    sk_msg_return()  //uncharged msg->sg.size(11000) to sk->sk_forward_alloc
>>
>> The msg->sg.size(11000) has been uncharged twice, to fix we can charge the
>> remaining msg->sg.size before goto more data.
> It looks like bpf_exec_tx_verdict() has the same issue.
>
> .

In bpf_exec_tx_verdict(), case __SK_REDIRECT,  msg_redir is used and 
msg->sg.size is deducted in advance.

Therefore, this issue (more uncharged) does not exist.

However, I think that if msg_redir processing cannot be completed , that 
is msg_redir has more data,

and there is no subsequent processing,  maybe that is another problem.


Thanks.

