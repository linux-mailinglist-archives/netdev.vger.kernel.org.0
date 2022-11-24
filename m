Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8097637779
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiKXLTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiKXLTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:19:37 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42F627B3C;
        Thu, 24 Nov 2022 03:19:36 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NHwQf3D89zqSgZ;
        Thu, 24 Nov 2022 19:15:38 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 19:19:34 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 19:19:33 +0800
Message-ID: <4d464258-de80-7d9c-bb8d-363d743396e7@huawei.com>
Date:   Thu, 24 Nov 2022 19:19:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net/9p: Fix a potential socket leak in p9_socket_open
To:     <asmadeus@codewreck.org>
CC:     <ericvh@gmail.com>, <lucho@ionkov.net>, <linux_oss@crudebyte.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <viro@zeniv.linux.org.uk>,
        <v9fs-developer@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20221124081005.66579-1-wanghai38@huawei.com>
 <Y382Spkkzt+i86e8@codewreck.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
In-Reply-To: <Y382Spkkzt+i86e8@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/24 17:15, asmadeus@codewreck.org 写道:
> Wang Hai wrote on Thu, Nov 24, 2022 at 04:10:05PM +0800:
>> Both p9_fd_create_tcp() and p9_fd_create_unix() will call
>> p9_socket_open(). If the creation of p9_trans_fd fails,
>> p9_fd_create_tcp() and p9_fd_create_unix() will return an
>> error directly instead of releasing the cscoket, which will
> (typo, socket or csocket -- I'll fix this on applying)
Hi, Dominique.
Thanks for reviewing.

Here is a typo, it should be csocket.
>> result in a socket leak.
>>
>> This patch adds sock_release() to fix the leak issue.
> Thanks, it looks good to me.
> A bit confusing that sock_alloc_files() calls sock_release() itself on
> failure, but that means this one's safe at least...
Yes, this mechanism was introduced by commit 8e1611e23579 ("make 
sock_alloc_file() do sock_release() on failures")
>
>> Fixes: 6b18662e239a ("9p connect fixes")
> (the leak was present before that commit so I guess that's not really
> correct -- but it might help figure out up to which point stable folks
> will be able to backport so I guess it's useful either way)
Yes, there was already a leak before this patch, and this patch also 
introduces a leak

-- 
Wang Hai

