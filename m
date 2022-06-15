Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5154C7FF
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbiFOL5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344258AbiFOL5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:57:47 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65601C12B;
        Wed, 15 Jun 2022 04:57:45 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LNP1T1w1WzDrFn;
        Wed, 15 Jun 2022 19:57:17 +0800 (CST)
Received: from dggpemm500011.china.huawei.com (7.185.36.110) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 15 Jun 2022 19:57:43 +0800
Received: from [10.136.114.193] (10.136.114.193) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 15 Jun 2022 19:57:42 +0800
Message-ID: <786e43b7-fe00-ffde-ed9a-f47a695c4123@huawei.com>
Date:   Wed, 15 Jun 2022 19:57:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [syzbot] WARNING: ODEBUG bug in route4_destroy
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     syzbot <syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <xiyou.wangcong@gmail.com>, <rose.chen@huawei.com>
References: <000000000000a81af205cb2e2878@google.com>
 <0c0468ae-5fe3-a71f-c987-18475756caca@huawei.com>
 <20220614144602.GJ2146@kadam>
From:   Zhen Chen <chenzhen126@huawei.com>
In-Reply-To: <20220614144602.GJ2146@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.193]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/6/14 22:46, Dan Carpenter wrote:
> On Tue, Jun 14, 2022 at 10:35:44PM +0800, 'Zhen Chen' via syzkaller-bugs wrote:
>>
>> This looks like  route4_destroy is deleting the 'fold' which has been
>> freed by tcf_queue_work in route4_change. It means 'fold' is still in
>> the table.
>> I have tested this patch on syzbot and it works well, but I am not
>> sure whether it will introduce other issues...
>>
>> diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
>> index a35ab8c27866..758c21f9d628 100644
>> --- a/net/sched/cls_route.c
>> +++ b/net/sched/cls_route.c
>> @@ -526,7 +526,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
>>  	rcu_assign_pointer(f->next, f1);
>>  	rcu_assign_pointer(*fp, f);
>>  
>> -	if (fold && fold->handle && f->handle != fold->handle) {
>> +	if (fold && f->handle != fold->handle) {
>                                  ^^^^^^^^^^^^
> There is still a dereference here so your patch doesn't make sense. :/
> 
> regards,
> dan carpenter

Thanks for your reply but I think the dereference may not be the point.
If fold->handle equals 0, it will not be removed from the hash table, but afterwards the old filter will be freed because it only checks the pointer 'fold' is null or not.

if (fold) {
	tcf_unbind_filter(tp, &fold->res);
	tcf_exts_get_net(&fold->exts);
	tcf_queue_work(&fold->rwork, route4_delete_filter_work);
}

So my patch simply eliminates the handle judgement and it seems to work fine on syzbot.
If I misunderstood anything, pleaese let me know :)   Thanks!
