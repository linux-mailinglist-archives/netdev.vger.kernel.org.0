Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474E26A976B
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjCCMoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 07:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjCCMod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 07:44:33 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EA75F501;
        Fri,  3 Mar 2023 04:44:27 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PSnfH4bCfz16Nxc;
        Fri,  3 Mar 2023 20:41:43 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 3 Mar
 2023 20:44:24 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
Date:   Fri, 3 Mar 2023 20:44:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/3 19:22, Alexander Lobakin wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Thu, 2 Mar 2023 10:30:13 +0800
> 
>> On 2023/3/2 0:03, Alexander Lobakin wrote:
>>> __xdp_build_skb_from_frame() state(d):
>>>
>>> /* Until page_pool get SKB return path, release DMA here */
>>>
>>> Page Pool got skb pages recycling in April 2021, but missed this
>>> function.
> 
> [...]
> 
>> We both rely on both skb->pp_recycle and page->pp_magic to decide
>> the page is really from page pool. So there was a few corner case
>> problem when we are sharing a page for different skb in the driver
>> level or calling skb_clone() or skb_try_coalesce().
>> see:
>> https://github.com/torvalds/linux/commit/2cc3aeb5ecccec0d266813172fcd82b4b5fa5803
>> https://lore.kernel.org/netdev/MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com/t/
>> https://lore.kernel.org/netdev/167475990764.1934330.11960904198087757911.stgit@localhost.localdomain/
> 
> And they are fixed :D
> No drivers currently which use Page Pool mix PP pages with non-PP. And

The wireless adapter which use Page Pool *does* mix PP pages with
non-PP, see below discussion:

https://lore.kernel.org/netdev/156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com/

> it's impossible to trigger try_coalesce() or so at least on cpumap path
> since we're only creating skbs at that moment, they don't come from
> anywhere else.
> 
>>
>> As the 'struct xdp_frame' also use 'struct skb_shared_info' which is
>> sharable, see xdp_get_shared_info_from_frame().
>>
>> For now xdpf_clone() does not seems to handling frag page yet,
>> so it should be fine for now.
> 
> xdpf_clone() clones a frame to a new full page and doesn't copy its
> skb_shared_info.
> 
>>
>> IMHO we should find a way to use per-page marker, instead of both
>> per-skb and per-page markers, in order to avoid the above problem
>> for xdp if xdp has a similar processing as skb, as suggested by Eric.
>>
>> https://lore.kernel.org/netdev/CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com/
> 
> As Jesper already pointed out, not having a quick way to check whether
> we have to check ::pp_magic at all can decrease performance. So it's
> rather a shortcut.

When we are freeing a page by updating the _refcount, I think
we are already touching the cache of ::pp_magic.

Anyway, I am not sure checking ::pp_magic is correct when a
page will be passing between different subsystem and back to
the network stack eventually, checking ::pp_magic may not be
correct if this happens.

Another way is to use the bottom two bits in bv_page, see:
https://www.spinics.net/lists/netdev/msg874099.html

> 
>>
>>>  
>>>  	/* Allow SKB to reuse area used by xdp_frame */
>>>  	xdp_scrub_frame(xdpf);
>>>
> 
> Thanks,
> Olek
> .
> 
