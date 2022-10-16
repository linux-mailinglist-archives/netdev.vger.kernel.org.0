Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B025FFD07
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 04:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJPCWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 22:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJPCWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 22:22:32 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6422E1183F
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 19:22:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MqkNP2nN8zDsST;
        Sun, 16 Oct 2022 10:19:49 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 16 Oct 2022 10:22:24 +0800
Message-ID: <2186aa41-ec5d-364d-b251-76fe5839f4a0@huawei.com>
Date:   Sun, 16 Oct 2022 10:22:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: net/kcm: syz issue about general protection fault in skb_unlink
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, <edumazet@google.com>,
        <sgarzare@redhat.com>, <ast@kernel.org>, <nikolay@nvidia.com>,
        <mkl@pengutronix.de>, <cong.wang@bytedance.com>
References: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
 <Y0s3cP9pzGKzwagT@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y0s3cP9pzGKzwagT@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/16 6:42, Cong Wang wrote:
> On Thu, Oct 13, 2022 at 06:51:29PM +0800, shaozhengchao wrote:
>> I found that the syz issue("general protection fault in skb_unlink")
>> still happen in Linux -next branch.
>> commit: 082fce125e57cff60687181c97f3a8ee620c38f5
>> Link:
>> https://groups.google.com/g/syzkaller-bugs/c/ZfR2B5KaQrA/m/QfnGHCYSBwAJ
>> Please ask:
>> Is there any problem with this patch? Why is this patch not merged into
>> the Linux -next branch or mainline?
>>
> 
> Does the following patch also fix this bug? It is much smaller than the
> one you refer above.
> 
> Thanks.
> 

Hi Wang:
	Thank you for your patch. I've tested this patch and it solves
my problem as well. Maybe it is better?

Zhengchao Shao
	
> ---------------->
> 
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 1215c863e1c4..67c4b25d351d 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -1116,6 +1116,7 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
>   {
>   	struct sock *sk = sock->sk;
>   	struct kcm_sock *kcm = kcm_sk(sk);
> +	struct kcm_mux *mux = kcm->mux;
>   	int err = 0;
>   	long timeo;
>   	struct strp_msg *stm;
> @@ -1156,8 +1157,10 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
>   msg_finished:
>   			/* Finished with message */
>   			msg->msg_flags |= MSG_EOR;
> +			spin_lock_bh(&mux->rx_lock);
>   			KCM_STATS_INCR(kcm->stats.rx_msgs);
>   			skb_unlink(skb, &sk->sk_receive_queue);
> +			spin_unlock_bh(&mux->rx_lock);
>   			kfree_skb(skb);
>   		}
>   	}
