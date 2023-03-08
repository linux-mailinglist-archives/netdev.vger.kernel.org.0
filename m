Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C314F6AFEE6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 07:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCHG1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 01:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHG1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 01:27:18 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AC9A8393;
        Tue,  7 Mar 2023 22:27:16 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PWj2d2hCkznWW4;
        Wed,  8 Mar 2023 14:24:25 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 8 Mar
 2023 14:27:13 +0800
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
 <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
 <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
 <9b5b88da-0d2d-d3f3-6ee1-7e4afc2e329a@intel.com>
 <98aa093a-e772-8882-b0e3-5895fd747e59@huawei.com>
 <0bc28bea-78f5-bcce-2d45-e6f6d1a7ed40@intel.com>
 <605cad27-2bf3-7913-877e-d2870892ecd5@huawei.com>
 <9e8a9346-37f4-7c5d-f1d0-cbba3de805db@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1cea3621-8f5d-ba95-1b0b-e245ce770abf@huawei.com>
Date:   Wed, 8 Mar 2023 14:27:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <9e8a9346-37f4-7c5d-f1d0-cbba3de805db@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/8 2:14, Alexander Lobakin wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Tue, 7 Mar 2023 10:50:34 +0800
> 
>> On 2023/3/6 19:58, Alexander Lobakin wrote:
>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>> Date: Mon, 6 Mar 2023 09:09:31 +0800
> 
> [...]
> 
>>> Ah, from that perspective. Yes, you're probably right, but would need to
>>> be tested anyway. I don't see any open problems with the PP recycling
>>> right now on the lists, but someone may try to change it one day.
>>> Anyway, this flag is only to do a quick test. We do have
>>> sk_buff::pfmemalloc, but this flag doesn't mean every page from this skb
>>> was pfmemalloced.
>>
>> The point seems to be that sk_buff::pfmemalloc allow false positive, which
>> means skb->pfmemalloc can be set to true while every page from this skb is
>> not pfmemalloced as you mentioned.
>>
>> While skb->pp_recycle can't allow false positive, if that happens, reference
>> counting of the page will not be handled properly if pp and non-pp skb shares
>> the page as the wireless adapter does.
> 
> You mean false-positives in both directions? Because if ->pp_recycle is
> set, the stack can still free non-PP pages. In the opposite case, I mean
> when ->pp_recycle is false and an skb page belongs to a page_pool, yes,
> there'll be issues.

That may depends on what is a PP pages and what is a non-PP pages, it seems
hard to answer now.

For a skb with ->pp_recycle being true and its frag page with page->pp_magic
being PP_SIGNATURE, when calling skb_clone()/pskb_expand_head() or
skb_try_coalesce(), we may call __skb_frag_ref() for the frag page, which
mean a page with page->pp_magic being PP_SIGNATURE can be both PP page
and non-PP page at the same time. So it is important to set the ->pp_recycle
correctly, and it seems hard to get that right from past experience，that's
why a per page marker is suggested.


> But I think the deal is to propagate the flag when you want to attach a
> PP-backed page to the skb? I mean, if someone decides to mix pages with
> different memory models, it's his responsibility to make sure everything
> is fine, because it's not a common/intended way. Isn't it?
> 
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> Anyway, I am not sure checking ::pp_magic is correct when a
>>>>>> page will be passing between different subsystem and back to
>>>>>> the network stack eventually, checking ::pp_magic may not be
>>>>>> correct if this happens.
>>>>>>
>>>>>> Another way is to use the bottom two bits in bv_page, see:
>>>>>> https://www.spinics.net/lists/netdev/msg874099.html
> 
> This one is interesting actually. We'd only need one bit -- which is
> 100% free and available in case of page pointers.
> 
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>  
>>>>>>>>>  	/* Allow SKB to reuse area used by xdp_frame */
>>>>>>>>>  	xdp_scrub_frame(xdpf);
> 
> [...]
> 
> Thanks,
> Olek
> 
> .
> 
