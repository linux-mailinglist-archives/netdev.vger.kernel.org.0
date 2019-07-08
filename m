Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B3062BDF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfGHWjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:39:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:37356 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGHWjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:39:07 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkcHb-0000vq-6q; Tue, 09 Jul 2019 00:38:51 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkcHa-000Xl3-Vr; Tue, 09 Jul 2019 00:38:51 +0200
Subject: Re: [PATCH bpf-next v3] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     ast@kernel.org, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, mst@redhat.com, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
References: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
 <20190702081646.23230-1-yuya.kusakabe@gmail.com>
 <ca724dcf-4ffb-ff49-d307-1b45143712b5@redhat.com>
 <52e3fc0d-bdd7-83ee-58e6-488e2b91cc83@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a5f4601a-db0e-e65b-5b32-cc7e04ba90be@iogearbox.net>
Date:   Tue, 9 Jul 2019 00:38:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <52e3fc0d-bdd7-83ee-58e6-488e2b91cc83@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 04:11 PM, Yuya Kusakabe wrote:
> On 7/2/19 5:33 PM, Jason Wang wrote:
>> On 2019/7/2 下午4:16, Yuya Kusakabe wrote:
>>> This adds XDP meta data support to both receive_small() and
>>> receive_mergeable().
>>>
>>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>>> ---
>>> v3:
>>>   - fix preserve the vnet header in receive_small().
>>> v2:
>>>   - keep copy untouched in page_to_skb().
>>>   - preserve the vnet header in receive_small().
>>>   - fix indentation.
>>> ---
>>>   drivers/net/virtio_net.c | 45 +++++++++++++++++++++++++++-------------
>>>   1 file changed, 31 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 4f3de0ac8b0b..03a1ae6fe267 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>                      struct receive_queue *rq,
>>>                      struct page *page, unsigned int offset,
>>>                      unsigned int len, unsigned int truesize,
>>> -                   bool hdr_valid)
>>> +                   bool hdr_valid, unsigned int metasize)
>>>   {
>>>       struct sk_buff *skb;
>>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>>> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>       else
>>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>>   -    if (hdr_valid)
>>> +    if (hdr_valid && !metasize)
>>>           memcpy(hdr, p, hdr_len);
>>>         len -= hdr_len;
>>> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>           copy = skb_tailroom(skb);
>>>       skb_put_data(skb, p, copy);
>>>   +    if (metasize) {
>>> +        __skb_pull(skb, metasize);
>>> +        skb_metadata_set(skb, metasize);
>>> +    }
>>> +
>>>       len -= copy;
>>>       offset += copy;
>>>   @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>       unsigned int delta = 0;
>>>       struct page *xdp_page;
>>>       int err;
>>> +    unsigned int metasize = 0;
>>>         len -= vi->hdr_len;
>>>       stats->bytes += len;
>>> @@ -683,10 +689,13 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>>           xdp.data = xdp.data_hard_start + xdp_headroom;
>>> -        xdp_set_data_meta_invalid(&xdp);
>>>           xdp.data_end = xdp.data + len;
>>> +        xdp.data_meta = xdp.data;
>>>           xdp.rxq = &rq->xdp_rxq;
>>>           orig_data = xdp.data;
>>> +        /* Copy the vnet header to the front of data_hard_start to avoid
>>> +         * overwriting by XDP meta data */
>>> +        memcpy(xdp.data_hard_start - vi->hdr_len, xdp.data - vi->hdr_len, vi->hdr_len);

I'm not fully sure if I'm following this one correctly, probably just missing
something. Isn't the vnet header based on how we set up xdp.data_hard_start
earlier already in front of it? Wouldn't we copy invalid data from xdp.data -
vi->hdr_len into the vnet header at that point (given there can be up to 256
bytes of headroom between the two)? If it's relative to xdp.data and headroom
is >0, then BPF prog could otherwise mangle this; something doesn't add up to
me here. Could you clarify? Thx

>> What happens if we have a large metadata that occupies all headroom here?
>>
>> Thanks
> 
> Do you mean a large "XDP" metadata? If a large metadata is a large "XDP" metadata, I think we can not use a metadata that occupies all headroom. The size of metadata limited by bpf_xdp_adjust_meta() as below.
> bpf_xdp_adjust_meta() in net/core/filter.c:
> 	if (unlikely((metalen & (sizeof(__u32) - 1)) ||
> 		     (metalen > 32)))
> 		return -EACCES;
> 
> Thanks.
> 
>>
>>
>>>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
>>>           stats->xdp_packets++;
>>>   @@ -695,9 +704,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>               /* Recalculate length in case bpf program changed it */
>>>               delta = orig_data - xdp.data;
>>>               len = xdp.data_end - xdp.data;
>>> +            metasize = xdp.data - xdp.data_meta;
>>>               break;
>>>           case XDP_TX:
>>>               stats->xdp_tx++;
>>> +            xdp.data_meta = xdp.data;
>>>               xdpf = convert_to_xdp_frame(&xdp);
>>>               if (unlikely(!xdpf))
>>>                   goto err_xdp;
>>> @@ -736,10 +747,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>       skb_reserve(skb, headroom - delta);
>>>       skb_put(skb, len);
>>>       if (!delta) {
>>> -        buf += header_offset;
>>> -        memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>>> +        memcpy(skb_vnet_hdr(skb), buf + VIRTNET_RX_PAD, vi->hdr_len);
>>>       } /* keep zeroed vnet hdr since packet was changed by bpf */
>>>   +    if (metasize)
>>> +        skb_metadata_set(skb, metasize);
>>> +
>>>   err:
>>>       return skb;
>>>   @@ -760,8 +773,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>>                      struct virtnet_rq_stats *stats)
>>>   {
>>>       struct page *page = buf;
>>> -    struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
>>> -                      PAGE_SIZE, true);
>>> +    struct sk_buff *skb =
>>> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>>>         stats->bytes += len - vi->hdr_len;
>>>       if (unlikely(!skb))
>>> @@ -793,6 +806,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>       unsigned int truesize;
>>>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>>>       int err;
>>> +    unsigned int metasize = 0;
>>>         head_skb = NULL;
>>>       stats->bytes += len - vi->hdr_len;
>>> @@ -839,8 +853,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>           data = page_address(xdp_page) + offset;
>>>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>>>           xdp.data = data + vi->hdr_len;
>>> -        xdp_set_data_meta_invalid(&xdp);
>>>           xdp.data_end = xdp.data + (len - vi->hdr_len);
>>> +        xdp.data_meta = xdp.data;
>>>           xdp.rxq = &rq->xdp_rxq;
>>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>>> @@ -852,8 +866,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>                * adjustments. Note other cases do not build an
>>>                * skb and avoid using offset
>>>                */
>>> -            offset = xdp.data -
>>> -                    page_address(xdp_page) - vi->hdr_len;
>>> +            metasize = xdp.data - xdp.data_meta;
>>> +            offset = xdp.data - page_address(xdp_page) -
>>> +                 vi->hdr_len - metasize;
>>>                 /* recalculate len if xdp.data or xdp.data_end were
>>>                * adjusted
>>> @@ -863,14 +878,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>               if (unlikely(xdp_page != page)) {
>>>                   rcu_read_unlock();
>>>                   put_page(page);
>>> -                head_skb = page_to_skb(vi, rq, xdp_page,
>>> -                               offset, len,
>>> -                               PAGE_SIZE, false);
>>> +                head_skb = page_to_skb(vi, rq, xdp_page, offset,
>>> +                               len, PAGE_SIZE, false,
>>> +                               metasize);
>>>                   return head_skb;
>>>               }
>>>               break;
>>>           case XDP_TX:
>>>               stats->xdp_tx++;
>>> +            xdp.data_meta = xdp.data;
>>>               xdpf = convert_to_xdp_frame(&xdp);
>>>               if (unlikely(!xdpf))
>>>                   goto err_xdp;
>>> @@ -921,7 +937,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>           goto err_skb;
>>>       }
>>>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
>>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>>> +                   metasize);
>>>       curr_skb = head_skb;
>>>         if (unlikely(!curr_skb))

