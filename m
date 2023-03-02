Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D414C6A797D
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 03:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCBCaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 21:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCBCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 21:30:18 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B038E9D;
        Wed,  1 Mar 2023 18:30:16 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PRw463bBWz16NkW;
        Thu,  2 Mar 2023 10:27:34 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 2 Mar
 2023 10:30:14 +0800
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
Date:   Thu, 2 Mar 2023 10:30:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

On 2023/3/2 0:03, Alexander Lobakin wrote:
> __xdp_build_skb_from_frame() state(d):
> 
> /* Until page_pool get SKB return path, release DMA here */
> 
> Page Pool got skb pages recycling in April 2021, but missed this
> function.
> 
> xdp_release_frame() is relevant only for Page Pool backed frames and it
> detaches the page from the corresponding Pool in order to make it
> freeable via page_frag_free(). It can instead just mark the output skb
> as eligible for recycling if the frame is backed by a PP. No change for
> other memory model types (the same condition check as before).
> cpumap redirect and veth on Page Pool drivers now become zero-alloc (or
> almost).
> 
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  net/core/xdp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 8c92fc553317..a2237cfca8e9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -658,8 +658,8 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>  	 * - RX ring dev queue index	(skb_record_rx_queue)
>  	 */
>  
> -	/* Until page_pool get SKB return path, release DMA here */
> -	xdp_release_frame(xdpf);
> +	if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
> +		skb_mark_for_recycle(skb);


We both rely on both skb->pp_recycle and page->pp_magic to decide
the page is really from page pool. So there was a few corner case
problem when we are sharing a page for different skb in the driver
level or calling skb_clone() or skb_try_coalesce().
see:
https://github.com/torvalds/linux/commit/2cc3aeb5ecccec0d266813172fcd82b4b5fa5803
https://lore.kernel.org/netdev/MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com/t/
https://lore.kernel.org/netdev/167475990764.1934330.11960904198087757911.stgit@localhost.localdomain/

As the 'struct xdp_frame' also use 'struct skb_shared_info' which is
sharable, see xdp_get_shared_info_from_frame().

For now xdpf_clone() does not seems to handling frag page yet,
so it should be fine for now.

IMHO we should find a way to use per-page marker, instead of both
per-skb and per-page markers, in order to avoid the above problem
for xdp if xdp has a similar processing as skb, as suggested by Eric.

https://lore.kernel.org/netdev/CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com/

>  
>  	/* Allow SKB to reuse area used by xdp_frame */
>  	xdp_scrub_frame(xdpf);
> 
