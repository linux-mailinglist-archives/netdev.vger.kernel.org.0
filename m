Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD25653D2D
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 09:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiLVIwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 03:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiLVIw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 03:52:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F1D2D2;
        Thu, 22 Dec 2022 00:52:28 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nd3vK4n6hzJqcK;
        Thu, 22 Dec 2022 16:51:25 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 22 Dec 2022 16:52:25 +0800
Message-ID: <47236b24-6b47-b03a-c7b8-c46ea07cac6f@huawei.com>
Date:   Thu, 22 Dec 2022 16:52:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
To:     Kalle Valo <kvalo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <wright.feng@cypress.com>,
        <chi-hsien.lin@cypress.com>, <a.fatoum@pengutronix.de>,
        <alsi@bang-olufsen.dk>, <pieterpg@broadcom.com>,
        <dekim@broadcom.com>, <linville@tuxdriver.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
 <167164758059.5196.17408082243455710150.kvalo@kernel.org>
 <Y6QJWPDXglDjUP9p@linutronix.de> <87cz8bkeqp.fsf@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <87cz8bkeqp.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/22 16:46, Kalle Valo wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
> 
>> On 2022-12-21 18:33:06 [+0000], Kalle Valo wrote:
>>> Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>>
>>>> After the DMA buffer is mapped to a physical address, address is stored
>>>> in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
>>>> brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain physaddr
>>>> and later unmap the DMA buffer. But when count is always equal to
>>>> pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
>>>> will not be unmapped anyway.
>>>>
>>>> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>>>
>>> Can someone review this?
>>
>> After looking at the code, that skb is mapped but not inserted into the
>> ringbuffer in this condition. The function returns with an error and the
>> caller will free that skb (or add to a list for later). Either way the
>> skb remains mapped which is wrong. The unmap here is the right thing to
>> do.
>>
>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Thanks for the review, very much appreciated.
> 

Thank you very much.

Zhengchao Shao
