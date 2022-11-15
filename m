Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBDC6290E2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiKODif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiKODie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:38:34 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DA82705
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:38:28 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBBcw2FXLzqSNs;
        Tue, 15 Nov 2022 11:34:40 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 11:38:26 +0800
Message-ID: <df913f58-d301-4df7-aeca-7cb83d18793f@huawei.com>
Date:   Tue, 15 Nov 2022 11:38:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] netdevsim: Fix memory leak of nsim_dev->fa_cookie
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
References: <1668234485-27635-1-git-send-email-wangyufen@huawei.com>
 <20221114185028.54fd7e14@kernel.org>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <20221114185028.54fd7e14@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/15 10:50, Jakub Kicinski 写道:
> On Sat, 12 Nov 2022 14:28:05 +0800 Wang Yufen wrote:
>> nsim_dev_trap_fa_cookie_write()
>>    kmalloc() fa_cookie
>>    nsim_dev->fa_cookie = fa_cookie
>> ..
>> nsim_drv_remove()
>>
>> nsim_dev->fa_cookie alloced, but the nsim_dev_trap_report_work()
>> job has not been done, the flow action cookie has not been assigned
>> to the metadata. To fix, add kfree(nsim_dev->fa_cookie) to
>> nsim_drv_remove().
> I don't see the path thru nsim_dev_trap_report_work() which would free
> the fa_cookie.
>
> The fix looks right, but the commit message seems incorrect. Isn't the
> leak always there, without any race?

Sorry, I didn't make it clear.

The detailed process of nsim_dev_trap_report_work() is as follows:

nsim_dev_trap_report_work()
   nsim_dev_trap_report_work()
     ...
     devlink_trap_report()
       devlink_trap_report_metadata_set()
       <-- fa_cookie is assigned to metadata->fa_cookie here， and will be freed in net_dm_hw_metadata_free()

