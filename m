Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685705297B4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 05:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiEQDMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 23:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiEQDMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 23:12:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910BE1D0F6;
        Mon, 16 May 2022 20:12:17 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L2LkP1XzXzhZG6;
        Tue, 17 May 2022 11:11:41 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 17 May 2022 11:12:14 +0800
Subject: Re: [PATCH net-next] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220514091443.4150162-1-william.xuanziyang@huawei.com>
 <CAHNKnsS0D8bRA5GY0xss2ZUCwY2HoLNMgeR0K4ecH-HfmdTefg@mail.gmail.com>
 <0b90f4f6-6911-017b-6d37-50354003900e@linux.intel.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <0d5e1262-8140-32d2-e589-d29d68ac49a4@huawei.com>
Date:   Tue, 17 May 2022 11:12:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0b90f4f6-6911-017b-6d37-50354003900e@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> On 5/16/2022 1:36 PM, Sergey Ryazanov wrote:
>> Hello Ziyang,
>>
>> On Sat, May 14, 2022 at 11:57 AM Ziyang Xuan
>> <william.xuanziyang@huawei.com> wrote:
>>> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
>>> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
>>> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>>>
>>> Replace GFP_KERNEL with GFP_ATOMIC to fix it.
>> Would not it will be more reliable to just rework
>> t7xx_cldma_clear_rxq() to avoid calling t7xx_cldma_alloc_and_map_skb()
>> under the spin lock instead of doing each allocation with GFP_ATOMIC?
>> E.g. t7xx_cldma_gpd_rx_from_q() calls t7xx_cldma_alloc_and_map_skb()
>> avoiding any lock holding.
> 
> t7xx_cldma_clear_rxq() is a helper for t7xx_cldma_clear_all_qs() which is only called by t7xx_cldma_exception() after stopping CLDMA, so it should be OK to remove the spin lock from t7xx_cldma_clear_rxq().
> 

OK, I see. Thus we can remove spink_lock and annotate it.

> 
> .
