Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E835369EE
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351878AbiE1Byp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238672AbiE1Byo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:54:44 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930713BF80;
        Fri, 27 May 2022 18:54:43 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L94Sg1mFvzgYLs;
        Sat, 28 May 2022 09:53:07 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 09:54:40 +0800
Subject: Re: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on in
 sk_stream_kill_queues
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <lmb@cloudflare.com>, <davem@davemloft.net>, <kafai@fb.com>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20220524075311.649153-1-wangyufen@huawei.com>
 <YpFEmCp+fm1nC23U@pop-os.localdomain>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <3d11ae70-8c2d-b021-b173-b000dce588e0@huawei.com>
Date:   Sat, 28 May 2022 09:54:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YpFEmCp+fm1nC23U@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/28 5:37, Cong Wang 写道:
> On Tue, May 24, 2022 at 03:53:11PM +0800, Wang Yufen wrote:
>> During TCP sockmap redirect pressure test, the following warning is triggered:
>> WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
>> CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
>> Call Trace:
>>   inet_csk_destroy_sock+0x55/0x110
>>   inet_csk_listen_stop+0xbb/0x380
>>   tcp_close+0x41b/0x480
>>   inet_release+0x42/0x80
>>   __sock_release+0x3d/0xa0
>>   sock_close+0x11/0x20
>>   __fput+0x9d/0x240
>>   task_work_run+0x62/0x90
>>   exit_to_user_mode_prepare+0x110/0x120
>>   syscall_exit_to_user_mode+0x27/0x190
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> The reason we observed is that:
>> When the listener is closing, a connection may have completed the three-way
>> handshake but not accepted, and the client has sent some packets. The child
>> sks in accept queue release by inet_child_forget()->inet_csk_destroy_sock(),
>> but psocks of child sks have not released.
>>
> Hm, in this scenario, how does the child socket end up in the sockmap?
> Clearly user-space does not have a chance to get an fd yet.
>
> And, how does your patch work? Since the child sock does not even inheirt
> the sock proto after clone (see the comments above tcp_bpf_clone()) at
> all?
>
> Thanks.
> .
My test cases are as follows:

__section("sockops")
int bpf_sockmap(struct bpf_sock_ops *skops)
{
     switch (skops->op) {
         case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
         case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
             ...
             bpf_sock_hash_update(skops, &sock_ops_map, &key, BPF_NOEXIST);
             break;
         ...
}

__section("sk_msg")
int bpf_redir(struct sk_msg_md *msg)
{
     ...
     bpf_msg_redirect_hash(msg, &sock_ops_map, &key, BPF_F_INGRESS);
     return SK_PASS;
}

//tcp_server
int main(char **argv)
{
     int sk = 0;
     int port, ret;
     struct sockaddr_in addr;

     signal(SIGCHLD, SIG_IGN);

     sk = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
     if (sk < 0) {
         perror("Can't create socket");
         return -1;
     }

     port = atoi(argv[1]);
     memset(&addr, 0, sizeof(addr));
     addr.sin_family = AF_INET;
     addr.sin_addr.s_addr = htonl(INADDR_ANY);
     addr.sin_port = htons(port);

     printf("Binding to port %d\n", port);

     ret = bind(sk, (struct sockaddr *)&addr, sizeof(addr));
     if (ret < 0) {
         perror("Can't bind socket");
         return -1;
     }

     ret = listen(sk, size);
     if (ret < 0) {
         perror("Can't put sock to listen");
         return -1;
     }

     printf("Waiting for connections\n");
     while (1) {
         //not accpet
         sleep(1);
     }
}

//tcp_client
int main(char **argv)
{
     int port, write_size;
     int val[10], rval[10];
     int sk = 0;

     port = atoi(argv[2]);
     val[0] = 1;

     sk = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
     if (sk < 0) {
         perror("Can't create socket");
         return -1;
     }

     memset(&addr, 0, sizeof(addr));
     addr.sin_family = AF_INET;
     inet_aton(argv[1], &addr.sin_addr);
     addr.sin_port = htons(port);

     ret = connect(sk[i], (struct sockaddr *)&addr, sizeof(addr));
     if (ret < 0) {
         perror("Can't connect");
         return -1;
     }

    while (1) {
         printf("send %d -> %d\n", val[0], val[0]);
         write(sk, &val, sizeof(val));
         val[0]++;
         sleep(1);
    }
}


1. start tcp_server
2. start tcp_client
3. kill tcp_server
The problem can be reproduced easily.
