Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2864CF2F
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiLNSJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbiLNSJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:09:17 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06AB4B9;
        Wed, 14 Dec 2022 10:09:15 -0800 (PST)
Message-ID: <de85f811-8b2f-3ded-53b4-5f6d5e165e04@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671041353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RVeE52fe8tao+Jgn1fchMA7etd6S9WYXBGMEn5oGVU=;
        b=HNzCbhUTrOzIAXCLd6h/BnqC3BLAQGZ4FyiH3GZuiqk9HY2DqkjmqGjmtqLuHcBf49uzKJ
        PCPdTKjLvXSmhQyh3TsMMJswXelM6s8xtOad/sV+Uz9Txn8Fu3F44OuIITj32l5RXPFeqe
        AWJKbQ3SRTiXjEL9R+s4L8LkmxCgmEY=
Date:   Wed, 14 Dec 2022 10:09:04 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 08/15] veth: Support RX XDP
 metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-9-sdf@google.com>
 <7ca8ac2c-7c07-a52f-ec17-d1ba86fa45ab@redhat.com>
 <CAKH8qBvCxnJ2-5gd9j1HYxMA8CNi6cQM-5WOUBghiZjHUHya3A@mail.gmail.com>
 <4bac619d-8767-1364-1924-78c05b1ecf88@redhat.com> <87a63qgt30.fsf@toke.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87a63qgt30.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/22 2:47 AM, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> 
>> On 13/12/2022 21.42, Stanislav Fomichev wrote:
>>> On Tue, Dec 13, 2022 at 7:55 AM Jesper Dangaard Brouer
>>> <jbrouer@redhat.com> wrote:
>>>>
>>>>
>>>> On 13/12/2022 03.35, Stanislav Fomichev wrote:
>>>>> The goal is to enable end-to-end testing of the metadata for AF_XDP.
>>>>>
>>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>>> Cc: David Ahern <dsahern@gmail.com>
>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>> Cc: xdp-hints@xdp-project.net
>>>>> Cc: netdev@vger.kernel.org
>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>> ---
>>>>>     drivers/net/veth.c | 24 ++++++++++++++++++++++++
>>>>>     1 file changed, 24 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>>> index 04ffd8cb2945..d5491e7a2798 100644
>>>>> --- a/drivers/net/veth.c
>>>>> +++ b/drivers/net/veth.c
>>>>> @@ -118,6 +118,7 @@ static struct {
>>>>>
>>>>>     struct veth_xdp_buff {
>>>>>         struct xdp_buff xdp;
>>>>> +     struct sk_buff *skb;
>>>>>     };
>>>>>
>>>>>     static int veth_get_link_ksettings(struct net_device *dev,
>>>>> @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
>>>>>
>>>>>                 xdp_convert_frame_to_buff(frame, xdp);
>>>>>                 xdp->rxq = &rq->xdp_rxq;
>>>>> +             vxbuf.skb = NULL;
>>>>>
>>>>>                 act = bpf_prog_run_xdp(xdp_prog, xdp);
>>>>>
>>>>> @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>>>>>         __skb_push(skb, skb->data - skb_mac_header(skb));
>>>>>         if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
>>>>>                 goto drop;
>>>>> +     vxbuf.skb = skb;
>>>>>
>>>>>         orig_data = xdp->data;
>>>>>         orig_data_end = xdp->data_end;
>>>>> @@ -1601,6 +1604,21 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>>>>>         }
>>>>>     }
>>>>>
>>>>> +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>>>>> +{
>>>>> +     *timestamp = ktime_get_mono_fast_ns();
>>>>
>>>> This should be reading the hardware timestamp in the SKB.
>>>>
>>>> Details: This hardware timestamp in the SKB is located in
>>>> skb_shared_info area, which is also available for xdp_frame (currently
>>>> used for multi-buffer purposes).  Thus, when adding xdp-hints "store"
>>>> functionality, it would be natural to store the HW TS in the same place.
>>>> Making the veth skb/xdp_frame code paths able to share code.
>>>
>>> Does something like the following look acceptable as well?
>>>
>>> *timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;

If it is to test the kfunc and ensure veth_xdp_rx_timestamp is called, this 
alone should be enough. skb_hwtstamps(_ctx->skb)->hwtstamp should be 0 if 
hwtstamp is unavailable?  The test can initialize the 'u64 *timestamp' arg to 
non-zero first.  If it is not good enough, an fentry tracing can be done to 
veth_xdp_rx_timestamp to ensure it is called also.  There is also fmod_ret that 
could change the return value but the timestamp is not the return value though.

If the above is not enough, another direction of thought could be doing it 
through bpf_prog_test_run_xdp() but it will need a way to initialize the 
veth_xdp_buff.

That said, overall, I don't think it is a good idea to bend the 
veth_xdp_rx_timestamp kfunc too much only for testing purpose unless there is no 
other way out.
