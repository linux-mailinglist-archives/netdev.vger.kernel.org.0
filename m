Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8329166D3BE
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 02:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjAQBDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 20:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjAQBDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 20:03:36 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A57222E0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 17:03:34 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NwrFR5NBbznVKH;
        Tue, 17 Jan 2023 09:01:47 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 17 Jan 2023 09:03:30 +0800
Message-ID: <8dabc718-4ffb-5178-6452-e634630814bb@huawei.com>
Date:   Tue, 17 Jan 2023 09:03:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <zengyhkyle@gmail.com>, David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
In-Reply-To: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+cc netdev@vger.kernel.org yuehaibing

On 2023/1/16 16:27, shaozhengchao wrote:
> When I analyzed the following LTS 5.10 patch, I had a small question:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b2c917e510e5ddbc7896329c87d20036c8b82952
> 
> As described in this patch, res is obtained through the tcf_classify()
> interface. If result is TC_ACT_SHOT, res may be an abnormal value.
> Accessing class in res will cause abnormal access.
> 
> For LTS version 5.10, if tcf_classify() is to return a positive value,
> the classify hook function to the filter must be called, and the hook 
> function returns a positive number. Observe the classify function of 
> each filter. Generally, res is initialized in four scenarios.
> 1. res is assigned a value by res in the private member of each filter.
> Generally, kzalloc is used to assign initial values to res of various
> filters. Therefore, class in res is initialized to 0. Then use the
> tcf_bind_filter() interface to assign values to members in res.
> Therefore, value of class is assigned. For example, cls_basic.
> 2. The classify function of the filter directly assigns a value to the
> class of res, for example, cls_cgroup.
> 3. The filter classify function references tp and assigns a value to
> res, for example, cls_u32.
> 4. The change function of the filter references fh and assigns a value
> to class in res, for example, cls_rsvp.
> 
> This Mainline problem is caused by commit:3aa260559455 (" net/sched:
> store the last executed chain also for clsact egress") and
> commit:9410c9409d3e ("net: sched: Introduce ingress classification
> function"). I don't know if my analysis is correct, please help correct, 
> thank you very much.
> 
> Zhengchao Shao
