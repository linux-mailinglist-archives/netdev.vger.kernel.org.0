Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2247A63F4C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 04:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfGJCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 22:30:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfGJCaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 22:30:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B87988309;
        Wed, 10 Jul 2019 02:30:16 +0000 (UTC)
Received: from [10.72.12.176] (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ABE35FCB1;
        Wed, 10 Jul 2019 02:30:08 +0000 (UTC)
Subject: Re: [PATCH bpf-next v3] virtio_net: add XDP meta data support
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     ast@kernel.org, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, mst@redhat.com, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
References: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
 <20190702081646.23230-1-yuya.kusakabe@gmail.com>
 <ca724dcf-4ffb-ff49-d307-1b45143712b5@redhat.com>
 <52e3fc0d-bdd7-83ee-58e6-488e2b91cc83@gmail.com>
 <a5f4601a-db0e-e65b-5b32-cc7e04ba90be@iogearbox.net>
 <eb955137-11d5-13b2-683a-6a2e8425d792@redhat.com>
 <116cdb35-57b3-e2fe-ef8a-05cc6a1afbbe@iogearbox.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eaa707f1-9058-97dc-db57-99746f9464fd@redhat.com>
Date:   Wed, 10 Jul 2019 10:30:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <116cdb35-57b3-e2fe-ef8a-05cc6a1afbbe@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 10 Jul 2019 02:30:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/10 上午4:03, Daniel Borkmann wrote:
> On 07/09/2019 05:04 AM, Jason Wang wrote:
>> On 2019/7/9 上午6:38, Daniel Borkmann wrote:
>>> On 07/02/2019 04:11 PM, Yuya Kusakabe wrote:
>>>> On 7/2/19 5:33 PM, Jason Wang wrote:
>>>>> On 2019/7/2 下午4:16, Yuya Kusakabe wrote:
>>>>>> This adds XDP meta data support to both receive_small() and
>>>>>> receive_mergeable().
>>>>>>
>>>>>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>>>>>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>>>>>> ---
>>>>>> v3:
>>>>>>     - fix preserve the vnet header in receive_small().
>>>>>> v2:
>>>>>>     - keep copy untouched in page_to_skb().
>>>>>>     - preserve the vnet header in receive_small().
>>>>>>     - fix indentation.
>>>>>> ---
>>>>>>     drivers/net/virtio_net.c | 45 +++++++++++++++++++++++++++-------------
>>>>>>     1 file changed, 31 insertions(+), 14 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>> index 4f3de0ac8b0b..03a1ae6fe267 100644
>>>>>> --- a/drivers/net/virtio_net.c
>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>>>>                        struct receive_queue *rq,
>>>>>>                        struct page *page, unsigned int offset,
>>>>>>                        unsigned int len, unsigned int truesize,
>>>>>> -                   bool hdr_valid)
>>>>>> +                   bool hdr_valid, unsigned int metasize)
>>>>>>     {
>>>>>>         struct sk_buff *skb;
>>>>>>         struct virtio_net_hdr_mrg_rxbuf *hdr;
>>>>>> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>>>>         else
>>>>>>             hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>>>>>     -    if (hdr_valid)
>>>>>> +    if (hdr_valid && !metasize)
>>>>>>             memcpy(hdr, p, hdr_len);
>>>>>>           len -= hdr_len;
>>>>>> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>>>>             copy = skb_tailroom(skb);
>>>>>>         skb_put_data(skb, p, copy);
>>>>>>     +    if (metasize) {
>>>>>> +        __skb_pull(skb, metasize);
>>>>>> +        skb_metadata_set(skb, metasize);
>>>>>> +    }
>>>>>> +
>>>>>>         len -= copy;
>>>>>>         offset += copy;
>>>>>>     @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>>>>         unsigned int delta = 0;
>>>>>>         struct page *xdp_page;
>>>>>>         int err;
>>>>>> +    unsigned int metasize = 0;
>>>>>>           len -= vi->hdr_len;
>>>>>>         stats->bytes += len;
>>>>>> @@ -683,10 +689,13 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>>>>>               xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>>>>>             xdp.data = xdp.data_hard_start + xdp_headroom;
>>>>>> -        xdp_set_data_meta_invalid(&xdp);
>>>>>>             xdp.data_end = xdp.data + len;
>>>>>> +        xdp.data_meta = xdp.data;
>>>>>>             xdp.rxq = &rq->xdp_rxq;
>>>>>>             orig_data = xdp.data;
>>>>>> +        /* Copy the vnet header to the front of data_hard_start to avoid
>>>>>> +         * overwriting by XDP meta data */
>>>>>> +        memcpy(xdp.data_hard_start - vi->hdr_len, xdp.data - vi->hdr_len, vi->hdr_len);
>>> I'm not fully sure if I'm following this one correctly, probably just missing
>>> something. Isn't the vnet header based on how we set up xdp.data_hard_start
>>> earlier already in front of it? Wouldn't we copy invalid data from xdp.data -
>>> vi->hdr_len into the vnet header at that point (given there can be up to 256
>>> bytes of headroom between the two)? If it's relative to xdp.data and headroom
>>> is >0, then BPF prog could otherwise mangle this; something doesn't add up to
>>> me here. Could you clarify? Thx
>> Vnet headr sits just in front of xdp.data not xdp.data_hard_start. So it could be overwrote by metadata, that's why we need a copy here.
> For the current code, you can adjust the xdp.data with a positive/negative offset
> already via bpf_xdp_adjust_head() helper. If vnet headr sits just in front of
> xdp.data, couldn't this be overridden today as well then? Anyway, just wondering
> how this is handled differently?


We will invalidate the vnet header in this case. But for the case of 
metadata adjustment without header adjustment, we want to seek a way to 
preserve that.

Thanks


>
> Thanks,
> Daniel
